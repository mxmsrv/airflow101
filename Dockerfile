FROM python:3.7-slim-bullseye

ARG USERNAME=airflow
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ARG AIRFLOW_HOME=/home/${USERNAME}
ARG AIRFLOW_VERSION=2.5.3

ARG PATH=${AIRFLOW_HOME}/.local/bin:$PATH

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

USER $USERNAME
WORKDIR $AIRFLOW_HOME

RUN PYTHON_VERSION="$(python --version | cut -d " " -f 2 | cut -d "." -f 1-2)" \
    && CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt" \
    && pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

ENV PATH="$AIRFLOW_HOME/.local/bin:$PATH"

CMD [ "airflow", "standalone" ]
# CMD [ "sleep", "3600" ]
