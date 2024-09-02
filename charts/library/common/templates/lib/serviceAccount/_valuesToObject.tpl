{{/*
Convert ServiceAccount values to an object
*/}}
{{- define "bjw-s.common.lib.serviceAccount.valuesToObject" -}}
  {{- $rootContext := .rootContext -}}
  {{- $identifier := .id -}}
  {{- $objectValues := .values -}}

  {{- /* Determine and inject the serviceAccount name */ -}}
  {{- $serviceAccountName := "" -}}
  {{- $defaultServiceAccountName := "default" -}}
  {{- if $objectValues.create -}}
    {{- $defaultServiceAccountName = (include "bjw-s.common.lib.chart.names.fullname" $rootContext) -}}
  {{- end -}}
  
  {{- $objectName := default $defaultServiceAccountName $objectValues.name -}}

  {{- if $objectValues.nameOverride -}}
    {{- $override := tpl $objectValues.nameOverride $rootContext -}}
    {{- if not (eq $objectName $override) -}}
      {{- $objectName = printf "%s-%s" $objectName $override -}}
    {{- end -}}
  {{- else -}}
    {{- $enabledServiceAccounts := (include "bjw-s.common.lib.serviceAccount.enabledServiceAccounts" (dict "rootContext" $rootContext) | fromYaml ) }}
    {{- if gt (len $enabledServiceAccounts) 1 -}}
      {{- if not (eq $objectName $identifier) -}}
        {{- $objectName = printf "%s-%s" $objectName $identifier -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- $_ := set $objectValues "name" $objectName -}}
  {{- $_ := set $objectValues "identifier" $identifier -}}
  {{- /* Return the serviceAccount object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}
