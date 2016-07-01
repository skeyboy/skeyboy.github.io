IFS=$'\n'
buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${PROJECT_DIR}/${INFOPLIST_FILE}")
versionNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${PROJECT_DIR}/${INFOPLIST_FILE}")
buildDate=$(date "+%y%m%d")


PATH=${PATH}:/usr/local/bin

function generateIcon () {
BASE_IMAGE_NAME=$1

TARGET_PATH="${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/${BASE_IMAGE_NAME}"
echo $TARGET_PATH
echo $SRCROOT
echo $(find ${SRCROOT} -name "Icon-60@2x.png")
BASE_IMAGE_PATH=$(find ${SRCROOT} -name ${BASE_IMAGE_NAME})
WIDTH=$(identify -format %w ${BASE_IMAGE_PATH})
FONT_SIZE=$(echo "$WIDTH * .15" | bc -l)
echo "font size $FONT_SIZE"

if [ "${CONFIGURATION}" == "Debug" ]; then
convert debugRibbon.png -resize ${WIDTH}x${WIDTH} resizedRibbon.png
convert ${BASE_IMAGE_PATH} -fill white -font Times-Bold -pointsize ${FONT_SIZE} -gravity south -annotate 0 "$versionNumber-$buildDate" - | composite resizedRibbon.png - ${TARGET_PATH}
fi

if [ "${CONFIGURATION}" == "Beta" ]; then
convert betaRibbon.png -resize ${WIDTH}x${WIDTH} resizedRibbon.png
convert ${BASE_IMAGE_PATH} -fill white -font Times-Boldr -pointsize ${FONT_SIZE} -gravity south -annotate 0 "$versionNumber-$buildDate" - | composite resizedRibbon.png - ${TARGET_PATH}
fi

if [ "${CONFIGURATION}" == "Release" ]; then
convert releaseRibbon.png -resize ${WIDTH}x${WIDTH} resizedRibbon.png
convert ${BASE_IMAGE_PATH} -fill white -font Times-Boldr -pointsize ${FONT_SIZE} -gravity south -annotate 0 "$versionNumber-$buildDate" - | composite resizedRibbon.png - ${TARGET_PATH}
fi
}

generateIcon "AppIcon60x60@2x.png"
generateIcon "AppIcon60x60@3x.png"

generateIcon "AppIcon40x40@2x.png"
generateIcon "AppIcon40x40@3x.png"

generateIcon "AppIcon29x29@2x.png"
generateIcon "AppIcon29x29@3x.png"