FROM python:3.11-slim

# ---- system deps (rarely change → cached) ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*

# Force cache invalidation - Build 2026-02-02-06

WORKDIR /app

# ---- python deps (cacheable layer) ----
RUN pip install --upgrade pip \
    # Added 'prisma' extra here
    && pip install --no-cache-dir "litellm[proxy,prisma]"

# Install prisma client and generate
RUN pip install --no-cache-dir prisma httpx
WORKDIR /usr/local/lib/python3.11/site-packages/litellm/proxy
RUN prisma generate 2>/dev/null || true
WORKDIR /app

# ---- app config (changes often → later layer) ----
COPY config.yaml /app/config.yaml

EXPOSE 8080

# It is often helpful to run 'prisma generate' if you're using a custom schema, 
# but for the standard LiteLLM proxy, the package install is usually enough.
CMD ["sh", "-c", "litellm --config config.yaml --port ${PORT:-8080} --detailed_debug"]
