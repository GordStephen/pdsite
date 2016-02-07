inputform=.md #TODO: Switch to this
outputfolder=.html

# Purge output folder
rm -rf $outputfolder

# Generate base file structure
find -not -path "*/\.*" -not -path "*index.md" -path '*.md' -type f | sed 's/\(.*\).md/\1/' | xargs -I path mkdir -p .html/path

# Copy over index files
find -not -path "*/\.*" -path '*index.md'  -type f -exec cp {} .html/{} \;

# Copy over other files
find -not -path "*/\.*" -not -path "*index.md" -path '*.md' -type f | sed 's/\(.*\)\/\(.*\).md/\0 \1\/\2\/index.md/' |  xargs -n 2 sh -c 'cp $0 .html/$1'

tree $outputfolder
