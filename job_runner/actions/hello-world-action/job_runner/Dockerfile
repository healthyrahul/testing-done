FROM python:3.10-slim-bullseye as no-sources

ENV SOURCE_PATH=/source
ENV SERVER_PATH=/srv
ENV RESOURCES_PATH=/srv/resources

RUN apt update
RUN apt install -y \
  git \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

RUN pip install --upgrade pip
RUN pip install pipenv

# Add docker repository. As bizarre as it sounds, this is the documented way to install docker on debian.
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt update
RUN apt install -y \
  docker-ce-cli \
  containerd.io \
  docker-compose-plugin
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Additional install for running keygen Scripts
RUN apt install openssh-client coreutils jq

# Tell git to trust the /source folder
RUN git config --global --add safe.directory /source

COPY Pipfile /srv/Pipfile
COPY Pipfile.lock /srv/Pipfile.lock

# WORKDIR into our Ballista code
WORKDIR /srv

# Testing
FROM no-sources AS dev-reqs

# This adds the user and group Jenkins uses
RUN addgroup --gid 1000 firstgroup && adduser --uid 1000 --gid 1000 firstuser

RUN pipenv sync --system --categories="packages dev-packages"

COPY . /srv

# Runner
FROM no-sources AS runner-image

RUN pipenv sync --system --categories="packages prod-packages"

COPY . /srv

ENV PYTHONPATH=/srv

# WORKDIR into our mapped source folder
WORKDIR /source

ENTRYPOINT ["python", "/srv/job_runner/main.py"]
