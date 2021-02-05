'use strict';

const AWS = require('aws-sdk');
const S3 = new AWS.S3();

const getFileContent = async (S3, bucket, filename) => {
  const params = {
    Bucket: bucket,
    Key: filename
  }

  const file = await S3.getObject(params).promise()
  return file.Body.toString('utf-8')
};

exports.handler = async (event) => {
  console.log(`Received event: ${JSON.stringify(event)}`);


  const { s3 } = event.Records[0];
  try {
    const content = await getFileContent(S3, s3.bucket.name, s3.object.key);
    console.log('S3 content:', content);
    return true;
  } catch (err) {
    throw new Error(err);
  }
};
