#' @title Combine fund returns and fundamental-to-price ratio into data.table
#' 
#' @description This function combines separate xts objects that contain fund level data into a single data.table so it can be added to attribution results calculated from the fund's underlying holdings.
#' 
#' @param metric_to_price An xts containing the fundamental-to-price ratio of the fund. Only the first column is used.
#' @param fund_returns An xts containing the returns of the fund. Only the first column is used.
#' @param metric_name A character name of the fundamental being used.
#' @param series_name A character name of the strategy, this is used to match a strategy's fund level and stock level data. Defaults to the name of the first column of the fund_returns xts.
#' @param group_id A character name that allows multiple series to be combined, a place holder for when relative attribution is applied.
#' 
#' @return A data.table of fund level data on which attribution can be run, or which can be added a strategy's stock level attribution results.
#' 
#' @export
fa_load_fund_xts <- function(metric_to_price = NULL, fund_returns, metric_name = NA, series_name = NA, group_id = NA){
  

  check_xts <- list(fund_returns)
  if (!is.null(metric_to_price)) check_xts <- c(check_xts, metric_to_price)
  if (any(!sapply(check_xts, FUN = function(x){'xts' %in% class(x)}))) stop("Only 'xts' objects can be used.")

  if (ncol(fund_returns) > 1) warning("Only the first column of 'fund_returns' will be used.")
  
  if (!is.null(metric_to_price)){ 
      if(ncol(metric_to_price) > 1) warning("Only the first column of 'metric_to_price' will be used.")
      if (is.na(metric_name)) stop("'metric_name' must be supplied.")
  }
  
  if (is.na(series_name)) series_name <- names(fund_returns)[1]
  
  if(is.na(group_id)) group_id <- series_name
  
  temp <- data.table::melt.data.table(data = data.table::as.data.table(fund_returns[,1]), 
                                      id.vars = 'index',
                                      variable.name = 'id', 
                                      value.name = 'returns', 
                                      na.rm = F)
  
  if(!is.null(metric_to_price)){
    
    temp <- data.table::merge.data.table(x = temp, 
                                         y = data.table::melt.data.table(data = data.table::as.data.table(metric_to_price[,1]), 
                                                                         id.vars = 'index',
                                                                         variable.name = 'id', 
                                                                         value.name = 'metric_to_price', 
                                                                         na.rm = F), 
                                         by = c('index','id'), 
                                         all = T)
    temp[,'metric_name' := metric_name]
  }
  
  temp[,start_weight := 1]
  temp[,returns_ctb := returns]
  
  temp[,'group_id' := group_id]
  temp[,'series_name' := series_name]
  temp[,'series_type' := 'strategy']
  
  return(temp)
}
