# Copyright (c) 2017 Mateusz K. Pyzik, all rights reserved.
include("EnableLocalModules.jl")
module GraphParser
export parseWeightedGraph

using Graphs

Weights = Dict{Tuple{Int,Int},Float64}

# FIXME wczytaj dane z pliku 
function parseGraph(filePath :: String) :: Tuple{Graph, Weights}
  return open(filePath) do handle
    n = rand(100:200) # FIXME wczytaj z pliku
    w = Weights()
    for i = 1:n-1, j = i+1:n
      w[i,j] = rand(10:50) # FIXME wczytaj z pliku
    end
    return (completeGraph(n), w)
  end
end
