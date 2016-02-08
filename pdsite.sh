# TODO: Pick standard location? ~/.pdsite-themes?
templatespath=~/Projects/pdsite/themes

# Set config defaults
template=default
inputextension=.md

# Load config variables from file
if [ -f ./.pdsite ]; then
   # This isn't the best idea, but it works for now
   # YAML would be ideal
   source ./.pdsite
else
    echo "ERROR: .pdsite configuration file not detected" 1>&2
    exit 1
fi

templatepath=$templatespath/$template
treedata=tree.yaml.tmp
localtreedata=localtree.yaml.tmp
localfiledata=fileloc.tmp
stylesheet=styles.css

# Convert to canonical path
outputfolder=$(readlink -f $outputfolder)
escapedoutputfolder=$(echo $outputfolder | sed 's/\./\\./')

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

# Copy in other content files
find -not -path "*/\.*" -not -path "$indexfileglob" -path "$extensionglob" -type f | sed 's/\(.*\)\/\(.*\)'$inputextension'/\0 \1\/\2\/index'$inputextension'/' |  xargs -n 2 sh -c 'cp $0 '$outputfolder'/$1'

# Move in CSS
cp $templatepath/styles.css $outputfolder

# Generate file structure for navigation templates
echo -e '---\n' $(tree -dfJ --noreport $outputfolder | cut -c 2- | sed 's|"name":"'$escapedoutputfolder'/\(.*\)/\(.*\)",|"name":"\2","path":"/\1/\2",|' | sed 's|"name":"'$escapedoutputfolder'/\(.*\)",|"name":"\1","path":"/\1",|') '\n...' > $outputfolder/$treedata

# Generate structure supplement for each file
find $outputfolder -path "$indexfileglob" -type f -execdir sh -c "pwd | sed 's|$escapedoutputfolder||' > $localfiledata" \; -execdir sh -c 'sed "s|\"path\":\"$(cat fileloc.tmp)\",|\0\"active\":y,|" '$outputfolder/$treedata' > '$localtreedata \;

# Generate header files
find $outputfolder -path "$indexfileglob" -type f -execdir pandoc -o header.html --template $templatepath/header.html -V sitename="$sitename" $localtreedata \;

# Generate footer files
find $outputfolder -path "$indexfileglob" -type f -execdir pandoc -o footer.html --template $templatepath/footer.html -V sitename="$sitename" $localtreedata \;

# Convert content files to HTML
find $outputfolder -path "$indexfileglob" -type f -execdir pandoc -T "$sitename" -c "/$stylesheet" -B header.html -A footer.html -V sitename="$sitename" -o index.html {} \; -execdir rm header.html footer.html \; -delete

# Clean up
find $outputfolder -path "*.tmp" -type f -delete

echo " done."

webfsd -Fd -r $outputfolder -f index.html -l -
