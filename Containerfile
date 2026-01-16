# Minimal test image for workflow validation
FROM alpine:3.23

LABEL org.opencontainers.image.title="Test Image" \
      org.opencontainers.image.description="Minimal image for testing publish workflows" \
      org.opencontainers.image.vendor="Test" \
      org.opencontainers.image.licenses="Apache-2.0"

ARG USER_UID=10001
USER ${USER_UID}

# Simple health check binary
COPY --chmod=755 <<EOF /healthcheck.sh
#!/bin/sh
echo "healthy"
EOF

ENTRYPOINT ["/bin/sh", "-c", "echo 'Test image running' && sleep infinity"]
