# Configuring GitHub Self-Hosted Runners for Organization Workflows

## Background

The deployment workflow was failing due to network connectivity issues between GitHub-hosted runners and the target server.

Example error:

```text
Will download drone-ssh-1.8.1-linux-amd64 from https://github.com/appleboy/drone-ssh/releases/download/v1.8.1
======= CLI Version =======
Drone SSH version 1.8.1
===========================
2026/06/04 10:45:30 dial tcp <SERVER_IP>:22: i/o timeout
```

Since GitHub-hosted runners originate from dynamic GitHub IP ranges, firewall restrictions prevented SSH connectivity to the target environment. To resolve this, Self-Hosted Runners were used instead.

## Creating an Organization Runner

Instead of creating repository-specific runners, organization-level runners were configured to allow reuse across multiple repositories.

Administrator privileges are required to manage organization runners.

Navigate to:

```text
Organization Settings
└── Actions
    └── Runners
        └── New self-hosted runner
```

Select the preferred operating system (Linux was used during testing) and follow the GitHub setup instructions.

GitHub will provide a configuration command similar to:

```bash
./config.sh --url https://github.com/<ORGANIZATION> --token <RUNNER_TOKEN>
```

Run the command and follow the prompts to:

* Configure the runner name
* Assign runner labels
* Choose a runner group (Default group was used in this setup)

A custom label matching the organization name was assigned for easier workflow targeting.

## Running the Runner

The runner can be started manually using:

```bash
./run.sh
```

However, this runs in the foreground and stops when the terminal session is closed.

## Installing as a Systemd Service

GitHub provides a helper script to install the runner as a systemd service so it runs automatically in the background and starts on boot.

Run:

```bash
sudo ./svc.sh install
sudo ./svc.sh start
```

You can verify the service status with:

```bash
sudo systemctl status actions.runner.*
```

## Creating Additional Runners

To provision multiple runners:

1. Create a new directory for the runner.
2. Download or copy the runner package into the directory.
3. Extract the package.
4. In GitHub, create a new runner to obtain a new registration token.
5. Run the new configuration command:

```bash
./config.sh --url https://github.com/<ORGANIZATION> --token <NEW_RUNNER_TOKEN>
```

6. Follow the configuration prompts.
7. Install and start the service:

```bash
sudo ./svc.sh install
sudo ./svc.sh start
```

Each runner should have a unique name. Labels can be used to target specific runners.

## Using Self-Hosted Runners in GitHub Actions

By default, workflows use GitHub-hosted runners:

```yaml
deploy:
  name: Deploy to Staging
  runs-on: ubuntu-latest
  needs: build
```

To use a self-hosted runner, replace `ubuntu-latest` with the labels assigned to the runner:

```yaml
deploy:
  name: Deploy to Staging
  runs-on:
    - self-hosted
    - organization-name
  needs: build
```

Where:

* `self-hosted` is the default label applied to all self-hosted runners.
* `organization-name` is the custom label assigned during runner configuration.

GitHub will automatically select any available runner matching the specified labels.

## Notes

* Multiple runners can exist on the same server or across multiple servers.
* GitHub automatically routes jobs to an available runner that matches the workflow labels.
* Organization runners can be shared across repositories, reducing management overhead.
* Running runners as systemd services ensures they remain active after reboots and do not require terminal sessions such as tmux or screen.
