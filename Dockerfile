FROM python:3.13-slim-bookworm

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# The hosted decoder scripts run as child processes of hostingbot.py.
# Install Go in this same container so their Pantegnos fallback can build/run.
RUN apt-get update && apt-get install -y --no-install-recommends \
    golang-go \
    ca-certificates \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt ./requirements.txt
RUN python -m pip install --upgrade pip && pip install -r requirements.txt
COPY hostingbot.py ./hostingbot.py

EXPOSE 8080
CMD ["python", "hostingbot.py"]
