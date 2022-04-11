#include <iostream>
#include <vector>
#include <unordered_map>
#include <algorithm>
#include <iterator>
using namespace std;

#ifndef NODE
#define NODE

class Node
{
    public:
        vector<vector<int>> state;
        int site;
        int type;
        bool is_valid;
        int total_cost;

        Node(vector<vector<int>> state, int site, int type)
        {
            this->site = site;
            this->type = type;
            this->state = state;
            this->set_state();
        }

        void set_state()
        {
            for(int i = 0; i < this->state[this->site].size(); i++)
            {
                this->state[this->site][i] = (this->type == i) ? 1 : 0;
            }
        }

        vector<int> get_site_types() const
        {
            vector<int> site_types(this->state.size(), NULL);
            for (int i = 0; i < this->state.size(); i++)
            {
                for (int j = 0; j < this->state[i].size(); j++)
                {
                    if(this->state[i][j] != NULL && this->state[i][j] == 1)
                    {
                        site_types[i] = j;
                    } 
                }
            }
            return site_types;
        }

        void compute_cost(const vector<vector<int>>& cost_matrix, const unordered_map<int, vector<int>>& graph) 
        {
            this->total_cost = 0;
            vector<int> site_types = this->get_site_types();
            int index = 0; 
            for (auto vertex : graph)
            {
                vector<int> edges = vertex.second;
                if (site_types[vertex.first] == NULL)
                {
                    continue;
                }

                for (auto edge : edges)
                {
                    if (edge <= index || site_types[edge] == NULL)
                    {
                        continue;
                    }

                    this->total_cost += cost_matrix[site_types[vertex.first]][site_types[edge]];
                    index++;
                }
            }
        }

        void check_validity(const vector<int>& type_amounts, const int type_count)
        {
            vector<int> site_types = this->get_site_types();
            vector<int> site_type_counts = vector<int>(type_count, 0);

            for (int i = 0; i < site_types.size(); i++)
            {
                if (site_types[i] != NULL)
                {
                    site_type_counts[site_types[i]] += 1;
                }
            }

            for (int i = 0; i < site_type_counts.size(); i++)
            {
                if (site_type_counts[i] > type_amounts[i])
                {
                    this->is_valid = false;
                    return;
                }
            }
            
            this->is_valid = true;
        }

        void print() const
        {
            vector<int> site_types = this->get_site_types();
            string str_site_types(site_types.begin(), site_types.end());
            printf("%s", str_site_types);
        }

        bool is_lower_cost(const Node* other) const
        {
            return this->total_cost < other->total_cost;
        }
};
#endif