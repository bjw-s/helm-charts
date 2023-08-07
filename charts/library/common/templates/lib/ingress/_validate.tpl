{{/*
Validate Ingress values
*/}}
{{- define "bjw-s.common.lib.ingress.validate" -}}
  {{- $rootContext := .rootContext -}}
  {{- $ingressValues := .object -}}

  {{- range $ingressValues.hosts -}}
    {{- range .paths -}}
      {{- if or (eq (dig "service" "name" "" .) "") (not .service.name) -}}
        {{- fail (printf "No service name configured. (ingress: %s, path: %s)" $ingressValues.identifier .path) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
