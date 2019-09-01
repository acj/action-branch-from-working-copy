#!/bin/sh

set -eu

# Set up .netrc file with GitHub credentials
git_setup ( ) {
  cat <<- EOF > $HOME/.netrc
        machine github.com
        login $GITHUB_ACTOR
        password $GITHUB_TOKEN

        machine api.github.com
        login $GITHUB_ACTOR
        password $GITHUB_TOKEN
EOF
    chmod 600 $HOME/.netrc

    git config --global user.email "actions@github.com"
    git config --global user.name "GitHub Actions"
}

function export_to_env {
  name=$(echo $1 | awk '{ print toupper($0)}')
  value=$(cat "$GITHUB_WORKSPACE"/.env/$1)
  export $name="$value"
}

for var in $(ls "$GITHUB_WORKSPACE"/.env); do
  export_to_env $var
done

cd $GITHUB_WORKSPACE/$INPUT_REPOSITORY_PATH
if ! git diff --quiet
then
    git_setup

    git checkout -b $INPUT_BRANCH_NAME

    git commit -a -m "$INPUT_COMMIT_MESSAGE" --author="$INPUT_COMMIT_AUTHOR_NAME <$INPUT_COMMIT_AUTHOR_EMAIL>"

    git push --set-upstream origin $INPUT_BRANCH_NAME
else
    echo "Working tree clean. Nothing to commit."
fi
