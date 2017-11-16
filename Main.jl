# Copyright (c) 2017 Mateusz K. Pyzik, all rights reserved.
include("EnableLocalModules.jl")

using GraphParser
using Christofides

filePath = input("Enter file name:")
(G, w) = parseGraphVLSI(filePath)
solution = christofides(G, w)
cost = 0
println(solution)
# for i = 1:n-1
#   u = min(p[i], p[i+1])
#   v = max(p[i], p[i+1])
#   cost += w[u,v]
# end
# println("Cost of solution: $cost")
