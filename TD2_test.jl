include("TD2.jl")
using Test
using Chairmarks

#Exercice 2
function performance_stack_queue(structure)
    for i in 1:10000
        push!(structure, i)
    end
    for i in 1:10000
        pop!(structure)
    end
end

#julia>@be performance_stack_queue(Queue{Int64}())
#Benchmark: 1566 samples with 1 evaluation
#min    17.200 μs (15 allocs: 326.422 KiB)
#median 18.200 μs (15 allocs: 326.422 KiB)
#mean   48.265 μs (15 allocs: 326.422 KiB, 4.62% gc time)
#max    5.101 ms (15 allocs: 326.422 KiB, 97.07% gc time)

#julia> @be performance_stack_queue(Stack{Int64}())
#Benchmark: 1942 samples with 1 evaluation
#min    15.200 μs (15 allocs: 326.438 KiB)
#median 20.100 μs (15 allocs: 326.438 KiB)
#mean   43.208 μs (15 allocs: 326.438 KiB, 4.62% gc time)
#max    809.900 μs (15 allocs: 326.438 KiB, 91.38% gc time)

#Il n'y a pas de difference notable entre les deux strucures