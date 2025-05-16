{{/*
Return the enabled NetworkPolicies.
*/}}
{{- define "bjw-s.common.lib.networkpolicy.enabledNetworkPolicies" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledNetworkPolicies := dict -}}

  {{- range $name, $networkPolicy := $rootContext.Values.networkpolicies -}}
    {{- if kindIs "map" $networkPolicy -}}
      {{- /* Enable by default, but allow override */ -}}
      {{- $networkPolicyEnabled := true -}}
      {{- if hasKey $networkPolicy "enabled" -}}
        {{- $networkPolicyEnabled = $networkPolicy.enabled -}}
      {{- end -}}

      {{- if $networkPolicyEnabled -}}
        {{- $_ := set $enabledNetworkPolicies $name . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledNetworkPolicies | toYaml -}}
{{- end -}}
