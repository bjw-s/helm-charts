{{/*
This template serves as a blueprint for all Ingress objects that are created
within the common library.
*/}}
{{- define "bjw-s.common.class.ingress" -}}
  {{- $rootContext := .rootContext -}}
  {{- $ingressObject := .object -}}

  {{- /* Make the Ingress reference the primary Service if no service has been set */ -}}
  {{- $primaryService := include "bjw-s.common.lib.service.primary" $rootContext | fromYaml -}}
  {{- $primaryServiceDefaultPort := dict -}}
  {{- if $primaryService -}}
    {{- $primaryServiceDefaultPort = include "bjw-s.common.lib.service.primaryPort" (dict "rootContext" $rootContext "object" $primaryService) | fromYaml -}}
  {{- end -}}
  {{- $labels := merge
    ($ingressObject.labels | default dict)
    (include "bjw-s.common.lib.metadata.allLabels" $rootContext | fromYaml)
  -}}
  {{- $annotations := merge
    ($ingressObject.annotations | default dict)
    (include "bjw-s.common.lib.metadata.globalAnnotations" $rootContext | fromYaml)
  -}}
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ $ingressObject.name }}
  {{- with $labels }}
  labels: {{- toYaml . | nindent 4 -}}
  {{- end }}
  {{- with $annotations }}
  annotations: {{- toYaml . | nindent 4 -}}
  {{- end }}
spec:
  {{- if $ingressObject.ingressClassName }}
  ingressClassName: {{ $ingressObject.ingressClassName }}
  {{- end }}
  {{- if $ingressObject.tls }}
  tls:
    {{- range $ingressObject.tls }}
    - hosts:
        {{- range .hosts }}
        - {{ tpl . $rootContext | quote }}
        {{- end }}
      {{- $secretName := tpl (default "" .secretName) $rootContext }}
      {{- if $secretName }}
      secretName: {{ $secretName | quote}}
      {{- end }}
    {{- end }}
  {{- end }}
  rules:
  {{- range $ingressObject.hosts }}
    - host: {{ tpl .host $rootContext | quote }}
      http:
        paths:
          {{- range .paths }}
            {{- $service := $primaryService.name -}}
            {{- $port := $primaryServiceDefaultPort.port -}}
            {{- if .service -}}
              {{- $service = default $service .service.name -}}
              {{- $port = default $port .service.port -}}
            {{- end }}
          - path: {{ tpl .path $rootContext | quote }}
            pathType: {{ default "Prefix" .pathType }}
            backend:
              service:
                name: {{ $service }}
                port:
                  number: {{ $port }}
          {{- end }}
  {{- end }}
{{- end }}
