{{/*
Convert ServiceMonitor values to an object
*/}}
{{- define "bjw-s.common.lib.serviceMonitor.valuesToObject" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $objectValues := .values -}}

  {{- /* Determine and inject the ServiceMonitor name */ -}}
  {{- $objectName := (include "bjw-s.common.lib.chart.names.fullname" $rootContext) -}}

  {{- if $objectValues.nameOverride -}}
    {{- $override := tpl $objectValues.nameOverride $rootContext -}}
    {{- if not (eq $objectName $override) -}}
      {{- $objectName = printf "%s-%s" $objectName $override -}}
    {{- end -}}
  {{- else -}}
    {{- $enabledServiceMonitors := (include "bjw-s.common.lib.serviceMonitor.enabledServiceMonitors" (dict "rootContext" $rootContext) | fromYaml ) }}
    {{- if gt (len $enabledServiceMonitors) 1 -}}
      {{- if not (eq $objectName $identifier) -}}
        {{- $objectName = printf "%s-%s" $objectName $identifier -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- $_ := set $objectValues "name" $objectName -}}
  {{- $_ := set $objectValues "identifier" $identifier -}}

  {{- /* Return the ServiceMonitor object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}
