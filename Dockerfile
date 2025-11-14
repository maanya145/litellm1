# Use an official Python slim image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies (optional but recommended for SSL, etc.)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install litellm with proxy extras
RUN pip install --no-cache-dir "litellm[proxy]"

# Copy your config.yaml into the container
COPY config.yaml /app/config.yaml

# Expose the default LiteLLM proxy port
EXPOSE 4000

# Start the proxy using your config
CMD ["litellm", "--config", "config.yaml", "--detailed_debug"]
