# Task-2 CI-CD Jenkins

# ----------- Build Stage -----------
FROM node:slim AS build

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# Clone Task-2 repository
RUN git clone https://github.com/Elevate-labs-intership/Task-2-CI-CD-JENKINS.git

# Install dependencies and build
WORKDIR /usr/src/app/Task-2-CI-CD-JENKINS
RUN npm ci --only=production && npm run build

# ----------- Runtime Stage -----------
FROM node:slim

WORKDIR /usr/src/app

# Copy only necessary files
COPY --from=build /usr/src/app/Task-2-CI-CD-JENKINS/.next ./.next
COPY --from=build /usr/src/app/Task-2-CI-CD-JENKINS/package*.json ./
COPY --from=build /usr/src/app/Task-2-CI-CD-JENKINS/node_modules ./node_modules

EXPOSE 3000

CMD ["npm", "start"]