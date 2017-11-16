# Copyright (c) 2017 Mateusz K. Pyzik, all rights reserved.
include("EnableLocalModules.jl")
module DisjointSets
export Forest, find!, join!

type Forest
  parent :: Vector{Int}
  rank :: Vector{Int}
end

function Forest(n :: Int)
  return Forest(collect(1:n), zeros(Int, n))
end

function find!(S :: Forest, x :: Int) :: Int
  while S.parent[x] ≠ x
    x = S.parent[x] = S.parent[S.parent[x]]
  end
  return x
end

function join!(S :: Forest, x :: Int, y :: Int) :: Void
  x = find!(S, x)
  y = find!(S, y)
  if x ≠ y
    if S.rank[x] < S.rank[y]
      S.parent[x] = y
    elseif S.rank[x] > S.rank[y]
      S.parent[y] = x
    else
      S.parent[y] = x
      S.rank[x] += 1
    end
  end
  return
end

end
