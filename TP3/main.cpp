#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>
#include <map>

#include "Site.cpp"

using namespace std;

void print_matrix(const vector<vector<int>>& matrix)
{
    unsigned i = 0;
    for (auto v1 : matrix)
    {
        printf("%d [ ", i);
        for (auto v2 : v1)
            v2 ? printf("1 ") : printf("0 ");
        i++;
        printf("] \n");
    }
}

vector<pair<int, int>> get_link_counts(const vector<vector<int>>& graph)
{
    vector<pair<int, int>> link_counts;
    unsigned int index = 0;
    for(auto v : graph)
    {
        unsigned int count = 0;
        for (auto itr = v.begin(); itr != v.end(); itr++)
        {
            if(*itr) count++;
        }
        link_counts.push_back(make_pair(index, count));
        index++;
    }
    
    sort(link_counts.begin(), link_counts.end(), 
        [&](pair<int, int>& a, pair<int, int>& b)
        {
            return a.second > b.second;
        }
    );

    return link_counts;
}

vector<pair<int, int>> get_atom_type_energy_sums(const vector<vector<int>>& energy_matrix)
{
    vector<pair<int, int>> energy_bond_sum(energy_matrix.size());
    unsigned int index = 0;
    for(auto v : energy_matrix)
    {
        energy_bond_sum[index].first = index;
        for (auto itr = v.begin(); itr != v.end(); itr++)
        {
            energy_bond_sum[index].second += *itr;
        }
        index++;
    }

    sort(energy_bond_sum.begin(), energy_bond_sum.end(), 
        [&](pair<int, int>& a, pair<int, int>& b)
        {
            return a.second < b.second;
        }
    );
    return energy_bond_sum;
}

size_t compute_total_energy_consumption(vector<pair<int, int>>& solution, vector<vector<int>>& energy_matrix) {
    return 0;
}

vector<pair<int, int>> bnb_solve(int lowest_cost_index, vector<vector<int>>& graph) {
    vector<pair<int, int>> solution;

    return solution;
}

int main(int argc, char* argv[]) {

    if (argc == 1)
    {
        printf("Utilisation: tp.sh -e [chemin_vers_exemplaire]\n");
        return -1;
    }

    string file_path;
    string file_arg(argv[1]);

    if (file_arg == "-e" && argc == 3)
    {
        file_path = argv[2];
    }
    else
    {
        printf("Fichier d'exemplaire non valide ou manquant...\n");
        return -1;
    }

    ifstream file(file_path);

    if(!file.is_open())
    {
        printf("Fichier non valide\n");
        return -1;
    }

    /* Parse input */

    // Get the list of sites, the type counts and the count for the number of edges. (Respectively: t, k, |A|)
    int site_count, types_count, edges_count;
    file >> site_count >> types_count >> edges_count;
    
    vector<int> atom_counts;
    int atom_count;

    // Get the count of atoms per type 
    for(int i = 0; i < types_count; i++)
    {
        file >> atom_count;
        atom_counts.push_back(atom_count);
    }

    // Initialize and fill a matrix containing the bond energies between each site.
    vector<vector<int>> bond_energies_matrix(types_count, vector<int>(0));

    int energy;
    for(int i = 0; i < types_count; i++)
    {
        for(int j = 0; j < types_count; j++)
        {
            file >> energy;
            bond_energies_matrix[i].push_back(energy);
        }
    }

    // Initialize, create and fill the graph with all the sites;
    vector<Site*> graph(site_count);
    int vertex_a, vertex_b; 
    for(int i = 0; i < edges_count; i++)
    {
        file >> vertex_a >> vertex_b;
        Site* site_ptr = graph[vertex_a];
        Site* neighbour_ptr = graph[vertex_b];
        
        if(site_ptr == NULL)
        {
            graph[vertex_a] = new Site(vertex_a);
        }

        if (neighbour_ptr == NULL)
        {
            graph[vertex_b] = new Site(vertex_b);
        }

        graph[vertex_a]->add_neighbour_site(graph[vertex_b]);
        graph[vertex_b]->add_neighbour_site(graph[vertex_a]);
    }

    for (Site* site : graph)
    {
        site->print_site();
    }

    
    // int lowest_cost_index = 0;
    // size_t sum = UINT64_MAX;
    // vector<pair<int, int>> solution;

    // do
    // {
        
    //     vector<pair<int, int>> new_solution = bnb_solve(lowest_cost_index, graph);
    //     const size_t new_sum = compute_total_energy_consumption(solution, bond_energies_matrix);
        
    //     if(sum <= new_sum)
    //     {
    //         sum = new_sum;
    //         solution = new_solution;
    //         printf("Total Energy: %lu\n", sum);
    //     }

    // } while(true);

    return 0;
}
