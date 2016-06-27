#!/bin/sh

#
# ./icon_debug.sh 1.2.22 false
# ./icon_debug.sh 1.2.22 true
# 脚本 版本号 是否添加debug样式

#工程绝对路径
#cd $1
echo $1
project_icon_name="icon.png"
echo "路径".$(pwd)
project_src_path=$(pwd)"/app/src/main/res"
cd ${project_src_path}
echo "资源路径：".$(pwd)
buildNumber=$1
buildDate=$(date "+%y%m%d")

DEBUG=$2

#根据指定的url 和路径 下载参考图片
function downImage() {
echo "$1 $2"
    if [ ! -f "$2" ]; then
                  curl $1 -o $2
    fi
}

function generateIcon () {

    #sproject_debug_ribbon_png=$(pwd)"/drawable/debug_ribbon.png"
    BASE_IMAGE_NAME=$1
    ICON_FOLDER=$2

    #根据是否debug添加不同的图层

    if $DEBUG ; then
        project_ribbon_png=$(pwd)"/drawable/debug_ribbon.png"
        downImage "https://skeyboy.github.io/debug_icon/debug_ribbon.png" ${project_ribbon_png}
    else
        project_ribbon_png=$(pwd)"/drawable/release_ribbon.png"
        downImage "https://skeyboy.github.io/debug_icon/release_ribbon.png" ${project_ribbon_png}
    fi

    TARGET_RELATIVE_PATH=$(pwd)"/${ICON_FOLDER}"
    TARGET_RELATIVE_PNG="${TARGET_RELATIVE_PATH}/ic_launcher.png"

    downImage "https://skeyboy.github.io/debug_icon/${ICON_FOLDER}/ic_launcher.png" ${TARGET_RELATIVE_PNG}

    TARGET_PATH="${TARGET_RELATIVE_PATH}/${BASE_IMAGE_NAME}"
    echo $TARGET_PATH

    BASE_IMAGE_PATH=${TARGET_PATH}

    rm -f TARGET_PATH

   if [ ! -f $(pwd)"/drawable/icon_original.png" ]; then
       downImage "https://skeyboy.github.io/debug_icon/mipmap-xxxhdpi/ic_launcher.png" $(pwd)"/drawable/icon_original.png"
   fi
    cp $(pwd)"/drawable/icon_original.png" ${TARGET_PATH}

   # echo "删除文件"${TARGET_PATH}

    WIDTH=$(identify -format %w ${TARGET_RELATIVE_PNG})
    FONT_SIZE=$(echo "$WIDTH * .15" | bc -l)
    #echo "font size $FONT_SIZE"${TARGET_RELATIVE_PNG}

    convert ${project_ribbon_png} -resize ${WIDTH}x${WIDTH} resizedRibbon.png
    convert  ${TARGET_PATH} -resize ${WIDTH}x${WIDTH} resizeTargetPng.png
    convert resizeTargetPng.png -fill white -font Times-Bold -pointsize ${FONT_SIZE} -gravity south -annotate 0 "${buildNumber} - ${buildDate}" - | composite resizedRibbon.png - ${TARGET_PATH}
   # echo "${project_ribbon_png}  ${DEBUG}"
    rm -f resizeTargetPng.png
    rm -rf resizedRibbon.png
  #  curl "https://s.yimg.com/zz/combo?a/i/us/nws/weather/gr/1d.png" -o "${TARGET_RELATIVE_PATH}/xx.png"

}

generateIcon "icon.png" "mipmap-hdpi"
generateIcon "icon.png" "mipmap-mdpi"
generateIcon "icon.png" "mipmap-xhdpi"
generateIcon "icon.png" "mipmap-xxhdpi"
generateIcon "icon.png" "mipmap-xxxhdpi"
generateIcon "icon.png" "drawable"
