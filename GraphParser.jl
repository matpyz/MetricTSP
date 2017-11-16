# Copyright (c) 2017 Mateusz K. Pyzik, all rights reserved.
include("EnableLocalModules.jl")
module GraphParser
export parseGraphVLSI

using Graphs

Weights = Dict{Tuple{Int,Int},Float64}

function euclidNorm(x1, y1, x2, y2) :: Float64
    return sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function parseGraphVLSI(filePath :: String) :: Tuple{Graph, Weights}
    return open(filePath) do handle
        row = readline(handle)
        row = readline(handle)
        splitedRow = split(row)
        while splitedRow[1] == "COMMENT" || splitedRow[1] == "COMMENT:"
            row = readline(handle)
            splitedRow = split(row)
        end
        row = readline(handle)
        splitedRow = split(row)
        n = parse(Int, splitedRow[length(splitedRow)])
        for i in 1:3
            row = readline(handle)
        end
        w = Weights()
        locations = []
        for i in 1:n
            splitedRow = split(row)
            x = parse(Float64, splitedRow[2])
            y = parse(Float64, splitedRow[3])
            push!(locations, (x, y))
            row = readline(handle)
        end
        for i = 1:n-1, j = i+1:n
            (x1, y1) = locations[i]
            (x2, y2) = locations[j]
            w[i,j] = euclidNorm(x1, y1, x2, y2)
        end
        return (completeGraph(n), w)
    end
end

end
