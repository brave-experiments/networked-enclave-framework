require(ggplot2)
require(tikzDevice)

args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
data <- read.csv(input_file, header = TRUE)

data$ms = data$us / 1000

tikz(file = "att-doc-latencies.tex",
     standAlone = FALSE,
     width = 3.25,
     height = 1.5)

printf <- function(...) cat(sprintf(...))
printf("%% of values < 1.5: %f\n",
    length(which(data$ms < 1.5)) / length(data$ms) * 100)
printf("Median latency: %f\n", median(data$ms))
printf("Quantiles:\n")
quantile(data$ms, c(.9, .95, .99))

ggplot(data, aes(x = ms)) +
       stat_ecdf() +
       scale_color_brewer(palette = "Dark2") +
       theme_minimal(base_size = 10) +
       scale_x_continuous(trans="log2") +
       labs(x = "Latency  in ms (log)",
            y = "Empirical CDF")
