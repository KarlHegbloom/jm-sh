if [ $(type -t fix-content | grep -c function) -gt 0 ]; then
    fix-content
fi
