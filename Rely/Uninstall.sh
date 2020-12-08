# !/bin/bash

qqMusic_path="/Applications/QQMusic.app"

if [ ! -d "$qqMusic_path" ]
then
qqMusic_path="/Applications/QQ音乐.app"
if [ ! -d "$qqMusic_path" ]
then
echo -e "\n\n应用程序文件夹中未发现QQ音乐，请检查是否有重命名或者移动路径位置"
exit
fi
fi

app_name="QQMusic"
framework_name="QQMusicExtension"
app_bundle_path="${qqMusic_path}/Contents/MacOS"
app_executable_path="${app_bundle_path}/${app_name}"
app_executable_backup_path="${app_executable_path}_backup"
framework_path="${app_bundle_path}/${framework_name}.framework"

# 备份QQMusic原始可执行文件
if [ -f "$app_executable_backup_path" ]
then
rm "$app_executable_path"
rm -rf "$framework_path"
mv "$app_executable_backup_path" "$app_executable_path"

if [ -f "$app_executable_backup_path" ]
then
	echo "卸载失败，请到 /Applications/QQMusic.app/Contents/MacOS 路径，删除 QQMusicPlugin.framework、QQMusic 两个文件文件，并将 QQMusic_backup 重命名为 QQMusic"
else
	echo "\n\t卸载成功, 重启QQ音乐生效!"
fi

else
    echo "\n\t未发现QQ音乐插件"
fi
