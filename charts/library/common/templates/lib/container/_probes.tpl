{{/*
Probes selection logic.
*/}}
{{- define "bjw-s.common.lib.container.probes" -}}
  {{- $primaryService := include "bjw-s.common.lib.service.primary" $ | fromYaml -}}
  {{- $primaryServiceDefaultPort := dict -}}
  {{- if $primaryService -}}
    {{- $primaryServiceDefaultPort = include "bjw-s.common.lib.service.primaryPort" (dict "rootContext" $ "serviceObject" $primaryService) | fromYaml -}}
  {{- end -}}

  {{- range $probeName, $probe := .Values.probes -}}
    {{- if $probe.enabled -}}
      {{- $probeOutput := "" -}}
      {{- if $probe.custom -}}
        {{- if $probe.spec -}}
          {{- $probeOutput = $probe.spec | toYaml -}}
        {{- end -}}
      {{- else -}}
        {{- if $primaryServiceDefaultPort -}}
          {{- $probeType := "" -}}
          {{- if eq $probe.type "AUTO" -}}
            {{- $probeType = $primaryServiceDefaultPort.protocol -}}
          {{- else -}}
            {{- $probeType = $probe.type | default "TCP" -}}
          {{- end -}}

          {{- $probeDefinition := dict
            "initialDelaySeconds" $probe.spec.initialDelaySeconds
            "failureThreshold" $probe.spec.failureThreshold
            "timeoutSeconds" $probe.spec.timeoutSeconds
            "periodSeconds" $probe.spec.periodSeconds
          -}}

          {{- $probeHeader := "" -}}
          {{- if or ( eq $probeType "HTTPS" ) ( eq $probeType "HTTP" ) -}}
            {{- $probeHeader = "httpGet" -}}

            {{- $_ := set $probeDefinition $probeHeader (
              dict
                "path" $probe.path
                "scheme" $probeType
              )
            -}}
          {{- else }}
            {{- $probeHeader = "tcpSocket" -}}
            {{- $_ := set $probeDefinition $probeHeader dict -}}
          {{- end -}}

          {{- if $probe.port }}
            {{- $_ := set (index $probeDefinition $probeHeader) "port" (tpl ( $probe.port | toString ) $) -}}
          {{- else if $primaryServiceDefaultPort.targetPort }}
            {{- $_ := set (index $probeDefinition $probeHeader) "port" $primaryServiceDefaultPort.targetPort -}}
          {{- else }}
            {{- $_ := set (index $probeDefinition $probeHeader) "port" ($primaryServiceDefaultPort.port | toString | atoi ) -}}
          {{- end }}

          {{- $probeOutput = $probeDefinition | toYaml | trim -}}
        {{- end -}}
      {{- end -}}

      {{- if $probeOutput -}}
        {{- printf "%sProbe:" $probeName | nindent 0 -}}
        {{- $probeOutput | nindent 2 -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
