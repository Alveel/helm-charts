{{/*
Expand the name of the chart.
*/}}
{{- define "keycloak.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "keycloak.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "keycloak.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "keycloak.labels" -}}
helm.sh/chart: {{ include "keycloak.chart" . }}
{{ include "keycloak.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "keycloak.selectorLabels" -}}
app.kubernetes.io/name: {{ include "keycloak.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Certificate secretName
*/}}
{{- define "keycloak.secretName" -}}
{{- if .Values.tls.secretName }}
{{- .Values.tls.secretName }}
{{- else }}
{{- .Release.Name }}-keycloak-cert
{{- end }}
{{- end }}

{{/*
Certificate dnsNames
*/}}
{{- define "keycloak.dnsNames" -}}
- {{ .Values.hostname.hostname }}
{{- if .Values.hostname.admin }}
- {{ .Values.hostname.admin }}
{{- end }}
{{- if .Values.hostname.adminUrl }}
- {{ .Values.hostname.adminUrl }}
{{- end }}
{{- end }}

{{/*
Pooling configuration
*/}}
{{- define "keycloak.poolingconfig" -}}
{{- if .Values.database.connection.poolingconfig.poolMinSize -}}
poolMinSize: {{ .Values.database.connection.poolingconfig.poolMinSize }}
{{- end }}
{{- if .Values.database.connection.poolingconfig.poolInitialSize -}}
poolInitialSize: {{ .Values.database.connection.poolingconfig.poolInitialSize }}
{{- end }}
{{- if .Values.database.connection.poolingconfig.poolMaxSize -}}
poolMaxSize: {{ .Values.database.connection.poolingconfig.poolMaxSize }}
{{- end }}
{{- end }}
