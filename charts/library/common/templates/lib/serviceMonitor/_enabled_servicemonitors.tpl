{{/*
Return the enabled serviceMonitors.
*/}}
{{- define "bjw-s.common.lib.serviceMonitor.enabledServiceMonitors" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledServiceMonitors := dict -}}

  {{- range $identifier, $serviceMonitor := $rootContext.Values.serviceMonitor -}}
    {{- if kindIs "map" $serviceMonitor -}}
      {{- /* Enable Service by default, but allow override */ -}}
      {{- $serviceMonitorEnabled := true -}}
      {{- if hasKey $serviceMonitor "enabled" -}}
        {{- $serviceMonitorEnabled = $serviceMonitor.enabled -}}
      {{- end -}}

      {{- if $serviceMonitorEnabled -}}
        {{- $_ := set $enabledServiceMonitors $identifier . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledServiceMonitors | toYaml -}}
{{- end -}}
