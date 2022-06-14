## example data for demonstrating caluclations and package functions

# Simple 2 period data example

library(xts)

# minimal examples

prices_short <- data.frame(time = as.Date(c('1999-12-31','2000-01-31','2000-02-29')),
                     a = c( 5.0,  7.5, 10.0),
                     b = c( 5.0,  7.5, 10.0),
                     c = c(10.0, 10.0, 10.0),
                     d = c(10.0, 10.0, 10.0))

prices_short <- xts(x = prices_short[,-1], order.by = prices_short[[1]])

price_to_fundamental_short <- data.frame(time = as.Date(c('1999-12-31','2000-01-31','2000-02-29')),
                                   a = c(1.0, 1.5, 2.0),
                                   b = c(1.0, 1.0, 1.0),
                                   c = c(2.0, 2.0, 2.0),
                                   d = c(1.0, 1.0, 1.0))

price_to_fundamental_short <- xts(x = price_to_fundamental_short[,-1], order.by = price_to_fundamental_short[[1]])

returns_short <- prices_short/lag(prices_short)-1
fundamental_yield_short <- 1/price_to_fundamental_short

usethis::use_data(returns_short, fundamental_yield_short, overwrite = TRUE)

# Simple 12 period data example

prices_long <- data.frame(time = as.Date(c('1999-12-31','2000-01-31','2000-02-29','2000-03-31','2000-04-30','2000-05-31','2000-06-30','2000-07-31','2000-08-31','2000-09-30','2000-10-31','2000-11-30','2000-12-31')),
                     a = c( 5.00,  7.00,  9.00,  12.00,  17.00,  20.00, 15.00,   8.00,  9.00,  11.00,  13.00,  15.00, 18.00),
                     b = c( 7.50, 10.00,  8.25,   5.50,   9.00,  12.00,  9.75,   6.50, 10.50,  14.00,  11.25,   7.50, 12.00),
                     c = c(15.00, 10.00, 16.50,  22.00,  18.00,  12.00, 19.50,  26.00, 21.00,  14.00,  22.50,  30.00, 24.00))

prices_long <- xts(x = prices_long[,-1], order.by = prices_long[[1]])

price_to_fundamental_long <- data.frame(time = as.Date(c('1999-12-31','2000-01-31','2000-02-29','2000-03-31','2000-04-30','2000-05-31','2000-06-30','2000-07-31','2000-08-31','2000-09-30','2000-10-31','2000-11-30','2000-12-31')),
                                   a = c(1.00, 1.17, 1.29, 1.50, 1.89, 2.00, 1.88, 1.14, 1.13, 1.22, 1.30, 1.36, 1.50),
                                   b = c(1.50, 2.00, 1.50, 1.00, 1.50, 2.00, 1.50, 1.00, 1.50, 2.00, 1.50, 1.00, 1.50),
                                   c = c(1.50, 1.00, 1.50, 2.00, 1.50, 1.00, 1.50, 2.00, 1.50, 1.00, 1.50, 2.00, 1.50))

price_to_fundamental_long <- xts(x = price_to_fundamental_long[,-1], order.by = price_to_fundamental_long[[1]])

returns_long <- prices_long/lag(prices_long)-1
fundamental_yield_long <- 1/price_to_fundamental_long

usethis::use_data(returns_long, fundamental_yield_long, overwrite = TRUE)
