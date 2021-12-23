warpbreaks

# install.packages("ggplot2")
library(ggplot2)

ggplot(warpbreaks, aes(x = tension, y = breaks, fill = tension)) +
  geom_violin(trim = FALSE,alpha = 0.5) + 
  geom_boxplot(width = 0.07) +
  guides(fill = guide_legend(title = "Title")) +
  scale_fill_hue(labels = c("G1", "G2", "G3")) + 
  theme(legend.position = "none") # remove legend
