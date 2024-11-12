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
    list = LinkedList{T}()
    for elem in l 
        list.element = elem
        newList = LinkedList{T}()
        newList.next
    end
    list 
end