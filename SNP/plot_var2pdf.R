#!/usr/bin/Rscript

#
# NAME
#
#   plot_var2pdf.R - Plot variation site information into a PDF file
#
# DESCRIPTION
#
# AUTHOR
#
#   zeroliu-at-gmail-dot-com
#
# VERSION
#
#   0.0.1   2018-04-30
#   0.1.0   2018-07-20
#   0.1.1   2018-07-25  More details for legend
#   0.2.0   2020-03-14  More options for fine tuning of plot

library(ggplot2)
library(reshape2)
library(dplyr)
library(aplot)
suppressPackageStartupMessages( library(R.utils) )

# Usage information
usage <- "
Plot SNP information according to the output of script 'align2var.py'.
Usage:
  Rscript plot_var2pdf.R --in=<fin> [--out=<fout>] [--group=<group>] [--strname] [--grid]
Arguments:
  --in=<fin>    Input file, created by the script 'align2var.py'
  --out=<fout>  Output file. Optional.
                Default 'vsite.pdf'.
Options:
  --strname     Show strain/sequence name.
                Default do not show.
  --grid        Show gray grid.
                Default do not show.
  --group=<group>   Input file of group.
"

# Parse command arguments
args <- commandArgs( trailingOnly = TRUE, asValues = TRUE )

if ( length(args$`in` ) == 0 ) {
  stop(paste("[ERROR] At least one argument must be supplied (input file)!\n", usage),
       call.=FALSE)
} else {
  fin = args$`in`
}


if ( length(args$out ) == 0 ) {
  # default output file
  print("[NOTE] Default output file 'vsites.pdf'.\n")
  fout    <- "vsites.pdf"
} else {
  fout    <- args$out
}

# Read input file
vsite <- read.table(fin, header = TRUE)
vsite <- melt(vsite[,-2], id="pos")
colnames(vsite) <- c("Location","Strain","Value")
# Operation on viste$Strain, for headmap plot in given order
vsite$Strain <- as.character( vsite$Strain )
vsite$Strain <- factor(vsite$Strain, levels = unique(vsite$Strain) )

# Plotting
p1 <- ggplot(vsite, aes(x=Location, y=Strain, fill=Value))

# Whether show/hide gray grid
if ( length(args$`grid`) == 0 ) {  # Hide
  p1 <- p1 + geom_tile()
} else {    # Show
  p1 <- p1 + geom_tile( color = "gray" )
}

# Hide background grid
p1 <- p1 + theme_classic()

# Whether show/hide strain/sequence name
if ( length(args$`strname`) == 0 ) {    # Hide
  p1 <- p1 + theme(
    axis.title.y = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    axis.line.y = element_blank() ) +
    ylim( rev( levels( vsite$Strain ) ) )   # Plot heatmap y label in line order
} else {   # Show
  p1 <- p1 + theme(
    axis.title.y = element_blank(),
    #axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    axis.line.y = element_blank() )
}

p1 <- p1 + scale_fill_manual(
  values = c("grey30", "white", "#e41a1c", "#377eb8"),
  breaks=c("-", "a", "n", "s"),
  labels=c("Gap", "Not changed", "Nonsynonymous", "Synonymous"), name=NULL)

if ( length(args$`group` ) == 0 ) {
  ggsave(fout, p1, device = "pdf")
} else {
  group = args$`group`

  df2 <- read.csv(group, header = TRUE)
  df2$y<-factor(df2$y,levels = rev(df2$y))

  p2<-ggplot(df2,aes(x=x,y=y))+
    geom_tile(aes(fill=group))+
    scale_x_continuous(expand = c(0,0))+
    theme(panel.background = element_blank(),
          axis.ticks = element_blank(),
          axis.title = element_blank(),
          axis.text = element_blank(),
          legend.position = "left",
          legend.title = element_blank())+
    scale_fill_manual(values = c("green","blue","red"))

  p3 <- p1%>%
    insert_left(p2,width = 0.05)

  ggsave(fout, p3, device = "pdf")
}




