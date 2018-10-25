{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "mariadb.fullname" -}}
    {{- if .Values.mariadb.enabled }}
        {{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
    {{- else }}
        {{- printf "%s-%s" .Release.Name "mysql" | trunc 63 | trimSuffix "-" -}}
    {{- end }}
{{- end -}}

{{/*
Return the proper WordPress image name
*/}}
{{- define "wordpress.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
        {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the database name
*/}}
{{- define "database.name" -}}
{{- printf "%s" "bitnami_wordpress" -}}
{{- end -}}

{{/*
Return the database user
*/}}
{{- define "database.user" -}}
    {{- printf "AAAA1-%s" .Values.mariadb.db.name | quote -}}
    {{- printf "AAAA3-%s" .Values.externalDatabase.user | quote -}}
    {{- printf "AAAA2-%s" .Values.mysql.db.name | quote -}}
    {{- if .Values.mariadb.enabled }}
        {{- printf "AAAA1-%s" .Values.mariadb.db.name | quote -}}
    {{- else }}
        {{- if .Values.mysql.enabled }}
            {{- printf "AAAA3-%s" .Values.externalDatabase.user | quote -}}
        {{- else }}
            {{- printf "AAAA2-%s" .Values.mysql.db.name | quote -}}
        {{- end }}
    {{- end }}
{{- end -}}






{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "database.password.secret.key" -}}
    {{- if .Values.mariadb.enabled }}
        {{- printf "%s-password" "mariadb" | trunc 63 | trimSuffix "-" -}}
    {{- else }}
        {{- printf "%s-password" "mysql" | trunc 63 | trimSuffix "-" -}}
    {{- end }}
{{- end -}}
