{{/*
The volume (referencing config) to be inserted into additionalVolumes.
*/}}
{{- define "bjw-s.common.addon.promtail.volumeSpec" -}}
configMap:
  name: {{ include "bjw-s.common.lib.chart.names.fullname" . }}-addon-promtail
{{- end -}}
