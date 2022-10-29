{{/* Common labels shared across objects */}}
{{- define "common.labels" -}}
helm.sh/chart: {{ include "bjw-s.common.lib.chart.names.chart" . }}
{{ include "common.labels.selectorLabels" . }}
  {{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
  {{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
  {{- with .Values.global.labels }}
    {{- range $k, $v := . }}
      {{- $name := $k }}
      {{- $value := tpl $v $ }}
{{ $name }}: {{ quote $value }}
    {{- end }}
  {{- end }}
{{- end -}}

{{/* Selector labels shared across objects */}}
{{- define "common.labels.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bjw-s.common.lib.chart.names.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
