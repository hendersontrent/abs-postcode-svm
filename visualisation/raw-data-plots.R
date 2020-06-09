#-------------------------------------
# This script sets out to visualise
# population size and internet access
# at the postcode level and see if
# a classifier algorithm works on it
#
# NOTE: This script requires setup.R
# to have been run first
#-------------------------------------

#-------------------------------------
# Author: Trent Henderson, 9 June 2020
#-------------------------------------

# Load data

d1 <- read_excel("data/three_level.xlsx")
d2 <- read_excel("data/two_level.xlsx")

#------------------DATA VIS---------------------

# Reusable plotting function

plotter <- function(data){
  ggplot(data = data, aes(x = usual_resident_population, y = prop_dwellings_internet_accessed)) +
    geom_point(aes(colour = grouped_ra), stat = "identity", alpha = 0.5) +
    geom_smooth(aes(group = grouped_ra, colour = grouped_ra), method = "glm", formula = y ~ x) +
    scale_x_log10() +
    scale_y_continuous(labels = function(x) paste0(x, "%")) +
    theme_bw() +
    labs(title = "Australian postcode population size and internet access by regionality",
         x = "Log10 resident population",
         y = "Proportion of dwellings with internet access",
         colour = NULL,
         caption = "Source: ABS, Orbisant Analytics analysis.") +
    theme(legend.position = "bottom")
}

p <- plotter(d1)
print(p)

p1 <- plotter(d2)
print(p1)

#------------------EXPORTS----------------------

CairoPNG("output/abs_chart.png", 600, 400)
print(p)
dev.off()

CairoPNG("output/abs_chart_2_levels.png", 600, 400)
print(p1)
dev.off()
