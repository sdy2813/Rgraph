set.seed(3)
x1 <- rnorm(200)
x2 <- rnorm(200, mean = 3)
x <- c(x1, x2)
group <- c(rep("G1", 200), rep("G2", 200))

df <- data.frame(x, group = group)

# install.packages("ggplot2")
library(ggplot2)

# Histogram by group in ggplot2
ggplot(df, aes(x = x, fill = group, colour = group)) + 
  geom_histogram(alpha = 0.5, position = "identity") 

# Histogram by group in ggplot2
ggplot(df, aes(x = x, fill = group, colour = group)) + 
  geom_histogram(alpha = 0.5, position = "dodge")
