#!/bin/bash

function init(){
  export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
  export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
  export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
  export AWS_REGION="eu-central-1"
  export CLUSTER_NAME="eks_cluster"
}

function associate_oidc(){
  curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
  mv /tmp/eksctl /usr/local/bin
  eksctl version
  
  eksctl utils associate-iam-oidc-provider \
      --region $AWS_REGION \
      --cluster $CLUSTER_NAME \
      --approve
}

function initTerraform(){
  tfenv use 1.0.0
  cd terraform || exit 1

  export STATEKEY_FILENAME="EKS.state"
  export TF_VAR_pipeline_tag=$CI_PIPELINE_URL
  export TF_VAR_environment=$ENVIRONMENT
  terraform init -backend-config="bucket=eks-cluster-state-bucket"  \
                 -backend-config="key=$STATEKEY_FILENAME" \
                 -backend-config="region=$AWS_REGION"
}

function plan(){
  initTerraform;
  terraform plan
}


function apply(){
  initTerraform;
  terraform apply -auto-approve=true
}

function destroy(){
  initTerraform;
  terraform destroy -auto-approve
}

function main() {
  init;
  if [ "$1" == "plan" ];then
    plan;
  elif [ "$1" == "apply" ];then
    apply;
  elif [ "$1" == "destroy" ];then
    destroy;
  fi
}

main $1
