# Palettes
feature.pal <- rcartocolor::carto_pal(8, "Bold")[c(6,4)]
location.pal <- RColorBrewer::brewer.pal(4, "Set2")
timepoint.pal <- viridis::plasma(29)
overlap.pal <- RColorBrewer::brewer.pal(9, "Greys")[c(3,5,7,9)]
rep.pal <- RColorBrewer::brewer.pal(9, "Blues")[c(1,3,4,6,7)]
phylum.pal <- c(rcartocolor::carto_pal(8, "Bold")[1:4], "gray25", "gray75")

# ggplot theme
basic.theme <- function(){
  theme_bw() + 
    theme(text = element_text(size = 12))
}