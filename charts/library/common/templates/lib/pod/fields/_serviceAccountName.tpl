{{- /*
Returns the value for serviceAccountName
*/ -}}
{{- define "bjw-s.common.lib.pod.field.serviceAccountName" -}}
  {{- $rootContext := .ctx.rootContext -}}

  {{- /* Default to "default" */ -}}
  {{- $name := "default" -}}

  {{- /* See if an override is needed */ -}}
  {{- if $rootContext.Values.serviceAccount.create -}}
    {{- $serviceAccountValues := (mustDeepCopy $rootContext.Values.serviceAccount) -}}
    {{- $serviceAccountObject := (include "bjw-s.common.lib.serviceAccount.valuesToObject" (dict "rootContext" $rootContext "id" "default" "values" $serviceAccountValues)) | fromYaml -}}
    {{- $name = $serviceAccountObject.name -}}
  {{- end -}}

  {{- $name -}}
{{- end -}}
