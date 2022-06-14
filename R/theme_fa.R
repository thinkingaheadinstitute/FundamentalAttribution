#' @title Apply a theme to a ggplot object
#'
#' @description This function applies a basic theme to a ggplot object.
#' 
#' @param base_size Set the text size in the ggplot.
#' @param base_family Set the font to use on the ggplot.
#' @param ... Applied further theme modifications.
#' 
#' @return A ggplot theme object.
#' 
#' @export
theme_fa <- function(base_size = 10, base_family = '', ...){
  
  temp <- ggplot2::theme_gray(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      rect =               ggplot2::element_rect(fill = NA, colour = "black", size = 0.5, linetype = 1),
      text =               ggplot2::element_text(family = base_family, face = "plain",colour = "black", size = base_size,hjust = 0.5, vjust = 0.5, angle = 0, lineheight = 0.9, margin = ggplot2::margin(5,5,10,5,"pt"), debug = F),
      axis.text =          ggplot2::element_text(size = ggplot2::rel(0.8), colour = "black"),
      strip.text =         ggplot2::element_text(size = ggplot2::rel(0.8), colour = "black"),
      
      axis.line =          ggplot2::element_line(colour = "black", size = 0.2, linetype = 1),
      axis.line.x =        ggplot2::element_line(colour = 'black', size = 0.2, linetype = 1),
      axis.line.y =        ggplot2::element_line(colour = 'black', size = 0.2, linetype = 1),
      axis.text.x =        ggplot2::element_text(vjust = 1, margin= ggplot2::margin(5,5,10,5,"pt")),
      axis.text.y =        ggplot2::element_text(hjust = 1, margin= ggplot2::margin(5,5,10,5,"pt")),
      axis.ticks =         ggplot2::element_line(colour = "black", size = 0.2),
      axis.title =         ggplot2::element_text(colour = "black"),
      axis.title.x =       ggplot2::element_text(vjust = 1, hjust = 0.5),
      axis.title.y =       ggplot2::element_text(angle = 90, hjust = 0.5),
      
      axis.ticks.length =  ggplot2::unit(0.3, "lines"),
      
      legend.spacing =     ggplot2::unit(0.4, "cm"),
      legend.margin =      ggplot2::margin(0.2, 0.2, 0.2, 0.2, "cm"),
      legend.key =         ggplot2::element_rect(fill = NA, colour = NA),
      legend.text =        ggplot2::element_text(size = ggplot2::rel(0.8), colour = "black"),
      legend.title =       ggplot2::element_blank(),
      legend.title.align = NULL,
      legend.position =    "bottom",
      legend.direction =   "horizontal",
      legend.justification = "center",
      
      panel.background =   ggplot2::element_rect(fill = NA, colour = NA),
      panel.border =       ggplot2::element_rect(fill = NA, colour = 'black', size = 0.2),
      panel.grid.major =   ggplot2::element_line(colour = 'black', size = 0.2, linetype = 'dotted'),
      panel.grid.minor =   ggplot2::element_line(colour = NA, size = 0.2, linetype = 'dotted'),
      panel.grid.minor.x = ggplot2::element_line(color = 'black'),
      
      strip.background =   ggplot2::element_rect(fill = NA, colour = NA),
      strip.text.x =       ggplot2::element_text(hjust = 0, face = 'bold'),
      strip.text.y =       ggplot2::element_text(angle = -90, face = 'bold'),
      
      plot.background =    ggplot2::element_rect(colour = NA, fill = NA),
      plot.title =         ggplot2::element_text(size = ggplot2::rel(1.2), colour = 'black', face = 'bold', hjust = 0),
      plot.subtitle =      ggplot2::element_text(size = ggplot2::rel(1), hjust = 0),
      plot.caption =       ggplot2::element_text(size = ggplot2::rel(0.8), hjust = 1),
      plot.caption.position = 'plot',
      plot.margin =        ggplot2::unit(c(2, 1, 0.5, 0.5), "lines")
    ) +
    ggplot2::theme(...)
  
  return(temp)
}
