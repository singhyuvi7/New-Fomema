<script>

    export default {
        props: {
            laboratory:{
                type: Object,
                default: () => {},
                required: true
            },
            doctors:{
                type: Array,
                default: () => {},
                required: true
            },
            search_route: {
                type: String,
                required: true
            },
            states: {
                type: Array,
                default: () => [],
                required: true
            },
        },
        mounted() {
            this.laboratory_data = this.laboratory
            this.listed_doctors = this.doctors
        },
        created() {},
        computed: {
            selectAll: {
                get: function () {
                    return this.listed_doctors ? this.selected_doctors.length == this.listed_doctors.length : false;
                },
                set: function (value) {
                    var selected = [];

                    if (value) {
                        this.listed_doctors.forEach(function (item) {
                            selected.push(item);
                        });
                    }

                    this.selected_doctors = selected;
                }
            }
        },
        data: function () {
            return {
                laboratory_data: {},
                listed_doctors: [],
                selected_doctors: [],
                search_data: {},
                is_loading: false,
                laboratories: [],
                towns: []
            }
        },
        watch: {

        },
        methods: {
            getQueryString(params) {

                let query_string = Object.keys(params).map(key => key + '=' + params[key]).join('&');

                return query_string;
            },
            apply: function(laboratory){
                if(this.selected_doctors.length > 0 && laboratory){
                    this.selected_doctors.forEach((doctor) => {
                        let index = this.listed_doctors.findIndex(x => x.id == doctor.id);
                        doctor.new_lab = laboratory;
                        this.listed_doctors.splice(index, 1, doctor)
                    });
                }else{
                    alert('Please select doctor(s) and a laboratory before applying the changes.')
                }
            },
            revert: function(index){
                //revert back to old lab
                if(this.selected_doctors.length > 0){
                    this.selected_doctors.forEach((doctor) => {
                        let index = this.listed_doctors.findIndex(x => x.id == doctor.id);
                        this.$delete(this.listed_doctors[index], 'new_lab')
                    });
                }else{
                     alert('Please select doctor(s) before reverting the changes.')
                }
            },
            submit() {
                this.$refs.laboratory_form.submit();
            },
            search() {
                this.search_data.state_id = document.getElementById("state_id").value
                this.search_data.town_id = document.getElementById("town_id").value
                let query_string = this.getQueryString(this.search_data);
                this.is_loading = true;

                return axios
                    .get(this.search_route + '.json?' + query_string)
                    .then(response => {
                        this.laboratories = response.data
                        this.is_loading = false;
                    })
                    .catch(function (error) {
                        console.log('error res -->', error);
                    });
            },
            totalWorkerAllocated(items){
                return items.reduce(function(sum, item){
                    return sum + item.quota_used; 
                },0);
            }
        }
    }
</script>

<style scoped>
    
</style>
