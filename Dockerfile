FROM alpine/git:1.0.7

LABEL "com.github.actions.name"="action-branch-from-working-copy"
LABEL "com.github.actions.description"=""
LABEL "com.github.actions.icon"="mic"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="http://github.com/acj/action-branch-from-working-copy"
LABEL "homepage"="http://github.com/acj/action-branch-from-working-copy"
LABEL "maintainer"="Adam Jensen <acjensen@gmail.com>"

ENV INPUT_REPOSITORY_PATH "."

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh
