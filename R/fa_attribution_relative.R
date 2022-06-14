#' @title Calculate fundamental attribution of relative returns
#' 
#' @description Calculate the relative fundamental attribution by combining the fundamental attribution results for a portfolio and its benchmark.
#' 
#' @param strategy The fundamental attribution results of the portfolio, calculated by the `fa_attribution` function.
#' @param benchmark The fundamental attribution results of the benchmark, calculated by the `fa_attribution` function.
#' 
#' @return A data.table of the attribution results of the portfolio, the benchmark, and their relative performance.
#' 
#' @export
fa_attribution_relative <- function(strategy, benchmark){
  
  temp_strategy <- data.table::melt.data.table(
    data = strategy, 
    id.vars = c('index','metric_name','group_id','series_name','series_type'), 
    variable.name = 'id', 
    value.name = 'value'
    )
  
  temp_benchmark <- data.table::melt.data.table(
    data = strategy[,.(index, metric_name, group_id)][data.table::as.data.table(benchmark)[, group_id := NULL], on = c('index', 'metric_name')], 
    id.vars = c('index','metric_name','group_id','series_name','series_type'), 
    variable.name = 'id', 
    value.name = 'value')[,series_type := 'benchmark']
  
  temp_relative <- data.table::rbindlist(
    list(temp_strategy, temp_benchmark), 
    use.names = T
    )[series_type == 'benchmark', value := -value][,.(value = sum(value, na.rm = T)), by = c('index','metric_name','group_id','id')][,series_name := 'Relative'][,series_type := 'relative']

  temp <- data.table::dcast.data.table(
    data = data.table::rbindlist(
      list(temp_strategy, temp_benchmark, temp_relative), 
      use.names = T
      ), 
    ...~id, 
    value.var = 'value'
    )
  
  return(temp)
}