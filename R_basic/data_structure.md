# 数据结构

## 数据结构
对象是 R 语言的基础性概念，R 语言内的数据变量、函数结果、产生的图像等，都是以对象的形似存在的。R 语言的对象类型有向量（vector）、数组（array）、矩阵（matrix）、列表（list）和数据框（data frame）等，也即是数据结构。列表和数据框可以包含不同的数据类型。

## 向量

向量从数据结构上看就是一个线性表，可以看成一个数组。R 语言中向量作为一种类型存在可以让向量的操作变得更加容易。

###  创造向量
```R
a = c(10, 20, 30, 40, 50)
>a[1:4] # 取出第 1 到 4 项，包含第 1 和第 4 项
[1] 10 20 30 40
> a[c(1, 3, 5)] # 取出第 1, 3, 5 项
[1] 10 30 50
> a[c(-1, -5)] # 去掉第 1 和第 5 项
[1] 20 30 40
```

### 空值
向量中常会用到 NA 和 NULL ，这里介绍一下这两个词语与区别：  
NA 代表的是"缺失"，NULL 代表的是"不存在"。NA 缺失就想占位符，代表这里没有一个值，但位置存在。NULL 代表的就是数据不存在。
```R
> length(c(NA, NA, NULL))
[1] 2
> c(NA, NA, NULL, NA)
[1] NA NA NA
# 很显然， NULL 在向量中没有任何意义。
```

### 特殊规律的向量的创建
```R
# 元素全同的向量
rep(3.2,5) # [1] 3.2 3.2 3.2 3.2 3.2

# 创建等差数列
## 连续整数：用冒号连接连续整数的首尾，如1:5,2:7,0:8,-3:7,6:-2，可以是正序，也可以是倒序，返回值包含首尾。结尾的数可以不是整数：当开头是整数，结尾不是整数时，返回不超过结尾的序列，如6:pi返回c(6,5,4)，1:pi返回c(1,2,3)。

## 公差为1或-1的实数等差序列：上面的用法，开头也可以不是整数而是一般实数，则序列的首项为开头数值，如
3.14:6返回c(3.14,4.14,5.14)
3.14:6.14返回c(3.14,4.14,5.14,6.14)
3.14:6.1返回c(3.14,4.14,5.14)
3.14:6.2返回c(3.14,4.14,5.14,6.14)
3.14:-6.2返回c(3.14,4.14,5.14,6.14)

## 任意公差的等差数列：用seq函数，其用法为：seq(from = 1, to = 1, by = ((to - from)/(length.out - 1)),length.out = NULL, along.with = NULL, ...)，其中from代表首项，to代表尾项，by代表公差，length.out代表项数。也可以不提供length.out而提供along.with，则项数用赋给along.with的参数的长度，典型的几种用法如下：
seq(from, to)

seq(from, to, by= )
> seq(1, 9, 2)
# [1] 1 3 5 7 9

seq(from, to, length.out= )
> seq(0, 1, length.out=3)
# [1] 0.0 0.5 1.0

seq(from,  by= , length.out= )
seq(by= , length.out= ,to=)
```

### 向量元素的选取
+ 单个元素的选取  
用中括号加上元素的序号；如果元素有名字，也可以在中括号中放置元素名。如果序号超过了向量长度，则会返回NA值，如果序号为0，则返回长度为0的该类型向量，如果序号为小数，则会被函数as.integer修正为整数，即向0取整。
```R
x <- c(1.2,3.5,pi)
x[1]
# [1] 1.2

b <- c(x1=1.2,3.5,x3=pi)
b["x3"]
##       x3 
## 3.141593
```

