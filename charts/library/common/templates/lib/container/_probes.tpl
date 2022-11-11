{{/*
Probes selection logic.
*/}}
{{- define "bjw-s.common.lib.container.probes" -}}
{{- $primaryService := get .Values.service (include "bjw-s.common.lib.service.primary" .) -}}
{{- $primaryPort := "" -}}
{{- if $primaryService -}}
  {{- $primaryPort = get $primaryService.ports (include "bjw-s.common.lib.service.primaryPort" (dict "serviceName" (include "bjw-s.common.lib.service.primary" .) "values" $primaryService)) -}}
{{- end -}}

{{- range $probeName, $probe := .Values.probes }}
  {{- if $probe.enabled -}}
    {{- "" | nindent 0 }}
    {{- $probeName }}Probe:
    {{- if $probe.custom -}}
      {{- $probe.spec | toYaml | nindent 2 }}
    {{- else }}
      {{- if and $primaryService $primaryPort -}}
        {{- $probeType := "" -}}
        {{- if eq $probe.type "AUTO" -}}
          {{- $probeType = $primaryPort.protocol -}}
        {{- else -}}
          {{- $probeType = $probe.type | default "TCP" -}}
        {{- end }}
        {{- if or ( eq $probeType "HTTPS" ) ( eq $probeType "HTTP" ) }}
  httpGet:
    path: {{ $probe.path }}
    scheme: {{ $probeType }}
        {{- else }}
  tcpSocket:
        {{- end }}
        {{- if $probe.port }}
    port: {{ ( tpl ( $probe.port | toString ) $ ) }}
        {{- else if $primaryPort.targetPort }}
    port: {{ $primaryPort.targetPort }}
        {{- else }}
    port: {{ $primaryPort.port }}
        {{- end }}
  initialDelaySeconds: {{ $probe.spec.initialDelaySeconds }}
  failureThreshold: {{ $probe.spec.failureThreshold }}
  timeoutSeconds: {{ $probe.spec.timeoutSeconds }}
  periodSeconds: {{ $probe.spec.periodSeconds }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end }}
