setwd("/home/sdy/Desktop/酉鸡肠道微生物/slide/photo/alpha/")
library(ggplot2)
library(ggsci)
library(ggsignif)
library(dplyr)  
library(reshape2)
library(ggpubr)

alpha_h <- read.table("alpha_index_h.tsv",sep = "\t",header = T)

alpha_h_1 <- melt(alpha_h,id="index")
alpha_h_1$Group <- c(rep("HZ1",24),rep("HZ2",20),rep("HD1",24),rep("HD2",24),rep("HC",24))
my_comparisons <- list(c("HZ1", "HC"),c("HZ2", "HC"),c("HD1", "HC"),c("HD2", "HC"),c("HD1", "HD2"),c("HZ1", "HZ2"))

p <- ggplot(data = alpha_h_1, aes(x = Group, y = value, color = Group)) +
  geom_boxplot(outlier.size = 1) +
  geom_jitter(aes(x = Group, y = value, color = Group),
              position = position_jitterdodge(), alpha = 0.4)+
  scale_color_jama()+
  facet_wrap(~index, 2, scales = 'free', ncol = 2)+
  theme_minimal()+
  theme(panel.grid = element_blank(), panel.background = element_rect(fill = 'transparent', color = 'black'), legend.title = element_blank(), legend.key = element_blank()) +
  labs(x = '', y = '')+
  geom_signif(comparisons = my_comparisons,step_increase = 0.1,
              map_signif_level = F,test = t.test,
              tip_length = c(0),color = "black",size = 0.5)

p

###

alpha_m <- read.table("alpha_index_m.tsv",sep = "\t",header = T)

alpha_m_1 <- melt(alpha_m,id="index")
alpha_m_1$Group <- c(rep("MZ1",24),rep("MZ2",20),rep("MD1",20),rep("MD2",24),rep("MC",24))
my_comparisons <- list(c("MZ1", "MC"),c("MZ2", "MC"),c("MD1", "MC"),c("MD2", "MC"),c("MD1", "MD2"),c("MZ1", "MZ2"))

p <- ggplot(data = alpha_m_1, aes(x = Group, y = value, color = Group)) +
  geom_boxplot(outlier.size = 1) +
  geom_jitter(aes(x = Group, y = value, color = Group),
              position = position_jitterdodge(), alpha = 0.4)+
  scale_color_jama()+
  facet_wrap(~index, 2, scales = 'free', ncol = 2)+
  theme_minimal()+
  theme(panel.grid = element_blank(), panel.background = element_rect(fill = 'transparent', color = 'black'), legend.title = element_blank(), legend.key = element_blank()) +
  labs(x = '', y = '')+
  geom_signif(comparisons = my_comparisons,step_increase = 0.1,
              map_signif_level = F,test = t.test,
              tip_length = c(0),color = "black",size = 0.5)

p
