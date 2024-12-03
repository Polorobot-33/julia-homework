#Exercice 1

mutable struct Stack{T}
    data::Vector{T}
    len::Int

    function Stack{T}() where {T}
        new{T}(T[], 0)
    end
end

"""
    push!(::Stack, ::Any)
    Ajoute un élément sur un stack
"""
function push!(s::Stack, x) 
    Base.push!(s.data, x)
    s.len += 1
    s
end

"""
    pop!(::Stack)
    Supprime le dernier element d'un stack et le renvoie
"""
function pop!(s::Stack)
    if s.len == 0 return; end;
    x = Base.pop!(s.data)
    s.len -= 1
    x
end

"""
    length(::Stack)
    renvoie la hauteur du stack
"""
function length(s::Stack)
    s.len
end

"""
    peek(::Stack)
    renvoie le dernier element du stack
"""
function peek(s::Stack)
    s.data[end]
end



# Exercice 2


mutable struct Queue{T}
    data::Vector{T}
    Queue{T}() where {T} = new{T}(T[])
end

function push!(q::Queue, x)
    Base.push!(q.data, x)
    q
end

function pop!(q::Queue)
    if size(q.data)[1] == 0 return; end;
    Base.popfirst!(q.data)
end

#Les méthodes pop! et push! sur une Queue sont de même complexité de Base.pop! et Base.push!, 
#et sont donc de complexité constante.



#Exercice 3

mutable struct BasicLinkedList
    element
    next::BasicLinkedList
end

mutable struct LinkedList{T}
    element::T
    next::LinkedList

    function LinkedList{T}() where {T}
        nil = new{T}()
        nil.next = nil
        nil
    end

end

"""
    LinkedList{T}(::Vector{T}) where {T}
    crée une LinkedList de type T contenant les éléments du Vector{T} en paramètre.
"""
function LinkedList{T}(l::Vector{T}) where {T}
    if Base.length(l) == 0 return LinkedList{T}(); end;
    list = LinkedList{T}()
    elem = popfirst!(l)
    list.element = elem
    list.next = LinkedList{T}(l)
    return list
end

"""
    length(::LinkedList)
    renvoie la longueur de la liste, en complexité linéaire
"""
function length(ll::LinkedList)
    len = 0
    list = ll
    while ~(list.next === list)
        len += 1
        list = list.next
    end
    return len
end

"""
    minimim(::LinkedList)
    renvoie le minimum de la liste
"""
function minimum(ll::LinkedList)
    if ll.next === ll
        return Inf
    else
        return min(ll.element, minimum(ll.next))
    end
end

#Les fonctions minimum et length sont de complexité linéaire par rapport à n
# Je n'arrive malheureusement pas à trouver la complexité des fonctions de base de julia...

# Exercice 4

mutable struct SimpleGraph
    neighbors::Array{Vector{Int}, 1}
    n_sommets::Int
    n_aretes::Int

    function SimpleGraph()
        graph = new(Array{Vector{Int}}[])
        graph.n_sommets = 0
        graph.n_aretes = 0
        return graph
    end
end

"""
    nv(::SimpleGraph)
    renvoie le nombre de sommets
"""
function nv(sg::SimpleGraph)
    return sg.n_sommets
end

"""
    ne(::SimpleGraph)
    renvoie le nombre d'arêtes
"""
function ne(sg::SimpleGraph)
    return sg.n_aretes
end

"""
    add_vertices!(::SimpleGraph, n)
    ajoute un sommet au graphe
"""
function add_vertices!(sg::SimpleGraph, n)
    sg.n_sommets += n
    for i in 1:n 
        push!(sg.neighbors, Vector{Int64}[])
    end
end

"""
    add_edge!(::SimpleGraph, Tuple{Int, Int})
    ajoute une arête entre deux sommets du graphe
"""
function add_edge!(sg::SimpleGraph, edge::Tuple{Int, Int})
    maximum(edge) <= nv(sg) || return false
    if edge[2] in sg.neighbors[edge[1]] return false; end
    push!(sg.neighbors[edge[1]], edge[2])
    sg.n_aretes += 1
    return true
end

"""
    initialise le graphe d'exemple du TD
"""
function exemple_graph()
    sg = SimpleGraph()
    add_vertices!(sg, 8)
    for edge in [(1, 4), (2, 1), (3, 2), (3, 8), (4, 1), (4, 3), (4, 6), (5, 7), (8, 6)]
        add_edge!(sg, edge)
    end
    sg
end

"""
    isoriented(::SimpleGraph)
    donne le caractère orienté du graphe
"""
function isoriented(sg::SimpleGraph) 
    sg.n_aretes % 2 == 0 || return true
    for i in 1:nv(sg)
        for j in sg.neighbors[i]
            (i in sg.neighbors[j]) || return true;
        end
    end
    return false;
end

"""
    notconnectedto(g::SimpleGraph, s::Int) :: Vector{Int}
    renvoie tous les sommets de g inaccessibles depuis le sommet s
"""
function notconnectedto(g::SimpleGraph, s::Int)
    stack = Stack{Int}()
    unexplored = [true for i=1:nv(g)]
    push!(stack, s)

    while (length(stack) > 0)
        vertex = pop!(stack)

        #a vertex may be have been added multiple times on the stack by the previous layer
        #in this case, just ignore the future occurences
        if ~unexplored[vertex] continue; end;

        unexplored[vertex] = false
        for i in g.neighbors[vertex]
            unexplored[i] && push!(stack, i)
        end
    end

    return [v for v=1:nv(g) if unexplored[v]]
end

"""
    isincycle(::SimpleGraph, ::Int)
    Renvoie true si le sommet d'indice spécifié fait partie d'un cycle 
"""
function isincycle(g::SimpleGraph, s)
    stack = Stack{Int}()
    unexplored = [true for i=1:nv(g)]
    push!(stack, s)

    while length(stack) > 0
        vertex = pop!(stack)

        #a vertex may be have been added multiple times on the stack by the previous layer
        #in this case, just ignore the future occurences
        if ~unexplored[vertex] continue; end;

        unexplored[vertex] = false
        for i in g.neighbors[vertex]
            if i == s; return true; end;
            unexplored[i] && push!(stack, i)
        end
    end

    return false;
end

# Tous les sommets sont visités si le graphe est connexe.

# Il est possible d'affaiblir cette condition : 
# tous les sommets sont visités si tous les sommets 
# sont accessibles depuis le sommet initial (noté s dans les fonctions précédentes),
# il n'y a nécessaire que le trajet inverse existe.

