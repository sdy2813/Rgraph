setwd("/data/home/xum/test/mp/circos/mp/")
library(stringr)	#方便处理字符串
library(circlize)	#绘制圈图
library(ComplexHeatmap)	#绘制图例
library(grid)	#组合画板，圈图 + 图例

#指定文件
sample_name <- 'Mycoplasma pneumoniae'	#测序样本名称
ref_name <- 'Mycoplasma pneumoniae M129'	#参考基因组名称

genome_gff <- 'NC_000912.gff3'	#参考基因组 gff 注释文件
genome_gff_1 <- 'Bacillus_subtilis.str168.gff'
snp_vcf <- 'S6_snp.vcf'	#SNP 检测结果 vcf 文件
indel_vcf <- 'S6_indel.vcf'	#InDel 检测结果 vcf 文件
depth_base_stat <- 'S6.depth_gc.txt'	#测序深度、碱基含量统计结果文件
seq_split <- 1000	#滑窗大小，与 depth_base_stat 中使用的滑窗大小对应

out_dir = 'output'	#生成一个目录，用于存放结果文件
if (!file.exists(out_dir)) dir.create(out_dir)

#####################
##参考基因组长度、GC 统计 & 测序覆盖度、深度统计
depth_base <- read.delim(depth_base_stat, stringsAsFactors = FALSE)
depth_base[,(5:9)] <- depth_base[,(5:9)]*100
genome_size <- sum(depth_base$seq_end - depth_base$seq_start + 1) 
genome_GC <- round(mean(depth_base$GC), 2)

depth_exist <- subset(depth_base, depth != 0)
coverage <- round(100 * sum(depth_exist$seq_end - depth_exist$seq_start + 1) / genome_size, 2)
average_depth <- round(mean(depth_base$depth), 0)

seq_stat <- NULL
for (seq_id in unique(depth_base$seq_ID)) seq_stat <- rbind(seq_stat, c(seq_id, 1, max(subset(depth_base, seq_ID == seq_id)$seq_end)))
seq_stat <- data.frame(seq_stat, stringsAsFactors = FALSE)
colnames(seq_stat) <- c('seq_ID', 'seq_start', 'seq_end')
rownames(seq_stat) <- seq_stat$seq_ID
seq_stat$seq_start <- as.numeric(seq_stat$seq_start)
seq_stat$seq_end <- as.numeric(seq_stat$seq_end)

write.table(seq_stat, str_c(out_dir, '/', sample_name, '.genome_stat.txt'), row.names = FALSE, sep = '\t', quote = FALSE)

##参考基因组基因信息，CDS & rRNA & tRNA
gene <- read.delim(genome_gff, header = FALSE, stringsAsFactors = FALSE, comment.char = '#')[c(1, 3, 4, 5, 7)]
gene <- subset(gene, V3 %in% c('CDS', 'rRNA', 'tRNA'))[c(1, 3, 4, 2, 5)]
names(gene) <- c('seq_ID', 'seq_start', 'seq_end', 'type', 'strand')

gene[which(gene$type == 'CDS'),'type'] <- 1
gene[which(gene$type == 'rRNA'),'type'] <- 2
gene[which(gene$type == 'tRNA'),'type'] <- 3
gene$type <- as.numeric(gene$type)
gene$type[11] <- 2
gene <- list(subset(gene, strand == '-')[-5], subset(gene, strand == '+')[-5])


##参考基因组基因信息，CDS & rRNA & tRNA
gene_1 <- read.delim(genome_gff_1, header = FALSE, stringsAsFactors = FALSE, comment.char = '#')[c(1, 3, 4, 5, 7)]
gene_1 <- subset(gene_1, V3 %in% c('CDS', 'rRNA', 'tRNA'))[c(1, 3, 4, 2, 5)]
names(gene_1) <- c('seq_ID', 'seq_start', 'seq_end', 'type', 'strand')

gene_1[which(gene_1$type == 'CDS'),'type'] <- 1
gene_1[which(gene_1$type == 'rRNA'),'type'] <- 2
gene_1[which(gene_1$type == 'tRNA'),'type'] <- 3
gene_1$type <- as.numeric(gene_1$type)
gene_1 <- list(subset(gene_1, strand == '-')[-5], subset(gene_1, strand == '+')[-5])



