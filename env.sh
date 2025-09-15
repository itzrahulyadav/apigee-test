
export PROJECT="oasis-0000"
export APIGEE_HOST="34.54.45.250.nip.io"
export APIGEE_ENV="eval"
PROJECT_NUMBER="$(gcloud projects describe $PROJECT --format="value(projectNumber)")"
export PROJECT_NUMBER
export CLOUD_BUILD_SA="$PROJECT_NUMBER-compute@developer.gserviceaccount.com"

gcloud config set project $PROJECT