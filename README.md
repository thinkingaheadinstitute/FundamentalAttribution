<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->


# Fundamental Attribution

This R package contains functions to implement the fundamental-based performance attribution methodology developed by the [Thinking Ahead Institute](https://www.thinkingaheadinstitute.org/). The goal of this package is to allow users to quickly apply the methodology to their own data while providing insight into how this analysis can be replicated or extended for different needs.

A paper describing the methodology in more detail is available [here](https://www.thinkingaheadinstitute.org/research-papers/fundamental-return-attribution/).

<br/>

## What is fundamental attribution?

Fundamental attribution is a performance attribution method that aims to separate a portfolio’s returns into three main components: 

- **Multiple return** - Returns arising from changes in market sentiment
- **Growth return** - The return due the growth of the portfolio’s underlying fundamentals
- **Activity return** - The change in those fundamental characteristics due to changes in the portfolio’s holdings

Decomposing returns into these three components enables a deeper understanding and assessment of how an investment strategy generates returns. More traditional attribution methods focus on explaining returns by the performance of different groupings of securities; whereas this approach considers how the investment process generates returns in aggregate due to the current decisions of the asset manager or its past asset selection decisions. The approach separates out returns arising from changes in short-term market sentiment, enabling a longer-term outlook by asset owners and asset managers when evaluating recent performance or setting future return expectations.

The framework allows the evaluation of an asset manager’s decisions to be based not only on market value returns, but also on changes in the fundamental attributes of the portfolio over time. This is intended to promote a longer-term outlook, and to enable an improved dialogue between asset owners and asset managers. Specifically, it broadens the portfolio review discussion away from an exclusive focus on short-term performance towards the asset manager’s decision-making and the health of the portfolio.

<br/>

## Improving reporting practices in the investment industry

This methodology was also developed to improve reporting practice across the investment industry. With this in mind, this source code is being shared under the MIT License, so that others may use this code to adopt this framework in their reporting to clients or easily re-implement the methodology in their analytic framework of choice. We are grateful to our members for testing the model against actual portfolios following various strategies and for supporting the overall initiative.

<br/>

## Installing the package

This package can be installed from this repo in the normal way.

```r
remotes::install_github(repo = 'thinkingaheadinstitute\FundamentalAttribution')
```

<br/>

## Using the package to run a fundamental attribution analysis

The following code uses the functions in this package to apply the Fundamental Attribution framework to some example data. This data has been created to demonstrate this analysis. This example is a two asset portfolio that is equally weighted and rebalanced at the end of each month. This example replicates the overall procedure used in the Fundamental Attribution paper's example.

To follow this example, copy each code chunk into R and run in turn. Once complete the analysis will show positive attribution effects from the Growth and Activity return components.

We begin by loading the library.

```r
library(FundamentalAttribution)
```

This example will be use the `returns_long` and `fundamental_yield_long` datasets for the returns and yield of portfolios' underlying assets.

```r
head(returns_long, 5)
head(fundamental_yield_long, 5)
```

As this is an example, the next step creates an xts of the asset starting weights. The portfolio will contain two stocks, each rebalanced to 50% weight at month end.

```r
weights <- returns_long[-1,]
weights[] <- 0
weights[,c('b','c')] <- 0.5
head(weights, 5)
```

The asset weights, returns and yields are combined into a single data.table for the attribution analysis.


```r
asset_data <- fa_load_assets_xts(metric_to_price = fundamental_yield_long, 
                   start_weights = weights,
                   asset_returns = returns_long, 
                   metric_name = 'Example_yield',
                   series_name = 'Rebalanced')

head(asset_data)
```

The attribution analysis is applied to this data.table.

```r
results <- fa_attribution(asset_data)

head(results)
```

The results of the attribution can then be displayed as a table or chart. 

```r
results %>% 
  fa_table_log_returns_pa()

results %>% 
  fa_chart_data_prep() %>% 
  fa_chart_cumulative_attribution() + 
  ggplot2::facet_wrap(~variable) + 
  theme_fa()
```

Once the attribution results are calculated alternative charts or analysis of the results may be more suitable depending on the purpose of performing the attribution.