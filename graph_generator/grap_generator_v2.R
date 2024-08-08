#############################_Libraries_##########################
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
getwd()
Sys.setenv(LANG = "en")

if (!("igraph" %in% rownames(installed.packages()))) install.packages("igraph")
library(igraph)

#############################_Graph_generation_#######################
#' Losowy obrót dla rysunku grafu - layout_in_circle() psuje losowość
#'
#' @param graph List
#' @return matrix
#'
randomLayout <- function(graph)
{
  rotation <- runif(1, 0, 2*pi)
  layout <- layout_in_circle(graph)
  return(cbind(cos(rotation) * layout[,1] - sin(rotation) * layout[,2], sin(rotation) * layout[,1] + cos(rotation) * layout[,2]))
}

#' Tworzy katalog do zapisu grafów
#'
#' @param vertexNo int - liczba wierzchołków
#' @param fileName string - nazwa grafu
#' @return string - ścieżka
#'
createDir <- function(vertexNo, fileName)
{
  dir.create(as.character(vertexNo), showWarnings = FALSE)
  dir.create(file.path(vertexNo, fileName), showWarnings = FALSE)
  pathName <- paste0(vertexNo, '/', fileName)
  unlink(paste0(pathName, "/*"))
  return(pathName)
}

#' Rysuj graf
#'
#' @param graph Graph - Graf do narysowania
#' @param pathName string - Ścieżka
#' @param fileName string - Nazwa pliku
#' @param vertexNo int - liczba wierzchołków
#' @param i int - Numer iteracji
#' @param plotCurve float
#' @return void
#'
plotGraphHelper <- function(graph, pathName, fileName, vertexNo, i, plotCurve)
{
  png(file.path(pathName, paste0(fileName, "-", vertexNo, "-", i, ".png")), width = 800, height = 600)
  plot(graph, vertex.label = NA, edge.curved = plotCurve)
  dev.off()
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
  pathName <- createDir(vertexNo, fileName)
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
    plotGraphHelper(graph, pathName, fileName, vertexNo, i, plotCurve)
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
  pathName <- createDir(vertexNo, fileName)
  for (i in 1:N)
  {
    graph <- make_ring(vertexNo, directed = FALSE)
    plotGraphHelper(graph, pathName, fileName, vertexNo, i, plotCurve)
  }
}

#' Graf pełny N wierzchołków, 100% pewności na połączenie wierzchołków, nieskierowany
#'
#' @param N int - liczba rysunków
#' @param vertexNo int - liczba wierzchołków
#' @param plotCurve float
#' @return void
#'
plotFullGraphs <- function(N, vertexNo, plotCurve)
{
  fileName <- 'full'
  pathName <- createDir(vertexNo, fileName)
  for (i in 1:N)
  {
    graph <- graph.full(vertexNo, directed = FALSE)
    E(graph)$weight <- runif(ecount(graph))
    plotGraphHelper(graph, pathName, fileName, vertexNo, i, plotCurve)
  }
}

#' Graf spójny N wierzchołków
#'
#' @param N int - liczba rysunków
#' @param vertexNo int - liczba wierzchołków
#' @param plotCurve float
#' @return void
#'
plotConnectedGraphs <- function(N, vertexNo, plotCurve)
{
  fileName <- 'connected'
  pathName <- createDir(vertexNo, fileName)
  for (i in 1:N)
  {
    graph <- graph(c(1, 2, 2, 3, 3, 4, 4, 5, 5, 1, 1, round(runif(1, 1, 10)), 2, round(runif(1, 1, 10)), 3, round(runif(1, 1, 10)) , 4, round(runif(1, 1, 10)) , 5, round(runif(1, 1, 10))))
    plotGraphHelper(graph, pathName, fileName, vertexNo, i, plotCurve)
  }
}

