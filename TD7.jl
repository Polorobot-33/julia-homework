#Exercice 1

using CSV, DataFrames

function loadDataFrame()
    df = CSV.read("fr-219200730-prenoms.csv", DataFrame)
end

function question1()
    df = loadDataFrame()
    #selection from 2010 to 2021
    selection = df[(df.annee .>= 2010) .&& (df.annee .<= 2021), "prenom"]
    dico = Dict()
    max = 0
    maxName = ""
    for name in selection
        if name in keys(dico)
            dico[name] += 1
        else
            dico[name] = 1
        end
        if dico[name] >= max
            max = dico[name]
            maxName = name
        end
    end
    
    maxName, max
end

function question1Bis()
    df = loadDataFrame()

    gb = combine(groupby(df, "prenom"), nrow)
    info = findmax(combine(groupby(df, "prenom"), nrow).nrow)
    gb.prenom[info[2]], info[1]
end

function proportion_prenoms_epycenes()
    df = loadDataFrame()

    unique_names = unique(df, ["prenom", "genre"]; keep=:first)
    gender_count = combine(groupby(unique_names, "prenom"), nrow => "nb")
    count_epicenes = nrow(gender_count[gender_count.nb .>= 2, :])
    count_epicenes / nrow(unique(df, ["prenom"]))
end

function generate_firstname(year)
    df = loadDataFrame()
    names = df[df.annee .== year, "prenom"]
    rand(names)
end



# Exercice 3

function loadAndDisplay()
    open("pathways.txt", "r") do io
        for l in eachline(io)
            println(l)
        end
    end
end

function loadPaths()
    path = Char[]
    width, height = 0, 0

    open("pathways.txt", "r") do io
        for l in eachline(io)
            row = [c for c in l]
            path = [path; row]
            height += 1
            width = max(width, length(l))
        end
    end

    permutedims(reshape(path, (height, width)))
end

function findD(path::Matrix{Char})
    for j = 1:size(path,2)
        for i = 1:size(path,1)
            path[i, j] == 'D' && return (j, i)
        end
    end
end

const UP = 0
const RIGHT = 1
const DOWN = 2
const LEFT = 3

function connected(tile1::Char, tile2::Char, direction::Int)
    if direction == UP
      return (tile1 == '┃' || tile1 == '┛' || tile1 == '┗') && (tile2 == '┃' || tile2 == '┏' || tile2 == '┓')
    elseif direction == RIGHT
        return (tile1 == '━' || tile1 == '┏' || tile1 == '┗') && (tile2 == '━' || tile2 == '┛' || tile2 == '┓')
    elseif direction == DOWN 
        return (tile1 == '┃' || tile1 == '┏' || tile1 == '┓') && (tile2 == '┃' || tile2 == '┛' || tile2 == '┗')
    elseif direction == LEFT
        return (tile1 == '━' || tile1 == '┛' || tile1 == '┓') && (tile2 == '━' || tile2 == '┏' || tile2 == '┗')
    end
end

function offset(direction::Int)
    direction == UP    && return ( 0, -1)
    direction == RIGHT && return ( 1,  0)
    direction == DOWN  && return ( 0,  1)
    direction == LEFT  && return (-1,  0)
    return (0, 0)
end

function oppositeDir(direction)
    (direction + 2) % 4
end

function mainPathLength()
    path = loadPaths()
    D = findD(path)

    len = 1
    count = 0
    for (x, y, c) in FollowPath(path, DOWN, D)
        len += 1
        (c == '━' || c == '┃') && (count += 1)
    end

    println("Le chemin principal fait $(len) cases de long et contient $(count) passages droits")
end

function furthestPoint()
    path = loadPaths()
    D = findD(path)

    total_path = []
    for step in FollowPath(path, DOWN, D)
        push!(total_path, step)
    end

    L = length(total_path)
    x, y, c = total_path[L ÷ 2]
    println("Le point le plus éloigné de D est $c aux coordonnées ($x, $y) et il se trouve à une distance de $(L ÷ 2)")
end

struct FollowPath
    path::Matrix
    start_direction::Int
    start::Tuple{Int, Int}
end

function Base.iterate(f::FollowPath, state=0)
    if state == 0
        x, y = f.start .+ offset(f.start_direction)
        value = x, y, f.path[y, x]
        state = (x, y), f.start_direction
        return value, state
    end

    position, prev_direction = state
    x, y =  position
    width, height = size(f.path)

    for dir in 0:3
        # avoid going backward
        (oppositeDir(dir) == prev_direction) && continue

        nextx, nexty = position .+ offset(dir)

        # stay within the grid
        (nextx < 1 || nextx > width || nexty < 1 || nexty > height) && continue

        if connected(f.path[y, x], f.path[nexty, nextx], dir)
            value = nextx, nexty, f.path[nexty, nextx]
            next_state = ((nextx, nexty), dir)
            return value, next_state
        end
    end

    return nothing
end