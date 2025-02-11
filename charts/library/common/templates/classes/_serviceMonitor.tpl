{{- define "bjw-s.common.class.serviceMonitor" -}}
  {{- $rootContext := .rootContext -}}
  {{- $serviceMonitorObject := .object -}}
  {{- $labels := merge
    ($serviceMonitorObject.labels | default dict)
    (include "bjw-s.common.lib.metadata.allLabels" $rootContext | fromYaml)
  -}}
  {{- $annotations := merge
    ($serviceMonitorObject.annotations | default dict)
    (include "bjw-s.common.lib.metadata.globalAnnotations" $rootContext | fromYaml)
  -}}
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{ $serviceMonitorObject.name }}
  {{- with $labels }}
  labels:
    {{- range $key, $value := . }}
    {{- printf "%s: %s" $key (tpl $value $rootContext | toYaml ) | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- with $annotations }}
  annotations:
    {{- range $key, $value := . }}
    {{- printf "%s: %s" $key (tpl $value $rootContext | toYaml ) | nindent 4 }}
    {{- end }}
  {{- end }}
  namespace: {{ $rootContext.Release.Namespace }}
spec:
  jobLabel: "{{ $serviceMonitorObject.name }}"
  namespaceSelector:
    matchNames:
      - {{ $rootContext.Release.Namespace }}
  selector:
    {{- if $serviceMonitorObject.selector -}}
      {{- tpl ($serviceMonitorObject.selector | toYaml) $rootContext | nindent 4}}
    {{- else }}
    matchLabels:
      app.kubernetes.io/service: {{ tpl $serviceMonitorObject.serviceName $rootContext }}
      {{- include "bjw-s.common.lib.metadata.selectorLabels" $rootContext | nindent 6 }}
    {{- end }}
  endpoints: {{- tpl (toYaml $serviceMonitorObject.endpoints) $rootContext | nindent 4 }}
  {{- if not (empty $serviceMonitorObject.targetLabels )}}
  targetLabels:
    {{- toYaml $serviceMonitorObject.targetLabels | nindent 4 }}
  {{- end }}
{{- end }}
