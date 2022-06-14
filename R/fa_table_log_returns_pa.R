#' @title A summary table of attribution return components
#' 
#' @description Calculate the average return component for each portfolio and fundamental included in the attribution results.
#' 
#' @param .dt A data.table of attribution results.
#' @param rescale A number to annualise, or otherwise, rescale the returns. Defaults to 12.
#' @param accuracy The accuracy of the results. Defaults to 0.01.
#' @param na_rm Remove rows with NAs from .dt. Defaults to TRUE.
#' 
#' @return A data.table summarising the returns of each attribution component.
#' 
#' @export
fa_table_log_returns_pa <- function(.dt, rescale = 12, accuracy = 0.01, na_rm = T){
  
  return_cols <- c('fund_return', 'implied_return', 'growth','activity','multiple','intra_period', 'residual')
  
  return_cols <- return_cols[return_cols %in% names(.dt)]
  
  temp <- data.table::as.data.table(.dt)
  
  if (na_rm) temp <- na.omit(temp)
  
  temp <- data.table::melt.data.table(data = temp[,c('index', 'metric_name', 'group_id', 'series_name','series_type', return_cols), with = FALSE], measure.vars = return_cols, value.name = 'value')
  
  temp <- temp[, .('N' = .N, Return = sum(value, na.rm = T)/.N * rescale), by = c('metric_name', 'group_id', 'series_name' ,'series_type', 'variable')][, 'Return' := scales::percent(x = Return, accuracy = accuracy)]
  
  temp <- data.table::dcast.data.table(data = temp, ...~variable, value.var = 'Return')
  
  return(temp)
}