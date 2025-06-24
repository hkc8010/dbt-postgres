FROM quay.io/astronomer/astro-runtime:11.18.0

# SHELL ["/bin/bash", "-o", "pipefail", "-e", "-u", "-x", "-c"]
# LABEL maintainer="MLOpsSupport@thehartford.com"

# LABEL io.astronomer.docker.airflow.customimage=true

# COPY pip.conf .
# ENV PIP_CONFIG_FILE pip.conf

# COPY packages.txt .
USER root
# RUN if [[ -s packages.txt ]]; then \
#     apt-get update && cat packages.txt | tr '\r\n' '\n' | xargs apt-get install -y --no-install-recommends \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*; \
#   fi

#install dbt python venv
RUN python -m venv dbt_venv && source dbt_venv/bin/activate && \
    pip install --no-cache-dir dbt-postgres dbt-snowflake && deactivate

# # Install python packages
# COPY requirements_child.txt .
# RUN if grep -Eqx 'apache-airflow\s*[=~>]{1,2}.*' requirements_child.txt; then \
#     echo >&2 "Do not upgrade by specifying 'apache-airflow' in your requirements_child.txt, change the base image instead!";  exit 1; \
#   fi; \
#   pip install --upgrade pip -r requirements_child.txt
USER astro

# Copy entire project directory
COPY --chown=astro:astro . .
