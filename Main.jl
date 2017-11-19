# Copyright (c) 2017 Mateusz K. Pyzik, all rights reserved.
include("EnableLocalModules.jl")

using GraphParser
using Christofides

filePath = input("Enter file name:")
(G, w) = parseGraphVLSI(filePath)
time = @time solution = christofides(G, w)
println("Time: ", time)
cost = 0
println(solution)
n = length(solution)
for i = 1:n-1
  u = min(solution[i], solution[i+1])
  v = max(solution[i], solution[i+1])
  cost += w[u,v]
end
println("Cost of solution: $cost")
