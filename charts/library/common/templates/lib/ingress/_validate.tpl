{{/*
Validate Ingress values
*/}}
{{- define "bjw-s.common.lib.ingress.validate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $ingressObject := .object -}}

  {{- $enabledServices := (include "bjw-s.common.lib.service.enabledServices" (dict "rootContext" $rootContext) | fromYaml ) -}}

  {{/* Verify automatic service detection */}}
  {{- if not (eq 1 (len $enabledServices)) -}}
    {{- range $ingressObject.hosts -}}
      {{- $host := . -}}
      {{- range $host.paths -}}
        {{- $path := . -}}
        {{- if or (not (has "service" (keys .))) (and (not $path.service.name) (not $path.service.identifier)) -}}
          {{- fail (printf "Either service.name or service.identifier is required because automatic Service detection is not possible. (ingress: %s, host: %s, path: %s)" $ingressObject.identifier $host.host $path.path ) -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

{{- end -}}
