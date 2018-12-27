Localizable.strings文件路径
localizableFile="${SRCROOT}/${PROJECT_NAME}/Base.lproj/Localizable.strings"
touch $localizedFile
# 生成的文件路径（根据个人习惯修改）
localizedFile="${SRCROOT}/${PROJECT_NAME}/LocalizedUtils.h"
# 将localizable.strings中的文本转为swift格式的常量，存入一个临时文件
sed "s/\" = \".*$/;/g" ${localizableFile} | sed "s/.*/& &/" | sed "s/^\"/ #define localized_/g" | sed "s/; \"/ localized(@\"/g" | sed "s/;/\")/g" > "${localizedFile}.tmp"

# 先将localized作为计算属性输出到目标文件
echo -e "#ifndef LocalizedUtils_h\n#define LocalizedUtils_h\n #define localized(o) NSLocalizedString(o, nil)" > "${localizedFile}"
# 再将临时文件中的常量增量输出到目标文件
cat "${localizedFile}.tmp" >> "${localizedFile}"
# 最后增量输出一个"}"到目标文件，完成输出
echo -e "\n#endif" >> "${localizedFile}"
# 删除临时文件
rm "${localizedFile}.tmp"
