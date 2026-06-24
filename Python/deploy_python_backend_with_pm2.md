# Setting Up a Python Service with PM2

## Prerequisites
- **PM2**  
- **Web server** (Nginx or Apache2)

---

## Step 1: Verify PM2 Installation
Check if PM2 is installed:

```bash
pm2 -v
```

If not installed, follow the [PM2 installation guide](https://pm2.io/)


## Step 2: Prepare Python Environment

Navigate to your backend directory:

```sh
cd /path/to/backend
```

Create a virtual environment:

```sh
python3 -m venv venv
```

Activate the virtual environment:

```sh
source venv/bin/activate
```

Install required Python packages:

```sh
pip install -r requirements.
```

## Step 3: Start the Project with PM2

Run the backend using PM2 in the virtual environment:

```sh
pm2 start backend/backend.py \
    --name my-backend \
    --interpreter /var/www/html/filename/backend/.venv/bin/python
```
--name: gives your process a recognizable name in PM2

--interpreter: ensures the virtual environment’s Python is used.

Incase there is an issue with loading the .env, add this to main.py

```sh
from pathlib import Path
from dotenv import load_dotenv

project_root = Path(__file__).resolve().parents[2]
load_dotenv(project_root / ".env")
```

Ensure the `project_root` directs to the root directory where .env is located.
Deactivate the virtual environment

``sh
deactivate
```
## Step 4: Verify PM2 Process

Check running PM2 processes:

```sh
pm2 list
```

Always activate the virtual environment in the terminal before running scripts manually.

PM2 will keep the service alive even if the terminal closes.