+ 多个元素的选取
在中括号中放置向量，向量元素为要选取的元素序号或名字组成，但序号和名字不能混用，如
```R
x <- c(5.2, 52.0, 520.0, 5200.0, 52000.0)
x[2:4]
## [1]   52  520 5200
x[c(1,3:4)]
## [1]    5.2  520.0 5200.0
a <- c(x1=1.2,x2=3.5,x3=pi)
a[c("x1","x3")]
##       x1       x3 
## 1.200000 3.141593
# a["x1","x3"] #这种写法会报错，一定要放在一个向量内
# a["x1":"x3"]  #这种写法也会报错，"x1":"x3"的写法没有意义

b <- c(x1=1.2,3.5,x3=pi)
# b[c(1,"x3")] #序号和名字放在一个向量中时，整数会转化为字符串，而b中不存在名为"1"的元素，因而返回非数NA
```
### 向量元素的修改
将新值赋给对应元素即可。如x[1] <- 2，b[2:3] <- c(3,2)。新值个数与被赋值的元素个数可以不相同。当新值个数大于被赋值元素个数时，超出部分不起作用。当新值个数小于被赋值元素个数时，新值会被复制多份，首尾相连，然后赋给被赋值元素。特别地，当新值个数为1时，将该值赋给每一个被赋值的元素。可以给尚不存在的元素赋值，相当于增加了向量的长度.
```R
# 新值个数小于被赋值元素个数
x <- 1:10
x[1:5] <- c(11,12)
## Warning in x[1:5] <- c(11, 12): number of items to replace is not a
## multiple of replacement length
x
##  [1] 11 12 11 12 11  6  7  8  9 10

# 新值个数大于被赋值元素个数
y <- 1:10
y[6:10] <- 1:6
## Warning in y[6:10] <- 1:6: number of items to replace is not a multiple of
## replacement length
y
##  [1] 1 2 3 4 5 1 2 3 4 5

# 新值个数为1
z <- 1:10
z[6:10] <- 0
z
##  [1] 1 2 3 4 5 0 0 0 0 0

# 给尚不存在的元素赋值
x <- 1:5
x[6] <- 6
x
## [1] 1 2 3 4 5 6
# or
x[10] <- 10
x
##  [1]  1  2  3  4  5  6 NA NA NA 10
x["a"] <- 8
x
##                                a 
##  1  2  3  4  5  6 NA NA NA 10  8
```

### 向量元素名的获取与修改
用names函数可获取向量的元素名，返回是各元素名字符串组成的向量，没定义名的为空字符串。如果一个向量，没有一个元素定义了名字，则返回空值NULL。如果需要修改元素名，直接将新元素名赋给names函数定义的位置即可。
```R
b <- c(x1=1.2,3.5,x3=pi)
names(b)
## [1] "x1" ""   "x3"

x <- 1:10
names(x)
## NULL
names(b)[2] <- "x2"
names(b)[1] <- "x1_0"
b
##     x1_0       x2       x3 
## 1.200000 3.500000 3.141593

names(x)[5] <- "x5"
x
## <NA> <NA> <NA> <NA>   x5 <NA> <NA> <NA> <NA> <NA> 
##    1    2    3    4    5    6    7    8    9   10

names(x)
##  [1] NA   NA   NA   NA   "x5" NA   NA   NA   NA   NA
```

### 向量元素的增加或插入

用函数c将增加了元素的向量赋给原向量
```R
x <- 1:10
# 在原来第4与第5个之间插入一个元素pi
x <- c(x[1:4],pi,x[5:length(x)])
x
##  [1]   0.000000   1.000000   2.000000   3.000000   3.141593   4.000000
##  [7]   5.000000   6.000000   7.000000   8.000000   9.000000  10.000000
## [13] 100.000000
```

### 向量元素的删除
用函数c将删除了元素的向量赋给原向量，一般会利用上面讲过的负数序号的用法，例如：
```R
x <- c(0.5,1:10,100)

# 删除第1个元素
x <- x[-1]
x
##  [1]   1   2   3   4   5   6   7   8   9  10 100

# 删除结尾元素
x <- x[-length(x)]
x
##  [1]  1  2  3  4  5  6  7  8  9 10

# 删除第2及4~6个元素
x <- x[-c(2,4:6)]
x
## [1]  1  3  7  8  9 10

# 删除名为"x1"的元素
b <- c(x1=1.2,3.5,x3=pi)
b <- b[!names(b) %in% c("x1")]

```

### 向量元素的排序
```R
x <- c(5:1,6,pi)
# 从小到大排序

# 用order函数
y1 <- x[order(x)]
y1
## [1] 1.000000 2.000000 3.000000 3.141593 4.000000 5.000000 6.000000

# 用sort函数
y12 <- sort(x)
y12
## [1] 1.000000 2.000000 3.000000 3.141593 4.000000 5.000000 6.000000

# 从大到小排序

# 用order函数
y2 <- x[order(x,decreasing = TRUE)]
y2
## [1] 6.000000 5.000000 4.000000 3.141593 3.000000 2.000000 1.000000

# 用sort函数
y22 <- sort(x,decreasing = TRUE)
y22
## [1] 6.000000 5.000000 4.000000 3.141593 3.000000 2.000000 1.000000
```

### 向量的翻转
直接将倒序后的向量赋给原向量即可，也可用rev函数，如
```R
x <- seq(2,10,by=2)
x
## [1]  2  4  6  8 10
x <- x[length(x):1]
x
## [1] 10  8  6  4  2
x <- rev(x)
x
## [1]  2  4  6  8 10
```



## 字符串

