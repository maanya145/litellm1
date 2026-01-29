FROM python:3.11-slim

# ---- system deps (rarely change → cached) ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# ---- python deps (cacheable layer) ----
# Copy nothing except what's needed for pip
RUN pip install --upgrade pip \
    && pip install --no-cache-dir "litellm[proxy]"

# ---- app config (changes often → later layer) ----
COPY config.yaml /app/config.yaml

EXPOSE 8080

CMD ["sh", "-c", "litellm --config config.yaml --port ${PORT:-8080} --detailed_debug"]
