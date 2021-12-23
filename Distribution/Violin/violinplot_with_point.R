library(ggplot2)
library(ggbeeswarm)

# Sample data set
df <- ToothGrowth
df$dose <- as.factor(df$dose)

ggplot(df, aes(x = dose, y = len, fill = dose)) +
  geom_violin(alpha = 0.5) +
  geom_jitter(position = position_jitter(seed = 1, width = 0.2)) +
  theme(legend.position = "none")

ggplot(df, aes(x = dose, y = len, fill = dose)) +
  geom_violin(alpha = 0.5) +
  geom_dotplot(binaxis = "y",
               stackdir = "center",
               dotsize = 0.5) +
  theme(legend.position = "none")

ggplot(df, aes(x = dose, y = len, fill = dose)) +
  geom_violin(alpha = 0.5) +
  geom_quasirandom() +
  theme(legend.position = "none")
