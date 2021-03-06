#!/bin/sh

# USAGE:
#   build.sh <source_dir> <outout_dir>

# DESCRIPTION:
#   Build documentation from source_dir into source_dir/output_dir

# NOTE:
#   Builds .uxf files to source_dir/images as well as source_dir/output_dir

# ARGS:
#   source_dir: Directory to mount, containing source files
#   outout_dir: Directory relative to source_dir for output files

# EXAMPLE:
#   Assume PWD=/home/john/github/docks
#
#   docks:
#     - docs
#       - document.tex
#     - README.md
#
#   To build the files in docks/docs to docks/docs/output
#
#   $ build.sh $(pwd)/docs output

# DEPENDENCIES
# - pdflatex
# - docker
# - sudo

set -e

sourceDir=$1
outputDir=$2
imageOutputDir="images/uml"

userId=$(id -u)
groupId=$(id -g)

echo "Executing as user:group ($userId:$groupId)"

mkdir -p $sourceDir/$outputDir
mkdir -p $sourceDir/$imageOutputDir

echo "Building .uxf files from $sourceDir to $sourceDir/$outputDir"
for i in $sourceDir/*.uxf; do
    [ -f "$i" ] || break

    fileNameExt=$(basename -- "$i")
    fileName="${fileNameExt%.*}"

    echo "Building $fileNameExt to $outputDir/$fileName.png"
    sudo docker run --name umlet-docker --rm -i --user="$userId:$groupId" --net=none -v "$sourceDir:/data" egeldenhuys/umlet-docker \
    java -jar umlet.jar -action=convert -format="png" -filename="/data/$fileNameExt" -output="/data/$outputDir/$fileName.png"

    # TEST:
    fileSize=$(stat -c%s "$sourceDir/$outputDir/$fileName.png")
    if [ "$fileSize" -eq "0" ]
    then
      echo "Failed to build $fileNameExt"
      exit 1
    fi

    # Import images for pdf generation
    cp $sourceDir/$outputDir/$fileName.png $sourceDir/$imageOutputDir
done

echo "Building .tex files from $sourceDir to $sourceDir/$outputDir"
oldPwd=$(pwd)

# Fix the latex image path problem
cd $sourceDir
for i in $sourceDir/*.tex; do
    [ -f "$i" ] || break

    fileNameExt=$(basename -- "$i")
    fileName="${fileNameExt%.*}"

    echo "Building $fileNameExt to $outputDir/$fileName.pdf"
    # sudo docker run --rm -it -v "$sourceDir:/pandoc" --user="$userId:$groupId" --net=none geometalab/pandoc \
    # pandoc "$fileNameExt" -o "$outputDir/$fileName.pdf"

    # Installing pdflatex is faster than pulling the 3GB pandoc image
    # Multiple passes to avoid errors in generating the TOC
    pdflatex -interaction=nonstopmode -halt-on-error $sourceDir/$fileNameExt
    pdflatex -interaction=nonstopmode -halt-on-error $sourceDir/$fileNameExt
    pdflatex -interaction=nonstopmode -halt-on-error $sourceDir/$fileNameExt

    # Copy pdf files to output dir
    cp $sourceDir/$fileName.pdf $sourceDir/$outputDir
done
cd $oldPwd

# TODO(egeldenhuys): Move to deploy section in .travis.yml
if ! [ -z ${CI+x} ]
then
  echo "Uploading artifacts to TripleParity/docs-bin"
  # NOTE: Update deploy command here
  openssl aes-256-cbc -K $encrypted_190d1b6a13b6_key -iv $encrypted_190d1b6a13b6_iv -in $TRAVIS_BUILD_DIR/.travis/github_deploy_key.enc -out github_deploy_key -d
  chmod 600 github_deploy_key
  eval $(ssh-agent -s)
  ssh-add github_deploy_key

  name=$(git log -1 --pretty=format:'%an')
  email=$(git log -1 --pretty=format:'%ae')

  git clone git@github.com:$DEPLOY_USERNAME/$DEPLOY_REPO.git

  cd docs-bin

  git config user.name "$name"
  git config user.email "$email"

  git checkout $TRAVIS_BRANCH || git checkout -b $TRAVIS_BRANCH
  rm -fr *
  cp -a $sourceDir/$outputDir/* .
  echo -e "# docs-bin\n\nThese files were generated by Travis CI from [$DEPLOY_USERNAME/$DEPLOY_REPO](https://github.com/$DEPLOY_USERNAME/$DEPLOY_REPO/tree/$TRAVIS_BRANCH/docs)" > README.md
  git add -A

  set +e
  git commit -m "$TRAVIS_COMMIT_MESSAGE"
  git push origin $TRAVIS_BRANCH
  set -e

  cd ..
  rm -fr docs-bin
fi
