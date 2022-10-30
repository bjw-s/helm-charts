{{- define "bjw-s.common.class.serviceMonitor" -}}
{{- $values := dict -}}
{{- if hasKey . "ObjectValues" -}}
  {{- with .ObjectValues.serviceMonitor -}}
    {{- $values = . -}}
  {{- end -}}
{{ end -}}

{{- $serviceMonitorName := include "bjw-s.common.lib.chart.names.fullname" . -}}
{{- if and (hasKey $values "nameOverride") $values.nameOverride -}}
  {{- $serviceMonitorName = printf "%v-%v" $serviceMonitorName $values.nameOverride -}}
{{ end -}}
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{ $serviceMonitorName }}
  {{- with (merge ($values.labels | default dict) (include "common.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (merge ($values.annotations | default dict) (include "common.annotations" $ | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  selector:
    {{- if $values.selector -}}
      {{- tpl ($values.selector | toYaml) $ | nindent 4}}
    {{- else }}
    matchLabels:
      app.kubernetes.io/service: {{ tpl $values.serviceName $ }}
      {{- include "common.labels.selectorLabels" . | nindent 6 }}
    {{- end }}
  endpoints: {{- toYaml (required (printf "endpoints are required for serviceMonitor %v" $serviceMonitorName) $values.endpoints) | nindent 4 }}
{{- end }}
