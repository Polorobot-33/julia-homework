# Exercice 1 :
function syracuse(n)
    u = n
    count = 0
    while u > 1
        count += 1
        u % 2 == 0 || (u ÷= 2;continue)
        u = 3*u + 1
    end
    return count
end

#Exercice 2 :
function isprime_naive(n)
    for i in 2:round(Int, sqrt(n-1))
        n%i != 0 || (return false)
    end
    true
end

function goldbach(isprime, n)
    if n % 2 == 0
        for a in 1:round(Int, sqrt(n))
            if isprime(a) && isprime(n-a) 
                return a, n-a, 0
            end
        end
    else 
        for a in 1:round(Int, sqrt(n))
            n_moins_a = n-a
            isprime(a) || continue
            for b in 1:round(Int, sqrt(n_moins_a))
                if isprime(b) && isprime(n-a-b) 
                    return a, b, n-a-b
                end
            end
        end
    end
    return false
end

#Exercice 3.1
function euler_rec(obj, max, n, j) 
    j==0 && (return obj == 0)
    for a in 1:max
        if euler_rec(obj-a^n, max, n, j-1)
            return true
        end
    end
    return false
end

function contre_exemple_euler(n)
    count = 0
    b = 1
    while (count < 1000) && (~euler_rec(b^n, b, n, n-1))
        b += 1
    end
    if count < 1000
        return b
    end
    return "echec"
end

# Exercice 3.2
function noteuler_rec(b, n, j)
    if ((j == 0) | (b<0)) return (b==0) ? (true) : (false) end

    amax = round(Int, b^(1/n))+1
    for a in 1:amax
        reste = noteuler_rec(b-a^n, n, j-1)
        if reste == true
            return a
        elseif reste != false
            return (a, reste)
        end
    end
    return false
end


function noteuler(n)
    b = 1
    while (b<200)
        resultat = noteuler_rec(b^n, n, n)
        if resultat != false
            println(b, " ", resultat)
            break
        else
            println(b, " fail")
        end
        b += 1
    end
end

# Exercice 4
function conway(n)
    if n <= 1
        return "1"
    end

    u = conway(n-1)
    count = 0
    char = ""
    nextu = ""
    for i in eachindex(u)
        currentchar = u[i]
        if currentchar == char
            count += 1
        else 
            if count > 0 
                nextu *= Char('0'+count) * char
            end
            char = currentchar
            count = 1
        end
    end
    nextu *= Char('0'+count) * char
end

function test_conway(n)
    for i in 1:n
        println(conway(i))
    end
end

# On remarque qu'il n'y a pas de chiffre supérieur à 3

# Exercice 5
function zeta4(T, n; reverse=false, power=:inner)
    sum = 0
    for i in (reverse ? (1:n) : (n:-1:1))
        if power === :inner
            sum += inv(T(i^4))
        elseif power === :outer 
            sum += inv(T(i)^4)
        else 
            sum += T(i)^(-4)
        end
    end
    return sum
end



#zeta4(Float64, 1000000, power=:outer)
#1.0823232337111381
#mean   7.289 ms

#zeta4(Float32, 1000000, power=:outer)
#1.0823232f0
# mean   6.212 ms

#zeta4(Rational{Int}, 1000000)
#ERROR: OverflowError: 2003764205206896640 * 1996229794797103359 overflowed for type Int64

#zeta4(BigFloat, 1000000, power=:outer)
#1.082323233711138191182670863207501236108084451918726907460753993222398393964743
# 436.044 ms

#Ces types permettent d'obtenir une précison ou une taille de nombre théoriquement infinie

#Exercice 6
function Hofstadter_Conway_memoization(n)
    memory = [1, 1]
    function Hofstadter_Conway()
        for i in (length(memory)+1):n
            push!(memory, memory[memory[i-1]] + memory[i-memory[i-1]])
        end
        return memory[n]
    end
    return Hofstadter_Conway()
end

function lim_Hofstadter_Conway(n)
    return Hofstadter_Conway_memoization(n)/n
end

# La suite semble tendre plus ou moins vers 0.5 = 1/2




#Exercice 7

function is_prime_tmp(memoire, j)
    limite = sqrt(j)
    for prime in memoire
        j%prime==0 && return false
        prime>limite && break
    end
    return true
end

function isprime_memoize(n)
    memoire = Int64[2]
    for j in 3:n
        is_prime_tmp(memoire, j) && push!(memoire, j)
    end

    return memoire[end] == n, length(memoire) #memoire[n_memoire] == n, 
end

#Premier / pas premier ?
#16372007 Oui
#16372009 Oui
#16372011 Non

#Exercice 8

"""
    knapsack_glouton_1(N::Int)

    algoritme glouton pour le probleme du sac à dos
    priorise la valeur des objets
"""
function knapsack_glouton_1(N)
    weights = [i + i÷2 + 2(i%2) - i%3 for i in 1:N]
    costs = [3i for i in 1:N]
    indices = reverse(sortperm(costs))

    wmax = N^2÷2

    sac = Int16[]
    weight = 0
    cost = 0
    for i in 1:N
        w = weights[indices[i]]
        if weight + w > wmax
            break;
        else 
            weight += w;
            push!(sac, indices[i])
            cost += costs[indices[i]]
        end
    end

    return sac, cost, weight, wmax
