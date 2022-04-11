#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>
#include <queue>
#include <map>
#include <set>
#include <list>

#include "Node.cpp"

using namespace std;

template <typename S>
void print_array(vector<S> array)
{

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
    int site_count, type_count, edges_count;
    file >> site_count >> type_count >> edges_count;
    
    vector<int> type_counts;
    int count;

    // Get the count of atoms per type 
    for(int i = 0; i < type_count; i++)
    {
        file >> count;
        type_counts.push_back(count);
    }

    // Initialize and fill a matrix containing the bond energies between each site.
    vector<vector<int>> cost_matrix(type_count, vector<int>(0));

    int energy;
    for(int i = 0; i < type_count; i++)
    {
        for(int j = 0; j < type_count; j++)
        {
            file >> energy;
            cost_matrix[i].push_back(energy);
        }
    }

    // Initialize, create and fill the graph with all the sites;
    int vertex_a, vertex_b; 
    unordered_map<int, vector<int>> graph;
    for(int i = 0; i < edges_count; i++)
    {
        file >> vertex_a >> vertex_b;
        graph[vertex_a].push_back(vertex_b);
    }

    int starting_site = 0;
    priority_queue<Node*, vector<Node*>> nodes;
    vector<vector<int>> default_state(site_count, vector<int>(type_count, NULL));
    for (int type = 0; type < type_count; type++)
    {
        Node* node = new Node(default_state, starting_site, type);
        node->compute_cost(cost_matrix, graph);
        node->check_validity(type_counts, type_count);
        nodes.push(node);
    }

    for(int i = 0; i < nodes.size(); ++i) {
        nodes.top()->print();
        nodes.pop();
    }

    Node* best = nullptr;
    int min_energy = INT64_MAX;

    while(!nodes.empty()) 
    {
        Node* next_node = nodes.top();

        for(int type = 0; type < type_count; type++)
        {
            Node* node = new Node(next_node->state, next_node->site + 1, type);
            node->compute_cost(cost_matrix, graph);
            node->check_validity(type_counts, type_count);
            if(node->site == (site_count - 1) && node->is_valid && node->total_cost <= min_energy)
            {
                best = node;
                min_energy = node->total_cost;
                best->print();
                break;
            }

            if (node->is_valid && node->site < (site_count - 1))
            {
                nodes.push(node);
            }
        }
        
        nodes.pop();
        delete next_node;
    }
    
    return 0;
}
