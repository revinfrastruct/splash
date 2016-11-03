#!/bin/bash

# Requires aws cli tool and credentials to be installed and configured.

if [ "$1" = "" ]; then
  >&2 echo "First argument should be the s3 bucket."
  exit 1
fi

if [ "$2" = "" ]; then
  >&2 echo "Second argument should be the cloudfront distribution id."
  exit 2
fi

aws s3 sync . "s3://$1/" --acl public-read --cache-control max-age=63072000 --expires "Sat, 01 Jan 2035 12:00:00 GMT" --exclude '.git/*' --exclude 'deploy.sh' --exclude '*.html'
aws s3 sync . "s3://$1/" --acl public-read --content-type "text/html; charset=utf-8" --exclude '*' --include '*.html'

aws cloudfront create-invalidation --distribution-id "$2" --paths '/*'
