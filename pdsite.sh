# TODO: Pick standard location? ~/.pdsite-themes?
templatespath=~/Projects/pdsite/themes

# Set config defaults
template=default
inputextension=.md

# Load config variables from file
if [ -f ./.pdsite ]; then
   # This isn't the best idea, but it works for now
   # YAML would be ideal
   # Arbitrary YAML (passed to template) + regex parsing for specific config vars?
   source ./.pdsite
else
    echo "ERROR: .pdsite configuration file not detected" 1>&2
    exit 1
fi

templatepath=$templatespath/$template
treedata=tree.yaml.tmp
localtreedata=localtree.yaml.tmp
stylesheet=styles.css

# Convert to canonical path
outputfolder=$(readlink -f $outputfolder)
escapedoutputfolder=$(echo $outputfolder | sed 's/\./\\./')

# Build glob expressions
extensionglob='*'$inputextension
indexfileglob='*index'$inputextension

# Define web-safe URL creation from file/directory names
makeslug(){
    tr -dc '[:graph:][:space:]' | tr '[:upper:]' '[:lower:]' | tr -s ' -_'  | tr ' _' '-'
}

# Define human-readable page title creation from web-safe filenames
makepretty(){
    tr '-' ' ' | awk '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) }}1'
}

# Purge output folder
echo -n "Clearing old build folder..."
rm -r $outputfolder/*
echo " done."

echo -n "Building site..."

# Generate base file structure
find -not -path "*/\.*" -not -path "$indexfileglob" -path "$extensionglob" -type f | sed 's|\(.*\)\..*|\1|' | makeslug | xargs -I path mkdir -p $outputfolder/path

# Copy in index files
find -not -path "*/\.*" -path "$indexfileglob" -type f | while read inpath; do
    outpath=$(echo $inpath | makeslug)
    cp "$inpath" "$outputfolder/$outpath"
done

# Copy in other content files
find -not -path "*/\.*" -not -path "$indexfileglob" -path "$extensionglob" -type f | while read inpath; do
    outpath=$(echo $inpath | sed 's|\./\(.*\)\.\(.*\)|\1/index.\2|' | makeslug)
    cp "$inpath" "$outputfolder"/"$outpath"
done

cd $outputfolder

# Generate global file structure for navigation templates
echo -e '\n---' > $treedata
tree -dfJ --noreport | cut -c 2- | while read line; do

    # Generate path relative to site root
    path=$(echo $line | grep 'type' | sed 's|.*"name":"\.\(.*\)","contents".*|\1|')

    # Generate pretty page name automatically
    name=$(echo $path | sed 's|.*/\(.*\)|\1|' | makepretty)

    #TODO: Generate page title from pandoc metadata
    # find -path "$indexfileglob" -type f -execdir ... pandoc ...

    # Inject page name and path into site tree
    echo $line | sed 's|"name":"\(.*\)","contents"|"name":"'"$name"'","path":"'"$path"'","contents"|'

done >> $treedata
echo -e '...\n' >> $treedata

# Generate local contextual nav data
find -path "$indexfileglob" -type f -execdir sh -c 'sed "s|\"path\":\"$(pwd | sed "s|'"$escapedoutputfolder"'||")\",|\0\"active\":y,|" '$outputfolder/$treedata' > '$localtreedata \;

# Generate header files
find -path "$indexfileglob" -type f -execdir pandoc -o header.html --template $templatepath/header.html -V sitename="$sitename" $localtreedata \;

# Generate footer files
find -path "$indexfileglob" -type f -execdir pandoc -o footer.html --template $templatepath/footer.html -V sitename="$sitename" $localtreedata \;

# Convert content files to HTML
find -path "$indexfileglob" -type f -execdir pandoc -T "$sitename" -c "/$stylesheet" -B header.html -A footer.html -V sitename="$sitename" -o index.html {} \; -execdir rm header.html footer.html \; -delete

# Move in CSS
cp $templatepath/styles.css $outputfolder

# Clean up
find -path "*.tmp" -type f -delete

echo " done."

webfsd -Fd -r $outputfolder -f index.html -l -
