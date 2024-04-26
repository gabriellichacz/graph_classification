#############################_Libraries_##########################
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
getwd()
Sys.setenv(LANG = "en")

if (!("igraph" %in% rownames(installed.packages()))) install.packages("igraph")
library(igraph)

#############################_Graph_generation_#######################
#' Losowy obrót dla rysunku grafu - layout_in_circle() psuje losowość
#'
#' @param List graph
#' @return matrix
#'
randomLayout <- function(graph)
{
  rotation <- runif(1, 0, 2*pi)
  layout <- layout_in_circle(graph)
  return(cbind(cos(rotation) * layout[,1] - sin(rotation) * layout[,2], sin(rotation) * layout[,1] + cos(rotation) * layout[,2]))
}

#' Graf ścieżka N wierzchołków, nieskierowany
#'
#' @param N int - liczba rysunków
#' @param vertexNo int - liczba wierzchołków
#' @param plotCurve float
#' @return void
#'
plotPaths <- function(N, vertexNo, plotCurve)
{
  fileName <- 'path'
  dir.create(fileName, showWarnings = FALSE)
  dir.create(file.path(fileName, vertexNo), showWarnings = FALSE)
  
  pathName <- paste0(fileName, '/', vertexNo)
  unlink(paste0(pathName, "/*"))
  
  definition <- c()
  for (index in 1:(vertexNo-1))
  {
    definition <- c(definition, index, index + 1)
  }
  definitionMatrix <- matrix(definition, ncol = 2, byrow = TRUE)
  
  for (i in 1:N)
  {
    graph <- graph_from_edgelist(definitionMatrix, directed = FALSE)
    E(graph)$weight <- runif(ecount(graph))
    png(file.path(pathName, paste0(fileName, "-", i, ".png")), width = 800, height = 600)
    plot(graph, vertex.label = NA, edge.curved = plotCurve)
    # plot(graph, vertex.label = NA, edge.curved = plotCurve, layout = randomLayout(graph)) # Bez opisów wierzchołków, zakrzywienie krawędzi, losowy obrót
    dev.off()
  }
}

#' Graf cykliczny N wierzchołków, 100% pewności na połączenie wierzchołków, nieskierowany
#'
#' @param N int - liczba rysunków
#' @param vertexNo int - liczba wierzchołków
#' @param plotCurve float
#' @return void
#'
plotCycles <- function(N, vertexNo, plotCurve)
{
  fileName <- 'cycle'
  dir.create(fileName, showWarnings = FALSE)
  dir.create(file.path(fileName, vertexNo), showWarnings = FALSE)
  
  pathName <- paste0(fileName, '/', vertexNo)
  unlink(paste0(pathName, "/*"))
  
  for (i in 1:N)
  {
    graph <- make_ring(vertexNo, directed = FALSE)
    png(file.path(pathName, paste0(fileName, "-", i, ".png")), width = 800, height = 600)
    plot(graph, vertex.label = NA, edge.curved = plotCurve)
    dev.off()
  }
}

#' Graf pełny N wierzchołków, 100% pewności na połączenie wierzchołków, nieskierowany
#'
#' @param N int - liczba rysunków
#' @param vertexNo int - liczba wierzchołków
#' @param plotCurve float
#' @return voided
#'
plotFullGraphs <- function(N, vertexNo, plotCurve)
{
  fileName <- 'full'
  dir.create(fileName, showWarnings = FALSE)
  dir.create(file.path(fileName, vertexNo), showWarnings = FALSE)
  
  pathName <- paste0(fileName, '/', vertexNo)
  unlink(paste0(pathName, "/*"))
  
  for (i in 1:N)
  {
    graph <- graph.full(vertexNo, directed = FALSE)
    E(graph)$weight <- runif(ecount(graph))
    png(file.path(pathName, paste0(fileName, "-", i, ".png")), width = 800, height = 600)
    plot(graph, vertex.label = NA, edge.curved = plotCurve)
    dev.off()
  }
}

plotPaths(200, 4, 0.3)
plotCycles(200, 4, 0.3)
plotFullGraphs(200, 4, 0.3)

plotPaths(200, 5, 0.3)
plotCycles(200, 5, 0.3)
plotFullGraphs(200, 5, 0.3)

plotPaths(200, 6, 0.3)
plotCycles(200, 6, 0.3)
plotFullGraphs(200, 6, 0.3)

plotPaths(200, 7, 0.3)
plotCycles(200, 7, 0.3)
plotFullGraphs(200, 7, 0.3)

