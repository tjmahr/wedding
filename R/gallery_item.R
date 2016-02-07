source("R/dsl_html.R")

'
          <li class="col-xs-4 col-sm-3 col-md-2">
            <a class="fancybox hover-effect" data-fancybox-group="group" href="http://placehold.it/800x600.jpg">
              <img alt="" class="img-rounded img-responsive" src="http://placehold.it/170x170.jpg">
              <span class="img-rounded">
                <i class="fa fa-search fa-3x"></i>
              </span>
              </a>
          </li>
'



li <- tag("li")
icon <- tag("i")
a <- tag("a")
span <- tag("span")
img <- void_tag("img")

li_gal <- function(...) li(..., class = "col-xs-4 col-sm-3 col-md-2")
span_part <- span(search_icon, class = "img-rounded")
search_icon <- icon("", class = "fa fa-search fa-3x")


a_fancybox <- function(..., href = placeholder(800, 600)) {
  a(..., class = "fancybox hover-effect",
    `data-fancybox-group` = "group",
    href = href)
}

thumbnail <- function(src = placeholder(170, 170), alt = "") {
  img(alt = alt, class="img-rounded img-responsive", src = src)
}

placeholder <- function(x, y) {
  sprintf("http://placehold.it/%sx%s.jpg", x, y)
}

gal_item <-
  li_gal(
    a_fancybox(thumbnail(src = "images/gallery/scary_thumb.jpg"),
               span_part,
               href = "images/gallery/scary_fit.jpg")
  )

cat(gal_item)



