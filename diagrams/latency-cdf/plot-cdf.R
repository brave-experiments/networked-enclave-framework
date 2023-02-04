require(ggplot2)
require(tikzDevice)

args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
data <- read.csv(input_file, header = TRUE)

data$cdf = data$pct / 100

# cairo_pdf("latency-cdf.pdf", width = 4.5, height = 2.5)
tikz(file = "latency-cdf.tex",
     standAlone = FALSE,
     width = 3.5,
     height = 1.5)

ggplot(data, aes(x = ms,
                 y = cdf,
                 color = type,
                 linetype = type,
                 shape = type)) +
       geom_point(size = 1.5) +
       geom_line() +
       # scale_x_continuous(labels=comma, trans="log2") +
       scale_color_brewer(palette = "Dark2") +
       theme_minimal() +
       labs(x = "Latency (ms)",
            y = "Empirical CDF",
            color = "Setup",
            linetype = "Setup",
            shape = "Setup")

dev.off()
