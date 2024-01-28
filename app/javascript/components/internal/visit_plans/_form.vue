<script>

  export default {
    props: {
      provider_type: {
        type: String,
        required: true
      },
      visit_plan: {
        type: Object,
        required: true
      },
      visit_plan_states: {
        type: Array,
        default: () => [],
        required: false
      },
      visit_plan_towns: {
        type: Array,
        default: () => [],
        required: false
      },
      visit_plan_items: {
        type: Array,
        default: () => [],
        required: false
      },
      states: {
        type: Array,
        required: true
      }
    },
    mounted() {

    },
    created() {

      // pre-select states

      let dummy_visit_plan_states = [
        {
          visit_plan_id: 1,
          state_id: 4,
          state: {
            id: 4,
            name: 'KUALA LUMPUR'
          }
        },
        {
          visit_plan_id: 1,
          state_id: 13,
          state: {
            id: 13,
            name: 'SELANGOR'
          }
        }
      ];

      let dummy_visit_plan_towns = [
        {
          visit_plan_id: 1,
          state_id: 4,
          town_id: 1,
          state: {
            id: 4,
            name: 'KUALA LUMPUR'
          },
          town: {
            id: 1,
            name: 'AMPANG'
          }
        },
        {
          visit_plan_id: 1,
          state_id: 4,
          town_id: 2,
          state: {
            id: 4,
            name: 'KUALA LUMPUR'
          },
          town: {
            id: 2,
            name: 'BEVERLY HEIGHTS'
          }
        },
        {
          visit_plan_id: 1,
          state_id: 13,
          town_id: 4,
          state: {
            id: 13,
            name: 'SELANGOR'
          },
          town: {
            id: 4,
            name: 'BANDAR BARU BANGI'
          }
        },
        {
          visit_plan_id: 1,
          state_id: 13,
          town_id: 5,
          state: {
            id: 13,
            name: 'SELANGOR'
          },
          town: {
            id: 5,
            name: 'BANGI SENTRAL'
          }
        }
      ];

      let dummy_visit_plan_providers = [
        {
          visit_plan_id: 1,
          state_id: 4,
          town_id: 1,
          visitable: {
            id: 6,
            name: 'RADIO 006',
          },
          visitable_id: 6,
          visitable_type: 'Radiology',
          state: {
            id: 4,
            name: 'KUALA LUMPUR'
          },
          town: {
            id: 1,
            name: 'AMPANG'
          }
        },
        {
          visit_plan_id: 1,
          state_id: 4,
          town_id: 2,
          visitable: {
            id: 2,
            name: 'RADIO 002',
          },
          visitable_id: 2,
          visitable_type: 'Radiology',
          state: {
            id: 4,
            name: 'KUALA LUMPUR'
          },
          town: {
            id: 2,
            name: 'BEVERLY HEIGHTS'
          }
        },
        {
          visit_plan_id: 1,
          state_id: 13,
          town_id: 5,
          visitable: {
            id: 1,
            name: 'RADIO 001',
          },
          visitable_id: 1,
          visitable_type: 'Radiology',
          state: {
            id: 13,
            name: 'SELANGOR'
          },
          town: {
            id: 5,
            name: 'BANGI SENTRAL'
          }
        }
      ];


      dummy_visit_plan_states.forEach((visit_state) => {

          // populate array of selected states

          this.selected_visit_plan_states.push(visit_state.state);

          // load the towns via ajax based on pre-select state

          this
            .fetchStateTowns(visit_state.state.name, visit_state.state.id)
            .then((res) => {

                //  and pre-select the towns by:

                // 1. get all towns for specific state
                let state_towns = _.filter(dummy_visit_plan_towns, { state_id: visit_state.state.id });

                let formatted_state_towns = state_towns.map(function (state_town) {
                                              return {
                                                id: state_town.town_id,
                                                name: state_town.town.name
                                              } 
                                            });

                // 2. push the state towns into selected_visit_plan_towns object
                Vue.set(this.selected_visit_plan_towns, visit_state.state.name, formatted_state_towns);
                
            })
            .then((res) => {

                //  and fetch all the selected state towns providers by:

                this.selected_visit_plan_towns[visit_state.state.name].forEach((town) => {
                  
                  this.fetchTownsProvider(town.name, town.id)
                    .then(() => {
                      
                      //  and pre-select the town providers by:

                      // 1. get all providers for specific town
                      
                      let town_providers = _.filter(dummy_visit_plan_providers, { town_id: town.id });

                      let formatted_town_providers = town_providers.map(function (town_provider) {
                                              return {
                                                id: town_provider.visitable_id,
                                                name: town_provider.visitable.name
                                              } 
                                            });

                      // 2. push the town providers into selected_visit_plan_providers object

                      Vue.set(this.selected_visit_plan_providers, town.name, formatted_town_providers);
                      
                    });

                });
                
            });

      });

      // pre-select clinics

    },
    computed: {

    },
    data: function () {
      return {
        selected_visit_plan_states: [],
        selected_visit_plan_towns: {},
        selected_visit_plan_providers: {},
        towns: {},
        providers: {},
      }
    },
    watch: {
      
    },
    methods: {

        selectNewState({ name, id }) {
            console.log(name, id);
            this.fetchStateTowns(name, id);
        },

        selectNewTown({ name, id }) {
            console.log(name, id);
            this.fetchTownsProvider(name, id);
        },

        selectNewProvider({ name, id }) {
            console.log(name, id);
        },

        getStateTowns(state_name) {

          if (this.towns[state_name]) {
            return this.towns[state_name];
          }

          return [];
        },

        getTownProviders(town_name) {

          if (this.providers[town_name]) {
            return this.providers[town_name];
          }

          return [];
        },

        fetchStateTowns(state_name, state_id) {

            return axios
                  .get('/states/' + state_id  + '/towns.json')
                  .then(response => {
                      let towns = response.data

                      Vue.set(this.towns, state_name, towns);

                  })
                  .catch(function (error) {
                      console.log('error res -->', error);
                  });
        },

        fetchTownsProvider(town_name, town_id) {

            return axios
                  .get('/towns/' + town_id  + '/' + this.provider_type + '.json')
                  .then(response => {

                      Vue.set(this.providers, town_name, response.data);

                  })
                  .catch(function (error) {
                      console.log('error res -->', error);
                  });


        },
        
    }
  }
</script>

<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>

<style scoped>
  
</style>
