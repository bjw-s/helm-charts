{{/*
Renders the configMap objects required by the chart.
*/}}
{{- define "bjw-s.common.render.configMaps" -}}
  {{- $rootContext := $ -}}

  {{- /* Generate named configMaps as required */ -}}
  {{- range $key, $configMap := .Values.configMaps }}
    {{- /* Enable configMap by default, but allow override */ -}}
    {{- $configMapEnabled := true -}}
    {{- if hasKey $configMap "enabled" -}}
      {{- $configMapEnabled = $configMap.enabled -}}
    {{- end -}}

    {{- if $configMapEnabled -}}
      {{- $configMapValues := (mustDeepCopy $configMap) -}}

      {{- /* Create object from the raw configMap values */ -}}
      {{- $configMapObject := (include "bjw-s.common.lib.valuesToObject" (dict "rootContext" $rootContext "id" $key "values" $configMapValues)) | fromYaml -}}

      {{- /* Perform validations on the configMap before rendering */ -}}
      {{- include "bjw-s.common.lib.configMap.validate" (dict "rootContext" $ "object" $configMapObject) -}}

      {{/* Include the configMap class */}}
      {{- include "bjw-s.common.class.configMap" (dict "rootContext" $ "object" $configMapObject) | nindent 0 -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
Renders configMap objects required by the chart from a folder in the repo's path.
*/}}
{{- define "bjw-s.common.render.configMaps.fromFiles" -}}
{{- $rootValues := .Values -}}

{{/* Generate a list of unique top level folders */}}
{{ $topLevelFolders := dict}}
{{- range $path, $_ := .Files.Glob (printf "%s/*/*" .Values.configMapsFromFolderBasePath) -}}
    {{- $_ := set $topLevelFolders (dir $path) "" -}}
{{- end -}}
{{- $top_level_folder_list := keys $topLevelFolders | sortAlpha -}}
  {{/* Iterate over the top level folders */}}
  {{ range $path := $top_level_folder_list }}
    {{- $filesContentNoFormat := ($.Files.Glob (printf "%s/*" $path)) -}}
    {{- $filesContent := dict -}}
    {{- $binaryFilesContent := dict -}}
    {{- range $file_name, $content := $filesContentNoFormat -}}
      {{- $key := base $file_name -}}
      {{- if contains ".escape" $key -}}
        {{- $key := $key | replace ".escape" "" -}}
        {{- $filesContent = merge $filesContent (dict $key (($.Files.Get $file_name) | replace "{{" "{{ `{{` }}")) -}}
      {{- else if contains ".binary" $key -}}
        {{- $key := $key | replace ".binary" "" -}}
        {{- $binaryFilesContent = merge $binaryFilesContent (dict $key ($.Files.Get $file_name | b64enc ))  -}}
      {{- else -}}
        {{- $filesContent = merge $filesContent (dict $key ($.Files.Get $file_name))  -}}
      {{- end -}}
    {{- end -}}

    {{- $configMapValues := dict "enabled" true "labels" dict "annotations" dict "data" $filesContent "binaryData" $binaryFilesContent -}}
    {{- $existingConfigMaps := (get $rootValues "configMaps"| default dict) -}}
    {{- $mergedConfigMaps := deepCopy $existingConfigMaps | merge (dict (base $path) $configMapValues) -}}
    {{- $rootValues := merge $rootValues (dict "configMaps" $mergedConfigMaps) -}}
  {{ end }}
{{ end }}
