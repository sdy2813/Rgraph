library(gghighlight)
library(ggplot2)
set.seed(1234)
year <- rep(1990:2015, times = 2)
type <- rep(c('A','B'),each = 26)
value <- c(runif(26),runif(26, min = 1,max = 1.5))
df <- data.frame(year = year, type = type, value = value)
ggplot(data = df, mapping = aes(x = year, y = value, colour = type)) + geom_line()

df %>% ggplot(
  aes(x = year, y = value, color = type)) +
  geom_line() +
  geom_point() +
  gghighlight::gghighlight()