end

"""
    knapsack_glouton_2(N::Int)

    algoritme glouton pour le probleme du sac à dos
    priorise la masse minimale
"""
function knapsack_glouton_2(N)
    weights = [i + i÷2 + 2(i%2) - i%3 for i in 1:N]
    indices = sortperm(weights)
    costs = [3i for i in 1:N]

    wmax = N^2÷2

    sac = Int16[]
    weight = 0
    cost = 0
    for i in 1:N
        w = weights[indices[i]]
        if weight + w > wmax
            break;
        else 
            weight += w;
            push!(sac, indices[i])
            cost += costs[indices[i]]
        end
    end

    return sac, cost, weight, wmax
end


"""
    knapsack_glouton_3(N::Int)

    algoritme glouton pour le probleme du sac à dos
    priorise le rapport valeur/masse
"""
function knapsack_glouton_3(N)
    weights = [i + i÷2 + 2(i%2) - i%3 for i in 1:N]
    costs = [3i for i in 1:N]
    indices = reverse(sortperm(costs ./ weights))

    wmax = N^2÷2

    sac = Int16[]
    weight = 0
    cost = 0
    for i in 1:N
        w = weights[indices[i]]
        if weight + w > wmax
            break;
        else 
            weight += w;
            push!(sac, indices[i])
            cost += costs[indices[i]]
        end
    end

    return sac, cost, weight, wmax
end

"""
    knapsack_glouton_1(N::Int)

    algoritme dynamique pour le probleme du sac à dos
"""
function knapsack_memo(N)
    weights = [i + i÷2 + 2(i%2) - i%3 for i in 1:N]
    costs = [3i for i in 1:N]
    wmax = N^2÷2

    opt = Array{Tuple{Vector{Int32}, Int32}, 2}(undef, N, wmax)
    #initialisation du tableau
    for w in 1:wmax
        if weights[1] <= w
            opt[1, w] = ([1], costs[1])
        else
            opt[1, w] = ([], 0)
        end
    end

    #remplissage du tableau
    for i in 2:N
        for w in 1:wmax
            if w-weights[i] < 0
                opt[i, w] = opt[i-1, w]
                continue
            end

            child_weight = w-weights[i]
            cost = (child_weight == 0 ? 0 : opt[i-1, child_weight][2]) + costs[i]#on teste pour éviter d'avoir des w == 0
            if cost < opt[i-1, w][2]
                opt[i, w] = (copy(opt[i-1, w][1]), opt[i-1, w][2])
            else
                old_sac = child_weight == 0 ? [] : copy(opt[i-1, child_weight][1])
                push!(old_sac, i)
                opt[i, w] = (old_sac, cost)
            end
        end
    end

    return opt[N, wmax]
end



#Exercice 9
const REFCHARS = [Char.(33:126); Char.(192:255); 'α':'ω']
# Cette opération initialise une Array{Char, 1} qui contient 
# tous les caractères de 33 à 126 et de 192 à 255 ainsi que l'alphabet greques

using Random
# ?randstring
# Cette fonction renvoie une chaine de caractères aléatoires
# de taille n avec des caractères pris dans une liste définie (optionnel)

"""
    str0() -> String

    génère une chaîne de 100000000 charactères aléatoires de REFCHARS
"""
function str0()
    return randstring(REFCHARS, 100000000)
end

"""
    plus_longue_chaine_sans_chiffre(str::String) -> String
"""
function plus_longue_chaine_sans_chiffre(str::String)
    max_chaine = ""
    max_len = 0
    
    chaine = ""
    len = 0
    
    for c in str
        if (Int(c) >= 48) & (Int(c) <= 57) #On vérifie que le caractère n'est pas un chiffre
            if len > max_len
                max_chaine = chaine
                max_len = len
            end
            chaine = ""
            len = 0
        else
            chaine *= c
            len += 1
        end
    end

    # besoin d'une dernière vérification si la dernière chaine vérifiée est la plus longue
    return (len > max_len) ? chaine : max_chaine
end


"""
    nb_ASCII(str0::String) -> Int
"""
function nb_ASCII(str0::String)
    count = 0
    for c in str0
        count += Int(Int(c) <= 127)
    end
    return count
end

# nb_ASCII(str0())
# > 51359043
# proportion de caractères ASCII dans str0 : 0.51359043
# proportion théorique : 0.51648352... = 94/182

"""
    nb_ASCII(str0::String) -> Int
"""
function lettres_consecutives(str::String)
    previous = Char(0) #Char(0) n'appartient pas à REFCHARS
    count = 0
    for c in str
        if c == previous
            count += 1
        end
        previous = c
    end
    return count
end

# lettres_consecutives("eldfjvhjnfcmzzmlkkkdmqù")
# > 3
# lettres_consecutives(str0())
# > 547127

"""
    ispalindrome(str::String) -> boolean
"""
function ispalindrome(str::String)
    reversed = reverse(str)
    for tup in zip(str, reversed)
        tup[begin] == tup[end] || return false
    end

    return true
end

# ispalindrome("engagelejeuquejelegagne")
# > true
# ispalindrome("kayak")
# > true
# ispalindrome("poisson")
# > false