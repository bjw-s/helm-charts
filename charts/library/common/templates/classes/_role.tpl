{{/*
This template serves as a blueprint for generating Role objects in Kubernetes.
*/}}
{{- define "bjw-s.common.class.rbac.Role" -}}
  {{- $rootContext := .rootContext -}}
  {{- $roleObject := .object -}}

  {{- $labels := merge
    ($roleObject.labels | default dict)
    (include "bjw-s.common.lib.metadata.allLabels" $rootContext | fromYaml)
  -}}
  {{- $annotations := merge
    ($roleObject.annotations | default dict)
    (include "bjw-s.common.lib.metadata.globalAnnotations" $rootContext | fromYaml)
  -}}
  {{- $rules := "" -}}
  {{- with $roleObject.rules -}}
    {{- $rules = (toYaml . ) | trim -}}
  {{- end -}}
---
apiVersion: rbac.authorization.k8s.io/v1
{{ with $roleObject.type -}}
kind: {{ . }}
{{ end -}}
metadata:
  name: {{ $roleObject.name }}
  {{- with $labels }}
  labels: {{- toYaml . | nindent 4 -}}
  {{- end }}
  {{- with $annotations }}
  annotations: {{- toYaml . | nindent 4 -}}
  {{- end }}
  {{ if eq $roleObject.type "Role" -}}
  namespace: {{ $rootContext.Release.Namespace }}
  {{- end -}}
{{ with $rules }}
rules: {{- tpl . $rootContext | nindent 2 }}
{{- end }}

{{- end -}}
