{{/*
Template to render VPN addon
It will include / inject the required templates based on the given values.
*/}}
{{- define "common.addon.vpn" -}}
{{- if .Values.addons.vpn.enabled -}}
  {{- if eq "openvpn" .Values.addons.vpn.type -}}
    {{- fail "The 'openvpn' VPN type is no longer supported. Please migrate to the 'gluetun' type." . }}
  {{- end -}}

  {{- if eq "wireguard" .Values.addons.vpn.type -}}
    {{- fail "The 'wireguard' VPN type is no longer supported. Please migrate to the 'gluetun' type." . }}
  {{- end -}}

  {{- if eq "gluetun" .Values.addons.vpn.type -}}
    {{- include "common.addon.gluetun" . }}
  {{- end -}}

  {{/* Include the configmap if not empty */}}
  {{- $configmap := include "common.addon.vpn.configmap" . -}}
  {{- if $configmap -}}
    {{- $configmap | nindent 0 -}}
  {{- end -}}

  {{/* Include the secret if not empty */}}
  {{- $secret := include "common.addon.vpn.secret" . -}}
  {{- if $secret -}}
    {{- $secret | nindent 0 -}}
  {{- end -}}

  {{/* Append the vpn scripts volume to the volumes */}}
  {{- $scriptVolume := include "common.addon.vpn.scriptsVolumeSpec" . | fromYaml -}}
  {{- if $scriptVolume -}}
    {{- $_ := set .Values.persistence "vpnscript" (dict "enabled" "true" "mountPath" "-" "type" "custom" "volumeSpec" $scriptVolume) -}}
  {{- end -}}

  {{/* Append the vpn config volume to the volumes */}}
  {{- $configVolume := include "common.addon.vpn.configVolumeSpec" . | fromYaml }}
  {{ if $configVolume -}}
    {{- $_ := set .Values.persistence "vpnconfig" (dict "enabled" "true" "mountPath" "-" "type" "custom" "volumeSpec" $configVolume) -}}
  {{- end -}}

  {{/* Include the networkpolicy if not empty */}}
  {{- $networkpolicy := include "common.addon.vpn.networkpolicy" . -}}
  {{- if $networkpolicy -}}
    {{- $networkpolicy | nindent 0 -}}
  {{- end -}}
{{- end -}}
{{- end -}}
