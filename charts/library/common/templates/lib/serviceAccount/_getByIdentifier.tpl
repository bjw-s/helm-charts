{{/*
Return a ServiceAccount Object by its Identifier.
*/}}
{{- define "bjw-s.common.lib.serviceAccount.getByIdentifier" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- if eq $identifier "default" -}}
      {{- include "bjw-s.common.lib.serviceAccount.valuesToObject" (dict "rootContext" $rootContext "id" "default" "values" $rootContext.Values.serviceAccount) -}}
  {{- else -}}
    {{- $serviceAccountValues := dig "extraServiceAccounts" $identifier nil $rootContext.Values.serviceAccount -}}
    {{- if not (empty $serviceAccountValues) -}}
      {{- include "bjw-s.common.lib.serviceAccount.valuesToObject" (dict "rootContext" $rootContext "id" $identifier "values" $serviceAccountValues) -}}
    {{- else -}}
      {{- fail (printf "No ServiceAccount configured with identifier: %s" $identifier) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}