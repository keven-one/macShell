#weex ios工程目录名称
weexproject=xxxapp_weex
iosproject=xxxapp_ios

#iOS工程测试的变量
tests=(
	"NSString \* const imageBucket = @\"test-xxx-images\";"
	"NSString \* const videoBucket = @\"test-xxx-videos\";"
	"NSString \* const bookBucket = @\"test-xxx-books\";"
	"NSString \* const kBaseUrl = @\"https:\/\/cs.management.xxx.com\";"
)
#iOS工程正式的变量
onlines=(
	"NSString \* const imageBucket = @\"xxx-images\";"
	"NSString \* const videoBucket = @\"xxx-videos\";"
	"NSString \* const bookBucket = @\"xxx-books\";"
	"NSString \* const kBaseUrl = @\"https:\/\/management.xxx.com\";"
)

#weex工程测试的变量
weextests=(
	"baseurl:'https:\/\/cs.management.xxx.com\/',"
	"imageUrl:'https:\/\/test-xxx-images.oss-cn-shanghai.aliyuncs.com\/',"
	"bookPathUrl:'https:\/\/test-xxx-books.oss-cn-shanghai.aliyuncs.com\/',"
	"videoUrl:'https:\/\/test-xxx-videos.oss-cn-shanghai.aliyuncs.com\/',"
	"audioUrl:'https:\/\/test-xxx-audios.oss-cn-shanghai.aliyuncs.com\/',"
	"othersUrl:'https:\/\/test-xxx-others.oss-cn-shanghai.aliyuncs.com\/',"
	"ueditUrl:'https:\/\/test-xxx-ueditor.oss-cn-shanghai.aliyuncs.com\/',"
	"zipBookPathUrl:'http:\/\/test-xxx-books.oss-cn-shanghai.aliyuncs.com\/',"
)
#weex工程正式的变量
weexonlines=(
	"baseurl:'https:\/\/management.xxx.com\/',"
	"imageUrl:'https:\/\/xxx-images.oss-cn-shanghai.aliyuncs.com\/',"
	"bookPathUrl:'https:\/\/xxx-books.oss-cn-shanghai.aliyuncs.com\/',"
	"videoUrl:'https:\/\/xxx-videos.oss-cn-shanghai.aliyuncs.com\/',"
	"audioUrl:'https:\/\/xxx-audios.oss-cn-shanghai.aliyuncs.com\/',"
	"othersUrl:'https:\/\/xxx-others.oss-cn-shanghai.aliyuncs.com\/',"
	"ueditUrl:'https:\/\/xxx-ueditor.oss-cn-shanghai.aliyuncs.com\/',"
	"zipBookPathUrl:'http:\/\/xxx-books.oss-cn-shanghai.aliyuncs.com\/',"
)

#开始修改DBConst为线上

#注释代码
#function 将传入数组的里的代码注释掉
annotationArray() {
	elements=$(($# - 1))
	allelements=$(($#))
	file=${!allelements}
	for ((i = 1; i <= $elements; i++)); do
		before=${!i}
		after="\/\/""${before}"
		#如果没有被注释则替换
		if [ $(grep -c "${after}" $file) -eq 0 ]; then
			sed -i '' 's/'"${before}"'/'"${after}"'/g' $file
		fi
	done
}
#去掉注释
#function 将传入数组的里的代码去掉注释
unannotationArray() {
	elements=$(($# - 1))
	allelements=$(($#))
	file=${!allelements}
	for ((i = 1; i <= $elements; i++)); do
		before=${!i}
		after="\/\/""${before}"
		#如果没有被注释则替换
		if [ $(grep -c "${after}" $file) -eq 1 ]; then
			sed -i '' 's/'"${after}"'/'"${before}"'/g' $file
		fi
	done
}

 cd ~/Documents/work/${iosproject}/xxxapp_ios/Common
 annotationArray "${tests[@]}" "DBConst.m"
 unannotationArray "${onlines[@]}" "DBConst.m"
cd ~/Documents/work/${weexproject}/src
annotationArray "${weextests[@]}" "api.js"
unannotationArray "${weexonlines[@]}" "api.js"

echo '替换线上成功----已将iOS中DBConst.m和Weex工程中api.js变量替换为线上----'
exit

cd ~/Documents/work/${weexproject}
git pull
cd ~/Documents/work/${iosproject}
git pull
sleep 60
#每次发版本自动将build号加1
bundleVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" ~/Documents/work/${iosproject}/xxxapp_ios/Info.plist)
bundleVersion=$((bundleVersion + 1))
/usr/libexec/PlistBuddy -c "Set CFBundleVersion ${bundleVersion}" ~/Documents/work/${iosproject}/xxxapp_ios/Info.plist
#修改APP名字
/usr/libexec/PlistBuddy -c "Set CFBundleDisplayName xxx" ~/Documents/work/${iosproject}/xxxapp_ios/Info.plist

SCHEMENAME=xxxapp_ios
WORKSPACE=~/Documents/work/${iosproject}/xxxapp_ios.xcworkspace
CHANHELOG=~/Desktop/${SCHEMENAME}.log

xcodebuild -workspace ${WORKSPACE} -scheme ${SCHEMENAME} clean
#编译工程
xcodebuild archive -workspace ${WORKSPACE} -scheme ${SCHEMENAME} -configuration Release -archivePath ~/Desktop/${SCHEMENAME}/${SCHEMENAME}

#导出ipa
xcodebuild -exportArchive -archivePath ~/Desktop/${SCHEMENAME}/${SCHEMENAME}.xcarchive -exportPath ~/Desktop/${SCHEMENAME}/IPA/ -exportOptionsPlist ~/Documents/work/${iosproject}/exprotOptionsPlist.plist -allowProvisioningUpdates -allowProvisioningDeviceRegistration





#需要安装fir-cli 安装方法 https://github.com/FIRHQ/fir-cli/blob/master/README.md
if [  -f "$CHANHELOG" ];then
rm ~/Desktop/${SCHEMENAME}.log
fi
cd ~/Documents/work/${weexproject}
git log -1 --pretty --oneline >> "$CHANHELOG"
fir login -T xxx
fir publish ~/Desktop/${SCHEMENAME}/IPA/${SCHEMENAME}.ipa --changelog="$CHANHELOG"

#!/bin/bash
email_reciver1="xxxx"
email_reciver2="xxxx"
#发送者邮箱
email_sender=xxx
#邮箱用户名
email_username=xxx
#邮箱密码
#使用qq邮箱进行发送需要注意：首先需要开启：POP3/SMTP服务，其次发送邮件的密码需要使用在开启POP3/SMTP服务时候腾讯提供的第三方客户端登陆码。
email_password=xxx
#附件图片
file_path="/Users/xxx/Documents/work/二维码.png"

#smtp服务器地址
email_smtphost=xxx
bundleShortVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" /Users/huangzhenyu/Documents/work/${iosproject}/xxxapp_ios/Info.plist)



email_title="xxxTest iOS客户端 V "$bundleShortVersion"Build "$bundleVersion
email_result=$(cat ${CHANHELOG})
email_content="下载地址：https://fir.im/test"'\n'"更新日志："'\n'"$email_result"
sendEmail -f ${email_sender} -t ${email_reciver1} ${email_reciver2} -s ${email_smtphost} -u ${email_title} -xu ${email_username} -xp ${email_password} -m "$email_content" -a ${file_path}  -o message-charset=utf-8
