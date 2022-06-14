#' @title Combine asset weights, returns and fundamental-to-price ratios into a data.table
#' 
#' @description This function combines separate xts objects containing the yields, returns and starting weights of the assets in a portfolio into a single data.table, suitable for the attribution calculations.
#' 
#' @param metric_to_price An xts containing the fundamental-to-price ratio of the assets in the portfolio. When as asset's weight changes to 0% during a measurement period this ratio is required in the end of the period.
#' @param start_weights An xts containing the starting weights of the assets in the portfolio during the measurement period. For example, if using monthly data the start weights of 31 Jan are the weights of the assets at the beginning of 1 Jan.
#' @param asset_returns An xts containing the returns of the assets during the measurement period.
#' @param asset_returns_ctb An optional xts containing the return contributions of the assets in the portfolio. If not supplied this is calculated as asset_returns * start_weights.
#' @param metric_name A character name of the fundamental being supplied.
#' @param series_name A character name of the strategy from which the starting weights and return contributions are sourced.
#' @param group_id A character name that allows multiple series to be combined, a place holder for when relative attribution is applied.
#' 
#' @return A data.table of the combined data that can be passed directly to the attribution functions.
#' 
#' @export
fa_load_assets_xts <- function(metric_to_price, start_weights, asset_returns, asset_returns_ctb = NULL, metric_name = NA, series_name = NA, group_id = NA){
  
  if (is.na(metric_name)) stop("'metric_name' must be supplied.")
  if (is.na(metric_name)) stop("'series_names' must be supplied.")
  
  if (
    any(
    !sapply(
      list(metric_to_price, start_weights, asset_returns), 
      FUN = function(x){'xts' %in% class(x)}
      )
    )) stop("Only 'xts' objects can be used.")
  
  if (is.na(group_id)) group_id <- series_name
  
  temp <- data.table::melt.data.table(
    data = data.table::as.data.table(start_weights), 
    id.vars = 'index',
    variable.name = 'id', 
    value.name = 'start_weight', 
    na.rm = F)
  
  temp <- data.table::merge.data.table(
    x = temp, 
    y = data.table::melt.data.table(
      data = data.table::as.data.table(asset_returns), 
      id.vars = 'index',
      variable.name = 'id', 
      value.name = 'returns', 
      na.rm = F), 
    by = c('index','id'), 
    all = T)
  
  if (is.null(asset_returns_ctb)) {
    temp[,returns_ctb := start_weight * returns]
  } else {
    temp <- data.table::merge.data.table(
      x = temp, 
      y = data.table::melt.data.table(
        data = data.table::as.data.table(asset_returns_ctb), 
        id.vars = 'index',
        variable.name = 'id', 
        value.name = 'returns_ctb', 
        na.rm = F), 
      by = c('index','id'), 
      all = T)
    }
  
  temp <- data.table::merge.data.table(
    x = temp, 
    y = data.table::melt.data.table(
      data = data.table::as.data.table(metric_to_price), 
      id.vars = 'index',
      variable.name = 'id', 
      value.name = 'metric_to_price', 
      na.rm = F), 
    by = c('index','id'), 
    all = T)
  
  temp[,'metric_name' := metric_name]
  temp[,'group_id' := group_id]
  temp[,'series_name' := series_name]
  temp[,'series_type' := 'strategy']
  
  return(temp)
}
