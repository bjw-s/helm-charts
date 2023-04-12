{{/*
Renders the serviceMonitor objects required by the chart.
*/}}
{{- define "bjw-s.common.render.serviceMonitors" -}}
  {{- /* Generate named serviceMonitors as required */ -}}
  {{- range $key, $serviceMonitor := .Values.serviceMonitor -}}
    {{- if $serviceMonitor.enabled -}}
      {{- $serviceMonitorValues := (mustDeepCopy $serviceMonitor) -}}

      {{/* Determine the serviceMonitor name */}}
      {{- $serviceMonitorName := (include "bjw-s.common.lib.chart.names.fullname" $) -}}
      {{- if $serviceMonitorValues.nameOverride -}}
        {{- $serviceMonitorName = printf "%s-%s" $serviceMonitorName $serviceMonitorValues.nameOverride -}}
      {{- else -}}
        {{- if ne $key "main" -}}
          {{- $serviceMonitorName = printf "%s-%s" $serviceMonitorName $key -}}
        {{- end -}}
      {{- end -}}
      {{- $_ := set $serviceMonitorValues "name" $serviceMonitorName -}}
      {{- $_ := set $serviceMonitorValues "key" $key -}}

      {{- /* Perform validations on the serviceMonitor before rendering */ -}}
      {{- include "bjw-s.common.lib.serviceMonitor.validate" (dict "rootContext" $ "object" $serviceMonitorValues) -}}

      {{/* Include the serviceMonitor class */}}
      {{- include "bjw-s.common.class.serviceMonitor" (dict "rootContext" $ "object" $serviceMonitorValues) | nindent 0 -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
