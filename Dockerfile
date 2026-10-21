FROM python:3.13-slim-bookworm

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# Step 1: System dependencies (curl, tar, build tools)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    tar \
    ca-certificates \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Step 2: Install LATEST Go (1.23.4) instead of Debian's old 1.19
RUN curl -LO https://go.dev/dl/go1.23.4.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.23.4.linux-amd64.tar.gz \
    && rm go1.23.4.linux-amd64.tar.gz

# Step 3: Add Go to PATH so the bot can find it
ENV PATH=$PATH:/usr/local/go/bin

WORKDIR /app

COPY requirements.txt ./requirements.txt
RUN python -m pip install --upgrade pip && pip install -r requirements.txt

COPY hostingbot.py ./hostingbot.py

EXPOSE 8080

CMD ["python", "hostingbot.py"]
