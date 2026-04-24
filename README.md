# Minecraft Server with Docker

## Table of Contents

* [Description](#description)
* [Requirements](#requirements)
* [Quickstart](#quickstart)
* [Usage](#usage)
* [Configuration](#configuration)
* [Persistence](#persistence)
* [Testing](#testing)
* [Notes](#notes)

---

## Description

This repository provides a Docker-based setup for running a self-hosted Minecraft Java server.

The project includes:

* a custom Dockerfile that builds a Minecraft server image
* a docker-compose configuration to run the service
* persistent storage for world data
* configurable environment variables
* an automated Python-based test script (`test_server.py`)

The purpose of this repository is to provide a simple and reproducible way to deploy a Minecraft server without relying on prebuilt Minecraft container images.

The Minecraft server binary is downloaded during the Docker build process directly from the official Mojang source.

---

## Requirements

* Docker
* Docker Compose
* Python 3 (for optional testing)
* Linux, macOS, or Windows environment
* Open TCP port `8888` (required for external access)

---

## Quickstart

Start the server:

```bash
docker compose up -d --build
```

Stop the server:

```bash
docker compose down
```

---

## Usage

### Start the server

```bash
docker compose up -d
```

### Stop the server

```bash
docker compose down
```

### Restart the server

```bash
docker compose restart
```

### View logs

```bash
docker compose logs -f
```

---

## Configuration

The server can be configured using environment variables defined in `docker-compose.yaml`.

### Available variables

| Variable    | Description                          | Default |
| ----------- | ------------------------------------ | ------- |
| SERVER_PORT | Port used by the Minecraft server    | 8888    |
| MEMORY      | Java heap size                       | 1024M   |
| EULA        | Must be set to `true` to accept EULA | true    |

### Example configuration

```yaml
environment:
  SERVER_PORT: 8888
  MEMORY: 2048M
  EULA: true
```

---

## Persistence

The Minecraft server data is stored in a Docker volume:

```
mc_data
```

This ensures that important data such as:

* world save data
* server configuration files
* generated content

are preserved even if the container is restarted or recreated.

---

## Testing

### 1. Server Availability

The server runs on:

```
localhost:8888
```

For deployment on a cloud VM:

```
<YOUR_SERVER_IP>:8888
```

You can verify that the port is reachable:

```bash
nc -vz localhost 8888
```

---

### 2. Persistence Test

To verify that data is not lost after a restart:

```bash
docker exec mc-server sh -c 'echo test123 > /data/test.txt'
docker compose restart
docker exec mc-server cat /data/test.txt
```

Expected output:

```
test123
```

---

### 3. Restart Behavior Test

To simulate a failure, terminate the main Java process:

```bash
docker exec mc-server pkill java
```

After a few seconds, the container restarts automatically due to:

```
restart: always
```

Verify restart count:

```bash
docker inspect mc-server --format '{{.RestartCount}}'
```

---sqw

### 4. Automated Testing with Python

A simple automated test can be performed using the `mcstatus` library.

#### Setup

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

#### Run the test

```bash
python test_server.py
```

#### Example script (`test_server.py`)

```python
from mcstatus import JavaServer

server = JavaServer.lookup("localhost:8888")
status = server.status()

print("Server description:", status.description)
print("Players online:", status.players.online)
print("Max players:", status.players.max)
```

#### Expected output

```
Server description: A Minecraft Server
Players online: 0
Max players: 20
```

If the script returns server information, the server is reachable and functioning correctly.

---

## Notes

* The Minecraft server uses a fixed version downloaded from the official Mojang source to ensure reproducibility.
* No sensitive data (such as credentials or SSH keys) is stored in this repository.
* All configuration is handled via environment variables.
* The container is configured with `restart: always` to ensure automatic recovery from failures.
* The Python test script provides an additional way to validate server availability without requiring a Minecraft client.

---
