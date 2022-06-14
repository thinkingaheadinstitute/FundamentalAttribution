#' @title Prepare attribution results data for plotting or other analysis
#' 
#' @description This function handles reshaping the attribution results data for use with ggplot2 and cleaning up auto-generated column names so they look nice when included in plot legends etc.
#' 
#' @param .dt A data.table of attribution results
#' @param direction Should the prepared data.table be 'long' or 'wide'? Defaults to 'long'.
#' @param labels A named character vector in the form `c('intra_period' = 'Intra-Period')` to correct column names. Default labels is compatible with default column names from package functions.
#' @param extra_id_cols Additional id cols to be added to `id_cols`.
#' @param id_cols A character vector of column names that identify each data point by time, portfolio and type (eg strategy, benchmark, relative).
#' @param replace_na Replace NA values in the attribution components with value from a named vector. Defaults to 0. Use NA to retain NAs in the data.
#' 
#' @return A reshaped and reformatted data.table of attribution results. When reshaping to 'long' the labels for calculated quantities (eg different attribution components) will be in the 'variable' column, and the value in the 'value' column.
#' 
#' @export
fa_chart_data_prep <- function(.dt, direction = 'long', labels = NA, extra_id_cols = NA, id_cols = c('index','metric_name','group_id', 'series_name','series_type'), replace_na = c('growth' = 0, 'activity' = 0, 'multiple' = 0, 'intra_period' = 0, 'fund_return' = 0)){
  
  temp <- data.table::as.data.table(.dt)
  
  if (is.na(labels)) {
    
    labels <- c('growth' = 'Growth',
                'activity' = 'Activity',
                'multiple' = 'Multiple',
                'intra_period' = 'Intra-Period',
                'implied_return' = 'Implied Return',
                'residual' = 'Residual',
                'fund_return' = 'Actual Return',
                'implied_yield' = 'Implied Yield',
                'fund_yield' = 'Actual Yield')
    
  }
  
  if (!any(is.na(replace_na))){
    replace_cols <- names(temp)[names(temp) %in% names(replace_na)]
    replace_value <- replace_na[replace_cols]
    for (j in replace_cols) {
      data.table::set(temp, which(is.na(temp[[j]])), j, replace_value[j])
    }
    if('fund_return' %in% replace_cols) temp[, 'residual' := fund_return - implied_return]
  }
  
  if (direction == 'long') {
    
    temp <- data.table::melt.data.table(data = temp, id.vars = as.character(stats::na.omit(c(id_cols, extra_id_cols))), variable.name = 'variable', value.name = 'value', variable.factor = F)
    
    temp[, temp_var := as.character(labels[variable])][,variable := data.table::fifelse(is.na(temp_var),variable,temp_var,NA_character_)][,temp_var := NULL]
    
  } else if (direction == 'wide') {
    
    #temp <- data.table::as.data.table(temp)
    
    for (i in 1:length(names(temp))) {
      names(temp)[i] <- ifelse(names(temp)[i] %in% names(labels),as.character(labels[names(labels) %in% names(temp)[i]]),names(temp)[i])
    }
    
  } else {
    stop("'direction' must be either 'long' or 'wide'.")
  }
  
  return(temp)
}
