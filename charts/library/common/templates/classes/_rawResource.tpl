{{/*
This template serves as a blueprint for all raw resource objects that are created
within the common library.
*/}}
{{- define "bjw-s.common.class.rawResource" -}}
  {{- $rootContext := .rootContext -}}
  {{- $resourceObject := .object -}}

  {{- $labels := merge
    ($resourceObject.labels | default dict)
    (include "bjw-s.common.lib.metadata.allLabels" $rootContext | fromYaml)
  -}}
  {{- $annotations := merge
    ($resourceObject.annotations | default dict)
    (include "bjw-s.common.lib.metadata.globalAnnotations" $rootContext | fromYaml)
  -}}
---
apiVersion: {{ $resourceObject.apiVersion }}
kind: {{ $resourceObject.kind }}
metadata:
  name: {{ $resourceObject.name }}
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
{{- with $resourceObject.spec }}
  {{- tpl (toYaml .) $rootContext | nindent 0 }}
{{- end }}
{{- end -}}
