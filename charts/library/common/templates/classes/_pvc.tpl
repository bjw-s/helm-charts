{{/*
This template serves as a blueprint for all PersistentVolumeClaim objects that are created
within the common library.
*/}}
{{- define "bjw-s.common.class.pvc" -}}
  {{- $rootContext := .rootContext -}}
  {{- $pvcObject := .object -}}
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{ $pvcObject.name }}
  {{- with (merge ($pvcObject.labels | default dict) (include "bjw-s.common.lib.metadata.allLabels" $rootContext | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  annotations:
    {{- if $pvcObject.retain }}
    "helm.sh/resource-policy": keep
    {{- end }}
    {{- with (merge ($pvcObject.annotations | default dict) (include "bjw-s.common.lib.metadata.globalAnnotations" $rootContext | fromYaml)) }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
spec:
  accessModes:
    - {{ required (printf "accessMode is required for PVC %v" $pvcObject.name) $pvcObject.accessMode | quote }}
  resources:
    requests:
      storage: {{ required (printf "size is required for PVC %v" $pvcObject.name) $pvcObject.size | quote }}
  {{- if $pvcObject.storageClass }}
  storageClassName: {{ if (eq "-" $pvcObject.storageClass) }}""{{- else }}{{ $pvcObject.storageClass | quote }}{{- end }}
  {{- end }}
  {{- if $pvcObject.volumeName }}
  volumeName: {{ $pvcObject.volumeName | quote }}
  {{- end }}
{{- end -}}
