# Defining colors
RED="\033[0;31m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
NO_COLOR="\033[0m"

SUBMISSIONS_DIR="submissions"

error () {
    echo -e "${RED}Invalid $1!
            ${RED}Use the following format:${NO_COLOR}
            ${CYAN}\t./setup.sh <student-lastname (or a unique part of his name :shrug:)>
            For example:
            \t./setup.sh tou${NO_COLOR}"
}

# Preprocessing $SUBMISSIONS_DIR directory
for submission in $SUBMISSIONS_DIR/*; do
    new_submission=`echo $submission | tr '[:upper:]' '[:lower:]'`
    new_submission=${new_submission// /-}
    if [[ "$submission" != "$new_submission" ]]; then
        mv "$submission" "$new_submission"
    fi
done
echo -e "${GREEN}Preprocessing done!${NO_COLOR}"

# Gitlab account
GITLAB_USERNAME=""              # Fill This
GITLAB_PASSWORD=""              # Fill This
GITLAB_PREFIX="https://$GITLAB_USERNAME:$GITLAB_PASSWORD@gitlab.com"

# Some mess to fetch GitLab repository stored in online text html file
STUDENT=$1
STUDENT_DIR=`ls $SUBMISSIONS_DIR/ | grep $STUDENT`
STUDENT_DIR_PREFIX="$SUBMISSIONS_DIR/$STUDENT_DIR"
echo $STUDENT_DIR
ONLINE_TEXT="$STUDENT_DIR_PREFIX/`ls $STUDENT_DIR_PREFIX | grep "html"`"
GITLAB_REPO=`grep -oP '(?<=https://gitlab.com/).*?(?=<|\")' $ONLINE_TEXT`
IFS=' ' read -ra ARR <<<"$GITLAB_REPO"
GITLAB_REPO=${ARR[0]}
if [[ -z $GITLAB_REPO ]]; then
    echo -e "${RED}Gitlab Repository couldn't be found.${NO_COLOR}"
    exit 1
fi
GITLAB_REPO="$GITLAB_PREFIX/$GITLAB_REPO"
echo $GITLAB_REPO


# Some mess to fetch student report file
REPORT="$STUDENT_DIR_PREFIX/`ls "$STUDENT_DIR_PREFIX" | grep -v html`"
echo $REPORT

# Prepare working directory
WORKING_DIR="working_directory/$STUDENT"

mkdir -p "$WORKING_DIR"

if cp "$REPORT" "$WORKING_DIR"; then
    echo -e "${GREEN}Report added to the working directory!${NO_COLOR}"
else
    error "report address"
fi
if git clone $GITLAB_REPO $WORKING_DIR/repository; then
    echo -e "${GREEN}Repository cloned successfully!${NO_COLOR}"
else 
    error "Gitlab repository address"
fi
