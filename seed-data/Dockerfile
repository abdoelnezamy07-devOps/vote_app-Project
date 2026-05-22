# Stage 1: Build & Data Generation
FROM python:3.9-slim AS builder
WORKDIR /app
COPY make-data.py generate-votes.sh ./
RUN python make-data.py

# Stage 2: Execution Image
FROM alpine:latest
WORKDIR /app

# تثبيت أداة apache2-utils اللي فيها أمر 'ab'
RUN apk add --no-cache apache2-utils
RUN addgroup -S loadgroup && adduser -S loaduser -G loadgroup
# نسخ الملفات المولدة والسكريبت من المرحلة الأولى
COPY --from=builder --chown=loaduser:loadgroup /app/posta /app/postb ./
COPY --from=builder --chown=loaduser:loadgroup /app/generate-votes.sh ./
USER loaduser

# إعطاء صلاحية التنفيذ للسكريبت
# RUN chmod +x generate-votes.sh
# تشغيل السكريبت عند بدء الـ Container
CMD ["sh", "./generate-votes.sh"]
