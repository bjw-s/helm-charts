{{/*
Return the enabled serviceAccounts.
*/}}
{{- define "bjw-s.common.lib.serviceAccount.enabledServiceAccounts" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledServiceAccounts := dict -}}

  {{- range $identifier, $serviceAccount := $rootContext.Values.serviceAccount -}}
    {{- if kindIs "map" $serviceAccount -}}
      {{- /* Enable Service by default, but allow override */ -}}
      {{- $serviceAccountEnabled := true -}}
      {{- if hasKey $serviceAccount "enabled" -}}
        {{- $serviceAccountEnabled = $serviceAccount.enabled -}}
      {{- end -}}

      {{- if $serviceAccountEnabled -}}
        {{- $_ := set $enabledServiceAccounts $identifier . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledServiceAccounts | toYaml -}}
{{- end -}}
