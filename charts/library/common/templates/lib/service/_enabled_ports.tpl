{{/*
Return the enabled ports for a given Service object.
*/}}
{{- define "bjw-s.common.lib.service.enabledPorts" -}}
  {{- $enabledPorts := dict -}}

  {{- range $name, $port := .values.ports -}}
    {{- if kindIs "map" $port -}}
      {{- $portEnabled := true -}}
      {{- if hasKey $port "enabled" -}}
        {{- $portEnabled = $port.enabled -}}
      {{- end -}}
      {{- if $portEnabled -}}
        {{- $_ := set $enabledPorts $name . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- if eq 0 (len $enabledPorts) }}
    {{- fail (printf "No ports are enabled for service \"%s\"!" (.serviceName | default "")) }}
  {{- end }}
  {{- $enabledPorts | toYaml -}}
{{- end -}}
