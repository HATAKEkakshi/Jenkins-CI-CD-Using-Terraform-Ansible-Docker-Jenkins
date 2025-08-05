# Task-2 CI/CD Jenkins Pipeline

This project demonstrates a complete CI/CD pipeline setup using Jenkins, Docker, Terraform, and Ansible to build and deploy a Next.js web application.

## Architecture Overview

![CI/CD Architecture](image/CICD%20Jenkins.png)

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Developer     │    │   Jenkins       │    │   Docker Hub    │
│   (Local)       │───▶│   Server        │───▶│   Registry      │
│                 │    │   (AWS EC2)     │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │
         ▼                       ▼
┌─────────────────┐    ┌─────────────────┐
│   Terraform     │    │   Ansible       │
│   (IaC)         │    │   (Config Mgmt) │
└─────────────────┘    └─────────────────┘
```

## Infrastructure Components

### 1. Terraform Infrastructure (Infrastructure/)

**Purpose**: Provision AWS infrastructure using Infrastructure as Code (IaC)

**Components**:
- **EC2 Instance**: t3.medium with 30GB EBS volume for Jenkins server
- **Security Groups**: Allow SSH (port 22) and Jenkins (port 8080) access
- **Key Pair**: SSH key for secure access
- **S3 Backend**: Remote state storage for Terraform

**Key Files**:
```
Infrastructure/
├── provider.tf      # AWS provider configuration
├── instance.tf      # EC2 instance definition
├── SecGrp.tf       # Security group rules
├── keypair.tf      # SSH key pair
├── variable.tf     # Input variables
├── output.tf       # Output values
└── backend.tf      # S3 backend configuration
```

**Usage**:
```bash
cd Infrastructure/
terraform init
terraform plan
terraform apply
```

### 2. Ansible Configuration (Configuration/)

**Purpose**: Automate software installation and configuration on the provisioned infrastructure

**Playbooks**:

#### installation.yaml
- Installs Java JDK 21 (Jenkins requirement)
- Adds Jenkins repository and GPG key
- Installs and starts Jenkins service
- Retrieves initial admin password

#### docker-install.yaml
- Installs Docker CE and dependencies
- Adds jenkins user to docker group
- Starts Docker service

**Key Files**:
```
Configuration/
├── inventory.yaml           # Target hosts definition
├── installation/
│   └── installation.yaml   # Jenkins installation
└── docker-install.yaml     # Docker installation
```

**Usage**:
```bash
cd Configuration/
ansible-playbook installation/installation.yaml
ansible-playbook installation/docker-install.yaml
```

## CI/CD Pipeline

### Jenkins Pipeline (Jenkinsfile)

**Stages**:

1. **Cleanup**: Remove unused Docker resources to free disk space
2. **Fetch Code**: Clone source code from GitHub repository
3. **Build Docker Image**: Create containerized application
4. **Push to Docker Hub**: Upload image to registry

**Environment Variables**:
- `DOCKER_IMAGE`: hatakekakashihk/webapp
- `DOCKER_REGISTRY`: https://index.docker.io/v1/
- `DOCKER_CREDENTIALS`: dockerhub-credentials

### Docker Configuration

#### Dockerfile
Multi-stage build for optimized image size:

**Build Stage**:
- Uses Node.js slim image
- Installs Git and clones repository
- Runs `npm ci` and `npm run build`

**Runtime Stage**:
- Clean Node.js slim image
- Copies only necessary files (.next, package.json, node_modules)
- Exposes port 3000

#### compose.yml
Docker Compose configuration for local deployment:
```yaml
services:
  Web:
    image: hatakekakashihk/webapp
    platform: linux/amd64   
    container_name: Website
    ports:
      - "3000:3000"
```

## Setup Instructions

### Prerequisites
- AWS CLI configured with appropriate permissions
- Terraform installed
- Ansible installed
- Docker Hub account

### Step 1: Infrastructure Provisioning
```bash
# Navigate to Infrastructure directory
cd Infrastructure/

# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Apply infrastructure
terraform apply
```

### Step 2: Software Configuration
```bash
# Navigate to Configuration directory
cd Configuration/

# Install Jenkins
ansible-playbook installation/installation.yaml

# Install Docker
ansible-playbook installation/docker-install.yaml
```

### Step 3: Jenkins Setup
1. Access Jenkins at `http://<EC2_PUBLIC_IP>:8080`
2. Use initial admin password from Ansible output
3. Install suggested plugins
4. Create admin user

### Step 4: Configure Jenkins Pipeline
1. **Add Docker Hub Credentials**:
   - Go to "Manage Jenkins" → "Manage Credentials"
   - Add Username/Password credential
   - ID: `dockerhub-credentials`
   - Username: Your Docker Hub username
   - Password: Your Docker Hub password/token

2. **Create Pipeline Job**:
   - New Item → Pipeline
   - Pipeline Definition: "Pipeline script from SCM"
   - SCM: Git
   - Repository URL: `https://github.com/Elevate-labs-intership/Task-2-CI-CD-JENKINS.git`
   - Branch: `main`
   - Script Path: `Jenkinsfile`

### Step 5: Run Pipeline
1. Click "Build Now"
2. Monitor build progress in console output
3. Verify image pushed to Docker Hub

## Deployment

### Local Deployment
```bash
# Using Docker Compose
docker-compose up -d

# Access application at http://localhost:3000
```

### Production Deployment
```bash
# Pull and run the image
docker run -d -p 3000:3000 hatakekakashihk/webapp:latest
```

## Troubleshooting

### Common Issues

1. **Disk Space Error**:
   - Solution: Increase EBS volume size in `instance.tf`
   - Run cleanup: `docker system prune -a -f`

2. **Permission Denied (Docker)**:
   - Solution: Add jenkins user to docker group
   - Restart Jenkins service

3. **Build Failures**:
   - Check Jenkins console output
   - Verify Docker Hub credentials
   - Ensure sufficient disk space

### Monitoring
- Jenkins build logs: Available in Jenkins UI
- Docker container logs: `docker logs <container_name>`
- System resources: `df -h` and `docker system df`

## Security Considerations

- SSH access restricted to specific IP addresses
- Jenkins accessible only on port 8080
- EBS volumes encrypted
- Docker Hub credentials stored securely in Jenkins
- Regular security updates recommended

## Cost Optimization

- Use t3.medium instance (can be scaled down for development)
- Implement auto-shutdown for non-production environments
- Monitor EBS usage and adjust volume size as needed
- Use Docker multi-stage builds to reduce image size

## Future Enhancements

- Implement automated testing stages
- Add deployment to Kubernetes
- Set up monitoring and alerting
- Implement GitOps workflow
- Add security scanning for Docker images