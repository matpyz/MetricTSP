# Copyright (c) 2017 Mateusz K. Pyzik, all rights reserved.
include("EnableLocalModules.jl")
module MinimumSpanningTree
export minimumSpanningTree

using Graphs
using DisjointSets

# Kruskal's algorithm
function minimumSpanningTree(G :: Graph, w) :: Graph
  n = order(G)
  T = Graph(n)
  S = Forest(n)
  E = sort!(collect(edges(G)), by = e -> w[e])
  for (u, v) ∈ E
    if find!(S, u) ≠ find!(S, v)
      addEdge!(T, u, v)
      join!(S, u, v)
    end
  end
  return T
end

end
