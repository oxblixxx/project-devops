## OVERVIEW
curl is a command-line tool used to transfer data from or to a server using protocols like HTTP, HTTPS and more.

## 1. Check Only Response Headers
Retrieve only the HTTP response headers.

```bash
curl -I https://example.com
>HTTP/1.1 200 OK
>Server: nginx
>Content-Type: text/html
>Content-Length: 1024
```

- Verify server availability
- Inspect response headers
- Check caching headers
- Verify redirect behavior

## 2. Show Request and Response Details (Verbose Mode)
-v enables verbose debugging output.

```sh
curl -v https://example.com
> GET / HTTP/1.1
> Host: example.com

< HTTP/1.1 200 OK
< Server: nginx
```

- Debug reverse proxies
- Inspect TLS handshake
- See headers sent by client and server

## 3. Include Headers in Output
This shows headers and response body together.

```bash
curl -i https://example.com
>HTTP/1.1 200 OK
>Server: nginx
><html>Hello</html>
```

- Debug APIs
- Inspect cookies and headers
- View response body alongside headers

## 4. Send a GET Request
GET is the default HTTP method.

```bash
curl https://api.example.com/users
```

- Retrieve API data
- Test endpoints

## 5. Send a POST Request

```sh
curl -X POST https://api.example.com/users
```

- Create resources
- Submit form or API data

## 6. Send a PUT Request

```bash
curl -X PUT https://api.example.com/users/1
```

- Update an existing resource

## 7. Send a DELETE Request

```bash
curl -X DELETE https://api.example.com/users/1
```

- Remove resources from an API

## 8. Send JSON Data

```bash
curl -X POST https://api.example.com/users \
-H "Content-Type: application/json" \
-d '{"name":"Mustapha"}'
```

### Option	Meaning
- -X	HTTP method
- -H	Add HTTP header
- -d	Send request body data

- API testing
- Microservice debugging

## 9. Send Custom Headers
curl -H "Authorization: Bearer TOKEN" \
-H "Content-Type: application/json" \
https://api.example.com

- Test authenticated APIs
- Debug token or header issues

## 10. Check Redirects
Check redirect without following it:

```bash
curl -I http://example.com
>HTTP/1.1 301 Moved Permanently
>Location: https://example.com
>Follow redirects automatically:
curl -L http://example.com
```


## 11. Debug TLS / SSL Issues

```bash
curl -v https://example.com
```

* SSL connection using TLS1.3
* Server certificate:
* subject: CN=example.com

- TLS handshake debugging
- Certificate validation issues

## 12. Check HTTP Status Code Only

```sh
curl -o /dev/null -s -w "%{http_code}\n" https://example.com
200
```

Option	Meaning
- -o /dev/null	Discard response body
- -s	Silent mode
- -w	Print custom output

- Health checks
- Monitoring scripts

## 13. Measure Response Time
Meaning the request took 423 milliseconds.
```bash
curl -o /dev/null -s -w "%{time_total}\n" https://example.com
0.423
```
- Performance debugging
- Latency monitoring

## 14. Pretty Print JSON Responses
jq formats JSON responses for easier reading.
```bash
curl https://api.example.com/users | jq
```

- API debugging
- Log inspection

## 15. Simulate Browser Requests

```bash
curl -A "Mozilla/5.0" https://example.com
```
-A sets the User-Agent header.

- Bypass simple bot blocks
- Test browser-specific behavior

## 16. Test Local Services
```bash
curl http://localhost:8000
```

- Verify backend services
- Test application ports
- Debug reverse proxy issues

## 17. Save Response to a File
This saves the response body into a file.

```bash
curl https://example.com -o page.html
```


- Download files
- Save API responses
- Debug HTML output

>Difference Between -i and -I.
>Option	Meaning	Behavior.
>-i	Include headers	Shows headers and body.
>-I	HEAD request	Sends HEAD request and shows headers only.
