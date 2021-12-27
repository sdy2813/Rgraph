# R 基本操作之ggplot2

## R包的安装
```R
install.packages("ggplot2")
```

绘图之前分清数据里哪些是定量变量，哪些是定性变量。

## 入门函数qplot
### 1 qplot函数参数
qplot 即“快速作图”（quick plot），顾名思义，能快速对数据进行可视化分析。它的用法和R base包的plot函数很相似，主要作用是让读者/用户在不知不觉中洗脑。先看看它的参数：

```R
qplot(x, y = NULL, ..., data, facets = NULL,
      margins = FALSE, geom = "auto", stat = list(NULL),
      position = list(NULL), xlim = c(NA, NA),
      ylim = c(NA, NA), log = "", main = NULL,
      xlab = deparse(substitute(x)),
      ylab = deparse(substitute(y)), asp = NA)

# x, y： 意义明确，不用说了
# data： 这个可以有，为数据框（data.frame）类型；如果有这个参数，那么x，y的名称必需对应数据框中某列变量的名称
# facets： 图形/数据的分面。这是ggplot2作图比较特殊的一个概念，它把数据按某种规则进行分类，每一类数据做一个图形，所以最终效果就是一页多图
# margins： 是否显示边界
# geom： 图形的几何类型（geometry），这又是ggplot2的作图概念。ggplot2用几何类型表示图形类别，比如point表示散点图、line表示曲线图、bar表示柱形图等。
# stat： 统计类型（statistics），这个更加特殊。直接将数据统计和图形结合，这是ggplot2强大和受欢迎的原因之一。
# position： 图形或者数据的位置调整，这不算太特殊，但对于图形但外观很重要
# xlim, ylim, xlab, ylab, asp： 初步可以按照plot函数的相应参数来理解

```

### 2 qplot做散点图

#### 2.1 使用向量数据
和plot函数一样，如果不指定图形的类型，qplot默认做出散点图。对于给定的x和y向量做散点图，qplot用法也和plot函数差不多：
```
library(ggplot2)
x <- 1:1000
y <- rnorm(1000)
plot(x, y, main="Scatter plot by plot()")
qplot(x,y, main="Scatter plot by qplot()")

```
#### 2.2 使用数据框数据
使用数据框有几个好处：数据框可以用来存储数值、字符串、因子等不同类型等数据；把数据放在同一个R数据框对象中可以避免使用过程中数据关系的混乱；数据外观的整理和转换方便。ggplot2中使用数据框作图的最直接的一个效果就是：你可以直接用数据的分类特性（数据框中的列变量）来决定图形元素的外观，这个过程在ggplot2中称为映射（mapping），是自动的。

在演示使用数据框作图的好处之前我们先了解以下ggplot2提供的一组有关钻石的示范数据 diamonds
```R
> diamonds
# A tibble: 53,940 x 10
   carat cut       color clarity depth table price     x     y     z
   <dbl> <ord>     <ord> <ord>   <dbl> <dbl> <int> <dbl> <dbl> <dbl>
 1 0.23  Ideal     E     SI2      61.5    55   326  3.95  3.98  2.43
 2 0.21  Premium   E     SI1      59.8    61   326  3.89  3.84  2.31
 3 0.23  Good      E     VS1      56.9    65   327  4.05  4.07  2.31
 4 0.290 Premium   I     VS2      62.4    58   334  4.2   4.23  2.63
 5 0.31  Good      J     SI2      63.3    58   335  4.34  4.35  2.75
 6 0.24  Very Good J     VVS2     62.8    57   336  3.94  3.96  2.48
 7 0.24  Very Good I     VVS1     62.3    57   336  3.95  3.98  2.47
 8 0.26  Very Good H     SI1      61.9    55   337  4.07  4.11  2.53
 9 0.22  Fair      E     VS2      65.1    61   337  3.87  3.78  2.49
10 0.23  Very Good H     VS1      59.4    61   338  4     4.05  2.39
```
这是数据框（data.frame）类型，有10个变量（列），每个变量有53940个测量值（行）。第一列为钻石的克拉数（carat），为数字型数据；第二列为钻石的切工好坏（cut），为因子类型数据，有5个水平；第三列为钻石颜色（color），为7水平的因子；后面还有其他数据。

如果要做钻石克拉和价格关系的曲线图，用plot和qplot函数都差不多：
```R
plot(x=diamonds$carat, y=diamonds$price, xlab="Carat", ylab="Price", main="plot function")
qplot(x=carat, y=price, data=datax, xlab="Carat", ylab="Price", main="qplot function")
```

用ggplot2作图你需要考虑数据分类和图形元素方面的问题就很少，你只要告诉它用做分类的数据就可以了：
```
theme_set(theme_bw())   # 如果不喜欢它默认的图形背景，要改变也相当简单，ggplot2预置了几个模板
qplot(x=carat, y=price, data=datax, color=cut, shape=cut, main="qplot function")
# 数据框可以存储不同的数据，而这些数据是有类型差别的。ggplot2作图对各类数据的要求也非常严格，用于分类的数据必需是因子类型，否则就出错.
```

### 3 qplot做曲线图

和plot函数一样，qplot也可以通过设置合适的参数产生曲线图，这个参数就是geom（几何类型）。图形的组合非常直接，组合表示几何类型的向量即可：
```R
qplot(x=carat, y=price, data=datax, color=cut, geom="line", main="geom=\"line\"")
qplot(x=carat, y=price, data=datax, color=cut, geom=c("line", "point"), main="geom=c(\"line\", \"point\")")
```

### 4 qplot做统计图
qplot是名副其实的qplot（quick plot）函数，通过改变几何类型geom参数的值你可以获得各种图形。geom参数可以设置的值和意义是：

+ point：散点图
+ line：曲线图
+ smooth：平滑曲线
+ jitter：另一种散点图
+ boxplot：箱线图
+ histogram：直方图
+ density：密度分布图
+ bar：柱状图

前两种我们看过了，bar类型下面另讲，jitter以后有机会再说，看看其他4种类型：
```R
qplot(carat, price, data = diamonds, color=cut, geom = "smooth", main = "smooth")
qplot(cut, price, data = diamonds, fill=cut, geom = "boxplot", main = "boxplot")
qplot(price, data = diamonds, fill=cut, geom = "histogram", main = "histogram")
qplot(price, data = diamonds, color=cut, geom = "density", main = "density")
```













