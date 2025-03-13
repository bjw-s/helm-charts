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
kind: {{ $routeKind }}
metadata:
  name: {{ $routeObject.name }}
  {{- with $labels }}
  labels:
    {{- range $key, $value := . }}
    {{- printf "%s: %s" $key (tpl $value $rootContext | toYaml ) | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- with $annotations }}
  annotations:
    {{- range $key, $value := . }}
    {{- printf "%s: %s" $key (tpl $value $rootContext | toYaml ) | nindent 4 }}
    {{- end }}
  {{- end }}
  namespace: {{ $rootContext.Release.Namespace }}
spec:
  parentRefs:
  {{- range $routeObject.parentRefs }}
    - group: {{ .group | default "gateway.networking.k8s.io" }}
      kind: {{ .kind | default "Gateway" }}
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
    - group: {{ .group | default "" | quote}}
      kind: {{ .kind | default "Service" }}
      name: {{ $service.name | default .name }}
      namespace: {{ .namespace | default $rootContext.Release.Namespace }}
      port: {{ .port | default $servicePrimaryPort.port }}
      weight: {{ include "bjw-s.common.lib.defaultKeepNonNullValue" (dict "value" .weight "default" 1) }}
    {{- end }}
    {{- if or (eq $routeKind "HTTPRoute") (eq $routeKind "GRPCRoute") }}
      {{- with .matches }}
    matches:
        {{- toYaml . | nindent 6 }}
      {{- end }}
        {{- with .filters }}
    filters:
        {{- toYaml . | nindent 6 }}
      {{- end }}
    {{- end }}
    {{- if (eq $routeKind "HTTPRoute") }}
      {{- with .timeouts }}
    timeouts:
        {{- toYaml . | nindent 6 }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
