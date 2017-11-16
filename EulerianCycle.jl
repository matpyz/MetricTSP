# Copyright (c) 2017 Mateusz K. Pyzik, all rights reserved.
include("EnableLocalModules.jl")
module EulerianCycle
export eulerianCycleWithShortcuts!

using Graphs

function eulerianCycleWithShortcuts!(G :: Graph) :: Vector{Int}
  n = order(G)
  C = findCycles!(G)
  return combineCycles!(n, C)
end

function findCycles!(G :: Graph) :: Dict{Int,Dict{Int,Int}}
  n = order(G)
  C = Dict{Int,Dict{Int,Int}}()
  V = Set{Int}([1])
  while !isempty(V)
    u = pop!(V)
    v = u
    c = Dict{Int,Int}()
    counter = 0
    while !isolated(G, v)
      w = pickEdge!(G, v)
      removeEdge!(G, v, w)
      v = w
      push!(V, v)
      c[counter += 1] = v
    end
    @assert u == v "Graph is not Eulerian"
    delete!(V, u)
    delete!(c, counter)
    C[u] = c
  end
  return C
end

function combineCycles!(n :: Int, C :: Dict{Int,Dict{Int,Int}}) :: Vector{Int}
  S = Dict{Int,Tuple{Dict{Int,Int},Int}}()
  P = Vector{Int}(n)
  top = 0
  out = 0
  S[top += 1] = (C[1], 1)
  P[out += 1] = 1
  delete!(C, 1)
  while top > 0
    (c, i) = S[top]
    top -= 1
    while haskey(c, i)
      u = c[i]
      i += 1
      if haskey(C, u)
        S[top += 1] = (c, i)
        S[top += 1] = (C[u], 1)
        P[out += 1] = u
        delete!(C, u)
        break
      end
    end
  end
  @assert out == n "Graph is not connected"
  return P
end

end
