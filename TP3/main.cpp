#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>
#include <map>

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

// EDIT: THIS WILL NOT WORK OUT XDD
size_t solve_greedy(
    unsigned int site_count,
    unsigned int type_count,
    const vector<int> atom_type_counts,
    const vector<vector<int>>& graph, 
    const vector<vector<int>>& energy_matrix
)
{
    vector<pair<int, int>> link_counts = get_link_counts(graph);    // O(n^2)
    vector<pair<int, int>> atom_type_energy_sums = get_atom_type_energy_sums(energy_matrix);    // O(n^2)
    return 0;
}

int main(int argc, char* argv[]) {

    if (argc == 1)
    {
        cout << "Utilisation: tp.sh -e [chemin_vers_exemplaire]" << endl;
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
        cout << "Fichier d'exemplaire non valide ou manquant..." << endl;
        return -1;
    }

    ifstream file(file_path);

    if(!file.is_open())
    {
        cout << "Fichier non valide" << endl;
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

    // Initialize and fill the adjacency matrix to plot the graph;
    vector<vector<int>> graph(site_count, vector<int>(site_count));
    int vertex_a, vertex_b; 
    for(int i = 0; i < edges_count; i++)
    {
        file >> vertex_a >> vertex_b;
        graph[vertex_a][vertex_b] = 1;
    }

    const size_t sum = solve_greedy(site_count, types_count, atom_counts, graph, bond_energies_matrix);

    return 0;
}
