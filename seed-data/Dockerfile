# Stage 1: Build & Data Generation
FROM python:3.9-slim AS builder
WORKDIR /app
COPY make-data.py generate-votes.sh ./
RUN python make-data.py

# Stage 2: Execution Image
FROM alpine:latest
WORKDIR /app

RUN apk add --no-cache apache2-utils
RUN addgroup -S loadgroup && adduser -S loaduser -G loadgroup
COPY --from=builder --chown=loaduser:loadgroup /app/posta /app/postb /app/generate-votes.sh ./
RUN chmod +x generate-votes.sh

USER loaduser
CMD ["sh", "-c", "sleep 5 && ./generate-votes.sh"]