```R
#字符串数据类型本身并不复杂，主要字符串的操作函数：
> toupper("Runoob") # 转换为大写
[1] "RUNOOB"

> tolower("Runoob") # 转换为小写
[1] "runoob"

> nchar("中文", type="bytes") # 统计字节长度
[1] 4

> nchar("中文", type="char") # 总计字符数量
[1] 2

> substr("123456789", 1, 5) # 截取字符串，从 1 到 5
[1] "12345"

> substring("1234567890", 5) # 截取字符串，从 5 到结束
[1] "567890"

> as.numeric("12") # 将字符串转换为数字
[1] 12

> as.character(12.34) # 将数字转换为字符串
[1] "12.34"

> strsplit("2019;10;1", ";") # 分隔符拆分字符串
[[1]]
[1] "2019" "10"   "1"

> gsub("/", "-", "2019/10/1") # 替换字符串
[1] "2019-10-1"

# collapse会把一个向量内部的元素黏连起来，而sep则适用于把不同的向量分别黏连起来。
> paste(c("双11", "是个", "什么节日"), collapse = "")
[1] "双11是个什么节日" # paste()连接字符串
> paste("A", 1:4, sep="_")
[1] "A_1" "A_2" "A_3" "A_4"
> paste(LETTERS[1:4], 1:4, sep = "_", collapse = "|")
[1] "A_1|B_2|C_3|D_4"

# 字符串查找与替换
txt = c("狗熊会", "CluBear", "双11", "生日")
# 返回含有关键字的字符位置
grep("Bear", txt)
##  [1] 2
gsub("生日", "happy birthday", txt)
##  [1] "狗熊会"         "CluBear"        "双11"           "happy birthday"
# 实例
salary = c("22万", "30万", "50万", "120万", "11万")
(salary0 = gsub("万", "0000", salary))
##  [1] "220000"  "300000"  "500000"  "1200000" "110000"
mean(as.numeric(salary0))
##  [1] 466000
median(as.numeric(salary0))  # 结果是科学计数法的形式
##  [1] 3e+05
```


## 矩阵
R 语言为线性代数的研究提供了矩阵类型，这种数据结构很类似于其它语言中的二维数组，但 R 提供了语言级的矩阵运算支持。  
矩阵里的元素可以是数字、符号或数学式，但是一个矩阵里的每个元素必须是同一种数据类型。  
R 语言的矩阵可以使用 matrix() 函数来创建，语法格式如下：
```R
matrix(data = NA, nrow = 1, ncol = 1, byrow = FALSE,dimnames = NULL)
# 参数说明：
# data 向量，矩阵的数据
# nrow 行数
# ncol 列数
# byrow 逻辑值，为 FALSE 按列排列，为 TRUE 按行排列
# dimname 设置行和列的名称
```

+ 矩阵的生成
```R
> vector=c(1, 2, 3, 4, 5, 6)
> matrix(vector, 2, 3)
     [,1] [,2] [,3]
[1,]    1    3    5
[2,]    2    4    6

# 向量中的值会一列一列的填充到矩阵中。如果想按行填充，需要指定 byrow 属性：
> m1 = matrix(vector, 2, 3, byrow=TRUE)
     [,1] [,2] [,3]
[1,]    1    2    3
[2,]    4    5    6

# 生成一个对角全是1的矩阵,直接在diag中输入对角线向量即可
dig = diag(rep(1, 4))
##       [,1] [,2] [,3] [,4]
##  [1,]    1    0    0    0
##  [2,]    0    1    0    0
##  [3,]    0    0    1    0
##  [4,]    0    0    0    1
# 向量可变
N = diag(1:4)
##       [,1] [,2] [,3] [,4]
##  [1,]    1    0    0    0
##  [2,]    0    2    0    0
##  [3,]    0    0    3    0
##  [4,]    0    0    0    4
```

+ 行列名称设定
```R
矩阵每一个列和每一行都可以设定名称，这个过程通过字符串向量批量完成
> colnames(m1) = c("x", "y", "z")
> rownames(m1) = c("a", "b")
> m1
  x y z
a 1 2 3
b 4 5 6
```

+ 矩阵的每一行或每一列当作向量来进行操作

```R
# apply() 函数
> (A = matrix(c(1, 3, 2, 4), 2, 2))
     [,1] [,2]
[1,]    1    2
[2,]    3    4
> apply(A, 1, sum) # 第二个参数为 1 按行操作，用 sum() 函数
[1] 3 7
> apply(A, 2, sum) # 第二个参数为 2 按列操作
[1] 4 6
```

+ 转置矩阵
R 语言矩阵提供了 t() 函数，可以实现矩阵的行列互换。

