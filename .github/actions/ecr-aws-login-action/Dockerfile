# FROM python:latest
# WORKDIR /app
# COPY ../job-runner /app/job-runner
# RUN docker build -t my-python-runner -f job-runner/Dockerfile.pythonrunner .
# ENTRYPOINT ["docker", "run", "my-python-runner"]

# Container image that runs your code
FROM alpine:3.10

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
