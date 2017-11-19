# Copyright (c) 2017 Mateusz K. Pyzik, all rights reserved.
include("EnableLocalModules.jl")
module MinimumCostPerfectMatching
export minimumCostPerfectMatching

# using JuMP
# using GLPKMathProgInterface
using Graphs
using BlossomV

if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

function minimumCostPerfectMatching(G :: Graph, w) :: Graph
  n = order(G)
  E = collect(edges(G))
  M = Graph(n)

  oddVertices = 0
  counter = 0
  mapping = Dict{Int64,Int64}()
  for i in 1:n
      if isodd(degree(G, i))
          oddVertices += 1
          mapping[counter] = i
          counter += 1
      end
  end

  m = Matching(Float64, oddVertices)

  for i in 0:oddVertices-2
      for j in i+1:oddVertices-1
          add_edge(m, i, j, w[mapping[i], mapping[j]])
      end
  end
  solve(m)

  for i in 0:oddVertices - 1
      u = mapping[i]
      v = mapping[get_match(m, i)]
      if u < v
          addEdge!(M, u, v)
      end
  end

  # m1 = Model(solver = GLPKSolverMIP())
  # @variables m1 begin
  #   x[u = 1:n, v in keys(G.adj[u]); u < v], Bin
  # end
  # @objective(m1, Min, sum(w[u,v]*x[u,v] for (u,v) in E))
  # @constraints m1 begin
  #   [u=1:n;!isolated(G,u)], sum(u<v? x[u,v]: x[v,u] for (v,_) in G.adj[u]) == 1
  # end
  #
  # status = solve(m1)
  # @assert status == :Optimal "Graph is not bipartite"
  # x = getvalue(x)
  # for (u,v) in E
  #   if u < v && round(x[u, v]) == 1
  #     addEdge!(M, u, v)
  #   end
  # end
  return M
end

end
