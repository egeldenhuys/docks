# Building Documentation on Travis CI

See https://github.com/alrra/travis-scripts/blob/master/docs/github-deploy-keys.md

```
gem install travis
cd .travis
ssh-keygen -t rsa -b 4096 -f 'github_deploy_key' -N ''

# Add public key to GitHub

rm github_deploy_key.pub
travis login --auto
travis encrypt-file github_deploy_key

# Update docs/scripts/build.sh

rm github_deploy_key

# Set $DEPLOY_USERNAME
# Set $DEPLOY_REPO
# So that docs will be uploaded to https://github.com/$DEPLOY_USERNAME/$DEPLOY_REPO
```