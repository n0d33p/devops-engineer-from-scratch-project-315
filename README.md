# Project DevOps Deploy

![CI](https://github.com/n0d33p/project-devops-deploy/actions/workflows/ci.yml/badge.svg)

Bulletin board service.

## Application Link

- **Production URL:** [https://bulletinsproject.ru/#/bulletins](https://bulletinsproject.ru/#/bulletins)
- **Swagger UI:** [https://bulletinsproject.ru/swagger-ui/index.html](https://bulletinsproject.ru/swagger-ui/index.html)

---

## Deployment Requirements

### Control Node (Host Machine)
- **OS:** Linux / macOS
- **Python:** 3.10+
- **Ansible:** 2.15+
- **Ansible Collections:** `community.docker`, `community.general`, `amazon.aws` (install via `make setup` or `make bootstrap`)

### Target Server (Managed Node)
- **OS:** Ubuntu 22.04 / 24.04 LTS
- **Ports Open:** 80 (HTTP), 443 (HTTPS), 22 (SSH)
- **Access:** User with `sudo` privileges and SSH key authorization
- **Pre-installed software:** Python 3 (Docker and Nginx/Caddy are provisioned automatically via Ansible roles)

---

## Deployment & Management Commands

All deployment workflows are automated via `Makefile`:

```bash
# 1. Install required Ansible collections
make setup

# 2. Deploy infrastructure and application to production
make deploy

# 3. Update application to a new image version
make update IMAGE_TAG=v1.0.1

# 4. Rollback application to a previous stable tag
make rollback IMAGE_TAG=v1.0.0

```

---

## About this fork

This is a fork of the [Hexlet `project-devops-deploy` template](https://github.com/Hexlet-components/project-devops-deploy), created as part of the "Bulletin board (IaC)" assignment.

**What was added in this fork:**

* Multi-stage `Dockerfile` assembling React Admin frontend and Spring Boot backend.
* Ansible roles (`common`, `deploy`, `nginx`, `storage`) for fully automated infrastructure provisioning and application deployment.
* CI workflow via GitHub Actions checking code formatting and tests.

Published Docker Image: **[`nxdeep/project-devops-deploy`](https://hub.docker.com/r/nxdeep/project-devops-deploy)**

---

## Local Development & Build

### Local Launch

```bash
# Run backend locally
make run

# Run tests & linting
make test
make lint

```

### Docker Commands

```bash
# Build Docker image
make docker-build

# Run Docker container locally
make docker-run

# Push image to registry
make docker-push

```

---

## Environment Variables Configuration

Sensitive data and environment configuration are managed via Ansible Vault in `group_vars/all/vault.yml` and `group_vars/all/main.yml`.

Key variables configured:

* `SPRING_PROFILES_ACTIVE`: `prod`
* `SPRING_DATASOURCE_URL`: PostgreSQL JDBC connection string
* `STORAGE_S3_*`: Object Storage S3 parameters
* `MANAGEMENT_SERVER_PORT`: `9090` (Actuator monitoring)

```

```