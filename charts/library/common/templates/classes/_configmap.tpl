{{/*
This template serves as a blueprint for all configMap objects that are created
within the common library.
*/}}
{{- define "common.classes.configmap" -}}
  {{- $fullName := include "common.names.fullname" . -}}
  {{- $configMapName := $fullName -}}
  {{- $values := .Values.configmap -}}

  {{- if hasKey . "ObjectValues" -}}
    {{- with .ObjectValues.configmap -}}
      {{- $values = . -}}
    {{- end -}}
  {{ end -}}

  {{- if and (hasKey $values "nameOverride") $values.nameOverride -}}
    {{- $configMapName = printf "%v-%v" $configMapName $values.nameOverride -}}
  {{- end }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $configMapName }}
  {{- with (merge ($values.labels | default dict) (include "common.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (merge ($values.annotations | default dict) (include "common.annotations" $ | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
data:
{{- with $values.data }}
  {{- tpl (toYaml .) $ | nindent 2 }}
{{- end }}
{{- end }}
