#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>
#include <queue>
#include <map>
#include <set>
#include <random>
#include <list>

#include "Node.cpp"

using namespace std;

bool operator<(Node& n1, Node& n2) {
    return n1.total_cost < n2.total_cost;
}

Node* solve_bnb(int site_count, vector<vector<int>>& cost_matrix, unordered_map<int, vector<int>>& link_graph, vector<int> type_amounts, int type_count)
{
    int min = INT64_MAX;

    Node* next_node = new Node(site_count); // Create root node

    for (int site = 0; site < site_count; site++)
    {
        priority_queue<Node*, vector<Node*>> nodes;
        for (int type = 0; type < type_count; type++)
        {
            Node* node = new Node(next_node->state, site, type);
            node->check_validity(type_amounts, type_count);
            node->compute_cost(cost_matrix, link_graph);
            if (node->is_valid)
            {
                nodes.push(node);
            }
            else
            {
                delete node;
            }
        }

        if (nodes.top())
        {
            delete next_node;
            next_node = nodes.top();
            nodes.pop();
        }

        while (!nodes.empty())
        {
            Node* node = nodes.top();
            nodes.pop();
            delete node;
        }
    }

    return next_node;
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

    unordered_map<int, int> random_solution;
    vector<int> all_types(type_count, 0);
    copy(type_counts.begin(), type_counts.end(), all_types.begin());
    for (int site = 0; site < site_count; site++)
    {
        int random_type = 0;
        do {
            random_type = floor((rand() % type_count));
        } while (all_types[random_type] == 0);
        random_solution.insert(make_pair(site, (int) random_type));
        all_types[random_type]--;
    }

    Node* best = new Node(random_solution);
    best->compute_cost(cost_matrix, graph);
    best->check_validity(type_counts, type_count);

    while (true)
    {
        for (auto& it : graph)
        {
            vector<Node*> neighbours = best->create_neighbours(it.first, it.second);
            for (auto n : neighbours)
            {
                n->compute_cost(cost_matrix, graph);
                if (n->total_cost < best->total_cost)
                {
                    delete best;
                    best = n;
                    cout << best->get_solution() << endl;
                    cout << best->total_cost << endl;
                }
                else
                {
                    delete n;
                }
            }
        }
    }

    return 0;
}
