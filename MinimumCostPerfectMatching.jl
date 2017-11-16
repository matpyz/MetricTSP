# Copyright (c) 2017 Mateusz K. Pyzik, all rights reserved.
include("EnableLocalModules.jl")
module MinimumCostPerfectMatching
export minimumCostPerfectMatching

using JuMP
using GLPKMathProgInterface
using Graphs

# FIXME napisz algorytm ze schematu prymalno-dualnego
function minimumCostPerfectMatching(G :: Graph, w) :: Graph
  n = order(G)
  M = Graph(n)
  E = collect(edges(G))
  m = Model(solver = GLPKSolverMIP())
  @variables m begin
    x[u = 1:n, v in keys(G.adj[u]); u < v], Bin
  end
  @objective(m, Min, sum(w[u,v]*x[u,v] for (u,v) in E))
  @constraints m begin
    [u=1:n;!isolated(G,u)], sum(u<v? x[u,v]: x[v,u] for (v,_) in G.adj[u]) == 1
  end
  status = solve(m)
  @assert status == :Optimal "Graph is not bipartite"
  x = getvalue(x)
  for (u,v) in E
    if u < v && round(x[u, v]) == 1
      addEdge!(M, u, v)
    end
  end
  return M
end

end
