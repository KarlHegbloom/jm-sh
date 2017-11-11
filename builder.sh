function set-install-version () {
    $GSED -i -e "s,<em:version>.*</em:version>,<em:version>${VERSION}</em:version>," install.rdf
    $GSED -i -e "s,<em:updateURL>.*</em:updateURL>,<em:updateURL>https://raw.githubusercontent.com/${GITHUBUSER}/${FORK}/${BRANCH}/update.rdf</em:updateURL>," install.rdf
}
