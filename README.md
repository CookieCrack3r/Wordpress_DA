# WordPress (Docker)

WordPress with a MySQL database, operated with Docker Compose — configured
through a local `.env` file, with persistent data in named volumes and
automatic restart on crashes.

## Table of Contents

- [Description](#description)
- [Repository Contents](#repository-contents)
- [Quickstart](#quickstart)
- [Usage](#usage)
  - [Environment Variables (.env)](#environment-variables-env)
  - [Applying Changes](#applying-changes)
  - [Data & Persistence](#data--persistence)
- [Testing](#testing)


## Repository Contents

| File | Purpose |
| --- | --- |
| `Dockerfile` | Builds the WordPress image from the official base image; extension point for custom themes/plugins. |
| `docker-compose.yaml` | Runtime configuration: builds the image, wires WordPress to the database, publishes the port, attaches the named volumes, injects `.env`, sets restart policies and the DB healthcheck. |
| `.env.example` | Template for the local `.env` file (all configuration). Copy it to `.env` and adjust the values — the real `.env` is excluded from git. |
| `.gitignore` | Keeps environment-specific files (`.env`) out of the repository. |
| `README.md` | This documentation. |

WordPress files (themes, plugins, uploads) live in the named volume
`wordpress`, the database in the named volume `db` — both are created
automatically on first start.

## Quickstart

**Prerequisites:** Git, Docker Engine with the Compose plugin (Docker Desktop
on Windows/macOS, or Docker CE on Linux).

```sh
git clone <repo-url>
cd Wordpress
cp .env.example .env    # then set a real MYSQL_PASSWORD
docker compose up -d --build
```

Open <http://localhost:8080> (or the `HOST_PORT` you configured) and run the
WordPress install wizard (language, site title, admin account).

## Usage

### Environment Variables (.env)

| Variable | Default | Purpose |
| --- | --- | --- |
| `HOST_PORT` | `8080` | Port published on the host; Apache always listens on 80 inside the container. |
| `MYSQL_DATABASE` | `wordpress` | Database name, created on first start. |
| `MYSQL_USER` | `wordpress` | Database user, created on first start. |
| `MYSQL_PASSWORD` | – | Database password. Set a real value before the first start. |

The MySQL root account gets a random throwaway password
(`MYSQL_RANDOM_ROOT_PASSWORD`) — WordPress never uses root.

> **Note:** `MYSQL_*` values only take effect on the **first** start, when the
> database is initialized. Changing them later requires resetting the `db`
> volume (see below) or changing the credentials inside MySQL.

### Applying Changes

| Change | Command |
| --- | --- |
| `.env` (e.g. `HOST_PORT`) | `docker compose up -d` |
| `Dockerfile` | `docker compose up -d --build` |
| Reset everything (deletes site + DB!) | `docker compose down -v` |

### Data & Persistence

`docker compose down` stops and removes the containers, but the named volumes
survive — site content and database are back after the next `up`. Only
`docker compose down -v` deletes the volumes.

## Testing

```sh
docker compose ps                  # both services "running", db "healthy"
docker compose logs -f wordpress   # Apache access/error log
curl -I http://localhost:8080      # HTTP 200 (or 30x to the install wizard)
```
