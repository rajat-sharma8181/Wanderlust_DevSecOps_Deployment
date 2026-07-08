{{/*
Common labels applied to all resources.
*/}}
{{- define "wanderlust.labels" -}}
app.kubernetes.io/name: wanderlust
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}

{{/*
Fully-qualified image reference for app images pushed to ECR.
Usage: include "wanderlust.image" (dict "reg" .Values.global.imageRegistry "img" .Values.backend.image)
*/}}
{{- define "wanderlust.image" -}}
{{- printf "%s/%s:%s" .reg .img.repository (.img.tag | toString) -}}
{{- end -}}
