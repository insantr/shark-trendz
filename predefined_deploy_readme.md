## 1. Install Terraform
Choose version for your OS: [Link to Terraform](https://developer.hashicorp.com/terraform/downloads?product_intent=terraform)

Don't forget to unzip it next (MacOS/Linux): `unzip terraform_1.3.9_linux_amd64.zip`

Confirm that Terraform is installed: `terraform -version`

For MacOS/Linux, if it does not work for you, move terraform: `sudo mv terraform /usr/local/bin/`

## 2. Install Google SDK
Choose the compatible version for your OS: [Download Google Cloud SDK](https://cloud.google.com/sdk/docs/install)

## 3. Initial set up in Google Cloud Platform (GCP)
Go to https://console.cloud.google.com/ and follow the instructions.

### 3.1 Create a new Google Cloud Project
1. Go to https://console.cloud.google.com/projectcreate and follow the instructions.
2. Go to https://console.cloud.google.com/home/dashboard and copy your Project ID 
```bash
export PROJECT_ID=<YOUR_PROJECT_ID>
```

### 3.1. Create a new Google Cloud service account 
```bash
gcloud auth login # OAuth 2 to GCP
gcloud config set project $PROJECT_ID
gcloud iam service-accounts create shark-trendz-sa --display-name "Shark Trendz Service Account"
gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:shark-trendz-sa@$PROJECT_ID.iam.gserviceaccount.com" --role="roles/viewer"
gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:shark-trendz-sa@$PROJECT_ID.iam.gserviceaccount.com" --role="roles/storage.admin"
gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:shark-trendz-sa@$PROJECT_ID.iam.gserviceaccount.com" --role="roles/storage.objectAdmin"
gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:shark-trendz-sa@$PROJECT_ID.iam.gserviceaccount.com" --role="roles/bigquery.admin"
gcloud iam service-accounts keys create ~/.config/gcloud/shark-trendz-sa.json --iam-account=shark-trendz-sa@$PROJECT_ID.iam.gserviceaccount.com
```