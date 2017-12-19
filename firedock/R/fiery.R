#' @importFrom routr RouteStack
router <- RouteStack$new()

#' @importFrom routr Route
route <- Route$new()
route$add_handler('get', '/hello/:what/', function(request, response, keys, ...) {
  response$status <- 200L
  response$type <- 'html'
  response$body <- paste0('<h1>Hello ', keys$what, '!</h1>')
  return(FALSE)
})

route$add_handler('get', '/*', function(request, response, keys, ...) {
  response$status <- 200L
  response$type <- 'html'
  response$body <- '<h1>I\'m not saying hello to you</h1><p>but here is a plot</p><img src="plot.png" alt="A plot">'
  return(FALSE)
})

route$add_handler('get', '/*/plot.png', function(request, response, keys, ...) {
  tmpfile <- tempfile(fileext = '.png')
  png(tmpfile)
  plot(runif(1e4), rnorm(1e4), col = sample(colors(), 1e4, replace = TRUE))
  dev.off()
  response$file <- tmpfile
  response$status <- 200L
  return(FALSE)
})

router$add_route(route, 'main')

#' The main app
#' 
#' This is a fiery instance that can be run with `ignite()`. See [fiery::Fire]
#' 
#' @importFrom fiery Fire
#' @export
app <- Fire$new(host = '0.0.0.0', port = 8080)
app$root <- Sys.getenv('FIERY_ROOT')
app$attach(router)

#' @importFrom fiery logger_console
app$set_logger(logger_console())
