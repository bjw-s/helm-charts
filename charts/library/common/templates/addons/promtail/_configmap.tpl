{{/*
The promtail config to be included.
*/}}
{{- define "bjw-s.common.addon.promtail.configmap" -}}
promtail.yaml: |
  server:
    http_listen_port: 9080
    grpc_listen_port: 0
  positions:
    filename: /tmp/positions.yaml
  {{- with .Values.addons.promtail.loki }}
  client:
    url: {{ . }}
  {{- end }}
  scrape_configs:
  {{- range .Values.addons.promtail.logs }}
  - job_name: {{ .name }}
    static_configs:
    - targets:
        - localhost
      labels:
        job: {{ .name }}
        __path__: "{{ .path }}"
  {{- end }}
{{- end -}}