##读取 SNP 检测结果
#读取 vcf 文件，统计 SNP 类型
snp <- read.delim(snp_vcf, header = FALSE, colClasses = 'character', comment.char = '#')[c(1, 2, 4, 5)]
snp$V2 <- as.numeric(snp$V2)
snp$change <- str_c(snp$V4, snp$V5)

change <- which(snp$change == 'AT')
snp[change,'type1'] <- 'A>T|T>A'; snp[change,'type2'] <- 'tv'
change <- which(snp$change == 'AG')
snp[change,'type1'] <- 'A>G|T>C'; snp[change,'type2'] <- 'ti'
change <- which(snp$change == 'AC')
snp[change,'type1'] <- 'A>C|T>G'; snp[change,'type2'] <- 'tv'

change <- which(snp$change == 'TA')
snp[change,'type1'] <- 'A>T|T>A'; snp[change,'type2'] <- 'tv'
change <- which(snp$change == 'TG')
snp[change,'type1'] <- 'A>C|T>G'; snp[change,'type2'] <- 'tv'
change <- which(snp$change == 'TC')
snp[change,'type1'] <- 'A>G|T>C'; snp[change,'type2'] <- 'ti'

change <- which(snp$change == 'GA')
snp[change,'type1'] <- 'G>A|C>T'; snp[change,'type2'] <- 'ti'
change <- which(snp$change == 'GT')
snp[change,'type1'] <- 'G>T|C>A'; snp[change,'type2'] <- 'tv'
change <- which(snp$change == 'GC')
snp[change,'type1'] <- 'G>C|C>G'; snp[change,'type2'] <- 'tv'

change <- which(snp$change == 'CA')
snp[change,'type1'] <- 'G>T|C>A'; snp[change,'type2'] <- 'tv'
change <- which(snp$change == 'CT')
snp[change,'type1'] <- 'G>A|C>T'; snp[change,'type2'] <- 'ti'
change <- which(snp$change == 'CG')
snp[change,'type1'] <- 'G>C|C>G'; snp[change,'type2'] <- 'tv'

snp_ti <- length(which(snp$type2 == 'ti'))
snp_tv <- length(which(snp$type2 == 'tv'))

snp_at <- length(which(snp$type1 == 'A>T|T>A'))
snp_ag <- length(which(snp$type1 == 'A>G|T>C'))
snp_ac <- length(which(snp$type1 == 'A>C|T>G'))
snp_ga <- length(which(snp$type1 == 'G>A|C>T'))
snp_gt <- length(which(snp$type1 == 'G>T|C>A'))
snp_gc <- length(which(snp$type1 == 'G>C|C>G'))

#统计 SNP 密度
snp <- snp[c(1, 2, 5, 6, 7)]
colnames(snp)[1:2] <- c('seq_ID', 'seq_site')

snp_stat <- NULL
seq_ID <- unique(snp$seq_ID)

for (seq_ID_n in seq_ID) {
  snp_subset <- subset(snp, seq_ID == seq_ID_n)
  seq_end <- seq_split
  snp_num <- 0
  
  for (i in 1:nrow(snp_subset)) {
    if (snp_subset[i,'seq_site'] <= seq_end) snp_num <- snp_num + 1
    else {
      snp_stat <- rbind(snp_stat, c(seq_ID_n, seq_end - seq_split + 1, seq_end, snp_num))
      
      seq_end <- seq_end + seq_split
      snp_num <- 0
      while (snp_subset[i,'seq_site'] > seq_end) {
        snp_stat <- rbind(snp_stat, c(seq_ID_n, seq_end - seq_split + 1, seq_end, snp_num))
        seq_end <- seq_end + seq_split
      }
      snp_num <- snp_num + 1
    }
  }
  
  while (seq_end < seq_stat[seq_ID_n,'seq_end']) {
    snp_stat <- rbind(snp_stat, c(seq_ID_n, seq_end - seq_split + 1, seq_end, snp_num))
    seq_end <- seq_end + seq_split
    snp_num <- 0
  }
  snp_stat <- rbind(snp_stat, c(seq_ID_n, seq_end - seq_split + 1, seq_stat[seq_ID_n,'seq_end'], snp_num))
}

