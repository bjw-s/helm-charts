{{/*
Template to render promtail addon
It will include / inject the required templates based on the given values.
*/}}
{{- define "bjw-s.common.addon.promtail" -}}
{{- if .Values.addons.promtail.enabled -}}
  {{/* Append the promtail container to the additionalContainers */}}
  {{- $container := include "bjw-s.common.addon.promtail.container" . | fromYaml -}}
  {{- if $container -}}
    {{- $_ := set .Values.additionalContainers "addon-promtail" $container -}}
  {{- end -}}

  {{/* Append the promtail configMap to the configmaps dict */}}
  {{- $configmap := include "bjw-s.common.addon.promtail.configmap" . -}}
  {{- if $configmap -}}
    {{- $_ := set .Values.configMaps "addon-promtail" (dict "enabled" true "data" ($configmap | fromYaml)) -}}
  {{- end -}}

  {{/* Append the promtail config volume to the volumes */}}
  {{- $volume := include "bjw-s.common.addon.promtail.volumeSpec" . | fromYaml -}}
  {{- if $volume -}}
    {{- $_ := set .Values.persistence "addon-promtail" (dict "enabled" true "mountPath" "-" "type" "custom" "volumeSpec" $volume) -}}
  {{- end -}}
{{- end -}}
{{- end -}}
