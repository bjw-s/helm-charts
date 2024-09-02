{{/*
Return the enabled serviceAccounts.
*/}}
{{- define "bjw-s.common.lib.serviceAccount.enabledServiceAccounts" -}}
  {{- $rootContext := .rootContext -}}
  {{- $enabledServiceAccounts := dict -}}

  {{- if ($rootContext.Values.serviceAccount).create -}}
    {{- $_ := set $enabledServiceAccounts "default" dict -}}
  {{- end -}}

  {{- range $name, $serviceAccount := ($rootContext.Values.serviceAccount).extraServiceAccounts -}}
    {{- if kindIs "map" $serviceAccount -}}
      {{- /* Enable by default, but allow override */ -}}
      {{- $serviceAccountEnabled := true -}}
      {{- if hasKey $serviceAccount "create" -}}
        {{- $serviceAccountEnabled = $serviceAccount.create -}}
      {{- end -}}

      {{- if $serviceAccountEnabled -}}
        {{- $_ := set $enabledServiceAccounts $name . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledServiceAccounts | toYaml -}}
{{- end -}}
