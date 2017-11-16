# Copyright (c) 2017 Mateusz K. Pyzik, all rights reserved.
include("EnableLocalModules.jl")
module Graphs
export Graph, completeGraph, order, degree, edges, isolated
export addEdge!, pickEdge!, removeEdge!, graphUnion!

type Graph
  adj :: Vector{Dict{Int,Int}}
end

function Graph(n :: Int)
  return Graph([Dict{Int,Int}() for i = 1:n])
end

function completeGraph(n :: Int) :: Graph
  return Graph([Dict(j => 1 for j=1:n if j≠i) for i=1:n])
end

function order(G :: Graph) :: Int
  return length(G.adj)
end

function degree(G :: Graph, v :: Int) :: Int
  return sum(values(G.adj[v]))
end

function edges(G :: Graph)
  return @task for u = 1:order(G), (v, k) ∈ G.adj[u]
    if u ≤ v
      for i = 1:k
        produce((u, v))
      end
    end
  end
end

function isolated(G :: Graph, u :: Int) :: Bool
  return isempty(G.adj[u])
end

function addEdge!(G :: Graph, u :: Int, v :: Int) :: Void
  G.adj[u][v] = get!(G.adj[u], v, 0) + 1
  G.adj[v][u] = get!(G.adj[v], u, 0) + 1
  return
end

function pickEdge!(G :: Graph, u :: Int) :: Int
  for (v, k) ∈ G.adj[u]
    return v
  end
end

function removeEdge!(G :: Graph, u :: Int, v :: Int) :: Void
  if (G.adj[u][v] -= 1; G.adj[v][u] -= 1) == 0
    delete!(G.adj[u], v)
    delete!(G.adj[v], u)
  end
  return
end

function graphUnion!(G :: Graph, H :: Graph) :: Void
  for (u, v) ∈ edges(H)
    addEdge!(G, u, v)
  end
  return
end

end
