#include <string>
#include <stdio.h>
#include <vector>

using namespace std;

#ifndef SITE
#define SITE

class Site {
    public:
        Site(size_t _site_id): site_id(_site_id) {};
        ~Site();

        void add_neighbour_site(Site* _neighbour_site)
        {
            this->neighbour_sites.push_back(_neighbour_site);
        }

        vector<Site*> get_neighbour_sites() const
        {
            return this->neighbour_sites;
        }

        void print_site() const {
            printf("Site %lu is connected to sites: ", site_id);

            for(auto site : this->neighbour_sites)
            {
                printf("%lu", site->site_id);
            }
            
            printf("\n");
        }
        
        void set_id (size_t id) 
        {
            this->site_id = id;
        }

        size_t get_id () const 
        {
            return this->site_id;
        }

        void set_type(int _type)
        {
            this->type = _type; 
        };

        int get_type() const
        {
            return this->type;
        }

        int get_neighbour_count() const 
        {
            return this->neighbour_sites.size();
        }

    private:
        int type;
        size_t site_id;
        size_t best_neighbour_type;
        size_t worst_neighbour_type;
        vector<Site*> neighbour_sites;
};
#endif