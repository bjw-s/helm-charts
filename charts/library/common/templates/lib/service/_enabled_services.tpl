{{/*
Return the enabled services.
*/}}
{{- define "bjw-s.common.lib.service.enabledServices" -}}
  {{- $enabledServices := dict -}}

  {{- range $name, $service := .Values.service -}}
    {{- if kindIs "map" $service -}}
      {{- /* Enable Service by default, but allow override */ -}}
      {{- $serviceEnabled := true -}}
      {{- if hasKey $service "enabled" -}}
        {{- $serviceEnabled = $service.enabled -}}
      {{- end -}}

      {{- if $serviceEnabled -}}
        {{- $_ := set $enabledServices $name . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledServices | toYaml -}}
{{- end -}}
