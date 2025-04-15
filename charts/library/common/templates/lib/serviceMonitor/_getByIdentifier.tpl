{{/*
Return a ServiceMonitor Object by its Identifier.
*/}}
{{- define "bjw-s.common.lib.serviceMonitor.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $enabledServiceMonitors := (include "bjw-s.common.lib.serviceMonitor.enabledServiceMonitors" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabledServiceMonitors $identifier) -}}
    {{- $objectValues := get $enabledServiceMonitors $identifier -}}
    {{- include "bjw-s.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledServiceMonitors)) -}}
  {{- end -}}
{{- end -}}
