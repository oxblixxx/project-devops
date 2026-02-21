# Python for DevOps: The Complete Roadmap (No Fluff, Just What Works) by: @livingdevops (X)

A lot of people reach out to me with one query: how to learn Python for Devops. How much to learn and what to learn. I am writing this to answer all these questions for once and all.

If you are planning to learn Azure devops with industry-grade real-world projects, then my upcoming Azure Devops bootcamp is for you.

**[16-Week Real World Project-based Azure DevOps Bootcamp](https://livingdevops.com/courses/15-week-devops-with-azure-bootcamp/)**

---

After teaching 1000+ DevOps engineers, I've noticed something: most Python tutorials teach you to build calculators and games. But in DevOps, you're automating infrastructure, parsing logs, and making API calls to AWS.

This roadmap focuses on what actually matters. Let's dive in.

## Week 1-2: Foundation

### Python Syntax Basics

Learn variables, operators, print statements, and comments. Every automation script starts here. You'll write hundreds of scripts in your career so get the basics right.

* **Quick win:** Write a script that asks for a server name and environment, then prints a deployment message.

### Data Structures: Where DevOps Gets Real

* **Strings:** Learn `split`, `join`, `strip`, `replace`, and f-strings. You'll use these for parsing log files, building dynamic Terraform files, formatting kubectl output, and creating Ansible playbooks.
* **Lists:** Master creating, accessing, and slicing lists. Learn `append`, `extend`, `remove`, and list comprehensions. Use these for storing multiple EC2 instance IDs, batch operations on servers, and processing CloudWatch alarms.
* **Dictionaries (Your Best Friend):** Understand creating dicts, `get`, `keys`, `values`, `items`, and nested dictionaries. 90% of AWS API responses are dictionaries. Use these for Kubernetes manifest parsing and storing server metadata.
* **Tuples:** Learn about immutable sequences. Perfect for database query results and fixed configuration data.
* **Sets:** Master unique elements, `union`, `intersection`, and `difference` operations. Use these for finding unique IPs in logs and detecting configuration drift between environments.

> **Practice:** Parse an nginx access log file, count requests per IP address, store in a dictionary, and print the top 5 IPs.

---

## Week 3: Type Conversion & Data Manipulation

### Working with Different Data Types

Learn `int`, `str`, `float`, `list`, `dict` conversions. Also master type checking and `isinstance` for validation.

* **Why this matters:** AWS returns everything as strings. Environment variables are strings. But you need integers for calculations.
* **Example use:** Read CPU usage from monitoring API as string, convert to float, trigger alert if over 80%.

---

## Week 4-5: File Operations & JSON

### File Management

Learn `open`, `read`, `write`, `readlines`, and file modes. Master context managers with `with` statements. Understand path handling with `pathlib`. Use these for reading config files and managing SSH keys.

### JSON Management (Critical Skill)

Master `json.load` vs `json.loads`, `json.dump` vs `json.dumps`, and pretty printing JSON.

* **Why JSON is everywhere:** Terraform state files, AWS CLI output, Kubernetes manifests, and CI/CD pipeline configs all use JSON.

> **Practice:** Read a JSON config file with server details, update the instance count, and write it back to the file.

---

## Week 5-6: System Operations

### OS Module & Subprocess

* **OS Module:** Learn `getcwd`, `chdir`, `listdir`, `path` operations, and `environ` for environment variables.
* **Subprocess Module:** Master `subprocess.run` to execute shell commands, capturing output, and checking return codes.
* **Real use:** Running AWS CLI commands, executing `kubectl`, and managing environment variables in deployments.

---

## Week 6-7: API Calls

### Making API Calls with Requests

Learn `GET`, `POST`, `PUT`, `DELETE` methods. Understand status codes, headers, authentication, and payloads.

| Status Code | Meaning | Action |
| --- | --- | --- |
| **200** | Success | Proceed |
| **201** | Created | Resource built successfully |
| **400** | Bad request | Check your payload |
| **401** | Unauthorized | Check your API key |
| **404** | Not found | Check the endpoint URL |
| **500** | Server error | Internal issue (not your fault) |

> **Practice:** Write a script that posts a message to Slack when a deployment completes. Include status and timestamp.

---

## Week 7-8: Control Flow & Functions

### Conditionals & Loops

Master `if/elif/else`. Learn `for` loops (most common in DevOps), `while` loops, `break`/`continue`, `enumerate` for index/value, and `zip` for parallel iteration.

### Functions (Write Reusable Code)

Learn `def`, parameters, return values, default parameters, `*args`, `**kwargs`, and `lambda` functions.

---

## Week 8-9: Code Organization

### Building Custom Modules

Learn creating modules as `.py` files, `import` statements, the `if __name__ == "__main__":` pattern, and package structure.

* **Goal:** Create a `devops_tools` package with `aws_utils`, `slack_notifier`, and `config_parser` modules.

---

## Week 9-10: Production-Ready Code

* **Logging (Stop Using Print!):** Master the `logging` module and levels (`DEBUG`, `INFO`, `WARNING`, `ERROR`, `CRITICAL`).
* **Exception Handling:** Learn `try/except/finally`. Catch specific exceptions; **never** use a bare `except`.

> **Practice:** Create a server health check script with proper logging and exception handling. Log to both console and file.

---

## Week 10-11: Object-Oriented Basics (OOP)

Learn classes, objects, the `__init__` method, and basic inheritance.

* **Why OOP in DevOps:** You'll use AWS SDK (`boto3`) and Kubernetes clients which are object-oriented.
* **Task:** Create a `Server` class with `name`, `ip`, and `environment` properties. Add methods for health checking.

---

## Additional Critical Topics

* **Regular Expressions (Regex):** Essential for parsing log files and extracting IPs.
* **Working with YAML:** Critical for Kubernetes manifests and Ansible playbooks. Use `pyyaml`.
* **Environment Variables:** Master `os.environ.get` and `.env` files. **Never hardcode secrets.**
* **Dates & Times:** Use `datetime` for log rotation and backup naming.
* **Command Line Arguments:** Use `argparse` for proper CLI tools.
* **Multithreading:** Use `ThreadPoolExecutor` for checking health of 100+ servers simultaneously.

---

## 10 Real-World DevOps Projects

1. **EC2 Instance Manager:** List/start/stop instances by tag using `boto3`.
2. **Log Parser & Alert System:** Find `ERROR` logs via regex and email alerts.
3. **Backup Automation Script:** Dump DB, compress, upload to S3, and prune old files.
4. **Kubernetes Pod Monitor:** Check pod status via `kubectl` and restart if failed.
5. **Multi-Cloud Cost Reporter:** Combine AWS and Azure cost data into a CSV report.
6. **CI/CD Pipeline Trigger:** Check GitHub releases and trigger Jenkins/GitLab via API.
7. **SSL Certificate Expiry Checker:** Alert if certificates expire in < 30 days.
8. **Infrastructure Drift Detector:** Compare Terraform state vs. actual AWS resources.
9. **Security Group Auditor:** Flag open `0.0.0.0/0` rules and unused groups.
10. **Multi-Server Deployment Tool:** Parallel deployment via SSH/Paramiko and Threading.

---

## Learning Path Summary

* **Weeks 1-2:** Basics + Data Structures
* **Weeks 3-4:** Files + JSON
* **Weeks 5-6:** OS operations + API calls
* **Weeks 7-8:** Control flow + Functions
* **Weeks 9-10:** Logging + Error handling
* **Week 11:** OOP basics
* **Week 12:** Additional topics (regex, YAML, CLI args)
* **Weeks 13-16:** Build all 10 projects

---

## My Advice After Teaching 1000+ Engineers

1. **Don't just watch tutorials.** Type every line of code yourself.
2. **Break things.** Intentionally make mistakes to see what errors look like.
3. **Read real code.** Check out `boto3` source code or Ansible modules.
4. **Automate your daily tasks.** If you do it every day, script it.
5. **Start small, ship fast.** Don't wait for perfection. Write a working script first.
6. **Document as you code.** Future you will thank you.

**Stop reading. Start coding.**
