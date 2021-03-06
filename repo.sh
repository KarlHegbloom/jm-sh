function check-for-uncommitted () {
    set +e
    CHANGE_COUNT=$(git status | grep -c 'Changes not staged for commit')
    set -e
    if [ ${CHANGE_COUNT} -gt 0 ]; then
	    echo "Warning: Found some UNCOMMITTED changes."
        CHECKED_IN_OK=0
    fi
}

function block-uncommitted () {
    if [ ${CHECKED_IN_OK} -eq 0 ]; then
        echo "ERROR: terminating release for uncommitted changes"
        exit 1
    fi
}

function create-release-dir () {
    if [ ! -d "${RELEASE_DIR}" ]; then
        mkdir "${RELEASE_DIR}"
    fi
}

function touch-log () {
    create-release-dir
    echo "" > "${LOG_FILE}" 2<&1
}

function refresh-style-modules () {
    trap booboo ERR
    git checkout "${BRANCH}" >> "${LOG_FILE}" 2<&1
    if [ "${RELEASE}" != "1" ]; then
      git submodule update --remote --recursive >> "${LOG_FILE}" 2<&1
    fi
    trap - ERR
}

function repo-finish () {
    echo "$2"
    date | $GSED -e "s/^/  /"
    ls -l "${XPI_FILE}" | $GSED -e "s/^/  /"
    if [ $1 -eq 1 ]; then
        git checkout install.rdf
    fi
}

function git-checkin-all-and-push () {
    git checkout "${BRANCH}" >> "${LOG_FILE}" 2<&1
    git commit -am "Updating install.rdf to version ${VERSION}" >> "${LOG_FILE}" 2<&1
    git push origin "${BRANCH}" >> "${LOG_FILE}" 2<&1
}
