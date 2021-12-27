# R包

包是 R 函数、实例数据、预编译代码的集合，包括 R 程序，注释文档、实例、测试数据等。

R 语言相关的包一般存储安装目录下对 "library" 目录，默认情况在 R 语言安装完成已经自带来一些常用对包，当然我们也可以在后期自定义添加一些要使用的包。

## 查看 R 包的安装目录
```R
> .libPaths()
[1] "/Library/Frameworks/R.framework/Versions/4.0/Resources/library"
```


## 查看已安装的包
```R
library()
```

## 查看已载入的包

```R
search()
```

## 安装新包

```R
install.packages("要安装的包名")
```

## 使用包
```R
library("包名")
```

## 更新R
install.packages("installr")
require(installr)
updateR()







