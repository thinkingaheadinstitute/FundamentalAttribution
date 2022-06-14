#' @title Add fund level data to attribution results
#' 
#' @description Add fund returns and fund yield to attribution results. A residual return component is calculated when fund returns are added measuring the difference between the bottom-up attribution returns and the top-level returns.
#' 
#' @param .dt The attribution results of a portfolio.
#' @param fund_data The additional fund data to be added. This is the output of a `fa_load_fund_*` function.
#' @param log_convert Should the fund returns be converted to log returns? Defaults to TRUE.
#' 
#' @return A data.table of the attribution results with the additional fund level data and a new residual return component - the difference between the fund return and the implied return.
#' 
#' @export
fa_add_fund_level <- function(.dt, fund_data, log_convert = TRUE){
  
  temp <- data.table::as.data.table(.dt)
  
  if (log_convert == T) { 
    temp_fund_data <- fund_data[, 'returns' := log(1 + returns)] }
  else {
    temp_fund_data <- fund_data
  }
  
  data.table::setnames(temp_fund_data, old = "returns", new = "fund_return")
  
  cols_merge <- c("index", "group_id", "series_name", "series_type")
  cols_values <- "fund_return"
  
  if('metric_to_price' %in% names(temp_fund_data)){
    
    data.table::setnames(temp_fund_data, old = "metric_to_price", new = "fund_yield")
    cols_merge <- c(cols_merge, "metric_name")
    cols_values <- c(cols_values, "fund_yield")
    
  }
  
  temp <- data.table::merge.data.table(x = temp, 
                                       y = temp_fund_data[, c(cols_merge, cols_values), with = FALSE], 
                                       by = cols_merge, 
                                       all.x = TRUE)
  
  temp[, 'residual' := fund_return - implied_return]
  
  return(temp)
}