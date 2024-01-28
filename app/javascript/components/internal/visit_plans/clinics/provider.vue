<script>

    export default {
        props: {
            providers: {
                type: Array,
                default: () => [],
                required: true
            },
            states: {
                type: Array,
                default: () => [],
                required: true
            },
            route: {
                type: String,
                required: true
            },
            new_route: {
                type: String,
                required: true
            }
        },
        mounted() {

        },
        created() {

            // preselect states based on value of search_data[state_ids]

            if ('state_ids' in this.search_data && this.search_data['state_ids']) {

                let state_id_arr = this.search_data['state_ids'].split(',');

                state_id_arr.forEach((state_id) => {
                    
                    let selected_state = _.find(this.states, { id: parseInt(state_id) });
                    this.selected_states.push(selected_state);
                });

                // fetch towns based on selected state ids

                this
                    .fetchStateTowns()
                    .then((res) => {

                        // preselect towns based on value of search_data[town_ids]

                        if ('town_ids' in this.search_data && this.search_data['town_ids']) {

                            let town_id_arr = this.search_data['town_ids'].split(',');

                            town_id_arr.forEach((town_id) => {
                                let selected_town = _.find(this.towns, { id: parseInt(town_id) });
                                this.selected_towns.push(selected_town);
                            });

                        }

                    });
                
            }

            

        },
        computed: {

            selected_provider_ids: function () {
                
                let selected_ids = _.map(this.selected_providers, 'id');

                return selected_ids;
            },

            selected_state_ids() {

                let state_ids = _.map(this.selected_states, 'id');

                state_ids = state_ids.join(",");

                return state_ids;

            },

            selected_town_ids() {

                let town_ids = _.map(this.selected_towns, 'id');

                town_ids = town_ids.join(",");

                return town_ids;

            },

            town_options() {

                let towns_by_state = _.groupBy(this.towns, 'state.name');

                const state_keys = Object.keys(towns_by_state);

                let options = [];

                state_keys.forEach((state_key) => {

                    let option_obj = {
                        state: state_key,
                        towns: towns_by_state[state_key]
                    };

                    options.push(option_obj);
                });

                return options;
            },

        },
        data: function () {
            return {
                selected_providers: [],
                selectAll: false,
                selected_states: [],
                selected_towns: [],
                towns: [],
                search_data: this.getSearchData(),
            }
        },
        watch: {

        },
        methods: {

            select() {
                this.selected_providers = [];
                
                if (!this.selectAll) {
                    this.selected_providers = [...this.providers];    
                }
            },

            updateStateSelection() {

                // set the search_data

                this.search_data['state_ids'] = this.selected_state_ids;

                if (this.selected_state_ids) {
                    this.fetchStateTowns();
                }
            },

            updateTownSelection() {
                this.search_data['town_ids'] = this.selected_town_ids;
            },

            selectNewState({ name, id }) {
                console.log(name, id);
            },

            selectNewTown({ name, id }) {
                console.log(name, id);
            },

            getStateTowns(state_name) {

                if (this.towns[state_name]) {
                    return this.towns[state_name];
                }

                return [];
            },

            fetchStateTowns() {

                return axios
                    .get('/states/' + this.selected_state_ids  + '/multistatetowns.json')
                    .then(response => {
                        let towns = response.data
                        
                        this.towns = towns;

                    })
                    .catch(function (error) {
                        console.log('error res -->', error);
                    });
            },

            getSearchData() {
                
                let urlParams = new URLSearchParams(window.location.search);
                
                let entries = urlParams.entries();
                
                // dynamically create search_data object based on query params
                
                let search_data = {
                    filter: true,
                };

                for (let pair of entries) {
                    search_data[pair[0]] = pair[1];
                }

                return search_data;
            },

            handleSubmit(e) {
                console.log('search_data: ', JSON.stringify(this.search_data, null, 2));
                this.search();
            },

            search() {
                
                let query_string = this.getQueryString(this.search_data);
                
                window.location.href = this.route + '?' + query_string;
            },

            reset() {
                
                this.search_data = {};

                this.search();
            },

            generate() {

                let query_string = this.getQueryString({ provider_ids: this.selected_provider_ids });
                
                window.location.href = this.new_route + '?' + query_string;

            },

            getQueryString(params) {

                let query_string = Object.keys(params).map(key => key + '=' + params[key]).join('&');

                return query_string;
            },

        }
    }
</script>

<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>

<style scoped>

</style>
