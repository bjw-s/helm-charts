{{/* Common annotations shared across objects */}}
{{- define "common.annotations" -}}
  {{- with .Values.global.annotations }}
    {{- range $k, $v := . }}
      {{- $name := $k }}
      {{- $value := tpl $v $ }}
{{ $name }}: {{ quote $value }}
    {{- end }}
  {{- end }}
{{- end -}}
