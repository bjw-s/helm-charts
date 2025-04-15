{{/*
Return a secret Object by its Identifier.
*/}}
{{- define "bjw-s.common.lib.secret.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $enabledSecrets := (include "bjw-s.common.lib.secret.enabledSecrets" (dict "rootContext" $rootContext) | fromYaml ) }}

  {{- if (hasKey $enabledSecrets $identifier) -}}
    {{- $objectValues := get $enabledSecrets $identifier -}}
    {{- include "bjw-s.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $objectValues "itemCount" (len $enabledSecrets)) -}}
  {{- end -}}
{{- end -}}
