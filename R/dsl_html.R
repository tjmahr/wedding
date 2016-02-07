# http://adv-r.had.co.nz/dsl.html#html
html <- function(x) structure(x, class = "html")
print.html <- function(x, ...) {
  out <- paste0("<HTML> ", x)
  cat(paste(strwrap(out), collapse = "\n"), "\n", sep = "")
}

escape <- function(x) UseMethod("escape")
escape.html <- function(x) x
escape.character <- function(x) {
  x <- gsub("&", "&amp;", x)
  x <- gsub("<", "&lt;", x)
  x <- gsub(">", "&gt;", x)

  html(x)
}
escape.list <- function(x) {
  lapply(x, escape)
}

named <- function(x) {
  if (is.null(names(x))) return(NULL)
  x[names(x) != ""]
}
unnamed <- function(x) {
  if (is.null(names(x))) return(x)
  x[names(x) == ""]
}

html_attributes <- function(list) {
  if (length(list) == 0) return("")

  attr <- Map(html_attribute, names(list), list)
  paste0(" ", unlist(attr), collapse = "")
}

html_attribute <- function(name, value = NULL) {
  if (length(value) == 0) return(name) # for attributes with no value
  if (length(value) != 1) stop("value must be NULL or of length 1")

  if (is.logical(value)) {
    # Convert T and F to true and false
    value <- tolower(value)
  } else {
    value <- escape_attr(value)
  }
  paste0(name, " = '", value, "'")
}

escape_attr <- function(x) {
  x <- escape.character(x)
  x <- gsub("\'", '&#39;', x)
  x <- gsub("\"", '&quot;', x)
  x <- gsub("\r", '&#13;', x)
  x <- gsub("\n", '&#10;', x)
  x
}

p <- function(...) {
  args <- list(...)
  attribs <- html_attributes(named(args))
  children <- unlist(escape(unnamed(args)))

  html(paste0(
    "<p", attribs, ">",
    paste(children, collapse = ""),
    "</p>"
  ))
}

tag <- function(tag) {
  force(tag)
  function(...) {
    args <- list(...)
    attribs <- html_attributes(named(args))
    children <- unlist(escape(unnamed(args)))

    html(paste0(
      "<", tag, attribs, ">",
      paste(children, collapse = ""),
      "</", tag, ">"
    ))
  }
}

void_tag <- function(tag) {
  force(tag)
  function(...) {
    args <- list(...)
    if (length(unnamed(args)) > 0) {
      stop("Tag ", tag, " can not have children", call. = FALSE)
    }
    attribs <- html_attributes(named(args))

    html(paste0("<", tag, attribs, " />"))
  }
}

