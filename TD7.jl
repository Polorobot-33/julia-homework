#Exercice 1

using CSV, DataFrames

"""
    loadDataFrame()

permet de visualiser le contenu de la dataframe et de s'assurer
que le fichier est bien chargé
"""
function loadDataFrame()
    df = CSV.read("fr-219200730-prenoms.csv", DataFrame)
end

"""
    prenom_le_plus_commun()

renvoie une tuple contenant le prenom le plus donné à Suresnes entre 2010 et 2021,
ainsi que son nombre d'occurence.
Cette méthode utilise un dictionnaire pour la comptabilisation.
"""
function prenom_le_plus_commun()
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

"""
    prenom_le_plus_commun_bis()

renvoie une tuple contenant le prenom le plus donné à Suresnes entre 2010 et 2021,
ainsi que son nombre d'occurence.
Cette méthode utilise uniquement les opérations sur les DataFrames
"""
function prenom_le_plus_commun_bis()
    df = loadDataFrame()

    gb = combine(groupby(df, "prenom"), nrow)
    info = findmax(combine(groupby(df, "prenom"), nrow).nrow)
    gb.prenom[info[2]], info[1]
end

"""
   proportion_prenoms_epycenes()
   
renvoie la proportion de prénoms épycènes dans l'ensemble des différents prénoms donnés.
"""
function proportion_prenoms_epycenes()
    df = loadDataFrame()

    unique_names = unique(df, ["prenom", "genre"]; keep=:first)
    gender_count = combine(groupby(unique_names, "prenom"), nrow => "nb")
    count_epicenes = nrow(gender_count[gender_count.nb .>= 2, :])
    count_epicenes / nrow(unique(df, ["prenom"]))
end

"""
    generate_firstname(::Int)

renvoie un prénom aléatoire de probabilité proportionnelle à sa fréquence
de l'année year
"""
function generate_firstname(year)
    df = loadDataFrame()
    names = df[df.annee .== year, "prenom"]
    rand(names)
end



# Exercice 3

"""
    loadAndDisplay()

charge et affiche le contenu du fichier "pathways.txt" 
"""
function loadAndDisplay()
    open("pathways.txt", "r") do io
        for l in eachline(io)
            println(l)
        end
    end
end

"""
    loadPaths()

charge le contenu du fichier "pathways.txt"
et renvoie ses caractères sous forme d'une matrice.
"""
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

"""
    findD(::Matrix{Char})

renvoie les coordonnées x et y de l'unique caractère D
"""
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

"""
    connected(::Char, ::Char, ::Int)

renvoie true si on peut aller de la tuile tile1 à la tuile t2 selon la direction direction
et false sinon.
"""
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

"""
    main_path_length()

calcule la longueur de la boucle principale passant par 'D',
et donne aussi le nombre de cases avec des passages droits
"""
function main_path_length()
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

"""
    furthest_point()

affiche les coordonnées et le caractère du point le plus loin de D
dans le chemin principal
"""
function furthest_point()
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

# struct utilisée pour réaliser l'itérateur sur le chemin principal
struct FollowPath
    path::Matrix
    start_direction::Int
    start::Tuple{Int, Int}
end

"""
    Base.iterate(::FollowPath, ::Union{Int, Tuple{Tuple{Int, Int}, Int}})

itérateur sur l'ensemble du chemin débutant à la position f.start
vers la direction f.start_direction
L'itération s'arrête lorsqu'il n'y a plus de chemin à suivre
"""
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