<script>

    export default {
        props: {
            visit_plan: {
                type: Object,
                default: () => {},
                required: true
            },
        },
        mounted() {

        },
        created() {

            this.visit_plan_categories = [...this.visit_plan.visit_plan_categories];
            this.visit_plan_states = [...this.visit_plan.visit_plan_states];
            this.visit_plan_towns = [...this.visit_plan.visit_plan_towns];
            this.visit_plan_items = [...this.visit_plan.visit_plan_items];

        },
        computed: {

            category_list: function () {

                let list = this.visit_plan_categories.map(function(c){ return c.category }).join(", ");

                return list;
            },

            state_list: function () {

                let list = this.visit_plan_states.map(function(s){ return s.state.name }).join(", ");

                return list;
            },

            town_list: function () {

                let list = this.visit_plan_towns.map(function(t){ return t.town.name }).join(", ");

                return list;
            },

            commentValidationRule: function () {

                let required = false;

                if (this.visit_plan_approval.decision === 'REJECT') {
                    required = true;
                }

                return {
                    required: required
                }
            },

            canEdit: function () {

                if (
                    this.visit_plan.status === 'LEVEL_1_APPROVAL'
                    || this.visit_plan.status === 'LEVEL_1_APPROVED'
                    || this.visit_plan.status === 'LEVEL_2_APPROVAL'
                ) {
                    return true;
                }

                return false;
            },

            haveApproval: function () {

                if (
                    this.visit_plan.level_1_approval_by
                    || this.visit_plan.level_2_approval_by
                ) {
                    return true;
                }

                return false;
            },

            isApproveLevel1: function () {

                if (this.visit_plan.level_1_approval_decision === 'APPROVE') {
                    return true;
                }

                return false;
            },

            isRejectLevel1: function () {

                if (this.visit_plan.level_1_approval_decision === 'REJECT') {
                    return true;
                }

                return false;
            },

            isApproveLevel2: function () {

                if (this.visit_plan.level_2_approval_decision === 'APPROVE') {
                    return true;
                }

                return false;
            },

            isRejectLevel2: function () {

                if (this.visit_plan.level_2_approval_decision === 'REJECT') {
                    return true;
                }

                return false;
            },

        },
        data: function () {
            return {
                visit_plan_approval: {},
                visit_plan_categories: [],
                visit_plan_states: [],
                visit_plan_towns: [],
                visit_plan_items: [],
                submit_action: 'save'
            }
        },
        watch: {

        },
        methods: {

            myDateTime(date) {
                let my_date_time = dayjs(date).format('DD/MM/YYYY H:m')
                return my_date_time;
            },

            safeAccess(object, key) {

                return _.get(object, key, 'N/A');
            },

            save() {
                this.submit_action = 'save';

                setTimeout(() => {
                    this.$refs.visit_plan_form.submit();
                }, 100);

            },

            submit() {
                this.submit_action = 'submit';

                this.$validator.validate().then(valid => {
                    
                    if (valid) {
                        this.$refs.visit_plan_form.submit();
                    }
                    else {
                        console.log('validation error');
                    }
                    
                });

            },

        }
    }
</script>

<style scoped>

</style>
