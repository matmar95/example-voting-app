FROM alpine as certs
RUN apk update && apk add ca-certificates curl

RUN curl -LO "https://download.sysdig.com/scanning/bin/sysdig-cli-scanner/$(curl -L -s https://download.sysdig.com/scanning/sysdig-cli-scanner/latest_version.txt)/linux/amd64/sysdig-cli-scanner" \
    && chmod +x ./sysdig-cli-scanner

FROM busybox
COPY --from=certs /etc/ssl/certs /etc/ssl/certs
COPY --from=certs /sysdig-cli-scanner /

ENTRYPOINT ["/sysdig-cli-scanner"]
