#!/bin/bash

#  Configure all aws variables needed for the script to work
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
echo "key id accessed"
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
echo "secret key accessed"
aws configure set region $AWS_DEFAULT_REGION
echo "region acceessed"

# Create a new folder to store the backup files
mkdir -p /backup/
echo "Creating backup folder ..."

# change the current directory to usr/bin folder of the container
cd /usr/bin 
echo "Backup started at $(date)"

# if mongodump command is successful echo success message else echo failure message
if mongodump --forceTableScan  --uri $MONGODB_URI  --gzip --archive > ../../backup/dump_`date "+%Y-%m-%d-%T"`.gz && cd ../../ && aws s3 cp /backup/ s3://$S3_BUCKET/db_backup1/ --recursive
then
    echo "Backup completed successfully at $(date)"
    echo "Uploaded to s3 bucket"
else
    echo  "Backup failed at $(date)"
fi

echo "Cleaning up..."
# Clean up by removing the backup folder
rm -rf /backup/ 

echo "Done !!!"