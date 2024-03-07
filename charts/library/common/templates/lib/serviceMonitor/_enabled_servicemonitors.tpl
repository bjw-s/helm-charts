{{/*
Return the enabled ServiceMonitors.
*/}}
{{- define "bjw-s.common.lib.serviceMonitor.enabledServiceMonitors" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledServiceMonitors := dict -}}

  {{- range $name, $serviceMonitor := $rootContext.Values.serviceMonitor -}}
    {{- if kindIs "map" $serviceMonitor -}}
      {{- /* Enable by default, but allow override */ -}}
      {{- $serviceMonitorEnabled := true -}}
      {{- if hasKey $serviceMonitor "enabled" -}}
        {{- $serviceMonitorEnabled = $serviceMonitor.enabled -}}
      {{- end -}}

      {{- if $serviceMonitorEnabled -}}
        {{- $_ := set $enabledServiceMonitors $name . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledServiceMonitors | toYaml -}}
{{- end -}}
