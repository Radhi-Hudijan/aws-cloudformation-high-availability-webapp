#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status

if [ "$#" -ne 4 ]; then 
    echo "Usage: $0 <action> <stack-name> <template-file> <parameters-file>"
    echo "Actions: create, update, delete , deploy , Review"
    exit 1
fi 

ACTION=$1
STACK_NAME=$2
TEMPLATE_FILE=$3
PARAMETERS_FILE=$4

case $ACTION in
    create)
        aws cloudformation create-stack --stack-name $STACK_NAME \
            --template-body file://$TEMPLATE_FILE \
            --parameters file://$PARAMETERS_FILE \
            --capabilities CAPABILITY_NAMED_IAM\
            --region eu-central-1
        ;;
    update)
        aws cloudformation update-stack --stack-name $STACK_NAME \
            --template-body file://$TEMPLATE_FILE \
            --parameters file://$PARAMETERS_FILE \
            --capabilities CAPABILITY_NAMED_IAM\
            --region eu-central-1
        ;;
    delete)
        aws cloudformation delete-stack --stack-name $STACK_NAME \
            --region eu-central-1
        ;;
    deploy)
        aws cloudformation deploy --stack-name $STACK_NAME \
            --template-file $TEMPLATE_FILE \
            --parameter-overrides $(jq -r '.[] | "\(.ParameterKey)=\(.ParameterValue)"' $PARAMETERS_FILE) \
            --capabilities CAPABILITY_NAMED_IAM\
            --region eu-central-1
        ;;
    Review)
        aws cloudformation deploy --stack-name $STACK_NAME \
            --template-file $TEMPLATE_FILE \
            --region eu-central-1 \
            --no-execute-changeset
        ;;
    *)
        echo "Invalid action: $ACTION"
        echo "Actions: create, update, delete , deploy , Review"
        exit 1
        ;;
esac