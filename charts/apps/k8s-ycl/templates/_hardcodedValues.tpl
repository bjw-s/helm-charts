{{- define "k8s-ycl.hardcodedValues" -}}
controllers:
  main:
    containers:
      main:
        probes:
          liveness:
            enabled: true
            custom: true
            spec:
              httpGet:
                path: /healthz
                port: 8081
              initialDelaySeconds: 0
              periodSeconds: 10
              timeoutSeconds: 1
              failureThreshold: 3
          readiness:
            enabled: true
            custom: true
            spec:
              httpGet:
                path: /readyz
                port: 8081
              initialDelaySeconds: 0
              periodSeconds: 10
              timeoutSeconds: 1
              failureThreshold: 3
          startup:
            enabled: true
            custom: true
            spec:
              httpGet:
                path: /healthz
                port: 8081
              failureThreshold: 30
              periodSeconds: 10

service:
  main:
    enabled: true
    nameOverride: webhook
    ports:
      http:
        enabled: true
        port: 9443
      metrics:
        enabled: true
        port: 8080
      probe:
        enabled: true
        port: 8081

serviceAccount:
  create: true

persistence:
  certs:
    enabled: true
    type: secret
    name: {{ include "k8s-ycl.servingCertificate" . }}
    globalMounts:
      - path: /tls
{{- end -}}
