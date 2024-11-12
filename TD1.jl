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