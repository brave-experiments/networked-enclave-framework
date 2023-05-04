require(ggplot2)
require(tikzDevice)

args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
data <- read.csv(input_file, header = TRUE)

data$ms = data$us / 1000

# cairo_pdf("density", width = 4.5, height = 2.5)
tikz(file = "density.tex",
     standAlone = FALSE,
     width = 3.5,
     height = 1.5)

length(which(data$ms < 1.5)) / length(data$ms) * 100
quantile(data$ms, c(.9, .95, .99))
median(data$ms)

ggplot(data, aes(x = ms)) +
       geom_density(fill = "grey") +
       #geom_violin() +
       scale_color_brewer(palette = "Dark2") +
       theme_minimal() +
       scale_x_continuous(trans="log2") +
       labs(x = "Latency  in ms (log)",
            y = "Density")

dev.off()
