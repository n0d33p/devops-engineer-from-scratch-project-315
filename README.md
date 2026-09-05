# Project DevOps Deploy

![CI](https://github.com/n0d33p/project-devops-deploy/actions/workflows/ci.yml/badge.svg)

Bulletin board service.

## About this repository

This repository contains the Ansible-based infrastructure-as-code setup used to
deploy the application from [n0d33p/project-devops-deploy](https://github.com/n0d33p/project-devops-deploy)
to a Yandex Cloud VM: server provisioning, Docker, Nginx + Let's Encrypt (HTTPS),
S3-compatible object storage, and automated deploy/update/rollback via `Makefile`.

Created as part of Hexlet's "Bulletin board (IaC)" assignment.

## Application Link

- **Production URL:** [https://bulletinsproject.ru/#/bulletins](https://bulletinsproject.ru/#/bulletins)
- **Swagger UI:** [https://bulletinsproject.ru/swagger-ui/index.html](https://bulletinsproject.ru/swagger-ui/index.html)

---

## Deployment Requirements

### Control Node (Host Machine)
- **OS:** Linux / macOS
- **Python:** 3.10+
- **Ansible:** 2.15+
- **Ansible Collections:** `community.docker`, `community.general`, `amazon.aws`
- **Ansible Galaxy Roles:** `geerlingguy.docker`, `geerlingguy.nginx`, `geerlingguy.certbot`
- Install both via `make bootstrap`

### Target Server (Managed Node)
- **OS:** Ubuntu 22.04 / 24.04 LTS
- **Ports Open:** 80 (HTTP), 443 (HTTPS), 22 (SSH)
- **Access:** User with `sudo` privileges and SSH key authorization
- **Pre-installed software:** Python 3 (Docker and Nginx are provisioned automatically via Ansible roles)

---

## Deployment & Management Commands

All deployment workflows are automated via `Makefile`:

```bash
# 1. Install required Ansible collections and roles
make bootstrap

# 2. Deploy infrastructure and application to production
make deploy

# 3. Update application to a new image version
make update IMAGE_TAG=v1.0.1

# 4. Rollback application to a previous stable tag
make rollback IMAGE_TAG=v1.0.0
```

---

## Application Source Code

The application itself (Java/Spring Boot backend + React Admin frontend, local
run/build/test commands, Dockerfile) lives in a separate repository:
[n0d33p/project-devops-deploy](https://github.com/n0d33p/project-devops-deploy)

Published Docker Image: **[`nxdeep/project-devops-deploy`](https://hub.docker.com/r/nxdeep/project-devops-deploy)**

---

## Environment Variables Configuration

Non-secret configuration lives in `group_vars/main.yml` (applies to every host).
Secrets are split per-group and managed via Ansible Vault:
- `group_vars/webservers/vault.yml` — OS user password, S3 keys (used by the
  deployed application on the target server)
- `group_vars/localnode/vault.yml` — S3 keys (used locally when provisioning
  the bucket via `roles/storage`)

The application runs on its default `dev` profile (in-memory H2 database) —
no external database is configured. Key environment variables passed to the
container:

* `STORAGE_S3_BUCKET` / `STORAGE_S3_REGION` / `STORAGE_S3_ENDPOINT` /
  `STORAGE_S3_ACCESSKEY` / `STORAGE_S3_SECRETKEY` — Yandex Object Storage
  (S3-compatible) configuration for uploaded images
* `MANAGEMENT_SERVER_PORT` — `9090` (Actuator monitoring)
* `JAVA_OPTS` — JVM heap limits and logging configuration