FROM node:18

# Install system dependencies
RUN apt-get update && apt-get install -y git socat && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Clone Cal.com source code
RUN git clone https://github.com/calcom/cal.com.git .

# Environment variables needed at build time
ENV DATABASE_URL=postgresql://ufokvmvq34ohfb1mzla9:edDmbVkcqmOF21XzoYCb@bf2o87qp9os32sohc3ij-postgresql.services.clever-cloud.com:7419/bf2o87qp9os32sohc3ij
ENV DATABASE_DIRECT_URL=postgresql://ufokvmvq34ohfb1mzla9:edDmbVkcqmOF21XzoYCb@bf2o87qp9os32sohc3ij-postgresql.services.clever-cloud.com:7419/bf2o87qp9os32sohc3ij?schema=public
ENV NEXT_PUBLIC_WEBAPP_URL=http://localhost:8080
ENV NEXT_PUBLIC_WEBSITE_URL=http://localhost:8080
ENV NEXT_PUBLIC_CONSOLE_URL=http://localhost:3004
ENV NEXT_PUBLIC_EMBED_LIB_URL=http://localhost:8080/embed/embed.js
ENV ALLOWED_HOSTNAMES='"cal.com","cal.dev","cal-staging.com","cal.community","cal.local:8080","localhost:8080"'
ENV RESERVED_SUBDOMAINS='"app","auth","docs","design","console","go","status","api","saml","www","matrix","developer","cal","my","team","support","security","blog","learn","admin"'
ENV NEXTAUTH_URL=http://localhost:8080
ENV NEXTAUTH_SECRET=JyHWW5Fkks6rpxx9j9YnjAo4qtFrjSvl+QqbnaD3f4c=
ENV CRON_API_KEY=0cc0e6c35519bba620c9360cfe3e68d0
ENV CRON_ENABLE_APP_SYNC=false
ENV CALENDSO_ENCRYPTION_KEY=Rjab51ROMmPtBgssV168xZ8vboDqJ59furG8p8t+/kw=
ENV PLAIN_API_URL=https://api.plain.com/v1
ENV GOOGLE_LOGIN_ENABLED=false
ENV NEXT_PUBLIC_FORMBRICKS_HOST_URL=https://app.formbricks.com
ENV NEXT_PUBLIC_IS_PREMIUM_NEW_PLAN=0
ENV API_KEY_PREFIX=cal_
ENV EMAIL_FROM=notifications@yourselfhostedcal.com
ENV EMAIL_FROM_NAME=Cal.com
ENV EMAIL_SERVER_HOST=localhost
ENV EMAIL_SERVER_PORT=1025
ENV NEXT_PUBLIC_TEAM_IMPERSONATION=false
ENV NEXT_PUBLIC_APP_NAME=Cal.com
ENV NEXT_PUBLIC_SUPPORT_MAIL_ADDRESS=help@cal.com
ENV NEXT_PUBLIC_COMPANY_NAME=Cal.com, Inc.
ENV NEXT_PUBLIC_MINUTES_TO_BOOK=5
ENV NEXT_PUBLIC_BOOKER_NUMBER_OF_DAYS_TO_LOAD=0
ENV NEXT_PUBLIC_ORGANIZATIONS_MIN_SELF_SERVE_SEATS=30
ENV NEXT_PUBLIC_ORGANIZATIONS_SELF_SERVE_PRICE_NEW=37
ENV E2E_TEST_CALCOM_QA_EMAIL=qa@example.com
ENV E2E_TEST_CALCOM_QA_PASSWORD=password
ENV CALCOM_CREDENTIAL_SYNC_HEADER_NAME=calcom-credential-sync-secret
ENV SENTRY_DISABLE_SERVER_WEBPACK_PLUGIN=1
ENV NEXT_PUBLIC_API_V2_URL=http://localhost:5555/api/v2
ENV TASKER_ENABLE_WEBHOOKS=0
ENV TASKER_ENABLE_EMAILS=0
ENV NEXT_PUBLIC_INVALIDATE_AVAILABLE_SLOTS_ON_BOOKING_FORM=0
ENV NEXT_PUBLIC_QUICK_AVAILABILITY_ROLLOUT=10
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_OPTIONS=--max-old-space-size=6144

# Install dependencies using Yarn
RUN corepack enable && yarn install --frozen-lockfile && yarn build

# Expose the port expected by Clever Cloud (informational)
EXPOSE 8080

# Start script: forward Clever Cloud's expected 8080 PORT to Cal.com port 3000
CMD socat TCP-LISTEN:8080,fork TCP:localhost:3000 & yarn start
