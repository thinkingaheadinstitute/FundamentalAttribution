#' @title A chart of the cumulative returns from each attribution component
#' 
#' @description A function to produce a simple ggplot showing the cumulative returns from each attribution component. As a ggplot object it can be edited in the usual ways.
#' 
#' @param .dt A data.table of attribution results, likely the output of `fa_chart_data_prep`.
#' @param cht_caption A character used in the caption of the chart. Defaults to NULL.
#' @param facet_scales Passed to the scales parameter of facet_wrap or facet_grid. Defaults to 'free_y'.
#' @param filter_variables The variables to be included in the chart, also determines the order of the variables.
#' @param order_variables Should the variables be ordered? If so, use the order in 'filter_variables'. Defaults to TRUE.
#' @param ... Additional parameters that are passed to `geom_line` via `aes` within the function.
#' 
#' @return A ggplot object of the cumulative return components.
#' 
#' @export
fa_chart_cumulative_attribution <- function(.dt, cht_caption = NULL, facet_scales = 'free_y', filter_variables = c('Activity', 'Growth', 'Multiple','Intra-Period','Residual','Implied Return','Actual Return'), order_variables = T, ...){
  
  if (isTRUE(order_variables)) order_variables <- filter_variables
  
  temp <- .dt %>% 
    tibble::as_tibble() %>%
    dplyr::filter(variable %in% filter_variables)
  
  if (!isFALSE(order_variables)) {
    temp <- temp %>%
      dplyr::mutate(variable = factor(x = variable, levels = order_variables, ordered = T))
  }

  temp <- temp %>%
    dplyr::group_by(metric_name, group_id, series_name, series_type, variable) %>%
    dplyr::arrange(index) %>%
    dplyr::mutate(value = cumsum(value))
  
  gg <- ggplot2::ggplot(
    data = temp, 
    ggplot2::aes(
      x = index, 
      y = value, 
      color = variable,  
      group = interaction(metric_name, group_id, series_name, series_type, variable)
      )
    ) +
    ggplot2::geom_hline(yintercept = 0, size = 0.2, color = 'black') +
    ggplot2::geom_line(ggplot2::aes(...)) +
    ggplot2::labs(x = NULL, y = 'Cumulative Log returns', title = NULL, caption = cht_caption) +
    ggplot2::scale_y_continuous(labels = scales::percent) +
    ggplot2::scale_color_discrete()
  
  if (length(unique(temp$group_id)) == 1) {
    gg <- gg + ggplot2::facet_wrap(~metric_name, ncol = 1, scales = facet_scales)
  } else {
    gg <- gg + ggplot2::facet_grid(metric_name~group_id, scales = facet_scales)
  }
  
  return(gg)
  
}
