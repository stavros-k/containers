FROM python:3.11.4

# Install python dependencies
RUN pip install pre-commit

RUN mkdir -p /.cache
RUN chown 1000:1000 -R /.cache

USER 1000

ENTRYPOINT "cat"
