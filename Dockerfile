FROM node:18

# Install system dependencies
RUN apt-get update && apt-get install -y git socat && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Clone Cal.com source code
RUN git clone https://github.com/calcom/cal.com.git .

ENV NODE_OPTIONS=--max-old-space-size=6144

# Install dependencies using Yarn
RUN corepack enable && yarn install --frozen-lockfile

# Expose the port expected by Clever Cloud (informational)
EXPOSE 8080

# Start script: forward Clever Cloud's expected 8080 PORT to Cal.com port 3000
CMD socat TCP-LISTEN:8080,fork TCP:localhost:3000 & \
    NODE_OPTIONS=--max-old-space-size=6144 yarn build && \
    NODE_OPTIONS=--max-old-space-size=6144 yarn start
