templatespath=~/Projects/pdsite/themes

inputextension=.md
outputfolder=.html
template=default

templatepath=$templatespath/$template

# Convert to canonical path
outputfolder=$(readlink -f $outputfolder)

# Build glob expressions
extensionglob='*'$inputextension
indexfileglob='*index'$inputextension

# Purge output folder
echo -n "Clearing old build folder..."
rm -rf $outputfolder
echo " done."

echo -n "Building site..."
# Generate base file structure
find -not -path "*/\.*" -not -path "$indexfileglob" -path "$extensionglob" -type f | sed 's/\(.*\)'$inputextension'/\1/' | xargs -I path mkdir -p $outputfolder/path

# Copy in index files
find -not -path "*/\.*" -path "$indexfileglob"  -type f -exec cp {} $outputfolder/{} \;

# Copy in other files
find -not -path "*/\.*" -not -path "$indexfileglob" -path "$extensionglob" -type f | sed 's/\(.*\)\/\(.*\)'$inputextension'/\0 \1\/\2\/index'$inputextension'/' |  xargs -n 2 sh -c 'cp $0 '$outputfolder'/$1'

# Generate file structure for navigation templates
echo -e '---\n' $(tree -dJ --noreport $outputfolder | cut -c 2-) '\n...' > $outputfolder/tree.yaml

# Generate header files
find $outputfolder -path "$indexfileglob" -type f -execdir pandoc -o header.html --template $templatepath/header.html $outputfolder/tree.yaml \;

# Generate footer files
find $outputfolder -path "$indexfileglob" -type f -execdir pandoc -o footer.html --template $templatepath/footer.html $outputfolder/tree.yaml \;

# Convert content files to HTML
find $outputfolder -path "$indexfileglob" -type f -execdir pandoc -B header.html -A footer.html -o index.html {} \; -delete

# TODO: Copy in css/js/img
echo " done."

echo "Starting up server at localhost:8000..."
webfsd -F -r $outputfolder -f index.html -l -
