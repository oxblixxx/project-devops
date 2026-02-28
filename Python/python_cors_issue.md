# Troubleshooting Guide: CORS and Payload Issues in Flask/FastAPI Backend Deployment

## Project Context
- **Backend:** Flask API (similar for FastAPI)  
- **Deployment:** Nginx reverse proxy in front of the backend  
- **Issue:** UI displayed `TypeError: Failed to fetch` and console inspection showed CORS-related errors.  

---

## Step 1: Identify the Issue
1. On the frontend, API calls failed with:  

```js
TypeError: Failed to fetch
```
2. Browser console indicated **CORS errors**  
3. Initial hypothesis: Middleware configuration or reverse proxy misconfiguration

---

## Step 2: Inspect Backend CORS Configuration
Backend code (`backend.py`) had multiple CORS middleware definitions:

```python
 app.add_middleware(
     CORSMiddleware,
     allow_origins=["*"],
     allow_credentials=True,
     allow_methods=["*"],
     allow_headers=["*"],
 )
allowed_origins = ["*"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```
Observations:

- Two middleware blocks caused conflicts

- Using "*" with allow_credentials=True is invalid and prevents proper CORS headers

## Step 3: Correct Backend Middleware

- Commented the first middleware block

Update the second middleware block to allow only the frontend domain:

```py
allowed_origins = ["https://xxxxxx.ai"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```
Result: Backend headers now correctly specify the allowed origin

## Step 4: Handle Preflight Requests in Nginx

Preflight OPTIONS requests must be handled before reaching the backend:

# Handle CORS preflight
```nginx
location / {

        # Handle preflight OPTIONS request for CORS
        if ($request_method = 'OPTIONS') {
            add_header 'Access-Control-Allow-Origin' 'https://inaiba.ai';
            add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS';
            add_header 'Access-Control-Allow-Headers' 'Authorization,Content-Type,Accept';
            add_header 'Access-Control-Allow-Credentials' 'true';
            add_header 'Content-Length' 0;
            add_header 'Content-Type' 'text/plain charset=UTF-8';
            return 204;
        }
```
Reload Nginx:

```sh
sudo nginx -t
sudo systemctl reload nginx
```

Expected Result: Browser receives proper CORS headers on preflight requests, but the console still showed `CORS ERROR` as before

## Step 5: Inspect Network Requests

Despite middleware and preflight fixes, network was inspected and it showed 413 Payload Too Large

Analysis: Large payloads were being sent in requests; Nginx blocked them by default

## Step 6: Increase Nginx Body Size Limit

Added in Nginx config:

```sh
client_max_body_size 200M;
```

Reload Nginx:

```sh
sudo nginx -t
sudo systemctl reload nginx
```

## Step 7: Final Result

API requests worked successfully

CORS errors in the browser disappeared

Large payload requests no longer returned 413 errors

Key Takeaways

- Only one CORS middleware should exist in FastAPI/Flask backend

- Do not use "*" with allow_credentials=True; always specify the frontend URL

- Preflight OPTIONS requests must be handled at the reverse proxy or backend

- Browser errors can be misleading — a failed preflight can look like a CORS error even if backend is correct

- Large payloads require increasing client_max_body_size in Nginx