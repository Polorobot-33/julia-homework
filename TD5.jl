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

function children(tree::AbstractTree)
    [root(t) for t in subtrees(tree)]
end

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

function root(tree::BinaryTree)
    tree.element
end

function subtrees(tree::BinaryTree)
    tree.branches
end

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
function Base.length(tree::BinaryTree)
    subTrees = subtrees(tree)
    sum = 1

    for subtree in subTrees
        sum += length(subtree)
    end

    return sum
end

#Exercice 4

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

struct Heap{T} <: AbstractTree{T}
    elements::Vector{T}
end

function root(heap::Heap)
    return heap.elements[0]
end

function isInBranch(i, n)
    i == 1 && return false
    exponent = trunc(Int, log2(i))
    base = 2^exponent

    ((i % base) < (base/2)) ⊻ (n == 2)
end

function subtrees(heap::Heap)
    subtree1 = [x for (i, x) in enumerate(heap.elements) if isInBranch(i, 1)]
    subtree2 = [x for (i, x) in enumerate(heap.elements) if isInBranch(i, 2)]
    T = eltype(heap.elements)

    return [Heap{T}(subtree1), Heap{T}(subtree2)]
end

function Heap{T}(tree::BinaryTree) where {T}
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

function BinaryTree{T}(heap::Heap) where {T}
    return BinaryTree{T}(heap.elements)
end

function Base.push!(h::Heap{T}, x::T) where {T}
    push!(h.elements, x)

    current = length(h.elements)
    while (h.elements[current] < h.elements[current ÷ 2]) && (current != 1)
        h.elements[current], h.elements[current ÷ 2] = h.elements[current ÷ 2], h.elements[current]
        current ÷= 2
    end
end

function Base.pop!(h::Heap)
    root_ = root(h)
    h.elements[1] = pop!(h.elements)

    current = 1
    while (h.elements[current] < h.elements[2 * current]) || (h.elements[current] < h.elements[2 * current + 1])
        if 
            
        else

        end
    end
end