# Exercice 1 : 

abstract type AbstractTree{T} end

struct Tree{T} <: AbstractTree{T}
    element::T
    branches::Vector{Tree{T}}
end

"""
    root(tree::Tree)
"""
function root(tree::Tree)
    tree.element
end

"""
    subtrees(tree::Tree)
"""
function subtrees(tree::Tree)
    tree.branches
end

"""
    children(tree::AbstractTree)

Returns the roots of the subtrees of tree
"""
function children(tree::AbstractTree)
    [root(t) for t in subtrees(tree)]
end

"""
    Base.iterate(tree::AbstractTree, chain::Union{Int, Tuple(Vector{AbstractTree}, Int)})

Iterator over all the elements of an AbstractTree
"""
function Base.iterate(tree::AbstractTree, chain=-1)
    #initialisation
    if chain == -1
        trees = [tree,]
        i = 1;
    else
        #trees permet de stocker tous les sous-arbres du niveau de profondeur suivant
        trees, i = chain
    end

    i <= length(trees) && return (root(trees[i]), (trees, i+1))

    #Dans ce cas, on a exporé tous les sous-arbres de niveau, il faut passer au niveau suivant.
    subtree = AbstractTree[]
    for t in trees
        length(subtrees(t)) > 0 && append!(subtree, subtrees(t))
    end
    
    length(subtree) > 0 && return (root(subtree[1]), (subtree, 2))

    return nothing
end

# Exercice 2 : 

# Un arbre binaire est équivalent à une liste chaînée si chaque noeud possède exactement un sous-noeud

struct BinaryTree{T} <: AbstractTree{T}
    element::T
    branches::Vector{BinaryTree{T}}

    function BinaryTree{T}(elem::T, l::Vector{BinaryTree{T}}) where T
        length(l) > 2 ? new(elem, l[1:2]) : new(elem, l)
    end
end

"""
    root(tree::BinaryTree)
"""
function root(tree::BinaryTree)
    tree.element
end

"""
    subtrees(tree::BinaryTree)
"""
function subtrees(tree::BinaryTree)
    tree.branches
end

"""
    BinaryTree{T}(l::Vector) where {T}

External constructor for the type BinaryTree generating a BinaryTree
from the Vector{T} l
"""
function BinaryTree{T}(l::Vector) where {T}
    L = length(l)

    #J'utilise ici un dictionnaire, mais il aurait été possible de simplement utiliser
    # une liste car les éléments auxquels on va accéder sont ordonnés
    dict = Dict()

    for (i, elem) in Iterators.reverse(enumerate(l))
        if L >= 2*i+1
            subTree = BinaryTree{T}(elem, [dict[2*i], dict[2*i+1]])
        elseif L == 2*i #L >= 2*i
            subTree = BinaryTree{T}(elem, [dict[2*i]])
        else
            subTree = BinaryTree{T}(elem, BinaryTree{T}[])
        end
        push!(dict, i => subTree)
    end

    return dict[1]
end

#> BinaryTree([i for i in 1:4])
#BinaryTree{Int64}(1, BinaryTree{Int64}[BinaryTree{Int64}(2, BinaryTree{Int64}[BinaryTree{Int64}(4, BinaryTree{Int64}[])]), BinaryTree{Int64}(3, BinaryTree{Int64}[])])

#> BinaryTree([i for i in 1:5])
#BinaryTree{Int64}(1, BinaryTree{Int64}[BinaryTree{Int64}(2, BinaryTree{Int64}[BinaryTree{Int64}(4, BinaryTree{Int64}[]), BinaryTree{Int64}(5, BinaryTree{Int64}[])]), BinaryTree{Int64}(3, BinaryTree{Int64}[])])

# Un arbre généré de cette manière a toutes ses feuillles à la même profondeur
# s'il existe n tel que length(l) = n^2 - 1


# Nécessaire pour utiliser collect()
"""
    Base.length(tree::BinaryTree)

returns the total number of nodes of the tree
"""
function Base.length(tree::BinaryTree)
    subTrees = subtrees(tree)
    sum = 1

    for subtree in subTrees
        sum += length(subtree)
    end

    return sum
end

#Exercice 4

"""
    isheap(tree::BinaryTree)

Returns true if the BinaryTree represents a heap
"""
function isheap(tree::BinaryTree)
    #On ne vérifie pas ici le caractère complet de l'arbre

    subTrees = subtrees(tree)
    length(subTrees) == 0 && return true

    for subtree in subTrees
        isheap(subtree) || return false
        root(subtree) > root(tree) || return false
    end

    return true
end

mutable struct Heap{T} <: AbstractTree{T}
    elements::Vector{T}
end

