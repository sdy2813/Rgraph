# R初学习

R 语言是为数学研究工作者设计的一种数学编程语言，主要用于统计分析、绘图、数据挖掘。  
R 语言与 C 语言都是贝尔实验室的研究成果，但两者有不同的侧重领域，R 语言是一种解释型的面向数学理论研究工作者的语言，而 C 语言是为计算机软件工程师设计的。  
R 语言是解释运行的语言（与 C 语言的编译运行不同），它的执行速度比 C 语言慢得多，不利于优化。但它在语法层面提供了更加丰富的数据结构操作并且能够十分方便地输出文字和图形信息，所以它广泛应用于数学尤其是统计学领域。

+ R 语言特点
	+ R 语言环境软件属于 GNU 开源软件，兼容性好、使用免费
	+ 语法十分有利于复杂的数学运算
	+ 数据类型丰富，包括向量、矩阵、因子、数据集等常用数据结构
	+ 代码风格好，可读性强

+ 变量
R 语言的有效的变量名称由字母，数字以及点号 . 或下划线 _ 组成，变量名称不得以数字开头。

## 基本操作
1.变量赋值
```R
# 注意：R 语言赋值使用的是左箭头 <- 符号，不过一些新版本也支持等号 =。
myString <- "Hello, World!"

# 查看已定义的变量使用 ls() 函数：
print(ls())

# 删除变量使用 rm() 函数：
rm(var.3)
```

2.输入输出
+ print() 输出
```R
# print() 是 R 语言的输出函数。
print("RUNOOB")
print(123)
```

+ cat() 函数
```R
# 输出结果的拼接使用 cat() 函数
print("RUNOOB")
cat(1, "加", 1, "等于", 2, '\n') 	# 1 加 1 等于 2
```

+ 输出内容到文件
```R
# cat() 函数支持直接输出结果到文件
# 这个语句不会在控制台产生结果，而是把 "RUNOOB" 输出到 "/Users/runoob/runoob-test/r_test.txt" 文件中去。file 参数可以是绝对路径或相对路径，建议使用绝对路径，
cat("RUNOOB", file="/Users/runoob/runoob-test/r_test.txt")
cat("RUNOOB", file="D:\\r_test.txt")
# 注意：这个操作是"覆盖写入"操作，请谨慎使用，因为它会将输出文件的原有数据清除。如果想"追加写入"，请不要忘记设置 append 参数：
cat("GOOGLE", file="/Users/runoob/runoob-test/r_test.txt", append=TRUE)

# sink() 函数可以把控制台输出的文字直接输出到文件中去：
# 注意：这个操作也是"覆盖写入"操作，会直接清除原有的文件内容。如果我们依然像保留控制台的输出，可以设置 split 属性：
sink("/Users/runoob/runoob-test/r_test.txt", split=TRUE)

# 如果想取消输出到文件，可以调用无参数的 sink ：
sink()
```

+ 从文件读入文字
```R
# 如果纯粹的想将某个文件中的内容读取为字符串，可以使用 readLines 函数：
readLines("/Users/runoob/runoob-test/r_test.txt")
# 注意：所读取的文本文件每一行 (包括最后一行) 的结束必须有换行符，否则会报错。
```

3.工作目录
```R
# 当前工作目录
print(getwd())

# 设置当前工作目录
setwd("/Users/runoob/runoob-test2")
```

## 常用数学函数
![](https://bookdown.org/xiao/RAnalysisBook/mathfunc1.png)
![](https://bookdown.org/xiao/RAnalysisBook/mathfunc2.png)

## 常用统计函数
![](https://bookdown.org/xiao/RAnalysisBook/stasfunc.png)


## 数据类型
数据类型指的是用于声明不同类型的变量或函数的一个广泛的系统。变量的类型决定了变量存储占用的空间，以及如何解释存储的位模式。
R 里的数据类型有数值型（numeric），复数型（complex），字符型（character）以及逻辑型（logical）。还有两种特殊的数据：数据的缺失（NA）和数据的未知状态（NULL）。
+ 数值型
	+ 一般型：123 -0.125
	+ 科学计数法：1.23e2 -1.25E-1
+ 逻辑  
逻辑类型在许多其他编程语言中常称为布尔型（Boolean），常量值只有 TRUE 和 FALSE。
注意：R 语言区分大小写，true 或 True 不能代表 TRUE。

+ 字符型  
最直观的数据类型就是文本类型。文本就是其它语言中常出现的字符串（String），常量用双引号包含。在 R 语言中，文本常量既可以用单引号包含，也可以用双引号包含，

+ 数据类型查看
```R
class(x)
```

常见数据类型
数据类型	|英文名称	|例子
:--:|:--:|:--:
整数	|integer	|1L -3L
浮点数	|double	|3.14 -5.1e-3
复数	|complex	|1+1i 2.4-5.6i
字符串	|character	|"Hello World!" 'a'
逻辑值	|logical	|TRUE FALSE

下面介绍几个相关的概念：

+ 模式（mode）：数据的模式与类型（type）非常像，典型的差异仅仅为，将整数型"integer"和浮点型"double"统称为数值型"numeric"。用mode函数可以识别变量的模式。

+ 类（class）：任意一个R对象（object）都可以被赋予一个类的属性（attribute），如果在被幅值时没有被指定，则有一个默认的类，包括矩阵"matrix"、数组"array"、 函数"function"或mode返回的结果。用class函数可以识别变量的类。

+ 结构（structure）：数据的结构是单个数据元素组合在一起的形式，常见的数据结构包括向量（vector）、列表（list）、矩阵（matrix）、数据框（data.frame）、数组（array）、时间格式（POSIXlt与POSIXlt）等，用函数str可查看数据的结构。我们将在下一章介绍对不同数据结构的操纵。

## Rstudio 中常用快捷键
+ 脚本编辑窗口：
	+ 新建脚本：Ctrl+Shift+N
	+ 代码提示与补全：Tab
	+ 注释或取消注释：Ctrl+Shift+C
	+ 运行所选代码：Ctrl+Enter
	+ 运行全部代码：Ctrl+Shift+Enter
	+ 全选：Ctrl+A
	+ 选择：Shift+箭头
	+ 删除行：Ctrl+D
	+ 撤销：Ctrl+Z
	+ 重做：Ctrl+Shift+Z
	+ 赋值符：Alt+-
	+ 代码折叠：Alt+L
	+ 代码展开：Shift+Alt+L
	+ 保存本脚本：Ctrl+S
	+ 保存全部脚本：Ctrl+Alt+S
	+ 增加缩进：选中代码后，Tab（可包括多行）
	+ 减小缩进：选中代码后，Shift+Tab
	+ 智能缩进：选中代码后，Ctrl+I
	+ 智能缩进加智能空格：Ctrl+Shift+A（更高级的代码格式规范化工具，可参考formatR包）
	+ 选择与替换：Ctrl+F
	+ 提取函数：Ctrl+Alt+X（RStudio 可以分析某一代码段，并自动将其转换成一个可重复使用的函数。任何在选择的代码内的“自由的”变量，即那些被引用但没有被创建的变量，将被转化为函数的参数）
+ 命令窗口中：
	+ 历史中的上一条命令：向上箭头
	+ 历史中的下一条命令：向下箭头
	+ 中断运行的代码：Esc
	+ 清除命令窗口中的内容：Ctrl+L













