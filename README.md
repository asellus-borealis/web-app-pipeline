# Web App Pipeline

Spring Boot microservice with Maven Wrapper, automated build/test scripts, and Docker containerization pipeline.

## Features

- **Spring Boot 3.2.5** REST Application with `/` and `/health` endpoints
- **Maven Wrapper (`./mvnw`)** - zero external Maven installation needed
- **Automated CI/CD Scripts**:
  - `scripts/build_and_test.sh`: automates clean build and unit tests
  - `scripts/deploy_container.sh`: builds Docker container and runs it with automated conflict cleanup
- **Dockerized deployment** (`eclipse-temurin:17-jre`)

## Quickstart

### Build and Test
```bash
chmod +x ./scripts/build_and_test.sh
./scripts/build_and_test.sh
```

### Deploy Container
```bash
chmod +x ./scripts/deploy_container.sh
./scripts/deploy_container.sh
```

### Health Check
```bash
curl http://localhost:8080/health
# {"status":"UP"}
```
