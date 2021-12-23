# install.packages("ggplot2")
library(ggplot2)

# Data
set.seed(8)
y <- rnorm(200)
group <- sample(LETTERS[1:3], size = 200,
                replace = TRUE)
df <- data.frame(y, group)

# Box plot by group with jitter
ggplot(df, aes(x = group, y = y, colour = group)) + 
  geom_boxplot(outlier.shape = NA) +
  geom_jitter() 

# Box plot by group with jitter
ggplot(df, aes(x = group, y = y,
               colour = group,
               shape = group)) + 
  geom_boxplot(outlier.shape = NA) +
  geom_jitter()
