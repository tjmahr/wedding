library("stringr")
library("tools")

resize <- function(input, output, x, y, test = FALSE) {
  cmd <- sprintf("convert %s -resize %sx%s %s", input, x, y, output)
  f <- if (test) message else shell
  f(cmd)
}

# Convert large squares to thumbnails
squares <- list.files("images/gallery/", "_square", full.names = TRUE)
thbs <- squares %>% str_replace("_square", "_thb")
Map(resize, squares, thbs, 170, 170)

# Convert raws to 800x600
raws <- list.files("images/gallery/", "_raw", full.names = TRUE)
outs <- raws %>% str_replace("_raw", "_fit")
Map(resize, raws, outs, 800, 600)

# Generate gallery items
fits <- list.files("images/gallery/", "_fit", full.names = TRUE)
thbs <- fits %>% str_replace("_fit", "_thb")

source("R/gallery_item.R")
Map(gal_item, thbs, fits) %>% unlist %>% unname %>% cat