snp_stat <- data.frame(snp_stat, stringsAsFactors = FALSE)
names(snp_stat) <- c('seq_ID', 'seq_start', 'seq_end', 'snp_num')
snp_stat$seq_start <- as.numeric(snp_stat$seq_start)
snp_stat$seq_end <- as.numeric(snp_stat$seq_end)
snp_stat$snp_num <- as.numeric(snp_stat$snp_num)

write.table(snp_stat, str_c(out_dir, '/', sample_name, '.snp_stat.txt'), row.names = FALSE, sep = '\t', quote = FALSE)

##读取 InDel 检测结果
#读取 vcf 文件，统计 InDel 长度
indel <- read.delim(indel_vcf, header = FALSE, colClasses = 'character', comment.char = '#')[c(1, 2, 4, 5)]
indel$V2 <- as.numeric(indel$V2)
indel$length <- str_length(indel[ ,4]) - str_length(indel[ ,3])
indel_insert <- length(which(indel$length > 0))
indel_delet <- length(which(indel$length < 0))

#统计 InDel 密度
indel <- indel[c(1, 2, 5)]
colnames(indel)[1:2] <- c('seq_ID', 'seq_site')

indel_stat <- NULL
seq_ID <- unique(indel$seq_ID)
for (seq_ID_n in seq_ID) {
  indel_subset <- subset(indel, seq_ID == seq_ID_n)
  seq_end <- seq_split
  indel_num <- 0
  
  for (i in 1:nrow(indel_subset)) {
    if (indel_subset[i,'seq_site'] <= seq_end) indel_num <- indel_num + 1
    else {
      indel_stat <- rbind(indel_stat, c(seq_ID_n, seq_end - seq_split + 1, seq_end, indel_num))
      
      seq_end <- seq_end + seq_split
      indel_num <- 0
      while (indel_subset[i,'seq_site'] > seq_end) {
        indel_stat <- rbind(indel_stat, c(seq_ID_n, seq_end - seq_split + 1, seq_end, indel_num))
        seq_end <- seq_end + seq_split
      }
      indel_num <- indel_num + 1
    }
  }
  
  while (seq_end < seq_stat[seq_ID_n,'seq_end']) {
    indel_stat <- rbind(indel_stat, c(seq_ID_n, seq_end - seq_split + 1, seq_end, indel_num))
    seq_end <- seq_end + seq_split
    indel_num <- 0
  }
  indel_stat <- rbind(indel_stat, c(seq_ID_n, seq_end - seq_split + 1, seq_stat[seq_ID_n,'seq_end'], indel_num))
}

indel_stat <- data.frame(indel_stat, stringsAsFactors = FALSE)
names(indel_stat) <- c('seq_ID', 'seq_start', 'seq_end', 'indel_num')
indel_stat$seq_start <- as.numeric(indel_stat$seq_start)
indel_stat$seq_end <- as.numeric(indel_stat$seq_end)
indel_stat$indel_num <- as.numeric(indel_stat$indel_num)

write.table(indel_stat, str_c(out_dir, '/', sample_name, '.indel_stat.txt'), row.names = FALSE, sep = '\t', quote = FALSE)



#####################
##circlize 绘图
pdf(str_c(out_dir, '/', sample_name, '.circlize.pdf'), width = 14, height = 8)
circle_size = unit(1, 'snpc')
# 一些基础参数可以通过 circos.par()函数设置
#  start.degree: 第一个扇区的角度，等于 90 时，表示从正上方开始.gap.degree:两个邻近扇区的距离，gap.after 和它一样.track.margin:轨道之间的空白距离，mm_h()/cm_h()/inches_h()函数设置.
circos.par(gap.degree = 2, start.degree = 90, track.margin = c(0.01, 0.01), cell.padding = c(0,0,0,0))

# 创建基因组数据的绘图区域的函数是 circos.genomicTrack()，或者 circos.genomicTrackPlotRegions()。
#第一圈，染色体区域
# 基因组外围刻度
circos.genomicInitialize(seq_stat, plotType = c('axis', 'labels'), major.by = 50000, track.height = 0.05)

# 使用 panel.fun 添加自定义的绘图函数
# 在 panel.fun 函数中，可以基础图形函数来添加图形，函数接收两个参数 region 和 value：

# region：包含两列起止位置的数据框
# value：其他列信息的数据框，一般从第四列开始的数据
# 其中 region 的数据用于标识 x 轴，value 标识的是 y 轴。

