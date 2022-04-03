#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <iterator>
#include <sstream>

using namespace std;

void print_adjacency_matrix(const vector<vector<int>>& graph)
{
    unsigned i = 0;
    for (auto v1 : graph)
    {
        printf("%d [ ", i);
        for (auto v2 : v1)
            v2 ? printf("1 ") : printf("0 ");
        i++;
        printf("] \n");
    }
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

    // Create a 2D array to contain the bond energies between each site.
    vector<vector<int>> bond_energies_matrix(types_count, vector<int>(0));
    
    // Fill the bond_energies array.
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

    return 0;
}
