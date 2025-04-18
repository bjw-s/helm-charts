{{/*
Renders the serviceMonitor object required by the chart.
*/}}
{{- define "bjw-s.common.render.serviceMonitors" -}}
  {{- $rootContext := $ -}}

  {{- /* Generate named serviceMonitors as required */ -}}
  {{- $enabledServiceMonitors := (include "bjw-s.common.lib.serviceMonitor.enabledServiceMonitors" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledServiceMonitors -}}
    {{- /* Generate object from the raw serviceMonitor values */ -}}
    {{- $serviceMonitorObject := (include "bjw-s.common.lib.serviceMonitor.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- /* Perform validations on the ServiceMonitor before rendering */ -}}
    {{- include "bjw-s.common.lib.serviceMonitor.validate" (dict "rootContext" $rootContext "object" $serviceMonitorObject) -}}

    {{- /* Include the ServiceMonitor class */ -}}
    {{- include "bjw-s.common.class.serviceMonitor" (dict "rootContext" $rootContext "object" $serviceMonitorObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
