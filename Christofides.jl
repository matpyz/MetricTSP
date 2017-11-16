# Copyright (c) 2017 Mateusz K. Pyzik, all rights reserved.
include("EnableLocalModules.jl")
module Christofides
export christofides

using Graphs
using MinimumSpanningTree
using MinimumCostPerfectMatching
using EulerianCycle

# Christofides' algorithm
function christofides(G :: Graph, w)
  T = minimumSpanningTree(G, w)
  O = verticesOfOddDegree(G, T)
  M = minimumCostPerfectMatching(O, w)
  graphUnion!(T, M)
  return eulerianCycleWithShortcuts!(T)
end

function verticesOfOddDegree(G :: Graph, T :: Graph) :: Graph
  n = order(G)
  O = Graph(n)
  for (i, j) ∈ Graphs.edges(G)
    if isodd(degree(T, i)) && isodd(degree(T, j))
      addEdge!(O, i, j)
    end
  end
  return O
end

end
