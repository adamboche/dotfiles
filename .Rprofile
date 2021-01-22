## https://kevinushey.github.io/blog/2015/02/02/rprofile-essentials/



## warn on partial matches
options(warnPartialMatchAttr = TRUE,
        warnPartialMatchDollar = TRUE,
        warnPartialMatchArgs = TRUE)

## enable autocompletions for package names in
## `require()`, `library()`
utils::rc.settings(ipck = TRUE)

## warnings are errors
## options(warn = 2)

## fancy quotes are annoying and lead to
## 'copy + paste' bugs / frustrations
options(useFancyQuotes = FALSE)

## Firstly, if you haven’t done this already, you should prefer putting every object you create in your .Rprofile within its own environment, and then attaching that environment to the search path, like so:
.__Rprofile_env__. <- new.env(parent = emptyenv())
## ... fill .__Rprofile_env__. with stuff ...
attach(.__Rprofile_env__.)


## print library paths on startup
if (length(.libPaths()) > 1) {
  msg <- "Using libraries at paths:\n"
} else {
  msg <- "Using library at path:\n"
}
libs <- paste("-", .libPaths(), collapse = "\n")
message(msg, libs, sep = "")


## Don’t Let R Blow Up your Console
## Did you really want to see all 10000 elements of that list? Probably not, right? Use:
options(max.print = 1000)

# Set terminal width.
options("width"=200)
