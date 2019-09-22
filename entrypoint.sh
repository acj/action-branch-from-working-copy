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

ENV_PATH="$GITHUB_WORKSPACE"/.env

function export_to_env {
  name=$(echo $1 | awk '{ print toupper($0)}')
  value=$(cat "$ENV_PATH/$1")
  export $name="$value"
}

if [ -d "$ENV_PATH" ]; then
    for var in $(ls "$ENV_PATH"); do
        export_to_env $var
    done
fi

set +e
git show-ref --verify --quiet refs/remotes/origin/"$INPUT_BRANCH_NAME"
branch_exists=$?
set -e

if [ $branch_exists -eq 0 ]; then
    if [ "$INPUT_FAIL_IF_BRANCH_EXISTS" = "true" ]; then
        echo "Branch $INPUT_BRANCH_NAME already exists"
        exit 1
    else
        echo 1 > "$ENV_PATH/BRANCH_NAME_ALREADY_EXISTS"
        exit 0
    fi
fi

cd $GITHUB_WORKSPACE/$INPUT_REPOSITORY_PATH
if ! git diff --quiet; then
    git_setup

    git checkout -b $INPUT_BRANCH_NAME

    git commit -a -m "$INPUT_COMMIT_MESSAGE" --author="$INPUT_COMMIT_AUTHOR_NAME <$INPUT_COMMIT_AUTHOR_EMAIL>"

    git push --set-upstream origin $INPUT_BRANCH_NAME
else
    echo "Working tree clean. Nothing to commit."
fi
