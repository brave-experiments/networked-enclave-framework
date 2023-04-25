require(ggplot2)
require(tikzDevice)
require(gridExtra)
require(scales) # for "labels=comma"

args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
data <- read.csv(input_file, header = TRUE)

# cairo_pdf("http-requests-per-sec.pdf", width = 3.5, height = 1.5)
tikz(file = "http-requests-per-sec.tex",
     standAlone = FALSE,
     width = 3.5,
     height = 1.6)

clean_data <- unique(subset(data, select = -c(ms, pct)))

ggplot(clean_data, aes(x = threads,
                       y = reqssec,
                       color = setting,
                       linetype = setting,
                       shape = setting)) +
       geom_point(size = 1.5) +
       geom_line() +
       scale_color_brewer(palette = "Dark2") +
       theme_minimal(base_size = 10) +
       scale_y_continuous(labels=comma, trans="log10") +
       theme(legend.key.height = unit(0.5, "cm")) +
       labs(x = "Number of threads",
            y = "Requests per sec (log)",
            color = "Setup",
            linetype = "Setup",
            shape = "Setup")

dev.off()
