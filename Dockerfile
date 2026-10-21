FROM python:3.13-slim-bookworm

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# 1. System dependencies (git is required to clone Pantegnos)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    tar \
    git \
    ca-certificates \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 2. Install Latest Go (1.23.4)
RUN curl -LO https://go.dev/dl/go1.23.4.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.23.4.linux-amd64.tar.gz \
    && rm go1.23.4.linux-amd64.tar.gz

# 3. Add Go to PATH
ENV PATH=$PATH:/usr/local/go/bin

WORKDIR /app

# 4. PRE-BUILD PANTEGNOS DURING DOCKER BUILD
# Ye line Pantegnos ko pehle se build kar degi aur exact usi folder me rakhegi jahan tera bot dhundh raha hai
RUN mkdir -p /root/.msd_v20_decoders && \
    git clone https://github.com/FrontierTM/Pantegnos.git /root/.msd_v20_decoders/pantegnos_bundle && \
    cd /root/.msd_v20_decoders/pantegnos_bundle && \
    go build -o /root/.msd_v20_decoders/pantegnos ./cmd/pantegnos

# 5. Install Python requirements
COPY requirements.txt ./requirements.txt
RUN python -m pip install --upgrade pip && pip install -r requirements.txt

# 6. Copy bot code
COPY hostingbot.py ./hostingbot.py

EXPOSE 8080

CMD ["python", "hostingbot.py"]
