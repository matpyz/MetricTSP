# Copyright (c) 2017 Mateusz K. Pyzik, all rights reserved.
include("EnableLocalModules.jl")

using GraphParser
using Christofides
using MinimumCostPerfectMatching
using MinimumCostPerfectMatchingMIP


function calculateTest(fileName)
  (G, w) = parseGraphVLSI(fileName)
  tic()
  solution = christofides(G, w, minimumCostPerfectMatching)
  t1 = toq()
  (G, w) = parseGraphVLSI(fileName)
  tic()
  solution = christofides(G, w, minimumCostPerfectMatchingMIP)
  t2 = toq()
  cost = 0
  println(solution)
  n = length(solution)
  for i = 1:n-1
    u = min(solution[i], solution[i+1])
    v = max(solution[i], solution[i+1])
    cost += w[u,v]
  end
#  println("Cost of solution: $cost")
  return n, cost, t1, t2
end

dirPath = pwd()
#files = ["berlin52.tsp", "lin105.tsp", "kroA100.tsp", "kroB100.tsp", "kroC100.tsp",
#        "kroD100.tsp", "kroE100.tsp", "pr76.tsp", "rat99.tsp",
#        "eil101.tsp", "eil76.tsp", "st70.tsp", "eil51.tsp"]

function correctnessTest(files)
  for file in files
    fileName = string(dirPath, file)
    n, cost, _, _ = calculateTest(fileName)
    expName = replace(file, ".tsp", "")
    optCost = Opts[expName]
    err = cost  / optCost
    costString = @sprintf("%0.5f", cost)
    errString = @sprintf("%0.5f", err)
    println(" $(expName) & $(n) & $(costString) &  $(optCost) & $(errString) \\\\ \\hline")
  end
end

function timeTest(files)
  for file in files
    fileName = string(dirPath, file)
    n, _, t1, t2 = calculateTest(fileName)
    expName = replace(file, ".tsp", "")
    t1String = @sprintf("%0.6f", t1)
    t2String = @sprintf("%0.6f", t2)
    println(" $(expName) & $(n) & $(t1String) &  $(t2String)  \\\\ \\hline")
  end
end

correctnessTest(avalaibleToTest[31:40])

timeTest(avalaibleToTest[1:10])


Opts = Dict(
"a280" => 2579,
"ali535" => 202339,
"att48" => 10628,
"att532" => 27686,
"bayg29" => 1610,
"bays29" => 2020,
"berlin52" => 7542,
"bier127" => 118282,
"brazil58" => 25395,
"brd14051" => 469385,
"brg180" => 1950,
"burma14" => 3323,
"ch130" => 6110,
"ch150" => 6528,
"d198" => 15780,
"d493" => 35002,
"d657" => 48912,
"d1291" => 50801,
"d1655" => 62128,
"d2103" => 80450,
"d15112" => 1573084,
"d18512" => 645238,
"dantzig42" => 699,
"dsj1000" => 18659688,
"eil51" => 426,
"eil76" => 538,
"eil101" => 629,
"fl417" => 11861,
"fl1400" => 20127,
"fl1577" => 22249,
"fl3795" => 28772,
"fri26" => 937,
"gil262" => 2378,
"fnl4461" => 182566,
"gr17" => 2085,
"gr21" => 2707,
"gr24" => 1272,
"gr48" => 5046,
"gr96" => 55209,
"gr120" => 6942,
"gr137" => 69853,
"gr202" => 40160,
"gr229" => 134602,
"gr431" => 171414,
"gr666" => 294358,
"hk48" => 11461,
"kroA100" => 21282,
"kroB100" => 22141,
"kroC100" => 20749,
"kroD100" => 21294,
"kroE100" => 22068,
"kroA150" => 26524,
"kroB150" => 26130,
"kroB200" => 29437,
"kroA200" => 29368,
"lin105" => 14379,
"lin318" => 42029,
"linhp318" => 41345,
"nrw1379" => 56638,
"p654" => 34643,
"pa561" => 2763,
"pcb442" => 50778,
"pcb1173" => 56892,
"pcb3038" => 137694,
"pla7397" => 23260728,
"pla33810" => 66048945,
"pla85900" => 142382641,
"pr76" => 108159,
"pr107" => 44303,
"pr124" => 59030,
"pr136" => 96772,
"pr144" => 58537,
"pr226" => 80369,
"pr152" => 73682,
"pr264" => 49135,
"pr299" => 48191,
"pr439" => 107217,
"pr1002" => 259045,
"pr2392" => 378032,
"rat195" => 2323,
"rat99" => 1211,
"rat575" => 6773,
"rat783" => 8806,
"rd100" => 7910,
"rd400" => 15281,
"rl1304" => 252948,
"rl1323" => 270199,
"rl1889" => 316536,
"rl5915" => 565530,
"rl5934" => 556045,
"rl11849" => 923288,
"si175" => 21407,
"si535" => 48450,
"si1032" => 92650,
"st70" => 675,
"ts225" => 126643,
"swiss42" => 1273,
"tsp225" => 3916,
"u159" => 42080,
"u574" => 36905,
"u724" => 41910,
"u1060" => 224094,
"u1432" => 152970,
"u1817" => 57201,
"u2152" => 64253,
"u2319" => 234256,
"ulysses16" => 6859,
"ulysses22" => 7013,
"usa13509" => 19982859,
"vm1084" => 239297,
"vm1748" => 336556
)


avalaibleToTest = [
"eil51.tsp",
"st70.tsp",
"eil76.tsp",
"berlin52.tsp",
"eil101.tsp",
"rat99.tsp",
"pr76.tsp",
"kroD100.tsp",
"kroC100.tsp",
"kroE100.tsp",
"kroA100.tsp",
"kroB100.tsp",
"lin105.tsp",
"pr107.tsp",
"pr124.tsp",
"kroB150.tsp",
"kroA150.tsp",
"pr136.tsp",
"pr144.tsp",
"pr152.tsp",
"rat195.tsp",
"bier127.tsp",
"kroA200.tsp",
"rd100.tsp",
"gil262.tsp",
"pr226.tsp",
"a280.tsp",
"ts225.tsp",
"pr264.tsp",
"tsp225.tsp",
"pr299.tsp",
"lin318.tsp",
"linhp318.tsp",
"ch130.tsp",
"u159.tsp",
"ch150.tsp",
"pr439.tsp",
"rat575.tsp",
"rat783.tsp",
"rd400.tsp",
"fl417.tsp",
"pcb442.tsp",
"d493.tsp",
"pr1002.tsp",
"p654.tsp",
"d657.tsp",
"u574.tsp",
"u724.tsp",
"u1060.tsp",
"vm1084.tsp",
"nrw1379.tsp",
"pcb1173.tsp",
"d1291.tsp",
"rl1323.tsp",
"rl1304.tsp",
"fl1400.tsp",
"u1432.tsp",
"fl1577.tsp",
"d1655.tsp",
"vm1748.tsp",
"u1817.tsp",
"rl1889.tsp",
"d2103.tsp",
"u2152.tsp",
"pr2392.tsp",
"pcb3038.tsp",
"fnl4461.tsp",
"fl3795.tsp",
"rl5915.tsp",
"rl5934.tsp",
"d15112.tsp",
"brd14051.tsp",
"rl11849.tsp",
"usa13509.tsp",
"d18512.tsp"
]
