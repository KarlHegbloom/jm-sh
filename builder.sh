function set-install-version () {
    cat install.rdf | $GSED -e "s/<em:version>.*<\/em:version>/<em:version>${VERSION}<\/em:version>/" > frag.txt
    mv frag.txt install.rdf
    cat install.rdf | $GSED -e "s/<em:updateURL>.*<\/em:updateURL>/<em:updateURL>https:\/\/juris-m.github.io\/${FORK}\/update.rdf<\/em:updateURL>/" > frag.txt
    mv frag.txt install.rdf
    cat install.rdf | $GSED -e "s/<em:updateURL>.*<\/em:updateURL>/<em:updateURL>https:\/\/juris-m.github.io\/${FORK}\/update.rdf<\/em:updateURL>/" > frag.txt
    mv frag.txt install.rdf
}

