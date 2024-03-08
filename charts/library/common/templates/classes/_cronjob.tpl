{{/*
This template serves as a blueprint for Cronjob objects that are created
using the common library.
*/}}
{{- define "bjw-s.common.class.cronjob" -}}
  {{- $rootContext := .rootContext -}}
  {{- $cronjobObject := .object -}}

  {{- $timeZone := "" -}}
  {{- if ge (int $rootContext.Capabilities.KubeVersion.Minor) 27 }}
    {{- $timeZone = dig "cronjob" "timeZone" "" $cronjobObject -}}
  {{- end -}}

  {{- $labels := merge
    (dict "common.bjw-s.dev/controller" $cronjobObject.identifier)
    ($cronjobObject.labels | default dict)
    (include "bjw-s.common.lib.metadata.allLabels" $rootContext | fromYaml)
  -}}
  {{- $annotations := merge
    ($cronjobObject.annotations | default dict)
    (include "bjw-s.common.lib.metadata.globalAnnotations" $rootContext | fromYaml)
  -}}

  {{- $cronJobSettings := dig "cronjob" dict $cronjobObject -}}
---
apiVersion: batch/v1
kind: CronJob
metadata:
  name: {{ $cronjobObject.name }}
  {{- with $labels }}
  labels: {{- toYaml . | nindent 4 -}}
  {{- end }}
  {{- with $annotations }}
  annotations: {{- toYaml . | nindent 4 -}}
  {{- end }}
spec:
  suspend: {{ default false $cronJobSettings.suspend }}
  concurrencyPolicy: {{ default "Forbid" $cronJobSettings.concurrencyPolicy }}
  startingDeadlineSeconds: {{ default 30 $cronJobSettings.startingDeadlineSeconds }}
  {{- with $timeZone }}
  timeZone: {{ . }}
  {{- end }}
  schedule: {{ $cronJobSettings.schedule | quote }}
  successfulJobsHistoryLimit: {{ default 1 $cronJobSettings.successfulJobsHistory }}
  failedJobsHistoryLimit: {{ default 1 $cronJobSettings.failedJobsHistory }}
  jobTemplate:
    spec:
      {{- with $cronJobSettings.ttlSecondsAfterFinished }}
      ttlSecondsAfterFinished: {{ . }}
      {{- end }}
      {{- with $cronJobSettings.parallelism }}
      parallelism: {{ . }}
      {{- end }}
      backoffLimit: {{ default 6 $cronJobSettings.backoffLimit }}
      template:
        metadata:
          {{- with (include "bjw-s.common.lib.pod.metadata.annotations" (dict "rootContext" $rootContext "controllerObject" $cronjobObject)) }}
          annotations: {{ . | nindent 12 }}
          {{- end -}}
          {{- with (include "bjw-s.common.lib.pod.metadata.labels" (dict "rootContext" $rootContext "controllerObject" $cronjobObject)) }}
          labels: {{ . | nindent 12 }}
          {{- end }}
        spec: {{ include "bjw-s.common.lib.pod.spec" (dict "rootContext" $rootContext "controllerObject" $cronjobObject) | nindent 10 }}
{{- end -}}