矩阵的常用操作
```R
# 查看矩阵的维度
dim(M) 
##  [1] 3 4
# 提取矩阵的行数
nrow(M) 
##  [1] 3
# 提取矩阵的列数
ncol(M)
##  [1] 4
```

## 列表

+ 创建列表
```R
list_data <- list("runoob", "google", c(11,22,33), 123, 51.23, 119.1)
```

+ 列表的元素命名
```R
# 列表包含向量、矩阵、列表
list_data <- list(c("Google","Runoob","Taobao"), matrix(c(1,2,3,4,5,6), nrow = 2),
   list("runoob",12.3))

# 给列表元素设置名字
names(list_data) <- c("Sites", "Numbers", "Lists")
```
+ 列表访问
```R
# 访问列表的第三个元素
print(list_data[3])

# 访问第一个向量元素
print(list_data$Numbers)
```

+ 操作列表元素
```R
# 添加元素
list_data[4] <- "新元素"
print(list_data[4])

# 删除元素
list_data[4] <- NULL

# 更新元素
list_data[3] <- "我替换来第三个元素"
print(list_data[3])
```
+ 合并列表
```R
# 用 c() 函数将多个列表合并为一个列表：
# 创建两个列表
list1 <- list(1,2,3)
list2 <- list("Google","Runoob","Taobao")

# 合并列表
merged.list <- c(list1,list2)
```
+ 列表转换为向量
```R
# 用 unlist() 函数，将列表转换为向量，可以方便我们进行算术运算
# 创建列表
list1 <- list(1:5)
# 转换为向量
v1 <- unlist(list1)
```

