function set-install-version () {
    # sed -i -r \
    #     -e "s,<em:version>.*<\/em:version>,<em:version>${VERSION}</em:version>," \
    #     -e "s,<em:updateURL>.*</em:updateURL>,<em:updateURL>https://raw.githubusercontent.com/KarlHegbloom/propachi-texmacs/propachi-texmacs-master/update.rdf</em:updateURL>,g" \
    #     install.rdf;
    cat install.rdf | $GSED -e "s/<em:version>.*<\/em:version>/<em:version>${VERSION}<\/em:version>/" > frag.txt
    mv frag.txt install.rdf
    cat install.rdf | $GSED -e "s/<em:updateURL>.*<\/em:updateURL>/<em:updateURL>https://raw.githubusercontent.com/KarlHegbloom/propachi-texmacs/propachi-texmacs-master/update.rdf<\/em:updateURL>/" > frag.txt
    mv frag.txt install.rdf
    cat install.rdf | $GSED -e "s/<em:updateURL>.*<\/em:updateURL>/<em:updateURL>https://raw.githubusercontent.com/KarlHegbloom/propachi-texmacs/propachi-texmacs-master/update.rdf<\/em:updateURL>/" > frag.txt
    mv frag.txt install.rdf
}
