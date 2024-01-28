<script>

    export default {
        props: {
            visit_plan: {
                type: Object,
                default: () => {},
                required: true
            },
            visit_plan_categories: {
                type: Array,
                default: () => [],
                required: false
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
                default: () => [],
                required: true
            },
            categories: {
                type: Object,
                default: () => {},
                required: true
            },
            search_route: {
                type: String,
                required: true
            },
            create_route: {
                type: String,
                required: true
            },
            visit_reports:{
                type: Array,
                default: () => [],
                required: false
            },
            visit_plan_approval:{
                type: Object,
                default: () => {},
                required: false
            },
            params:{
                type: Object,
                default: () => {},
                required: false
            },
            visit_report_details:{
                type: Array,
                default: () => [],
                required: false
            },
            allocations_last_year:{
                type: Array,
                default: () => [],
                required: false
            },
            allocations_current_year:{
                type: Array,
                default: () => [],
                required: false
            },
            examined_last_year:{
                type: Array,
                default: () => [],
                required: false
            },
            examined_current_year:{
                type: Array,
                default: () => [],
                required: false
            },
            certification_last_year:{
                type: Array,
                default: () => [],
                required: false
            },
            certification_current_year:{
                type: Array,
                default: () => [],
                required: false
            },
        },
        mounted() {

        },
        created() {

            // convert category constant into array

            this.categories_arr = Object.values(this.categories);

            // clone visit plan from props

            this.visit_plan_data = {...this.visit_plan};

            // preselect categories based on visit_plan_categories

            if (this.visit_plan_categories.length > 0) {
                this.visit_plan_categories.forEach((plan_category) => {
                    let selected_category = plan_category.category;
                    this.selected_categories.push(selected_category);
                });
            }

            // preselect states based on value of visit_plan_states

            if (this.selected_state_ids.length > 0) {

                this.visit_plan_states.forEach((visit_plan_state) => {
                    let selected_state = _.find(this.states, { id: parseInt(visit_plan_state.state_id) });
                    this.selected_states.push(selected_state);
                });

                // fetch towns based on selected state ids

                this
                    .fetchStateTowns()
                    .then((res) => {

                        // preselect towns based on visit_plan_towns

                        if (this.visit_plan_towns.length > 0) {

                            this.visit_plan_towns.forEach((visit_plan_town) => {
                                let selected_town = _.find(this.towns, { id: parseInt(visit_plan_town.town_id) });
                                this.selected_towns.push(selected_town);
                            });

                        }

                    })
                    .then((res) => {

                        // set search data

                        this.search_data['filter'] = true;
                        this.search_data['state_ids'] = this.selected_state_ids;
                        this.search_data['town_ids'] = this.selected_town_ids;

                        // fetch visit plan items

                        this
                            .search()
                            .then((res) => {

                                // preselect items based on visit_plan_items

                                if (this.visit_plan_items.length > 0) {

                                    this.visit_plan_items.forEach((visit_plan_item) => {
                                        
                                        let selected_provider = _.find(this.providers, { id: parseInt(visit_plan_item.visitable_id) });
                                        if (selected_provider) {
                                            selected_provider.visit_plan_item_id = visit_plan_item.id
                                            //check visit report
                                            let visit_report = _.find(this.visit_reports, { visit_plan_item_id: parseInt(visit_plan_item.id)})
                                            selected_provider.isVisitReportExist = visit_report ? true : false
                                            selected_provider.visit_report = visit_report ? visit_report : []

                                            //selected_provider = this.add_additional_data(visit_plan_item.visitable_id,selected_provider)
                                          
                                            this.selected_providers.push(selected_provider);
                                        }
                                        
                                    });

                                }

                        });

                    });

            }

        },
        computed: {

            // validation rules
            commentValidationRule: function (){
                let required = false;

                if(this.visit_plan_approval_data.decision === 'reject')
                    required = true;

                return {
                    required: required
                }     
            },
            categoryRule: function () {

                let required = false;

                if (this.submit_action.toLowerCase() === 'submit') {
                    required = true;
                }

                return {
                    required: required
                }
            },

            inspectFromRule: function () {

                let required = false;

                if (this.submit_action.toLowerCase() === 'submit') {
                    required = true;
                }

                return {
                    required: required
                }
            },

            inspectToRule: function () {

                let required = false;

                if(this.visit_plan_data.inspect_from > this.visit_plan_data.inspect_to){
                    this.visit_plan_data.inspect_to = ''
                }

                if (this.submit_action.toLowerCase() === 'submit') {
                    required = true;
                }

                return {
                    required: required
                }
            },

            commentRule: function () {

                let required = false;

                if (this.submit_action.toLowerCase() === 'submit') {
                    // required = true;
                }

                return {
                    required: required
                }
            },

            selectedProviderRule: function () {

                let required = false;

                if (this.submit_action.toLowerCase() === 'submit') {
                    required = true;
                }

                return {
                    required: required
                }
            },

            stateRule: function () {

                let required = false;

                if (this.submit_action.toLowerCase() === 'submit') {
                    required = true;
                }

                return {
                    required: required
                }
            },

            townRule: function () {

                let required = false;

                if (this.submit_action.toLowerCase() === 'submit') {
                    required = true;
                }

                return {
                    required: required
                }
            },

            // end of validation rules

            formReadOnly: function () {

                return !this.canEdit;
            },

            canEdit: function () {

                if (
                    !this.visit_plan_data.status
                    || this.visit_plan_data.status === 'DRAFT'
                    || this.visit_plan_data.status === 'REJECTED'
                ) {
                    return true;
                }

                return false;
            },

            selected_provider_ids: function () {
                
                let selected_ids = _.map(this.selected_providers, 'id');

                selected_ids = selected_ids.join(",");

                return selected_ids;
            },

            selected_state_ids() {

                let state_ids = _.map(this.selected_states, 'id');
                
                // get state_ids from visit_plan_items if the user remove state from selection when draft mode

                let visit_item_state_ids = _.map(this.visit_plan_items, 'state_id');
                
                // combine both ids and get the unique ids

                let unique_state_ids = Array.from(new Set(state_ids.concat(visit_item_state_ids)));

                unique_state_ids = unique_state_ids.join(",");

                return unique_state_ids;

            },

            selected_town_ids() {

                let town_ids = _.map(this.selected_towns, 'id');

                // get town_ids from visit_plan_items if the user remove town from selection when draft mode
                
                let visit_item_town_ids = _.map(this.visit_plan_items, 'town_id');

                // combine both ids and get the unique ids
                
                let unique_town_ids = Array.from(new Set(town_ids.concat(visit_item_town_ids)));

                unique_town_ids = unique_town_ids.join(",");

                return unique_town_ids;

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
            onApprove: function (){
                if(this.params.action == 'approval'){
                    return true;
                }
                return false;
            }

        },
        data: function () {
            return {
                visit_plan_data: {},
                visit_plan_approval_data: {
                    decision: ''
                },
                providers: [],
                categories_arr: [],
                selected_categories: [],
                selected_providers: [],
                selected_states: [],
                selected_towns: [],
                towns: [],
                search_data: {},
                selectAll: false,
                is_loading: false,
                submit_action: 'save'
            }
        },
        watch: {

        },
        methods: {
            approvalUpdate($event){
                this.visit_plan_approval_data.decision = $event.target.value.toLowerCase()
            },
            safeAccess(object, key) {

                return _.get(object, key, 'N/A');
            },

            providerInfo(provider) {

                let provider_info = provider.town.name + ', ' + provider.state.name + ' - ' + provider.name + ' (' + provider.code + ')';

                return provider_info;
            },

            removeSelectedProvider(provider) {
                this.selected_providers = this.selected_providers.filter((p) => p.id != provider.id);
            },

            select() {
                this.ss = [];

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

            selectNewState({name, id}) {
                // console.log(name, id);
            },

            selectNewTown({name, id}) {
                // console.log(name, id);
            },

            getStateTowns(state_name) {

                if (this.towns[state_name]) {
                    return this.towns[state_name];
                }

                return [];
            },

            fetchStateTowns() {

                return axios
                    .get('/states/' + this.selected_state_ids + '/multistatetowns.json')
                    .then(response => {
                        let towns = response.data

                        this.towns = towns;

                    })
                    .catch(function (error) {
                        console.log('error res -->', error);
                    });
            },

            filter(e) {
                this.search_data.filter = true;

                //console.log('search_data: ', JSON.stringify(this.search_data, null, 2));
                this.search();
            },

            search() {
                if(this.search_data.state_ids && this.search_data.town_ids){
                    let query_string = this.getQueryString(this.search_data);

                    this.is_loading = true;

                    return axios
                        .get(this.search_route + '.json?' + query_string)
                        .then(response => {
                            this.providers = []
                            response.data.forEach((provider) => {
                                provider = this.add_additional_data(provider.id,provider)
                                if(this.search_data.indicator){
                                    let indicator = this.search_data.indicator
                                    let check = false
                                    if(indicator == 'RED' && !provider.is_previous_year_exist && !provider.is_current_year_exist){
                                        // no current year
                                        check = true
                                    }else if(indicator == 'YELLOW' && provider.is_previous_year_exist && !provider.is_current_year_exist){
                                        // with last year
                                        check = true
                                    }
                                    else if(indicator == 'GREEN' && provider.is_current_year_exist){
                                        // with current year
                                        check = true
                                    }

                                    if(check)
                                       this.providers.push(provider) 
                                }
                                else
                                    this.providers.push(provider)
                            });

                            this.is_loading = false;

                        })
                        .catch(function (error) {
                            console.log('error res -->', error);
                        });
                }else{
                    this.providers = []
                }
            },

            reset() {
                this.$delete(this.search_data, 'code')
                this.$delete(this.search_data, 'provider_name')

                //this.selected_states = [];
                //this.selected_towns = [];

                this.search();
            },

            save() {

                this.submit_action = 'save';

                var self = this;

                Vue.nextTick(function () {
                    self.formSubmit();
                });

            },

            submit() {

                this.submit_action = 'submit';

                var self = this;

                Vue.nextTick(function () {
                    self.formSubmit();
                });
                
            },

            formSubmit() {

                this.$validator.validate().then(valid => {
                        
                    if (valid) {
                        this.$refs.visit_plan_form.submit();
                    }
                    else {
                        // scroll to top
                        window.scrollTo(0,0);

                        console.log('validation error');
                    }

                });
            },

            getQueryString(params) {

                let query_string = Object.keys(params).map(key => key + '=' + params[key]).join('&');

                return query_string;
            },
            selectProviderUpdate: function (event){
                this.selected_providers = Object.values(this.selected_providers.reduce((arr,obj)=>Object.assign(arr,{[obj.code]:obj}),{}))
            },
            add_additional_data: function(visitable_id,selected_provider){
                //for last visit report date
                let visitable_type = this.visit_plan_data.visitable_type
                
                /* this.sp_visit_report = this.visit_report_details.filter(obj => {
                    if(visitable_type == 'Doctor')
                        return obj.doctor_id === parseInt(visitable_id)
                    else if(visitable_type == 'Laboratory')
                        return obj.laboratory_id === parseInt(visitable_id)
                    else if(visitable_type == 'XrayFacility')
                        return obj.xray_facility_id === parseInt(visitable_id)
                }) */

                //to check if theres visit report for current year
                /* let current_year = moment().year()
                let is_current_year_exist = this.sp_visit_report.some(function(x) {
                    let year = moment(x.created_at).year()
                    return year === current_year;
                }); 
                selected_provider.is_current_year_exist = is_current_year_exist */

                // to check if theres visit report for previous year
                /* let previous_year = moment().subtract(1, 'year').year()
                let is_previous_year_exist = this.sp_visit_report.some(function(x) {
                    let year = moment(x.created_at).year()
                    return year === previous_year;
                }); 
                selected_provider.is_previous_year_exist = is_previous_year_exist */

                // this.last_visit_report = this.sp_visit_report[this.sp_visit_report.length -1];

                // get sop compliance
                if(selected_provider.last_visit_report_date && (visitable_type == 'Doctor' || visitable_type == 'XrayFacility')){
                    selected_provider.sop_compliance = this.get_sop_compliance(visitable_type,selected_provider) //stop here
                }else
                   selected_provider.sop_compliance = '-' 
                
                selected_provider.last_visit_report_date = selected_provider.last_visit_report_date ? moment(selected_provider.last_visit_report_date).format('DD/MM/YYYY') : '-'

                // end last visit report date

                // allocations
                /*
                this.allocations_last_year_count = this.allocations_last_year.filter(obj => {
                    if(visitable_type == 'Doctor')
                        return obj.doctor_id === parseInt(visitable_id)
                    else if(visitable_type == 'Laboratory')
                        return obj.laboratory_id === parseInt(visitable_id)
                    else if(visitable_type == 'XrayFacility')
                        return obj.xray_facility_id === parseInt(visitable_id)
                })
                selected_provider.allocations_last_year = this.allocations_last_year_count.length

                this.allocations_current_year_count = this.allocations_current_year.filter(obj => {
                    if(visitable_type == 'Doctor')
                        return obj.doctor_id === parseInt(visitable_id)
                    else if(visitable_type == 'Laboratory')
                        return obj.laboratory_id === parseInt(visitable_id)
                    else if(visitable_type == 'XrayFacility')
                        return obj.xray_facility_id === parseInt(visitable_id)
                })

                selected_provider.allocations_current_year = this.allocations_current_year_count.length */
                // end allocations

                // examined
                /*
                this.examined_last_year_count = this.examined_last_year.filter(obj => {
                    if(visitable_type == 'Doctor')
                        return obj.doctor_id === parseInt(visitable_id)
                    else if(visitable_type == 'Laboratory')
                        return obj.laboratory_id === parseInt(visitable_id)
                    else if(visitable_type == 'XrayFacility')
                        return obj.xray_facility_id === parseInt(visitable_id)
                })
                selected_provider.examined_last_year = this.examined_last_year_count.length
                
                this.examined_current_year_count = this.examined_current_year.filter(obj => {
                    if(visitable_type == 'Doctor')
                        return obj.doctor_id === parseInt(visitable_id)
                    else if(visitable_type == 'Laboratory')
                        return obj.laboratory_id === parseInt(visitable_id)
                    else if(visitable_type == 'XrayFacility')
                        return obj.xray_facility_id === parseInt(visitable_id)
                })
                selected_provider.examined_current_year = this.examined_current_year_count.length */
                //end

                //certification
                /*
                this.certification_last_year_count = this.certification_last_year.filter(obj => {
                    return obj.doctor_id === parseInt(visitable_id)
                })
                selected_provider.certification_last_year = this.certification_last_year_count.length
                
                this.certification_current_year_count = this.certification_current_year.filter(obj => {
                    return obj.doctor_id === parseInt(visitable_id)
                })
                selected_provider.certification_current_year = this.certification_current_year_count.length */
                // end certification

                return selected_provider
            },
            get_sop_compliance(visitable_type,visit_report){
                let sopArr = []
                if(visitable_type == 'Doctor'){
                    if(visit_report.satisfactory) { sopArr.push('S') }
                    if(visit_report.non_verify_original_passport_fw_present) { sopArr.push('Y') }
                    if(visit_report.non_verify_original_passport_fw_not_present) { sopArr.push('N') }
                    if(visit_report.unable_to_produce_apc) { sopArr.push('A') }
                    if(visit_report.non_notify_communicable_disease) { sopArr.push('G') }
                    if(visit_report.inadequate_equipment) { sopArr.push('I') }
                    if(visit_report.insufficient_operation_hour) { sopArr.push('H') }
                    if(visit_report.inappropriate_vacutainer) { sopArr.push('V') }
                    if(visit_report.no_produce_dispatch_record) { sopArr.push('L') }
                    if(visit_report.no_produce_written_consent) { sopArr.push('C') }
                    if(visit_report.no_produce_medical_record) { sopArr.push('R') }
                    if(visit_report.closed) { sopArr.push('P') }
                    if(visit_report.no_produce_borang_b) { sopArr.push('B') }
                    if(visit_report.other) { sopArr.push('K') }  
                
                }else if(visitable_type == 'XrayFacility'){
                    if(visit_report.satisfactory) { sopArr.push('S') }
                    if(visit_report.non_verify_original_passport_fw_present) { sopArr.push('Y') }
                    if(visit_report.non_verify_original_passport_fw_not_present) { sopArr.push('N') }
                    if(visit_report.unable_to_produce_apc) { sopArr.push('A') }
                    if(visit_report.no_xray_license_for_mengguna) { sopArr.push('M') }
                    if(visit_report.inadequate_equipment) { sopArr.push('I') }
                    if(visit_report.insufficient_operation_hour) { sopArr.push('H') }
                    if(visit_report.expired_license_menstor_mengguna) { sopArr.push('E') }
                    if(visit_report.no_produce_medical_record) { sopArr.push('R') }
                    if(visit_report.closed) { sopArr.push('P') }
                    if(visit_report.no_produce_borang_b) { sopArr.push('B') }
                    if(visit_report.other) { sopArr.push('K') }
                }
                return sopArr.join()
            }

        },
        filters: {
            // Filter definitions
            associated_clinic(doctors) {
                return doctors.length
                // return doctors.map(function (doctor){
                //     return doctor.clinic_name
                // }).join(',')
            }
        }
    }
</script>

<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>

<style scoped>
    
</style>
