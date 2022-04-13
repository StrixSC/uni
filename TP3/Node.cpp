#include <iostream>
#include <vector>
#include <unordered_map>
#include <algorithm>
#include <string>
#include <sstream>
#include <iterator>
using namespace std;

#ifndef NODE
#define NODE

class Node
{
public:
    unordered_map<int, int> state;
    int site;
    int type;
    bool is_valid;
    string solution;
    int total_cost;

    Node(int site_count)
    {
        for (int i = 0; i < site_count; i++)
        {
            this->state.insert(make_pair(i, -1));
        }
    }

    Node(unordered_map<int, int> state)
    {
        this->state = state;
        this->solution = "";
        this->site = 0;
        this->type = 0;
        this->is_valid = true;
        this->total_cost = UINT64_MAX;
    }

    Node(unordered_map<int, int> state, int site, int type)
    {
        this->site = site;
        this->type = type;
        this->state = state;
        this->solution = "";
        this->state[site] = type;
    }

    void compute_cost(const vector<vector<int>>& cost_matrix, const unordered_map<int, vector<int>>& graph)
    {
        this->total_cost = 0;
        int index = 0;
        for (auto& it : graph)
        {
            int vertex = it.first;
            vector<int> connected_vertices = it.second;
            if (this->state[it.first] == -1)
            {
                continue;
            }

            for (auto connected_vertex : connected_vertices)
            {
                if (connected_vertex <= index || this->state[connected_vertex] == -1)
                {
                    continue;
                }

                this->total_cost += cost_matrix[this->state[vertex]][this->state[connected_vertex]];
                index++;
            }
        }
    }

    void check_validity(const vector<int>& type_amounts, const int type_count)
    {
        vector<int> site_type_counts = vector<int>(type_count, 0);

        for (size_t i = 0; i < this->state.size(); i++)
        {
            if (this->state[i] != -1)
            {
                site_type_counts[this->state[i]]++;
            }
        }

        for (size_t i = 0; i < site_type_counts.size(); i++)
        {
            if (site_type_counts[i] > type_amounts[i])
            {
                this->is_valid = false;
                return;
            }
        }

        this->is_valid = true;
    }

    string get_solution()
    {
        if (this->solution != "")
        {
            return this->solution;
        }

        string solution;
        for (auto& it : this->state)
        {
            solution += to_string(it.second);
        };

        this->solution = solution;
        return solution;
    }

    bool operator<(const Node& rhs)
    {
        return this->total_cost < rhs.total_cost;
    }

    vector<Node*> create_neighbours(int vertex, vector<int>& edges)
    {
        vector<Node*> nodes;
        for (auto edge : edges)
        {
            if (edge < vertex)
            {
                continue;
            }

            Node* node = new Node(this->state);
            int tmp = node->state[vertex];
            node->state[vertex] = node->state[edge];
            node->state[edge] = tmp;

            if (node->get_solution() != this->get_solution())
            {
                nodes.push_back(node);
            }
        }

        return nodes;
    }
};
#endif