## 数组
R 数组
数组也是 R 语言的对象，R 语言可以创建一维或多维数组。R 语言数组是一个同一类型的集合，前面我们学的矩阵 matrix 其实就是一个二维数组。  
向量、矩阵、数组关系可以看下图：
![](https://www.runoob.com/wp-content/uploads/2020/07/2039-08-06Done.png)

R 语言数组创建使用 array() 函数，该函数使用向量作为输入参数，可以使用 dim 设置数组维度。  
array() 函数语法格式如下：
```R
array(data = NA, dim = length(data), dimnames = NULL)
# 参数说明：
# data 向量，数组元素。
# dim 数组的维度，默认是一维数组。
# dimnames 维度的名称，必须是个列表，默认情况下是不设置名称的。
```
```R
# 创建两个不同长度的向量
vector1 <- c(5,9,3)
vector2 <- c(10,11,12,13,14,15)
column.names <- c("COL1","COL2","COL3")
row.names <- c("ROW1","ROW2","ROW3")
matrix.names <- c("Matrix1","Matrix2")

# 创建数组，并设置各个维度的名称
result <- array(c(vector1,vector2),dim = c(3,3,2),dimnames = list(row.names,column.names,matrix.names))
print(result)

# 结果为
, , Matrix1

     COL1 COL2 COL3
ROW1    5   10   13
ROW2    9   11   14
ROW3    3   12   15

, , Matrix2

     COL1 COL2 COL3
ROW1    5   10   13
ROW2    9   11   14
ROW3    3   12   15
```

## 因子
因子用于存储不同类别的数据类型，例如人的性别有男和女两个类别，年龄来分可以有未成年人和成年人。  
R 语言创建因子使用 factor() 函数，向量作为输入参数。  
factor() 函数语法格式：
```R
factor(x = character(), levels, labels = levels,
       exclude = NA, ordered = is.ordered(x), nmax = NA)
# 参数说明：
# x：向量。
# levels：指定各水平值, 不指定时由x的不同值来求得。
# labels：水平的标签, 不指定时用各水平值的对应字符串。
# exclude：排除的字符。
# ordered：逻辑值，用于指定水平是否有序。
# nmax：水平的上限数量。
```

```R
x <- c("男", "女", "男", "男",  "女",levels=c('男','女'))
sex <- factor(x)
print(sex)
print(is.factor(sex))

# 结果为
levels1 levels2 
男      女      男      男      女      男      女 
Levels: 男 女
[1] TRUE
```

+ 因子水平标签
labels 参数为每个因子水平添加标签，labels 参数的字符顺序，要和 levels 参数的字符顺序保持一致，例如：
```R
sex=factor(c('f','m','f','f','m'),levels=c('f','m'),labels=c('female','male'),ordered=TRUE)
print(sex)
执行以上代码输出结果为：
female male   female female male  
Levels: female < male
```

## 数据框
数据框（Data frame）可以理解成我们常说的"表格"。数据框是 R 语言的数据结构，是特殊的二维列表。数据框每一列都有一个唯一的列名，长度都是相等的，同一列的数据类型需要一致，不同列的数据类型可以不一样。
![](https://static.runoob.com/images/mix/data-frame.svg)

R 语言数据框使用 data.frame() 函数来创建，语法格式如下：
```R
data.frame(…, row.names = NULL, check.rows = FALSE,
           check.names = TRUE, fix.empty.names = TRUE,
           stringsAsFactors = default.stringsAsFactors())

# …: 列向量，可以是任何类型（字符型、数值型、逻辑型），一般以 tag = value 的形式表示，也可以是 value。
# row.names: 行名，默认为 NULL，可以设置为单个数字、字符串或字符串和数字的向量。
# check.rows: 检测行的名称和长度是否一致。
# check.names: 检测数据框的变量名是否合法。
# fix.empty.names: 设置未命名的参数是否自动设置名字。
# stringsAsFactors: 布尔值，字符是否转换为因子，factory-fresh 的默认值是 TRUE，可以通过设置选项（stringsAsFactors=FALSE）来修改。
```

```R
table = data.frame(
    姓名 = c("张三", "李四"),
    工号 = c("001","002"),
    月薪 = c(1000, 2000)   
)

print(table) # 查看 table 数据

# 获取数据结构
str(table)
# 结果
'data.frame':   2 obs. of  3 variables:
 $ 姓名: chr  "张三" "李四"
 $ 工号: chr  "001" "002"
 $ 月薪: num  1000 2000
 
# 提取指定的列
result <- data.frame(table$姓名,table$月薪)

# 提取前面两行
result <- table[1:2,]

```

+ 拓展数据框
	+ 单纯添加一列
```R
# 添加部门列
table$部门 <- c("运营","技术","编辑")
```

### 数据框行名、列名的创建、选取与修改
当用向量建立数据框时，向量名被默认作为数据框的列名。当用矩阵建立数据框时，矩阵列名也会默认作为数据框列名。如果数据框没有指定列名，则列名默认为“V1”、“V2”…，如果数据框没有指定行名，则行名默认为“1”、“2”、“3”…。获取数据框列名，可用names函数或colnames函数。获取数据框行名，可用row.names函数或rownames函数，对数据框来说，row.names函数效率更高，因而推荐使用row.names函数。

### 数据框的拼接与合并
+ cbind() 函数将多个向量合成一个数据框,左右合并
```R
name <- c("Alice","Bob","Christien")
age <- c(10,20,14)
gender <- c("F","M","F")
weight <- c(25,50,30)
df1 <- data.frame(name,age,gender,weight) # 注意此处字符串会转化为因子型
nationality <- c("USA","UK","China")
height <- c(1.2,1.65,1.43)
df2 <- data.frame(nationality,height)
df3 <- cbind(df1,df2)
df4 <- data.frame(nationality,height,age=age[c(3,2,1)])
df5 <- cbind(df1,df4)
df6 <- data.frame(nationality,height,age)
df7 <- cbind(df1,df6)

df8 <- merge(df1,df6)
df9 <- merge(df1,df4)
```
+ rbind() 函数多个向量合成一个数据框,上下合并
```R
name <- c("Alice","Bob","Christien")
age <- c(10,20,14)
gender <- c("F","M","F")
weight <- c(25,50,30)
df1 <- data.frame(name,age,gender,weight) # 注意此处字符串会转化为因子型
df2 <- data.frame(age=24,gender="F",name="Dora",weight=55)
df3 <- rbind(df1,df2)
df4 <- data.frame(age=25,name="Einstein",weight=54)
# df5 <- rbind(df3,df4) # 列数不一致，报错
df4$gender <- NA
df5 <- rbind(df3,df4)

```

### 数据框的排序
如果需要根据一列或多列的顺序，对其他列做相应的调整，可以使用order函数。如果需要将所有列都按降序排序，则增加decreasing = TRUE参数。如果大多数升序，某些降序，在降序的列前加-rank函数（如果是数值型，仅加负号就可以）。如果大多数降序，某些升序，在升序前加-rank函数函数，且添加decreasing = TRUE参数。下面是一些列子：
```R
name <- c("Alice","Bob","Christien","Einstein")
age <- c(10,20,14,25)
gender <- c("F","M","F","M")
weight <- c(25,50,30,54)
nationality <- c("USA","UK","China","German")
height <- c(1.2,1.65,1.43,1.75)
df <- data.frame(name,age,gender,weight,nationality,height)
df2 <- df[order(df$gender,df$weight,decreasing = TRUE),]
df3 <- df[order(-rank(df$gender),df$weight),]
df4 <- df[order(df$gender,-df$weight),]
```





