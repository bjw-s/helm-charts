{{/*
Return a ServiceAccount Object by its Identifier.
*/}}
{{- define "bjw-s.common.lib.serviceAccount.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $enabledServiceAccounts := (include "bjw-s.common.lib.serviceAccount.enabledServiceAccounts" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabledServiceAccounts $identifier) -}}
    {{- $objectValues := get $enabledServiceAccounts $identifier -}}
    {{- include "bjw-s.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledServiceAccounts)) -}}
  {{- end -}}
{{- end -}}
