library(tidyverse)
text <- 'UIUC_ECON_2026'
# Detect
str_detect(text, 'UIUC') #TRUE
str_detect(text, '[a-z]+') #FALSE, because there's no lower case
str_detect(text, '[A-Z]+') #TRUE
str_detect(text, '\\d{4}') # 探測是否包含 4 位連續數字

str_extract(text, '\\d+') == '2026'
#Indexing
str_which(text, "\\d+") # 匹配成功，返回該元素所在的下標位置 1

#count
str_count(text) #14
str_count(text, '_')
# 統計連續字母段 "[A-Z]+" 出現的次數（"UIUC" 與 "ECON"）
str_count(text, "[A-Z]+")
# 輸出: [1] 2

# 統計單個字母 "[A-Z]" 出現的次數（u, i, u, c, e, c, o, n）
str_count(text, "[A-Z]")
# 輸出: [1] 8


# 探測是否包含 4 位連續數字
str_detect(text, "\\d{4}")

#Replacement
str_replace(text, '_','\\abc') #"UIUCabcECON_2026"
str_replace_all(text, '_',' ') #"UIUC ECON 2026"
str_replace(text, '\\d+','2006') #"UIUC_ECON_2006"
#Removal
str_remove(text, '\\w') "IUC_ECON_2026"
str_remove_all(text, '\\w') # ""
#Split
str_split(text, '_') #"UIUC" "ECON" "2026"
str_which(str_detect(text, "_'"))
