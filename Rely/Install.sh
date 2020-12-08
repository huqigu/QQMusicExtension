#!/bin/bash

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
shell_path="$(dirname "$0")"
framework_name="QQMusicExtension"
app_bundle_path="${qqMusic_path}/Contents/MacOS"
app_executable_path="${app_bundle_path}/${app_name}"
app_executable_backup_path="${app_executable_path}_backup"
framework_path="${app_bundle_path}/${framework_name}.framework"

# 先执行卸载流程
if [ -f "$app_executable_backup_path" ]
then
rm "$app_executable_path"
rm -rf "$framework_path"
mv "$app_executable_backup_path" "$app_executable_path"

if [ -f "$app_executable_backup_path" ]
then
    echo "卸载失败，请到 /Applications/QQMusic.app/Contents/MacOS 路径，删除 QQMusicPlugin.framework、QQMusic 两个文件文件，并将 QQMusic_backup 重命名为 QQMusic"
else
    echo "\n\t卸载旧插件成功,安装新版中..."
fi
#未发现小助手
fi

# 执行安装流程
# 对 QQMusic 赋予权限
if [ ! -w "$qqMusic" ]
then
echo -e "\n\n为了将插件写入QQ音乐, 请输入密码 ： "
sudo chown -R $(whoami) "$qqMusic"
fi

# 判断是否已经存在备份文件 或者 是否强制覆盖安装
if [ ! -f "$app_executable_backup_path" ] || [ -n "$1" -a "$1" = "--force" ]
then
# 备份 QQMusic 原始可执行文件
cp "$app_executable_path" "$app_executable_backup_path"
result="y"
else
read -t 150 -p "已安装QQ音乐插件，是否覆盖？[y/n]:" result
fi

if [[ "$result" == 'y' ]]; then
    cp -r "${shell_path}/Plugin/QQMusicExtension/${framework_name}.framework" ${app_bundle_path}
    ${shell_path}/insert_dylib --all-yes "${framework_path}/${framework_name}" "$app_executable_backup_path" "$app_executable_path"
fi
