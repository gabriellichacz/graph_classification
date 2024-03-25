#############################_Libraries_##########################
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
getwd()
Sys.setenv(LANG = "en")

if (!("igraph" %in% rownames(installed.packages()))) install.packages("igraph")
library(igraph)

#############################_Graphs_#######################
# # Directed graph
# graph_directed <- graph.formula(A -+ B, B -+ C, C -+ A)
# plot(graph_directed, main = "Directed graphy")

# # Undirected graph
# graph_undirected <- graph.formula(A -- B, B -- C, C -- A)
# plot(graph_undirected, main = "Undirected graph")

#############################_Graphs_undirected_directed_#######################
path_name_unlabeled_undirected <- "unlabeled_undirected"
path_name_rest <- "rest"
dir.create(path_name_unlabeled_undirected, showWarnings = FALSE)
dir.create(path_name_rest, showWarnings = FALSE)

# 50 random unlabeled and undirected graphs ------------------ main interest
for (i in 1:50) {
  graph_unlabeled_undirected <- erdos.renyi.game(10, 0.2, directed = FALSE)
  V(graph_unlabeled_undirected)$name <- sample(LETTERS, vcount(graph_unlabeled_undirected))
  E(graph_unlabeled_undirected)$weight <- runif(ecount(graph_unlabeled_undirected))
  png(file.path(path_name_unlabeled_undirected, paste0(path_name_unlabeled_undirected, "-", i, ".png")), width = 800, height = 600)
  plot(graph_unlabeled_undirected)
  dev.off()
}

# 50 random undirected graphs
for (i in 1:50) {
  graph_undirected <- erdos.renyi.game(10, 0.2) # 10 wierzchołków
  png(file.path(path_name_rest, paste0(path_name_rest, "-undirected-", i, ".png")), width = 800, height = 600)
  plot(graph_undirected)
  dev.off()
}

# 50 random directed graphs
for (i in 1:50) {
  graph_directed <- erdos.renyi.game(10, 0.2, directed = TRUE) # 10 wierzchołków
  png(file.path(path_name_rest, paste0(path_name_rest, "-directed-", i, ".png")), width = 800, height = 600)
  plot(graph_directed)
  dev.off()
}

# 50 random labeled and directed graphs
for (i in 1:50) {
  graph_labeled_directed <- erdos.renyi.game(10, 0.2, directed = TRUE) # 10 wierzchołków
  V(graph_labeled_directed)$name <- sample(LETTERS, vcount(graph_labeled_directed))
  E(graph_labeled_directed)$weight <- runif(ecount(graph_labeled_directed))
  png(file.path(path_name_rest, paste0(path_name_rest, "-labeled_directed-", i, ".png")), width = 800, height = 600)
  plot(graph_labeled_directed)
  dev.off()
}

# 50 random labeled and undirected graphs
for (i in 1:50) {
  graph_labeled_undirected <- erdos.renyi.game(10, 0.2, directed = FALSE) # 10 wierzchołków
  V(graph_labeled_undirected)$name <- sample(LETTERS, vcount(graph_labeled_undirected))
  E(graph_labeled_undirected)$weight <- runif(ecount(graph_labeled_undirected))
  png(file.path(path_name_rest, paste0(path_name_rest, "-labeled_undirected-", i, ".png")), width = 800, height = 600)
  plot(graph_labeled_undirected)
  dev.off()
}