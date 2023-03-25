setwd("~/Desktop/")

library("reshape2")
library("ComplexHeatmap")
library("gplots")

### get data, convert to matrix
ani <- read.table("ani_0325")
ani_matrix <- acast(ani, V1~V2, value.var="V3")
ani_matrix[is.na(ani_matrix)] <- 70

### define the colors within 2 zones
ani_breaks = seq(min(ani_matrix), max(100), length.out=100)
gradient1 = colorpanel( sum( ani_breaks[-1]<=99.8 ), "red", "white" )
gradient2 = colorpanel( sum( ani_breaks[-1]>99.8 & ani_breaks[-1]<=100), "white", "blue" )

hm.colors = c(gradient1, gradient2)
heatmap.2(ani_matrix, scale = "none", trace = "none", col = hm.colors, cexRow=0.9, cexCol=0.85)

min(ani_matrix)
max(ani_matrix)
