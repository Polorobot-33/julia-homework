# Exercice 1 : 

abstract type AbstractTree{T} end

struct Tree{T} <: AbstractTree{T}
    element::T
    branches::Vector{Tree{T}}
end

function root(tree::Tree)
    tree.element
end

function subtrees(tree::Tree)
    tree.branches
end

function children(tree::AbstractTree{T})
    [root(t) for t in subtrees(t)]
end

function Base.iterate(tree::AbstractTree{T}, chain)
    trees, i = chain
    i <= length(trees) && return (root(trees[i]), (trees, i+1))

    subtree = AbstractTree{T}[]
    for t in trees
        length(subtrees(t)) > 0 && append!(subtree, subtrees(t))
    end
    
    length(subtree) > 0 && return (root(subtree[1]), (subtree, 2))

    return nothing
end

# Exercice 6 : 

# Un arbre binaire est équivalent à une liste chaînée si chaque noeud possède exactement un sous-noeud

struct BinaryTree{T} <: AbstractTree{T}
    element::T
    branches::Vector{BinaryTree{T}}

    function BinaryTree{T}(elem::T, l::Vector{BinaryTree{T}}) where T
        length(l) > 2 ? new(elem, l[1:2]) : new(elem, l)
    end
end

#=function BinaryTree(l::Vector)
    T=eltype(l)
    tree = BinaryTree{T}(l[1], ())
end=#
