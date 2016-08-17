function set-install-version () {
    sed -i -r \
        -e "s,<em:version>.*<\/em:version>,<em:version>${VERSION}</em:version>," \
        -e "s,<em:updateURL>.*</em:updateURL>,<em:updateURL>https://raw.githubusercontent.com/KarlHegbloom/propachi-texmacs/propachi-texmacs-master/update.rdf</em:updateURL>,g" \
        install.rdf;
}