# panel.fun 函数还强制要求传入第三个参数 ...，用于传递用户不可见的变量，并交由其内部的基础绘图函数进行解析，如 circos.genomicPoints
# circos.genomicRect函数：绘制矩形网格，专门用于基因组图形
# region : 一个数据帧包含两列，分别对应于起始位置和结束位置。value : 数据帧包含值和其他信息。
circos.genomicTrackPlotRegion(
  # track.height:轨道高度，可通过 mm_h()/cm_h()/inches_h()设置.
  seq_stat, track.height = 0.05, stack = TRUE, bg.border = NA,
  panel.fun = function(region, value=NULL, ...) {
    circos.genomicRect(region, value=NULL, col = '#049a0b', border = NA, ...)
  } )

#第二圈，GC% 含量图
# circos.genomicTrack 创建一个新轨道
circos.genomicTrack(
  depth_base[c(1:3, 5)], track.height = 0.05, bg.col = '#EEEEEE6E', bg.border = NA,
  panel.fun = function(region, value, ...) {
    # circos.genomicLines函数：为绘图区域添加线条，特别是基因组图形
    circos.genomicLines(region, value, col = 'blue', lwd = 0.35, ...)
    # circos.lines函数：向打印区域添加线。col : 线条颜色。lwd : 线条宽度。lty : 线条样式。这里表示平均GC含量
    circos.lines(c(0, max(region)), c(genome_GC, genome_GC), col = 'blue2', lwd = 0.15, lty = 2)
    # circos.axis() 和 circos.yaxis(): 添加轴。tick.length : 记号的长度；labels.cex : 轴标签的字体大小
    circos.yaxis(labels.cex = 0.2, lwd = 0.1, tick.length = convert_x(0.15, 'mm'))
  } )

gc_legend <- Legend(
  at = 1, labels = c(str_c('GC % ( Average: ', genome_GC, ' % )')), labels_gp = gpar(fontsize = 8),
  grid_height = unit(0.5, 'cm'), grid_width = unit(0.5, 'cm'), type = 'lines', background = '#EEEEEE6E', 
  legend_gp = gpar(col = 'blue', lwd = 0.5))

#第三圈，覆盖度 & 深度
circos.genomicTrack(
  depth_base[1:4], track.height = 0.05, ylim = c(0, (max(depth_base$depth) + 1)), bg.col = '#EEEEEE6E', bg.border = NA,
  panel.fun = function(region,value, ...) {
    # circos.rect函数：绘制矩形网格。每个单位区域内的测序深度
    circos.genomicRect(region, value, ytop.column = 1, ybottom = 0, border = 'white', lwd = 0.02, col = 'red', ...)
    # 平均测序深度，虚线
    circos.lines(c(0, max(region)), c(average_depth, average_depth), col = 'red3', lwd = 0.15, lty = 2)
    circos.yaxis(labels.cex = 0.2, lwd = 0.1, tick.length = convert_x(0.15, 'mm'))
    print(head(region, n = 2))
    print(head(value, n = 2))
  } )

depth_legend <- Legend(
  at = 1, labels = str_c(' Depth ( average: ', average_depth, ' X )'), labels_gp = gpar(fontsize = 8),
  title = str_c('Coverage: ', coverage , ' %'), title_gp = gpar(fontsize = 9),
  grid_height = unit(0.4, 'cm'), grid_width = unit(0.4, 'cm'), type = 'points', pch = NA, background = 'red')

#第四圈，CDS & rRNA & tRNA
color_assign <- colorRamp2(breaks = c(1, 2, 3), col = c('#00ADFF', 'orange', 'green2'))
gene1  <- data.frame(gene[1])

circos.genomicTrackPlotRegion(
  gene, track.height = 0.1, stack = TRUE, bg.border = NA,
  panel.fun = function(region, value, ...) {
    circos.genomicRect(region, value, col = color_assign(value[[1]]), border = NA, ...)
    print(head(region, n = 2))
    print(head(value[[1]], n = 2))
  } )

gene_legend <- Legend(
  at = c(3, 2, 1), labels = c(' CDS', ' rRNA', ' tRNA'), labels_gp = gpar(fontsize = 8),
  title = 'CDS | rRNA | tRNA', title_gp = gpar(fontsize = 9), 
  grid_height = unit(0.4, 'cm'), grid_width = unit(0.4, 'cm'), type = 'points', pch = NA, background = c('#00ADFF', 'orange', 'green2'))


