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

#############################_Graphs_generation_#######################
path_name_undirected <- "undirected"
path_name_directed <- "directed"
dir.create(path_name_undirected, showWarnings = FALSE)
dir.create(path_name_directed, showWarnings = FALSE)

# 50 random undirected graphs
for (i in 1:50) {
  graph_undirected <- erdos.renyi.game(10, 0.2) # 10 wierzchołków
  png(file.path(path_name_undirected, paste0(path_name_directed, "-", i, ".png")), width = 800, height = 600)
  plot(graph_undirected, main = paste("Undirected graph no.", i))
  dev.off()
}

# 50 random directed graphs
for (i in 1:50) {
  graph_directed <- erdos.renyi.game(10, 0.2, directed = TRUE) # 10 wierzchołków
  png(file.path(path_name_directed, paste0(path_name_directed, "-", i, ".png")), width = 800, height = 600)
  plot(graph_directed, main = paste("Directed graph no.", i))
  dev.off()
}
