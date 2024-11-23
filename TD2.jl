#Exercice 1

mutable struct Stack{T}
    data::Vector{T}
    len::Int

    function Stack{T}() where {T}
        new{T}(T[], 0)
    end
end

function Base.push!(s::Stack, x) 
    push!(s.data, x)
    s.len += 1
    s
end

function Base.pop!(s::Stack)
    x = pop!(s.data)
    s.len -= 1
    x
end

function Base.length(s::Stack)
    s.len
end

function Base.peek(s::Stack)
    s.data[end]
end



# Exercice 2

mutable struct Queue{T}
    data::Vector{T}
    Queue{T}() where {T} = new{T}(T[])
end

function Base.push!(q::Queue, x)
    push!(q.data, x)
end

function Base.pop!(q::Queue)
    return popfirst!(q.data)
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

function LinkedList{T}(l::Vector{T}) where {T}
    if Base.length(l) == 0 return LinkedList{T}(); end;
    list = LinkedList{T}()
    elem = popfirst!(l)
    list.element = elem
    list.next = LinkedList{T}(l)
    return list
end

function length(ll::LinkedList)
    len = 0
    list = ll
    while ~(list.next === list)
        len += 1
        list = list.next
    end
    return len
end


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

function nv(sg::SimpleGraph)
    return sg.n_sommets
end

function ne(sg::SimpleGraph)
    return sg.n_aretes
end

function add_vertices!(sg::SimpleGraph, n)
    sg.n_sommets += n
    for i in 1:n 
        push!(sg.neighbors, Vector{Int64}[])
    end
end

function add_edge!(sg::SimpleGraph, edge::Tuple{Int, Int})
    maximum(edge) <= nv(sg) || return false
    if edge[2] in sg.neighbors[edge[1]] return false; end
    push!(sg.neighbors[edge[1]], edge[2])
    sg.n_aretes += 1
    return true
end

function exemple_graph()
    sg = SimpleGraph()
    add_vertices!(sg, 8)
    for edge in [(1, 4), (2, 1), (3, 2), (3, 8), (4, 1), (4, 3), (4, 6), (5, 7), (8, 6)]
        add_edge!(sg, edge)
    end
    sg
end