#第五圈，SNP 密度
value_max <- max(snp_stat$snp_num)
colorsChoice <- colorRampPalette(c('white', '#245B8E'))
color_assign <- colorRamp2(breaks = c(0:value_max), col = colorsChoice(value_max + 1))

circos.genomicTrackPlotRegion(
  snp_stat, track.height = 0.05, stack = TRUE, bg.border = NA,
  panel.fun = function(region, value, ...) {
    circos.genomicRect(region, value, col = color_assign(value[[1]]), border = NA, ...)
  } )

snp_legend <- Legend(
  at = round(seq(0, value_max, length.out = 6), 0), labels_gp = gpar(fontsize = 8),
  col_fun = colorRamp2(round(seq(0, value_max, length.out = 6), 0), colorsChoice(6)),
  title_position = 'topleft', title = 'SNP density', legend_height = unit(4, 'cm'), title_gp = gpar(fontsize = 9))

#第六圈，InDel 密度
value_max <- max(indel_stat$indel_num)
colorsChoice <- colorRampPalette(c('white', '#7744A4'))
color_assign <- colorRamp2(breaks = c(0:value_max), col = colorsChoice(value_max + 1))

circos.genomicTrackPlotRegion(
  indel_stat, track.height = 0.05, stack = TRUE, bg.border = NA,
  panel.fun = function(region, value, ...) {
    circos.genomicRect(region, value, col = color_assign(value[[1]]), border = NA, ...)
  } )

indel_legend <- Legend(
  at = round(seq(0, value_max, length.out = 6), 0), labels_gp = gpar(fontsize = 8),
  col_fun = colorRamp2(round(seq(0, value_max, length.out = 6), 0), colorsChoice(6)),
  title_position = 'topleft', title = 'InDel density', legend_height = unit(4, 'cm'), title_gp = gpar(fontsize = 9))




#最后添加图例，图例在图中的存放位置自己看着调吧
y_coord <- 0.8
x_coord <- 0.87

pushViewport(viewport(x = x_coord + 0.011, y = y_coord))
grid.draw(gc_legend)
y_coord <- y_coord - 0.06
upViewport()

pushViewport(viewport(x = x_coord + 0.005, y = y_coord))
grid.draw(depth_legend)
y_coord <- y_coord - 0.1
upViewport()

pushViewport(viewport(x = x_coord - 0.0063, y = y_coord))
grid.draw(gene_legend)
y_coord <- y_coord - 0.19
upViewport()

pushViewport(viewport(x = x_coord - 0.0205, y = y_coord))
grid.draw(snp_legend)
y_coord <- y_coord
upViewport()

pushViewport(viewport(x = x_coord + 0.0505, y = y_coord))
grid.draw(indel_legend)
y_coord <- y_coord - 0.195
upViewport()


#统计总览（涵括了上文大部分的统计结果信息，例如 SNP 替换类型统计等）
stat_legend <- Legend(
  at = 1, labels = '1', labels_gp = gpar(fontsize = 0), title_gp = gpar(fontsize = 9), 
  grid_height = unit(0, 'cm'), grid_width = unit(0, 'cm'), type = 'points', pch = NA, background = NA, 
  title = str_c('Sample: ', sample_name, '\nRefer species: ', ref_name, '\nRefer size: ', genome_size, ' bp\nRefer GC: ', genome_GC, ' %\n\n\nTotal SNP: ', snp_ti + snp_tv, '\nTransitions: ', snp_ti, '\nTransversions: ', snp_tv, '\nTi/Tv: ', round(snp_ti / snp_tv, 2), '\nA>T|T>A: ', snp_at, '\nA>G|T>C: ', snp_ag, '\nA>C|T>G: ', snp_ac, '\nG>A|C>T: ', snp_ga, '\nG>T|C>A: ', snp_gt, '\nG>C|C>G: ', snp_gc, '\n\n\nTotal InDel: ', indel_insert + indel_delet, '\nInsert: ', indel_insert, '\nDelet: ', indel_delet))

pushViewport(viewport(x = 0.12, y = 0.5))
grid.draw(stat_legend)
upViewport()

#最后清除预设样式并关闭画板，以免影响继续作图
circos.clear()
dev.off()