"""
    root(heap::Heap)
"""
function root(heap::Heap)
    return heap.elements[1]
end

"""
    isInBranch(i::Int, n::Int)

Returns true if the element of index i belongs to the branch n of a heap
(index i==1 represents the root)
n is therefore choosen between 1 and 2
"""
function isInBranch(i, n)
    i == 1 && return false
    exponent = trunc(Int, log2(i))
    base = 2^exponent

    ((i % base) < (base/2)) ⊻ (n == 2)
end

"""
    subtrees(heap::Heap)
"""
function subtrees(heap::Heap)
    subtree1 = [x for (i, x) in enumerate(heap.elements) if isInBranch(i, 1)]
    subtree2 = [x for (i, x) in enumerate(heap.elements) if isInBranch(i, 2)]
    T = eltype(heap.elements)

    return [Heap{T}(subtree1), Heap{T}(subtree2)]
end

"""
    Heap{T}(tree::BinaryTree) where {T}

External constructor for the type Heap, creating a Heap from the BinaryTree tree
"""
function Heap{T}(tree::BinaryTree) where {T}
    # check if the tree can represent a heap
    isheap(tree) || return nothing

    queue = [tree]
    elements = []

    while length(queue) > 0
        current = popfirst!(queue)
        push!(elements, root(current))

        for child in subtrees(current)
            push!(queue, child)
        end
    end

    return Heap{T}(elements)
end

"""
    BinaryTree{T}(heap::Heap) where {T}

External constructor for the type BinaryTree,
creating a BinaryTree from a heap Heap
"""
function BinaryTree{T}(heap::Heap) where {T}
    return BinaryTree{T}(heap.elements)
end

function Base.push!(h::Heap{T}, x::T) where {T}
    push!(h.elements, x)

    current = length(h.elements)
    while (h.elements[current] < h.elements[max(current ÷ 2, 1)]) && (current != 1)
        h.elements[current], h.elements[max(current ÷ 2, 1)] = h.elements[max(current ÷ 2, 1)], h.elements[current]
        current ÷= 2
        current = max(current, 1)
    end
end

"""
    Base.pop!(h::Heap)

Returns the root of a heap, and removes it from the heap
while conservating its heap properties
"""
function Base.pop!(h::Heap)
    root_ = root(h)
    last_elem = pop!(h.elements)
    L = length(h.elements)

    L == 0 && return root_

    h.elements[1] = last_elem

    current = 1
    child1 = 2 * current
    child2 = 2 * current + 1
    while (child1 <= L && (h.elements[current] > h.elements[child1])) || (child2 <= L && (h.elements[current] > h.elements[child2]))
        if child2 > L || h.elements[child1] < h.elements[child2]
            h.elements[child1], h.elements[current] = h.elements[current], h.elements[child1]
            current = child1
        else
            h.elements[child2], h.elements[current] = h.elements[current], h.elements[child2]
            current = child2
        end

        child1 = 2 * current
        child2 = 2 * current + 1
    end

    return root_
end

"""
    Base.length(h::Heap)

Returns the number of elements in the Heap h
"""
function Base.length(h::Heap)
    return length(h.elements)
end

"""
    Base.minimum(h::Heap)
"""
function Base.minimum(h::Heap)
    return minimum(h.elements)
end

# La complexité de cette fonction est la même que Base.minimum(::eltype(h.elements))
# Ainsi sa complexité doit être linéaire (si je ne me trompe pas...)

"""
    heapSort(arr::Vector{T}) where {T}

Returns a sorted array in the ascendent order of the input array arr
using the heap sort algorithm
"""
function heapSort(arr::Vector{T}) where {T}
    h = Heap{T}(T[])

    for elem in arr
        push!(h, elem)
    end

    sorted = T[]
    while length(h) > 0
        push!(sorted, pop!(h))
    end

    sorted
end

# Exercice 5

struct InverseSyracuseTree <: AbstractTree{Int}
    element::Int
end

"""
    root(tree::InverseSyracuseTree)
"""
function root(tree::InverseSyracuseTree)
    return tree.element
end

"""
    subtrees(tree::InverseSyracuseTree)
"""
function subtrees(tree::InverseSyracuseTree)
    if root(tree) == 1
        return [InverseSyracuse(2)]
    else
        if (root(tree) - 1) % 3 == 0 && ((root(tree) - 1) ÷ 3) % 2 == 1
            return [root(tree) * 2, (root(tree) - 1) ÷ 3]
        else
            return [root(tree) * 2]
        end
    end
end

# Un arbre inverse de syracuse est (à priori) de taille infinie tel qu'il est défini.
# Il faut donc trouver un critère d'arrêt pour l'itération