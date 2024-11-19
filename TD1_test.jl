#Exercice 8
function test_1()
    for i in 2:10
        println("N=$i : ");
        println("\tglouton 1 : $(knapsack_glouton_1(i)[2])")
        println("\tglouton 2 : $(knapsack_glouton_2(i)[2])")
        println("\tglouton 3 : $(knapsack_glouton_3(i)[2])")
    end
end

# il semble que les algoritmes donnent des résultats différents
# mais proches les uns des autres, 
# sans qu'aucun ne soit meilleur tout le temps

function test_2()
    for i in 2:10
        println("Le memo est le meilleur : $(knapsack_memo(i)[2] >= max(knapsack_glouton_1(i)[2], knapsack_glouton_2(i)[2], knapsack_glouton_3(i)[2]))")
    end
end