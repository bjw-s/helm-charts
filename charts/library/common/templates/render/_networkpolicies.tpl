{{/*
Renders the networkPolicy objects required by the chart.
*/}}
{{- define "bjw-s.common.render.networkpolicies" -}}
  {{- $rootContext := $ -}}

  {{- /* Generate networkPolicy as required */ -}}
  {{- $enabledNetworkPolicies := (include "bjw-s.common.lib.networkpolicy.enabledNetworkPolicies" (dict "rootContext" $rootContext) | fromYaml ) -}}
  {{- range $identifier := keys $enabledNetworkPolicies -}}
    {{- /* Generate object from the raw persistence values */ -}}
    {{- $networkPolicyObject := (include "bjw-s.common.lib.networkpolicy.getByIdentifier" (dict "rootContext" $rootContext "id" $identifier) | fromYaml) -}}

    {{- /* Perform validations on the networkPolicy before rendering */ -}}
    {{- include "bjw-s.common.lib.networkpolicy.validate" (dict "rootContext" $ "object" $networkPolicyObject) -}}

    {{- /* Include the networkPolicy class */ -}}
    {{- include "bjw-s.common.class.networkpolicy" (dict "rootContext" $ "object" $networkPolicyObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
