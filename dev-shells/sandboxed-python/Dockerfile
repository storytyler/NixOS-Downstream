FROM python:3.13-slim-bookworm

ARG PYTHON_VERSION=3.13
ARG UV_VERSION=0.5.15
ARG POETRY_VERSION=1.8.5
ARG RUFF_VERSION=0.9.0
ARG BLACK_VERSION=24.10.0

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    vim \
    curl \
    wget \
    ca-certificates \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r developer && useradd -r -g developer -m developer

RUN pip install --no-cache-dir \
    uv==${UV_VERSION} \
    poetry==${POETRY_VERSION} \
    ruff==${RUFF_VERSION} \
    black==${BLACK_VERSION} \
    basedpyright \
    pip-tools

RUN mkdir -p /workspace && chown developer:developer /workspace
WORKDIR /workspace

USER developer

RUN poetry config virtualenvs.create false

RUN git config --global init.defaultBranch main && \
    git config --global user.name "Developer" && \
    git config --global user.email "dev@localhost"

ENV SHELL=/bin/bash
ENV PS1="🐍 \[\033[36m\]\w\[\033[0m\] $ "

CMD ["/bin/bash"]
