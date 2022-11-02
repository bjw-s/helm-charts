{{/*
Renders the serviceAccount object required by the chart.
*/}}
{{- define "bjw-s.common.render.serviceAccount" -}}
  {{- if .Values.serviceAccount.create -}}
    {{- include "bjw-s.common.class.serviceAccount" $ | nindent 0 -}}
  {{- end -}}
{{- end -}}
