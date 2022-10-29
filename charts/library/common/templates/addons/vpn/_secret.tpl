{{/*
The OpenVPN config secret to be included.
*/}}
{{- define "bjw-s.common.addon.vpn.secret" -}}
{{- if and .Values.addons.vpn.configFile (not .Values.addons.vpn.configFileSecret) }}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "bjw-s.common.lib.chart.names.fullname" . }}-vpnconfig
  labels: {{- include "common.labels" $ | nindent 4 }}
  annotations: {{- include "common.annotations" $ | nindent 4 }}
stringData:
  {{- with .Values.addons.vpn.configFile }}
  vpnConfigfile: |-
    {{- . | nindent 4}}
  {{- end }}
{{- end -}}
{{- end -}}
