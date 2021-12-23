# Data
set.seed(5)
x <- c(rnorm(200, mean = -2, 1.5),
       rnorm(200, mean = 0, sd = 1),
       rnorm(200, mean = 2, 1.5))
group <- c(rep("A", 200), rep("B", 200), rep("C", 200))
df <- data.frame(x, group)

# install.packages("ggplot2")
library(ggplot2)

cols <- c("#F76D5E", "#FFFFBF", "#72D8FF")

# Basic density plot in ggplot2
ggplot(df, aes(x = x, fill = group)) +
  geom_density(alpha = 0.7, color = NA) + 
  scale_fill_manual(values = cols)
