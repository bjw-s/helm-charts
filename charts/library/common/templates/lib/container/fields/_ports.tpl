{{/*
Ports used by the container.
*/}}
{{- define "bjw-s.common.lib.container.field.ports" -}}
  {{- $ctx := .ctx -}}
  {{- $rootContext := $ctx.rootContext -}}
  {{- $containerObject := $ctx.containerObject -}}

  {{- /* Default to empty list */ -}}
  {{- $ports := list -}}

  {{- $enabledServices := (include "bjw-s.common.lib.service.enabledServices" $rootContext | fromYaml ) -}}
  {{- range $servicename, $service := $enabledServices -}}
    {{- $enabledPorts := include "bjw-s.common.lib.service.enabledPorts" (dict "rootContext" $rootContext "serviceObject" $service) | fromYaml -}}
    {{- range $portname, $port := ($enabledPorts | default dict) -}}
      {{- $_ := set $port "name" $portname -}}
      {{- $ports = mustAppend $ports $port -}}
    {{- end -}}
  {{- end -}}

  {{- if not (empty $ports) -}}
    {{- range $_ := $ports }}
      {{- if default true .enabled | }}
- name: {{ .name }}
        {{- if and .targetPort (kindIs "string" .targetPort) }}
          {{- fail (printf "Our charts do not support named ports for targetPort. (port name %s, targetPort %s)" .name .targetPort) }}
        {{- end }}
  containerPort: {{ .targetPort | default .port }}
        {{- if .protocol }}
          {{- if or ( eq .protocol "HTTP" ) ( eq .protocol "HTTPS" ) ( eq .protocol "TCP" ) }}
  protocol: TCP
          {{- else }}
  protocol: {{ .protocol }}
          {{- end }}
        {{- else }}
  protocol: TCP
        {{- end }}
      {{- end }}
    {{- end -}}
  {{- end -}}
{{- end -}}