#' Graf dwudzielny N wierzchołków
#'
#' @param N int - liczba rysunków
#' @param vertexNo int - liczba wierzchołków
#' @param plotCurve float
#' @return void
#'
plotBipartiteGraphs <- function(N, vertexNo, plotCurve)
{
  fileName <- 'bipartite'
  pathName <- createDir(vertexNo, fileName)
  for (i in 1:N)
  {
    graph <- make_full_bipartite_graph(vertexNo/2, vertexNo/2, directed = FALSE)
    E(graph)$weight <- runif(ecount(graph))
    plotGraphHelper(graph, pathName, fileName, vertexNo, i, plotCurve)
  }
}

#' Graf pusty N wierzchołków
#'
#' @param N int - liczba rysunków
#' @param vertexNo int - liczba wierzchołków
#' @param plotCurve float
#' @return void
#'
plotEmptyGraphs <- function(N, vertexNo, plotCurve)
{
  fileName <- 'empty'
  pathName <- createDir(vertexNo, fileName)
  for (i in 1:N)
  {
    graph <- make_empty_graph(vertexNo, directed = FALSE)
    plotGraphHelper(graph, pathName, fileName, vertexNo, i, plotCurve)
  }
}

#' Graf drzewa N wierzchołków, nieskierowany
#'
#' @param N int - liczba rysunków
#' @param vertexNo int - liczba wierzchołków
#' @param plotCurve float
#' @param treeType string - typ drzewa ("binary", "random")
#' @return void
#'
plotTrees <- function(N, vertexNo, plotCurve, treeType = "random")
{
  fileName <- 'tree'
  pathName <- createDir(vertexNo, fileName)
  
  for (i in 1:N)
  {
    if (treeType == "binary")
    {
      graph <- make_tree(vertexNo, children = 2, mode = "undirected") # Drzewo binarne o liczbie wierzchołków vertexNo
    }
    else if (treeType == "random")
    {
      graph <- sample_tree(vertexNo, directed = FALSE) # Losowe drzewo rozpinające (drzewo losowe)
    }
    else
    {
      stop("Nieznany typ drzewa. Dostępne opcje to 'binary' lub 'random'.")
    }
    E(graph)$weight <- runif(ecount(graph))
    plotGraphHelper(graph, pathName, fileName, vertexNo, i, plotCurve)
  }
}


#' Graf hiper-kostki o N wymiarach
#'
#' @param N int - liczba rysunków
#' @param No int - liczba wymiarów (czyli liczba bitów w ciągach binarnych)
#' @param plotCurve float
#' @return void
#'
plotHypercube <- function(N, No, plotCurve)
{
  fileName <- 'hypercube'
  pathName <- createDir(No, fileName)
  for (i in 1:N)
  {
    graph <- make_graph("cube", dim = N)
    E(graph)$weight <- runif(ecount(graph))
    plotGraphHelper(graph, pathName, fileName, No, i, plotCurve)
  }
}

plotPaths(500, 4, 0.3)
plotCycles(500, 4, 0.3)
plotFullGraphs(500, 4, 0.3)
plotEmptyGraphs(200, 4, 0.3)
plotTrees(500, 4, 0.3, "random")
plotTrees(500, 4, 0.3, "binary")
plotHypercube(500, 4, 0.3)

plotPaths(500, 5, 0.3)
plotCycles(500, 5, 0.3)
plotFullGraphs(500, 5, 0.3)
plotEmptyGraphs(500, 5, 0.3)
plotTrees(500, 5, 0.3, "random")
plotTrees(500, 5, 0.3, "binary")
plotHypercube(500, 5, 0.3)

plotPaths(500, 6, 0.3)
plotCycles(500, 6, 0.3)
plotFullGraphs(500, 6, 0.3)
plotEmptyGraphs(500, 6, 0.3)
plotTrees(500, 6, 0.3, "random")
plotTrees(500, 6, 0.3, "binary")
plotHypercube(500, 6, 0.3)

plotPaths(500, 7, 0.3)
plotCycles(500, 7, 0.3)
plotFullGraphs(500, 7, 0.3)
plotEmptyGraphs(500, 7, 0.3)
plotTrees(500, 7, 0.3, "random")
plotTrees(500, 7, 0.3, "binary")
plotHypercube(500, 7, 0.3)
