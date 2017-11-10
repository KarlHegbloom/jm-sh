function set-install-version () {
    $GSED -ie "s,<em:version>.*</em:version>,<em:version>${VERSION}</em:version>," install.rdf
    $GSED -ie "s,<em:updateURL>.*</em:updateURL>,<em:updateURL>https://raw.githubusercontent.com/${GITHUBUSER}/${FORK}/${BRANCH}/update.rdf</em:updateURL>,"install.rdf
}
