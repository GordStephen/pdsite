templatespath=~/Projects/pdsite

inputextension=.md
outputfolder=.html
template=test-template

templatepath=$templatespath/$template

# Convert to canonical path
outputfolder=$(readlink -f $outputfolder)

# Build glob expressions
extensionglob='*'$inputextension
indexfileglob='*index'$inputextension

# Purge output folder
rm -rf $outputfolder

# Generate base file structure
find -not -path "*/\.*" -not -path "$indexfileglob" -path "$extensionglob" -type f | sed 's/\(.*\)'$inputextension'/\1/' | xargs -I path mkdir -p $outputfolder/path

# Copy in index files
find -not -path "*/\.*" -path "$indexfileglob"  -type f -exec cp {} $outputfolder/{} \;

# Copy in other files
find -not -path "*/\.*" -not -path "$indexfileglob" -path "$extensionglob" -type f | sed 's/\(.*\)\/\(.*\)'$inputextension'/\0 \1\/\2\/index'$inputextension'/' |  xargs -n 2 sh -c 'cp $0 '$outputfolder'/$1'

# Generate file structure for navigation templates
echo '---\n' $(tree -dJ --noreport $outputfolder | cut -c 2-) '\n...' > $outputfolder/tree.yaml

# Generate header files
find $outputfolder -path "$indexfileglob" -type f -execdir pandoc -o header.html --template $templatepath/header.html $outputfolder/tree.yaml \;

# Generate footer files
find $outputfolder -path "$indexfileglob" -type f -execdir pandoc -o footer.html --template $templatepath/footer.html $outputfolder/tree.yaml \;

# Convert content files to HTML
find $outputfolder -path "$indexfileglob" -type f -execdir pandoc -B header.html -A footer.html -o {}.html {} \; -delete


# TODO: Generate header/footer HTML from templates
# TODO: Copy in css/js/img
