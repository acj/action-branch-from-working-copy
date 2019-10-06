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

set +e
git show-ref --verify --quiet refs/remotes/origin/"$INPUT_BRANCH_NAME"
branch_exists=$?
set -e

if [ $branch_exists -eq 0 ]; then
    echo ::set-output name=branch_name_already_exists::true
    if [ "$INPUT_FAIL_IF_BRANCH_EXISTS" == "true" ]; then
        echo "Branch $INPUT_BRANCH_NAME already exists"
        exit 1
    else
        exit 0
    fi
fi

echo ::set-output name=branch_name_already_exists::false

cd $GITHUB_WORKSPACE/$INPUT_REPOSITORY_PATH
if ! git diff --quiet; then
    git_setup

    git checkout -b $INPUT_BRANCH_NAME

    git commit -a -m "$INPUT_COMMIT_MESSAGE" --author="$INPUT_COMMIT_AUTHOR_NAME <$INPUT_COMMIT_AUTHOR_EMAIL>"

    git push --set-upstream origin $INPUT_BRANCH_NAME
else
    echo "Working tree clean. Nothing to commit."
fi
