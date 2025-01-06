include("TD5.jl")

#Exercice 1

function testTree() 
    subTree1 = Tree{Int}(2, [Tree{Int}(i, Vector{Tree{Int}}()) for i in 4:6])
    subTree2 = Tree{Int}(3, [Tree{Int}(i, Vector{Tree{Int}}()) for i in 7:8])
    return Tree{Int}(1, Tree{Int}[subTree1, subTree2])
end

function test_iterate()
    test_tree = testTree()
    for tree in test_tree
        println(tree)
    end
end

#Exercice 2

function testBinaryTree() 
    subTree1 = BinaryTree{Int}(2, [BinaryTree{Int}(i, Vector{BinaryTree{Int}}()) for i in 4:6])
    subTree = BinaryTree{Int}(3, [BinaryTree{Int}(i, Vector{BinaryTree{Int}}()) for i in 7:8])
    return BinaryTree{Int}(1, BinaryTree{Int}[subTree1, subTree2])
end

function Base.size(tree::BinaryTree)
    subTrees = subtrees(tree)
    length(subTrees) == 0 && return 1

    sum = 0
    for subtree in subTrees
        sum += size(subtree)
    end

    return sum
end

function append_print!(tree::BinaryTree, lines::Vector{String}, depth::Int)
    if length(lines) < depth
        if length(lines) == 0# || lines[1][end-1] != ' '
            offset = 0
        else
            offset = length(lines[1]) - 2
        end
        #offset = length(lines) == 0 ? 0 : length(lines[end])
        push!(lines, repeat(" ", offset))
    end

    subTrees = subtrees(tree)

    #=println()
    println("new")
    for l in lines
        println(l)
    end=#

    if length(subTrees) == 0
        for i in 1:length(lines)
            length(lines[i]) > length(lines[depth]) && continue
            lines[i] *= i == depth ? string(root(tree)) : " "
            lines[i] *= " "
        end
    else
        lines[depth] *= string(root(tree)) * " "
        for subtree in subTrees
            append_print!(subtree, lines, depth+1)
        end
    end
end

function print(tree::BinaryTree)
    #=lines = String[]

    # place all the values in the table
    append_print!(tree, lines, 1)

    # find the number of inter-lines
    ninter = fill(1, length(lines))
    for i in 2:length(lines)
        l = lines[i]

        for j in 1:2:length(l)
            if ~(l[j] == ' ')
                # find parent

                k = 0
                while lines[i-1][j - 2*k] == ' '
                    k += 1
                end
                ninter[i] = max(ninter[i], k)
            end
        end
    end
    
    for (i, l) in enumerate(lines)
        i == 1 && begin; println(l); continue; end

        for j in 1:ninter[i]
            println("f");
        end

        println(l)
    end

    println()
    # final display
    for l in lines
        println(l)
    end=#

    # 1
    # |\
    # | \
    # |  \
    # |   \
    # 2    3
    # |\   |\
    # | \  | |
    # 4  5 6 7
    # |\
    # 8 9

    #         1
    #        / \
    #       /   \
    #      /     \
    #     2       3
    #    / \     / \
    #   4   5   6   7
    #  / \
    # 8   9

    # 1
    # |-2
    # | |-4
    # | | |-8
    # | | |-9
    # | | 
    # | |-5
    # |
    # |-3
    #   |-6
    #   |-7
end

# Exercice 4

function testHeap(n::Int) 
    return Heap{Int}([i for i in 1:n])
end

"""
    testRandomHeap(n::Int)

returns a vector of n random integers between min (included) and max (excluded)
"""
function randomArray(n::Int, min::Int, max::Int) 
    return Int.(trunc.(rand(n) .* (max - min)) .+ min)
end

function testHeapSort()
    #=for i in 1:10000
    
    end=#
    l = randomArray(12, 0, 10)
    println(l)
    println(heapSort(l))
end