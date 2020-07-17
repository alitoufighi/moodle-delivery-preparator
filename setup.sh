# Defining colors
RED="\033[0;31m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
NO_COLOR="\033[0m"

SUBMISSIONS_DIR="submissions"
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
STUDENT_DIR="$SUBMISSIONS_DIR/`ls $SUBMISSIONS_DIR/ | grep $STUDENT`"
echo $STUDENT_DIR
ONLINE_TEXT="$STUDENT_DIR/`ls $STUDENT_DIR | grep "html"`"
GITLAB_REPO=`grep -oP '(?<=https://gitlab.com/).*?(?=<|\")' $ONLINE_TEXT`
IFS=' ' read -ra ARR <<<"$GITLAB_REPO"
GITLAB_REPO=${ARR[0]}
if [[ -z $GITLAB_REPO ]]; then
    echo -e "${RED}Gitlab Repository couldn't be found.${NO_COLOR}"
    exit 1
fi
GITLAB_REPO="$GITLAB_PREFIX/$GITLAB_REPO"
echo $GITLAB_REPO
exit 0
STUDENT_REPOSITORY="$GITLAB_PREFIX/$2"
WORKING_DIR="working_directory"

error () {
    echo -e "${RED}Invalid $1!
            ${RED}Use the following format:${NO_COLOR}
            ${CYAN}\t./meeting_setup.sh <report_address> <repository_path>
            For example:
            \t./meeting_setup.sh reports/Ali_Elahi/OS-S99-CA3-Report.pdf ae1999/multithreading-os${NO_COLOR}"
}

#### Generate working directory ####

mkdir -p $WORKING_DIR/$2
# rm -rf $WORKING_DIR/*

if cp $STUDENT_REPORT $WORKING_DIR; then
    echo -e "${GREEN}Report added to the working directory!${NO_COLOR}"
else
    error "report address"
fi
if git clone $STUDENT_REPOSITORY $WORKING_DIR/repository; then
    echo -e "${GREEN}Repository cloned successfully!${NO_COLOR}"
else 
    error "Gitlab repository address"
fi