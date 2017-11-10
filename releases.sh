function create-github-release () {
    if [ "$BETA" -gt "0" ]; then
        RELEASE_TAG="v${VERSION_STUB}beta"
        RELEASE_NAME="Beta pre-release of v${VERSION_STUB}"
        RELEASE_BODY="To install, download the xpi for the beta version you wish to install, then use the Addons interface to install the xpi file into Juris-M or Zotero standalone. This is NOT a Firefox plugin. Beta pre-releases should update automatically when the final release appears."
    else
        RELEASE_TAG="v${VERSION_STUB}"
        RELEASE_NAME="v${VERSION_STUB} final"
        RELEASE_BODY="To install the plugin, download the xpi file below while viewing this page in a web browser. Then, use the Addons interface to install the xpi file into Juris-M or Zotero standalone. This is NOT a Firefox plugin. This plugin should update automatically."
    fi
    UPLOAD_URL=$(curl -k --fail --silent \
        --user "${DOORKEY}" \
        "https://api.github.com/repos/${GITHUBUSER}/${FORK}/releases/tags/${RELEASE_TAG}" \
                     | ~/bin/jq '.upload_url')
    #echo "FIRST ${UPLOAD_URL}"
    if [ "$UPLOAD_URL" == "" ]; then
        # Create the release
        DAT=$(printf '{"tag_name": "%s", "name": "%s", "body":"%s", "draft": false, "prerelease": %s}' "$RELEASE_TAG" "$RELEASE_NAME" "$RELEASE_BODY" "$IS_BETA")
        echo "${DAT}"
        UPLOAD_URL=$(curl -k --fail --silent \
            --user "${DOORKEY}" \
            --data "${DAT}" \
            "https://api.github.com/repos/${GITHUBUSER}/${FORK}/releases" \
                         | ~/bin/jq '.upload_url')
    fi
    #echo "SECOND ${UPLOAD_URL}"
    UPLOAD_URL=$(echo $UPLOAD_URL | $GSED -e "s/\"\(.*\){.*/\1/")
    #echo "THIRD ${UPLOAD_URL}"
    if [ "${UPLOAD_URL}" == "" ]; then
        echo "Fatal: no upload URL"
        echo "Aborting"
        exit 0
    fi
}

function add-xpi-to-github-release () {
    # Sign XPI and move into place
    jpm sign --api-key=${API_KEY} --api-secret=${API_SECRET} --xpi="${XPI_FILE}"
    mv "${SIGNED_STUB}-v${VERSION}-fx.xpi" "${XPI_FX_FILE}"

    # Get content-length of downloaded file
    SIZE=$(stat -c %s "${XPI_FX_FILE}")

    # Upload "asset"
    NAME=$(curl -k --fail --silent --show-error \
        --user "${DOORKEY}" \
        -H "Accept: application/vnd.github.manifold-preview" \
        -H "Content-Type: application/x-xpinstall" \
	-H "Content-Length: ${SIZE}" \
        --data-binary "@${XPI_FX_FILE}" \
        "${UPLOAD_URL}?name=$(basename ${XPI_FX_FILE})" \
               | ~/bin/jq '.name')
    echo "Uploaded ${NAME}"
}

function publish-update () {
    # Prepare the update manifest
    $GSED -si "s,\(<em:version>\).*\(<\/em:version>\),\\1${VERSION}\\2," update-TEMPLATE.rdf
    $GSED -si "s,\(<em:updateLink>.*download\/\).*\(<\/em:updateLink>\),\\1v${VERSION}/${CLIENT}-v${VERSION}-fx.xpi\\2," update-TEMPLATE.rdf
    git commit -m "Refresh update-TEMPLATE.rdf" update-TEMPLATE.rdf >> "${LOG_FILE}" 2<&1
    echo -n "Proceed? (y/n): "
    read CHOICE
    if [ "${CHOICE}" == "y" ]; then
        echo Okay, here goes ...
    else
        echo Aborting
        exit 1
    fi
    # Slip the update manifest over to the gh-pages branch, commit, and push
    cp update-TEMPLATE.rdf update-TRANSFER.rdf
    git checkout gh-pages >> "${LOG_FILE}" 2<&1
    if [ $(git ls-files | grep -c update.rdf) -eq 0 ]; then
        echo "XXX" > update.rdf
        git add update.rdf
    fi
    mv update-TRANSFER.rdf update.rdf >> "${LOG_FILE}" 2<&1
    git add update.rdf >> "${LOG_FILE}" 2<&1
    git commit -m "Refresh update.rdf" update.rdf >> "${LOG_FILE}" 2<&1
    git push >> "${LOG_FILE}" 2<&1
    echo "Refreshed update.rdf on project site"
    git checkout "${BRANCH}" >> "${LOG_FILE}" 2<&1
}
