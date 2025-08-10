# CI-CD Jenkins

# ----------- Build Stage -----------
FROM node:slim AS build

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# Clone SourceCode repository
RUN git clone https://github.com/HATAKEkakshi/Jenkins-CI-CD-Using-Terraform-Ansible-Docker-Jenkins.git

# Install dependencies and build
WORKDIR /usr/src/app/Jenkins-CI-CD-Using-Terraform-Ansible-Docker-Jenkins
RUN npm install && npm run build

# ----------- Runtime Stage -----------
FROM node:slim

WORKDIR /usr/src/app

# Copy only necessary files
COPY --from=build /usr/src/app/Jenkins-CI-CD-Using-Terraform-Ansible-Docker-Jenkins/.next ./.next
COPY --from=build /usr/src/app/Jenkins-CI-CD-Using-Terraform-Ansible-Docker-Jenkins/package*.json ./
COPY --from=build /usr/src/app/Jenkins-CI-CD-Using-Terraform-Ansible-Docker-Jenkins/node_modules ./node_modules

EXPOSE 3000

CMD ["npm", "start"]
