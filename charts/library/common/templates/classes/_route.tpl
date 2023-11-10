{{/*
This template serves as a blueprint for all Route objects that are created
within the common library.
*/}}
{{- define "bjw-s.common.class.route" -}}
  {{- $rootContext := .rootContext -}}
  {{- $routeObject := .object -}}

  {{- $routeKind := $routeObject.kind | default "HTTPRoute" -}}
  {{- $apiVersion := "gateway.networking.k8s.io/v1alpha2" -}}
  {{- if $rootContext.Capabilities.APIVersions.Has (printf "gateway.networking.k8s.io/v1beta1/%s" $routeKind) }}
    {{- $apiVersion = "gateway.networking.k8s.io/v1beta1" -}}
  {{- end -}}
  {{- if $rootContext.Capabilities.APIVersions.Has (printf "gateway.networking.k8s.io/v1/%s" $routeKind) }}
    {{- $apiVersion = "gateway.networking.k8s.io/v1" -}}
  {{- end -}}
  {{- $labels := merge
    ($routeObject.labels | default dict)
    (include "bjw-s.common.lib.metadata.allLabels" $rootContext | fromYaml)
  -}}
  {{- $annotations := merge
    ($routeObject.annotations | default dict)
    (include "bjw-s.common.lib.metadata.globalAnnotations" $rootContext | fromYaml)
  -}}
---
apiVersion: {{ $apiVersion }}
{{- if and (ne $routeKind "GRPCRoute") (ne $routeKind "HTTPRoute") (ne $routeKind "TCPRoute") (ne $routeKind "TLSRoute") (ne $routeKind "UDPRoute") }}
  {{- fail (printf "Not a valid route kind (%s)" $routeKind) }}
{{- end }}
kind: {{ $routeKind }}
metadata:
  name: {{ $routeObject.name }}
  {{- with $labels }}
  labels: {{- toYaml . | nindent 4 -}}
  {{- end }}
  {{- with $annotations }}
  annotations: {{- toYaml . | nindent 4 -}}
  {{- end }}
spec:
  parentRefs:
  {{- range $routeObject.parentRefs }}
    - group: {{ default "gateway.networking.k8s.io" .group }}
      kind: {{ default "Gateway" .kind }}
      name: {{ required (printf "parentRef name is required for %v %v" $routeKind $routeObject.name) .name }}
      namespace: {{ required (printf "parentRef namespace is required for %v %v" $routeKind $routeObject.name) .namespace }}
      {{- if .sectionName }}
      sectionName: {{ .sectionName | quote }}
      {{- end }}
  {{- end }}
  {{- if and (ne $routeKind "TCPRoute") (ne $routeKind "UDPRoute") $routeObject.hostnames }}
  hostnames:
    {{- range $routeObject.hostnames }}
    - {{ tpl . $rootContext | quote }}
    {{- end }}
  {{- end }}
  rules:
  {{- range $routeObject.rules }}
  - backendRefs:
    {{- range .backendRefs }}
      {{ $service := include "bjw-s.common.lib.service.getByIdentifier" (dict "rootContext" $rootContext "id" .name) | fromYaml -}}
      {{ $servicePrimaryPort := dict -}}
      {{ if $service -}}
        {{ $servicePrimaryPort = include "bjw-s.common.lib.service.primaryPort" (dict "rootContext" $rootContext "serviceObject" $service) | fromYaml -}}
      {{- end }}
    - group: {{ default "" .group | quote}}
      kind: {{ default "Service" .kind }}
      name: {{ default .name $service.name }}
      namespace: {{ default $rootContext.Release.Namespace .namespace }}
      port: {{ default .port $servicePrimaryPort.port }}
      weight: {{ default 1 .weight }}
    {{- end }}
    {{- if (eq $routeKind "HTTPRoute") }}
      {{- with .matches }}
    matches:
        {{- toYaml . | nindent 6 }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
