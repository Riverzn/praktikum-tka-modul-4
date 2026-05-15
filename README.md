# TKA Modul 4 — Logging and Monitoring

**Question Source:** [Cloud Computing Practicum Module 4](https://docs.google.com/document/d/1BELhOZZNuK7Y5WsFxK_uwBINmCrAcDb_lcNc4gwkrys/edit?tab=t.0)

## Group B08 Members

| No | Name | GitHub |
|----|------|--------|
| 1 | Adiwidya | [@Riverzn](https://github.com/Riverzn) |
| 2 | Prabaswara | [@zostradamus](https://github.com/zostradamus) |
| 3 | Zelig | [@zelebwr](https://github.com/zelebwr) |

---

## Overview

This practicum covers the implementation of **Logging and Monitoring** in a cloud-based system using the following tools:

- **Prometheus** — metrics collection and alerting toolkit
- **Node Exporter** — exposes system-level metrics (CPU, memory) to Prometheus
- **Grafana** — visualization and dashboarding platform
- **Node.js + prom-client** — custom application with exposed `/metrics` endpoint

---

## Project Structure

```
project-metrics-B08/
├── prometheus/
│   └── prometheus.yml
├── node-app/
│   ├── app.js
│   ├── Dockerfile
│   └── package.json
└── docker-compose.yml
```

---

## Question 1 — Spiral Power Engine Monitoring

Sets up a real-time remote metrics monitoring system for Team Dai-Gurren's Gurren Lagann mecha, tracking:
- **CPU Usage** — representing Spiral Power Output
- **Memory Usage** — representing Core Structural Integrity

### Services
| Service | Image | Port |
|---------|-------|------|
| node-exporter | prom/node-exporter:latest | 9100 |
| prometheus | prom/prometheus:latest | 9090 |
| grafana | grafana/grafana:latest | 3000 |

### Key Configurations
- Prometheus scrape interval: **5s**
- Prometheus job name: `gurren-lagann-core`
- Grafana credentials: `simon` / `gigadrillbreaker`
- Persistent volumes: `prometheus_data`, `grafana_data`
- Dashboard: **"Gurren Lagann Vitals"** with CPU and Memory panels

---

## Question 3 — Web App Monitoring & Alerting

Extends the setup from Question 1 by adding a Node.js application that exposes HTTP request metrics, and configures alerting in Grafana.

### Additional Service
| Service | Image | Port |
|---------|-------|------|
| node-app | custom build | 3001 |

### Key Configurations
- Prometheus job name: `node-app-metrics`
- Metrics endpoint: `http://localhost:3001/metrics`
- Dashboard panel: **"Total HTTP Request (node-app)"**
- Alert rule: `Over Kicau Alert` — fires when HTTP requests exceed threshold

### PromQL Queries Used
```promql
# CPU Usage
100 - (avg by(instance)(rate(node_cpu_seconds_total{mode="idle"}[1m])) * 100)

# Memory Usage
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100

# Total HTTP Requests
sum(http_requests_total{job="node-app-metrics"})
```

---

## How to Run

```bash
# Clone and enter project directory
cd project-metrics-B08

# Start all services
docker compose up -d --build

# Verify services are running
docker ps

# Generate traffic to node-app
for i in $(seq 1 30); do curl http://localhost:3001/; done
```

### Access Points
| Service | URL |
|---------|-----|
| Prometheus | http://localhost:9090 |
| Grafana | http://localhost:3000 |
| Node App | http://localhost:3001 |
| Node App Metrics | http://localhost:3001/metrics |
