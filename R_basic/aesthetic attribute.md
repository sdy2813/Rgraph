# 图形部件
一张统计图形就是从数据到几何形状(geometric object，缩写geom)所包含的图形属性(aesthetic attribute，缩写aes)的一种映射。

1. data: 数据框data.frame (注意，不支持向量vector和列表list类型）

2. aes: 数据框中的数据变量映射到图形属性。什么叫图形属性？就是图中点的位置、形状，大小，颜色等眼睛能看到的东西。什么叫映射？就是一种对应关系，比如数学中的函数b = f(a)就是a和b之间的一种映射关系, a的值决定或者控制了b的值，在ggplot2语法里，a就是我们输入的数据变量，b就是图形属性， 这些图形属性包括：

+ x（x轴方向的位置）
+ y（y轴方向的位置）
+ color（点或者线等元素的颜色）
+ size（点或者线等元素的大小）
+ shape（点或者线等元素的形状）
+ alpha（点或者线等元素的透明度）

3. geoms: 几何形状，确定我们想画什么样的图，一个geom_***确定一种形状。更多几何形状推荐阅读这里

+ geom_bar()
+ geom_density()
+ geom_freqpoly()
+ geom_histogram()
+ geom_violin()
+ geom_boxplot()
+ geom_col()
+ geom_point()
+ geom_smooth()
+ geom_tile()
+ geom_density2d()
+ geom_bin2d()
+ geom_hex()
+ geom_count()
+ geom_text()
+ geom_sf()
Source: <a href="https://ggplot2-book.org/individual-geoms.html">ggplot2 book</a>Source: <a href="https://ggplot2-book.org/individual-geoms.html">ggplot2 book</a>Source: <a href="https://ggplot2-book.org/individual-geoms.html">ggplot2 book</a>Source: <a href="https://ggplot2-book.org/individual-geoms.html">ggplot2 book</a>Source: <a href="https://ggplot2-book.org/individual-geoms.html">ggplot2 book</a>Source: <a href="https://ggplot2-book.org/individual-geoms.html">ggplot2 book</a>Source: <a href="https://ggplot2-book.org/individual-geoms.html">ggplot2 book</a>Source: <a href="https://ggplot2-book.org/individual-geoms.html">ggplot2 book</a>
图 22.1: Source: ggplot2 book

4. stats: 统计变换
4. scales: 标度
4. coord: 坐标系统
4. facet: 分面
4. layer： 增加图层
4. theme: 主题风格
4. save: 保存图片
