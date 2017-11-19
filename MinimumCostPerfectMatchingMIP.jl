# Copyright (c) 2017 Mateusz K. Pyzik, all rights reserved.
include("EnableLocalModules.jl")
module MinimumCostPerfectMatchingMIP
export minimumCostPerfectMatchingMIP

using JuMP
using GLPKMathProgInterface
using Graphs

function minimumCostPerfectMatchingMIP(G :: Graph, w) :: Graph
  n = order(G)
  E = collect(edges(G))
  M = Graph(n)

  m1 = Model(solver = GLPKSolverMIP())
  @variables m1 begin
    x[u = 1:n, v in keys(G.adj[u]); u < v], Bin
  end
  @objective(m1, Min, sum(w[u,v]*x[u,v] for (u,v) in E))
  @constraints m1 begin
    [u=1:n;!isolated(G,u)], sum(u<v? x[u,v]: x[v,u] for (v,_) in G.adj[u]) == 1
  end

  status = solve(m1)
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
