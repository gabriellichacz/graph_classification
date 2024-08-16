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
  dir.create(paste0('random-curve/', as.character(vertexNo)), showWarnings = FALSE)
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

#' Liczba losowa z rozkładu normalnego
#'
#' @param minVal float - minimalna wartość
#' @param maxVal float - maksylamna wartość
#' @return float
#'
generateGaussian <- function(minVal, maxVal)
{
  z <- sqrt(-2 * log(runif(1))) * cos(2 * pi * runif(1))
  gaussian_num <- 0.5 * (z + 1) * (maxVal - minVal) + minVal
  gaussian_num <- pmin(pmax(gaussian_num, 0.01), 0.99)
  return(gaussian_num)
}

#' Graf ścieżka N wierzchołków, nieskierowany
#'
#' @param N int - liczba rysunków
#' @param vertexNo int - liczba wierzchołków
#' @return void
#'
plotPaths <- function(N, vertexNo)
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
    plotCurve <- generateGaussian(0.01, 0.99)
    graph <- graph_from_edgelist(definitionMatrix, directed = FALSE)
    E(graph)$weight <- runif(ecount(graph))
    plotGraphHelper(graph, pathName, fileName, vertexNo, i, plotCurve)
  }
}

#' Graf cykliczny N wierzchołków, 100% pewności na połączenie wierzchołków, nieskierowany
#'
#' @param N int - liczba rysunków
#' @param vertexNo int - liczba wierzchołków
#' @return void
#'
plotCycles <- function(N, vertexNo)
{
  fileName <- 'cycle'
  pathName <- createDir(vertexNo, fileName)
  for (i in 1:N)
  {
    plotCurve <- generateGaussian(0.01, 0.99)
    graph <- make_ring(vertexNo, directed = FALSE)
    plotGraphHelper(graph, pathName, fileName, vertexNo, i, plotCurve)
  }
}

#' Graf pełny N wierzchołków, 100% pewności na połączenie wierzchołków, nieskierowany
#'
#' @param N int - liczba rysunków
#' @param vertexNo int - liczba wierzchołków
#' @return void
#'
plotFullGraphs <- function(N, vertexNo)
{
  fileName <- 'full'
  pathName <- createDir(vertexNo, fileName)
  for (i in 1:N)
  {
    plotCurve <- generateGaussian(0.01, 0.99)
    graph <- graph.full(vertexNo, directed = FALSE)
    E(graph)$weight <- runif(ecount(graph))
    plotGraphHelper(graph, pathName, fileName, vertexNo, i, plotCurve)
  }
}

#' Graf spójny N wierzchołków
#'
#' @param N int - liczba rysunków
#' @param vertexNo int - liczba wierzchołków
#' @return void
#'
plotConnectedGraphs <- function(N, vertexNo)
{
  fileName <- 'connected'
  pathName <- createDir(vertexNo, fileName)
  for (i in 1:N)
  {
    plotCurve <- generateGaussian(0.01, 0.99)
    graph <- graph(c(1, 2, 2, 3, 3, 4, 4, 5, 5, 1, 1, round(runif(1, 1, 10)), 2, round(runif(1, 1, 10)), 3, round(runif(1, 1, 10)) , 4, round(runif(1, 1, 10)) , 5, round(runif(1, 1, 10))))
    plotGraphHelper(graph, pathName, fileName, vertexNo, i, plotCurve)
  }
}

#' Graf dwudzielny N wierzchołków
#'
#' @param N int - liczba rysunków
#' @param vertexNo int - liczba wierzchołków
#' @return void
#'
plotBipartiteGraphs <- function(N, vertexNo)
{
  fileName <- 'bipartite'
  pathName <- createDir(vertexNo, fileName)
  for (i in 1:N)
  {
    plotCurve <- generateGaussian(0.01, 0.99)
    graph <- make_full_bipartite_graph(vertexNo/2, vertexNo/2, directed = FALSE)
    E(graph)$weight <- runif(ecount(graph))
    plotGraphHelper(graph, pathName, fileName, vertexNo, i, plotCurve)
  }
}

#' Graf pusty N wierzchołków
#'
#' @param N int - liczba rysunków
#' @param vertexNo int - liczba wierzchołków
#' @return void
#'
plotEmptyGraphs <- function(N, vertexNo)
{
  fileName <- 'empty'
  pathName <- createDir(vertexNo, fileName)
  for (i in 1:N)
  {
    plotCurve <- generateGaussian(0.01, 0.99)
    graph <- make_empty_graph(vertexNo, directed = FALSE)
    plotGraphHelper(graph, pathName, fileName, vertexNo, i, plotCurve)
  }
}

#' Graf drzewa N wierzchołków, nieskierowany
#'
#' @param N int - liczba rysunków
#' @param vertexNo int - liczba wierzchołków
#' @param treeType string - typ drzewa ("binary", "random")
#' @return void
#'
plotTrees <- function(N, vertexNo, treeType = "random")
{
  fileName <- paste0('tree-', treeType)
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
    plotCurve <- generateGaussian(0.01, 0.99)
    E(graph)$weight <- runif(ecount(graph))
    plotGraphHelper(graph, pathName, fileName, vertexNo, i, plotCurve)
  }
}

#' Graf hiper-kostki o N wymiarach
#'
#' @param N int - liczba rysunków
#' @param No int - liczba wymiarów (czyli liczba bitów w ciągach binarnych)
#' @return void
#'
plotHypercube <- function(N, No) {
  fileName <- 'hypercube'
  pathName <- createDir(No, fileName)
  generate_hypercube_edges <- function(dim)
  {
    num_vertices <- 2^dim
    edges <- matrix(nrow = 0, ncol = 2)
    vertices <- expand.grid(rep(list(c(0, 1)), dim))
    vertices <- as.matrix(vertices)
    for (i in 1:(num_vertices - 1))
    {
      for (j in (i + 1):num_vertices)
      {
        if (sum(vertices[i, ] != vertices[j, ]) == 1)
        {
          edges <- rbind(edges, c(i, j))
        }
      }
    }
    return(edges)
  }
  
  for (i in 1:N)
  {
    plotCurve <- generateGaussian(0.01, 0.99)
    edges <- generate_hypercube_edges(No)
    graph <- graph_from_edgelist(edges, directed = FALSE)
    E(graph)$weight <- runif(ecount(graph))
    plotGraphHelper(graph, pathName, fileName, No, i, plotCurve)
  }
}

plotPaths(500, 4)
plotCycles(500, 4)
plotFullGraphs(500, 4)
plotEmptyGraphs(200, 4)
# plotTrees(500, 4, "random")
plotTrees(500, 4, "binary")
# plotHypercube(500, 4)

plotPaths(500, 5)
plotCycles(500, 5)
plotFullGraphs(500, 5)
plotEmptyGraphs(500, 5)
# plotTrees(500, 5, "random")
plotTrees(500, 5, "binary")
# plotHypercube(500, 5)

plotPaths(500, 6)
plotCycles(500, 6)
plotFullGraphs(500, 6)
plotEmptyGraphs(500, 6)
# plotTrees(500, 6, "random")
plotTrees(500, 6, "binary")
# plotHypercube(500, 6)

plotPaths(500, 7)
plotCycles(500, 7)
plotFullGraphs(500, 7)
plotEmptyGraphs(500, 7)
# plotTrees(500, 7, "random")
plotTrees(500, 7, "binary")
# plotHypercube(500, 7)
