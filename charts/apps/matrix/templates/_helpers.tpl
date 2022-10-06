{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "matrix.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "matrix.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "matrix.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "matrix.labels" -}}
helm.sh/chart: {{ include "matrix.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/name: "matrix"
{{- end -}}
# TODO: Include labels from values
{{/*
Synapse specific labels
*/}}
{{- define "matrix.synapse.labels" -}}
{{- range $key, $val := .Values.synapse.labels -}}
{{ $key }}: {{ $val }}
{{- end }}
{{- end -}}

{{/*
Element specific labels
*/}}
#TOOO: Change riot to element
{{- define "matrix.element.labels" -}}
{{- range $key, $val := .Values.riot.labels }}
{{ $key }}: {{ $val }}
{{- end }}
{{- end -}}

{{/*
Coturn specific labels
*/}}
{{- define "matrix.coturn.labels" -}}
{{- range $key, $val := .Values.coturn.labels -}}
{{ $key }}: {{ $val }}
{{- end }}
{{- end -}}

{{/*
Mail relay specific labels
*/}}
{{- define "matrix.mail.labels" -}}
{{- range $key, $val := .Values.mail.relay.labels -}}
{{ $key }}: {{ $val }}
{{- end }}
{{- end -}}

{{/*
Synapse hostname, derived from either the Values.matrix.hostname override or the Ingress definition
*/}}
{{- define "matrix.hostname" -}}
{{- if .Values.matrix.hostname }}
{{- .Values.matrix.hostname -}}
{{- else }}
{{- .Values.ingress.hosts.synapse -}}
{{- end }}
{{- end }}

{{/*
Synapse hostname prepended with https:// to form a complete URL
*/}}
{{- define "matrix.baseUrl" -}}
{{- if .Values.matrix.hostname }}
{{- printf "https://%s" .Values.matrix.hostname -}}
{{- else }}
{{- printf "https://%s" .Values.ingress.hosts.synapse -}}
{{- end }}
{{- end }}

{{/*
Helper function to get a postgres connection string for the database, with all of the auth and SSL settings automatically applied
*/}}
{{- define "matrix.postgresUri" -}}
{{- if .Values.postgresql.enabled -}}
postgres://{{ .Values.postgresql.username }}:{{ .Values.postgresql.password }}@{{ include "matrix.fullname" . }}-postgresql/%s{{ if .Values.postgresql.ssl }}?ssl=true&sslmode={{ .Values.postgresql.sslMode}}{{ end }}
{{- else -}}
postgres://{{ .Values.postgresql.username }}:{{ .Values.postgresql.password }}@{{ .Values.postgresql.hostname }}:{{ .Values.postgresql.port }}/%s{{ if .Values.postgresql.ssl }}?ssl=true&sslmode={{ .Values.postgresql.sslMode }}{{ end }}
{{- end }}
{{- end }}
