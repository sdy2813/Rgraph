p1_1 <- ggscatterhist(
  coverage, x = "CT", y = "Coverage",
  color = "Stype",shape = "Stype", 
  size = 3, alpha = 0.6,
  add = "reg.line",
  palette = "jama",#杂志lancet的配色
  #ellipse = TRUE,
  margin.plot = "boxplot",
  #star.plot = TRUE,
  legend.title = "Sample Type",
  xlab = "Cycle Threshold Value",
  ylab = "Coverage",
  ggtheme = theme_bw()
)
