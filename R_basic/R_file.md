# R语言文件目录相关操作
R语言对文件系统的操作，包括文件操作和目录操作，函数API都定义在base包中。
## 目录操作
### 查看目录
```R
 setwd()               #设定某个目录为当前目录
 getwd()               # 当前的目录
 list.dirs()           # 查看当前目录的子目录  参数详见dir()
 
 dir()                 #查看当前目录的子目录和文件。
 dir(path="C:/windows")#查看指定目录的子目录和文件
 dir(path="C:/windows",all.files=TRUE)# 列出目录下所有的目录和文件，包括隐藏文件
 dir(path="C:/windows",pattern='^R')#只列出以字母R开头的子目录或文件
 
 file.info(".")         # 查看当前目录权限
```

### 创建目录
```R
dir.create("your dir")        # 在当前目录下，新建一个目录
dir.create(path="a1/b2/c3",recursive = TRUE)  #递归创建一个3级子目录./a1/b2/c3，直接创建会出错
```

### 检查目录是否存在
```R
system("tree")                      # 通过系统命令查看目录结构
file.exists("./a1")             # 查看某个目录是否存在,可以多层次调用目录
```

### 检查目录的权限
```R
df<-dir(full.names = TRUE)         #获取当前目录的所有目录(不含子目录)和文件名（含后缀）
file.access(df, model=0) == 0      # 检查文件或目录是否存在，mode=0
         						  # 检查文件或目录是否可执行，mode=1，目录为可以执行
         						  # 检查文件或目录是否可写，mode=2
          						 # 检查文件或目录是否可读，mode=4
```

### 对目录重名
```R
file.rename("create", "newcreate")            # 对tcreate目录重命名为newcreate
unlink("newcreate", recursive = TRUE)         # 删除newcreate目录   递归删除
```

## 文件操作

### 查看文件
```R
file.exists("readme.txt")         # 检查文件是否存在
file.info("readme.txt")            # 查看文件完整信息
file.access("readme.txt",0)        # 查看文件访问权限，存在详情见2.4
file_test("-d", "readme.txt")      #判断是文件还是目录。-d ,是目录返回ture
file_test("-f", "readme.txt")      # 判断是否是文件 .  -f 是文件但会ture
```

### 创建文件
```
file.create("A.txt")            # 创建一个空文件 A.txt
cat("file B\n", file = "B.txt") # 把相关的内容写入B.txt文件中，没有这个文件则创建文件并写入内容 

readLines("A.txt")         # 读取A.txt并打印
file.append("A.txt", rep("B.txt", 10))   # 合并文件,把文件B.txt的内容，合并到 A.txt。
file.copy("A.txt", "C.txt")    #把文件A.txt复制到文件C.txt ,文件复制
```

### 修改文件权限
```R
# 修改文件权限，创建者可读可写可执行，其他人无权限
Sys.chmod("A.txt", mode = "0700", use_umask = TRUE)
```

### 文件重命名
```R
file.rename("A.txt","AA.txt")     # 给文件A.txt重命名为AA.txt
```

### 删除文件

有两个函数可以使用file.remove和unlink，其中unlink函数使用同删除目录操作是一样的。
```R
file.remove("A.txt", "B.txt", "C.txt")      # 删除文件
unlink("readme.txt")                   # 删除文件
system("ls -l")            # 查看目录文件
```

## 实操

### R操作CSV 文件
CSV（Comma-Separated Values，CSV，有时也称为字符分隔值，因为分隔字符也可以不是逗号） 是一种非常流行的表格存储文件格式，这种格式适合储存中型或小型数据规模的数据。由于大多数软件支持这个文件格式，所以常用于数据的储存与交互。

CSV 本质是文本，它的文件格式极度简单：数据一行一行的用文本保存起来而已，每条记录被分隔符分隔为字段，每条记录都有同样的字段序列。

+ 注意：包含非英文字符的文本要注意保存的编码，由于很多计算机普遍使用 UTF-8 编码，所以我是用 UTF-8 进行保存的。
+ 注意： CSV 文件最后一行需要保留一个空行，不然执行程序会有警告信息。

#### 读取 CSV 文件
 read.csv() 函数来读取 CSV 文件的数据,read.csv() 函数返回的是数据框，我们可以很方便的对数据进行统计处理，以下实例我们查看行数和列数:
```R
# 如果不设置 encoding 属性，read.csv 函数将默认以操作系统默认的文字编码进行读取，如果你使用的是 Windows 中文版系统且没有设置过系统的默认编码，那系统的默认编码应该是 GBK。所以大家请尽可能地统一文字编码以防出错。
data <- read.csv("sites.csv", encoding="UTF-8")

id   name            url likes
1  1 Google www.google.com   111
2  2 Runoob www.runoob.com   222
3  3 Taobao www.taobao.com   333

print(is.data.frame(data))  # 查看是否是数据框
print(ncol(data))  # 列数
print(nrow(data))  # 行数

# likes 最大的数据
like <- max(data$likes)

# 指定查找条件，类似 SQL where 子句一样查询数据，需要用到到函数是 subset()。
# likes 为 222 的数据
# 注意：条件语句等于使用 ==
retval <- subset(data, likes == 222)

# 多个条件使用 & 分隔符，以下实例查找 likes 大于 1 name 为 Runoob 的数据：
retval <- subset(data, likes > 1 & name=="Runoob")
```

### 保存为 CSV 文件
```R
# 写入新的文件
write.csv(retval,"runoob.csv",sep = ";")
```
























