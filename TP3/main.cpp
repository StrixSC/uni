#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>
#include <queue>
#include <map>
#include <set>
#include <random>
#include <unordered_map>
#include <list>
#include <ctime>
#include <iterator>

using namespace std;


vector<vector<int>> create_neighbours(vector<int> &solution, int site, vector<int> &connected_vertices)
{
    vector<vector<int>> neighbours;
    for (auto &connected_vertex : connected_vertices)
    {
        if (connected_vertex < site)
        {
            continue;
        }

        vector<int> neighbour(solution.size(), 0);
        copy(solution.begin(), solution.end(), neighbour.begin());
        int tmp = neighbour[site];
        neighbour[site] = neighbour[connected_vertex];
        neighbour[connected_vertex] = tmp;
        bool is_equal = equal(solution.begin(), solution.end(), neighbour.begin());
        if (!is_equal)
        {
            neighbours.push_back(neighbour);
        }
    }
    return neighbours;
}

int compute_cost(vector<int> &solution, vector<vector<int>> &cost_matrix, unordered_map<int, vector<int>> &graph)
{
    int total_cost = 0;
    for (auto &it : graph)
    {
        int vertex = it.first;
        vector<int> connected_vertices = it.second;
        for (auto connected_vertex : connected_vertices)
        {
            total_cost += cost_matrix[solution[vertex]][solution[connected_vertex]];
        }
    };
    return total_cost;
}

int main(int argc, char *argv[])
{

    if (argc == 1)
    {
        printf("Utilisation: tp.sh -e [chemin_vers_exemplaire]\n");
        return -1;
    }

    string file_path;
    string file_arg(argv[1]);

    if (file_arg == "-e" && argc >= 3)
    {
        file_path = argv[2];
    }
    else
    {
        printf("Fichier d'exemplaire non valide ou manquant...\n");
        return -1;
    }

    ifstream file(file_path);

    if (!file.is_open())
    {
        printf("Fichier non valide\n");
        return -1;
    }

    /* Parse input */
    // Get the list of sites, the type counts and the count for the number of edges. (Respectively: t, k, |A|)
    int site_count, type_count, edges_count;
    file >> site_count >> type_count >> edges_count;

    vector<int> type_counts;
    int count;

    // Get the count of atoms per type
    for (int i = 0; i < type_count; i++)
    {
        file >> count;
        type_counts.push_back(count);
    }

    // Initialize and fill a matrix containing the bond energies between each site.
    vector<vector<int>> cost_matrix(type_count, vector<int>(0));

    int energy;
    for (int i = 0; i < type_count; i++)
    {
        for (int j = 0; j < type_count; j++)
        {
            file >> energy;
            cost_matrix[i].push_back(energy);
        }
    }

    // Initialize, create and fill the graph with all the sites;
    int vertex_a, vertex_b;
    unordered_map<int, vector<int>> graph;
    for (int i = 0; i < edges_count; i++)
    {
        file >> vertex_a >> vertex_b;
        graph[vertex_a].push_back(vertex_b);
    }

    vector<int> best_solution;
    vector<int> all_types(type_count, 0);
    copy(type_counts.begin(), type_counts.end(), all_types.begin());
    for (int site = 0; site < site_count; site++)
    {
        for (int i = 0; i < type_count; i++)
        {
            if (all_types[i] > 0)
            {
                best_solution.push_back(i);
                all_types[i]--;
                break;
            }
        }
    }

    auto rng = std::default_random_engine{};
    shuffle(best_solution.begin(), best_solution.end(), rng);
    int best_cost = compute_cost(best_solution, cost_matrix, graph);
    bool changed = false;
    while (true)
    {
        for (auto &it : graph)
        {
            vector<vector<int>> neighbours = create_neighbours(best_solution, it.first, it.second);

            for (auto n : neighbours)
            {
                int cost = compute_cost(n, cost_matrix, graph);
                if (cost < best_cost)
                {
                    best_solution = n;
                    best_cost = cost;
                    changed = true;
                    // copy(best_solution.begin(), best_solution.end(), std::ostream_iterator<int>(std::cout, " "));
                    for (auto &v : best_solution)
                    {
                        cout << v << " ";
                    }
                    cout << endl;
                    // cout << cost << endl;
                }
            }
        }

        if (!changed)
        {
            shuffle(best_solution.begin(), best_solution.end(), rng);
        }

        changed = false;
    }

    return 0;
}
