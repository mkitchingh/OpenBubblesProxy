FROM python:3.12-alpine

WORKDIR /app
COPY proxy.py .

# identity registry lives on a volume so registrations survive rebuilds
ENV REGISTRY_PATH=/data/registry.json
EXPOSE 8080

CMD ["python", "proxy.py"]
