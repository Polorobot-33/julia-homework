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

function question2()
    all = combine(groupby(df, ["prenom", "genre"]), nrow => "count")
    unique = count(groupby(df, "prenom"))
end