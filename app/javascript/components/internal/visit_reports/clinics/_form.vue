<script>
    import { Validator } from 'vee-validate';
    export default {
        props: {
            visit_report: {
                type: Object,
                default: () => {},
                required: true
            },
            org_users: {
                type: Array,
                default: () => [],
                required: true
            },
            visit_report_visitors: {
                type: Array,
                default: () => [],
                required: false
            },
            categories: {
                type: Object,
                default: () => {},
                required: true
            },
            params:{
                type: Object,
                default: () => {},
                required: false
            },
            visit_report_approval:{
                type: Object,
                default: () => {},
                required: false
            },
            recommendations: {
                type: Object,
                default: () => {},
                required: true
            },
            years: {
                type: Array,
                default: () => [],
                required: true
            },
            pass_visit_report_details: {
                type: Object,
                default: () => {},
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
        },
        mounted() {

        },
        created() {
            this.categories_arr = Object.values(this.categories);
            
            // clone visit plan from props
            this.visit_report_data = {...this.visit_report};

            //default foreign worker number
            this.visit_report_data.visit_report_doctor.foreign_worker_present = this.visit_report_data.visit_report_doctor.foreign_worker_present ? this.visit_report_data.visit_report_doctor.foreign_worker_present : 0

            for (const [key, value] of Object.entries(this.visit_report_data.visit_report_doctor)) {
                if (key.includes("_acceptable")) {
                    if (!value)
                        this.visit_report_data.visit_report_doctor[key] = 'Y'
                }
            }

            //tick all acceptable and satisfactory if its new
            if(this.visit_report_data.code == null)
                this.acceptableChange()

            // for clinic address
            this.clinic_address = [this.visit_report_data.visit_plan_item.visitable.address1,this.visit_report_data.visit_plan_item.visitable.address2,this.visit_report_data.visit_plan_item.visitable.address3,this.visit_report_data.visit_plan_item.visitable.address4,this.visit_report_data.visit_plan_item.visitable.postcode]

            // if operating hour doesnt exist
            if(!this.visit_report_data.visit_plan_item.visitable.operating_hour){
                this.visit_report_data.visit_plan_item.visitable.operating_hour = {}
            }
            this.org_users_arr = this.org_users

            let type_of_visit = ''

            // preselect inspectorate team based on visit report visitors
            if (this.visit_report_visitors.length > 0) {
                this.visit_report_visitors.forEach((inspectorate_team) => {
                    let selected_visitor = _.find(this.org_users, { id: parseInt(inspectorate_team.visitor_id) });
                    if(selected_visitor)
                        this.selected_visitors.push(selected_visitor);
                    else
                        this.addTag(inspectorate_team.name)
                });
            }

            // convert time format for visit_time_from and visit_time_to

            this.visit_report_data.visit_time_from = dayjs(this.visit_report_data.visit_time_from).format('HH:mm');
            this.visit_report_data.visit_time_to = dayjs(this.visit_report_data.visit_time_to).format('HH:mm');

            //convert time format for operation hours
            if(this.visit_report.status === null || this.visit_report.status === 'DRAFT' || this.visit_report.status === 'REJECTED'){
                this.operating_hour = this.visit_report_data.visit_plan_item.visitable.operating_hour
            }else
                this.operating_hour = this.visit_report_data.operating_hour

            this.operating_hour.monday_start = this.operating_hour.monday_start ? dayjs(this.operating_hour.monday_start).format('HH:mm') : ''
            this.operating_hour.monday_end = this.operating_hour.monday_end ? dayjs(this.operating_hour.monday_end).format('HH:mm') : ''
            this.operating_hour.tuesday_end = this.operating_hour.tuesday_end ? dayjs(this.operating_hour.tuesday_end).format('HH:mm') : ''
            this.operating_hour.wednesday_end = this.operating_hour.wednesday_end ? dayjs(this.operating_hour.wednesday_end).format('HH:mm') : ''
            this.operating_hour.thursday_end = this.operating_hour.thursday_end ? dayjs(this.operating_hour.thursday_end).format('HH:mm') : ''
            this.operating_hour.friday_end = this.operating_hour.friday_end ? dayjs(this.operating_hour.friday_end).format('HH:mm') : ''
            this.operating_hour.saturday_end = this.operating_hour.saturday_end ? dayjs(this.operating_hour.saturday_end).format('HH:mm') : ''
            this.operating_hour.sunday_end = this.operating_hour.sunday_end ? dayjs(this.operating_hour.sunday_end).format('HH:mm') : ''
            this.operating_hour.public_holiday_end = this.operating_hour.public_holiday_end ? dayjs(this.operating_hour.public_holiday_end).format('HH:mm') : ''

            this.operating_hour.tuesday_start = this.operating_hour.tuesday_start ? dayjs(this.operating_hour.tuesday_start).format('HH:mm') : ''
            this.operating_hour.wednesday_start = this.operating_hour.wednesday_start ? dayjs(this.operating_hour.wednesday_start).format('HH:mm') : ''
            this.operating_hour.thursday_start = this.operating_hour.thursday_start ? dayjs(this.operating_hour.thursday_start).format('HH:mm') : ''
            this.operating_hour.friday_start = this.operating_hour.friday_start ? dayjs(this.operating_hour.friday_start).format('HH:mm') : ''
            this.operating_hour.saturday_start = this.operating_hour.saturday_start ? dayjs(this.operating_hour.saturday_start).format('HH:mm') : ''
            this.operating_hour.sunday_start = this.operating_hour.sunday_start ? dayjs(this.operating_hour.sunday_start).format('HH:mm') : ''
            this.operating_hour.public_holiday_start = this.operating_hour.public_holiday_start ? dayjs(this.operating_hour.public_holiday_start).format('HH:mm') : ''

            //convert date format for prepare
            this.visit_report_data.prepare_at = dayjs(this.visit_report_data.prepare_at).format('YYYY-MM-DD');

            // readonly details
            this.last_visited_date = this.pass_visit_report_details ? dayjs(this.pass_visit_report_details.created_at).format('DD/MM/YYYY') : ''
            this.allocations_last_current_year = this.allocations_last_year.length+'/'+this.allocations_current_year.length
            // end readonly

            //move to globalize (repeated in all visit report)
            Validator.extend('time_validator', {
                getMessage: field => "The " + field + " value should be after the selected starting time",
                validate: (value) => new Promise(resolve => {
                    resolve({
                        valid: false
                    });
                })
            });
            //end global

            // for unacceptable fields
            let _unacceptable_fields = this.visit_report_data.visit_report_doctor.unacceptable_fields ? JSON.parse(this.visit_report_data.visit_report_doctor.unacceptable_fields) : {}
            for (var _unacceptable_field in _unacceptable_fields) {
                    for (var key in _unacceptable_fields[_unacceptable_field])
                        this.unacceptable_fields[_unacceptable_field][key] = _unacceptable_fields[_unacceptable_field][key];
            }
            this.unacceptable_fields_string = JSON.stringify(this.unacceptable_fields)
            // end unacceptable fields

        },
        computed: {

            // validation rules
            commentValidationRule: function (){
                let required = false;
                
                if(this.visit_report_approval_data.decision === 'reject')
                    required = true;

                return {
                    required: required
                }
            },

            doctorNameRule: function () {
                let required = true;

                return {
                    required: required
                }
            },

            visitDateRule: function () {

                let required = true;

                return {
                    required: required
                }
            },

            visitTimeFromRule: function () {

                let required = true;

                return {
                    required: required
                }
            },

            visitTimeToRule: function () {

                let required = true;
                let time_validator = false

                if (this.visit_report_data.visit_time_from > this.visit_report_data.visit_time_to ){
                    time_validator = true
                }

                return {
                    required: required,
                    time_validator: time_validator
                }
            },

            visitDateMax: function () {
                return this.visit_report_data.created_at ? this.visit_report_data.created_at : new Date()
            },

            categoryRule: function () {
                
                let required = true;

                return {
                    required: required
                }
            },

            interactedWithRule: function () {
                
                let required = true;

                return {
                    required: required
                }
            },

            checklistRule: function () {
                let required = true;

                return {
                    required: required,
                    numeric: true
                }          
            },

            foreignWorkerPresentRule: function () {

                let required = true;

                return {
                    required: required,
                    numeric :true
                }
            },
            
            foreignWorkerPresentCommentRule: function () {

                let required = false;

                if (this.visit_report_data.visit_report_doctor.foreign_worker_present_acceptable === 'N') {
                    required = true;
                }

                return {
                    required: required
                }
            },

            foreignWorkerPresentAcceptableRule: function () {

                let required = true;

                return {
                    required: required
                }
            },

            non_verify_original_passport_fw_present_rule: function () {
                
                let required = false;

                return {
                    required: required
                }
            },

            inappropriate_vacutainer_rule: function () {
                
                let required = false;

                return {
                    required: required
                }
            },

            inspectorateTeamRule: function () {

                let required = false;

                if (this.submit_action.toLowerCase() === 'submit') {
                    required = true;
                }

                return {
                    required: required
                }
            },

            /* apc */
            apcNoRule: function () {

                let required = true;

                return {
                    required: required
                }
            },

            apcYearRule: function () {

                let required = true;

                return {
                    required: required,
                    numeric: true
                }
            },

            apcAcceptableRule: function () {

                let required = true;

                return {
                    required: required
                }
            },

            apcCommentRule: function () {

                let required = false;

                if (this.visit_report_data.visit_report_doctor.apc_acceptable === 'N') {
                    required = true;
                }

                return {
                    required: required
                }
            },
            /* end apc*/

            /* reg. number */
            regNoRule: function () {

                let required = true;

                return {
                    required: required
                }
            },

            regNoAcceptableRule: function () {

                let required = true;

                return {
                    required: required
                }
            },

            regNoCommentRule: function () {

                let required = false;

                if (this.visit_report_data.visit_report_doctor.private_healthcare_registration_number_acceptable === 'N') {
                    required = true;
                }

                return {
                    required: required
                }
            },
            /* end reg. number */

            /* consent */
            consentAcceptableRule: function () {

                let required = true;

                return {
                    required: required
                }
            },
            contentCommentRule: function () {

                let required = false;

                if (this.visit_report_data.visit_report_doctor.written_consent_acceptable === 'N') {
                    required = true;
                }

                return {
                    required: required
                }
            },
            /* end consent */

            /* maintenance */
            maintenanceAcceptableRule: function () {

                let required = true;

                return {
                    required: required
                }
            },
            maintenanceCommentRule: function () {

                let required = false;

                if (this.visit_report_data.visit_report_doctor.medical_record_maintenance_acceptable === 'N') {
                    required = true;
                }

                return {
                    required: required
                }
            },
            /* end maintenance */

            /* notify comm. */
            notificationCommAcceptableRule: function () {

                let required = true;

                return {
                    required: required
                }
            },
            notificationCommCommentRule: function () {

                let required = false;

                if (this.visit_report_data.visit_report_doctor.communicable_disease_acceptable === 'N') {
                    required = true;
                }

                return {
                    required: required
                }
            },
            /* end notify comm. */

            /* vacutainer */
            vacutainerExpiryRule: function () {

                let required = true;

                return {
                    required: required
                }
            },
            vacutainerExpiryDateMin: function (){
                //disallow the expiry date before visit date if ticked as 'Yes'
                if(this.visit_report_data.visit_report_doctor.vacutainer_acceptable === 'Y'){
                    return this.visit_report_data.visit_date ? this.visit_report_data.visit_date : ""
                }
                return ""
            },
            vacutainerAcceptableRule: function () {

                let required = true;

                return {
                    required: required
                }
            },
            vacutainerCommentRule: function () {

                let required = false;

                if (this.visit_report_data.visit_report_doctor.vacutainer_acceptable === 'N') {
                    required = true;
                }

                return {
                    required: required
                }
            },
            /* end vacutainer */

            /* facilities */
            facilitiesAcceptableRule: function () {

                let required = true;

                return {
                    required: required
                }
            },
            facilitiesCommentRule: function () {

                let required = false;

                if (this.visit_report_data.visit_report_doctor.adequate_facility_acceptable === 'N') {
                    required = true;
                }

                return {
                    required: required
                }
            },
            /* end facilities */

            /* dispatch record */
            dispatchRecordAcceptableRule: function () {

                let required = true;

                return {
                    required: required
                }
            },
            dispatchRecordCommentRule: function () {

                let required = false;

                if (this.visit_report_data.visit_report_doctor.dispatch_record_acceptable === 'N') {
                    required = true;
                }

                return {
                    required: required
                }
            },
            /* end dispatch record */

            /* operating hour */  
            monBreakHourRule: function () {
                let required = true;

                if (this.visit_report_data.operating_hour.monday_is_close) {
                    required = false
                }

                return {
                    required: required
                }  
            },
            monVisitTimeStartRule: function (){
                let required = true;

                if (this.visit_report_data.operating_hour.monday_is_close || this.visit_report_data.operating_hour.monday_is_24_hour) {
                    required = false
                }

                return {
                    required: required
                }      
            },
            monVisitTimeEndRule: function (){
                let required = true;
                let time_validator = false

                if (this.visit_report_data.operating_hour.monday_is_close || this.visit_report_data.operating_hour.monday_is_24_hour) {
                    required = false
                }

                if (this.visit_report_data.operating_hour.monday_start > this.visit_report_data.operating_hour.monday_end ){
                    time_validator = true
                }

                return {
                    required: required,
                    time_validator: time_validator
                }      
            },
            tuesBreakHourRule: function () {
                let required = true;

                if (this.visit_report_data.operating_hour.tuesday_is_close) {
                    required = false
                }

                return {
                    required: required
                }  
            },
            tuesVisitTimeStartRule: function (){
                let required = true;

                if (this.visit_report_data.operating_hour.tuesday_is_close || this.visit_report_data.operating_hour.tuesday_is_24_hour) {
                    required = false
                }

                return {
                    required: required
                }      
            },
            tuesVisitTimeEndRule: function (){
                let required = true;
                let time_validator = false

                if (this.visit_report_data.operating_hour.tuesday_is_close || this.visit_report_data.operating_hour.tuesday_is_24_hour) {
                    required = false
                }
                if (this.visit_report_data.operating_hour.tuesday_start > this.visit_report_data.operating_hour.tuesday_end ){
                    time_validator = true
                }
                return {
                    required: required,
                    time_validator: time_validator
                }      
            },
            wedBreakHourRule: function () {
                let required = true;

                if (this.visit_report_data.operating_hour.wednesday_is_close) {
                    required = false
                }

                return {
                    required: required
                }  
            },
            wedVisitTimeStartRule: function (){
                let required = true;

                if (this.visit_report_data.operating_hour.wednesday_is_close || this.visit_report_data.operating_hour.wednesday_is_24_hour) {
                    required = false
                }

                return {
                    required: required
                }      
            },
            wedVisitTimeEndRule: function (){
                let required = true;
                let time_validator = false

                if (this.visit_report_data.operating_hour.wednesday_is_close || this.visit_report_data.operating_hour.wednesday_is_24_hour) {
                    required = false
                }
                if (this.visit_report_data.operating_hour.wednesday_start > this.visit_report_data.operating_hour.wednesday_end ){
                    time_validator = true
                }
                return {
                    required: required,
                    time_validator: time_validator
                }      
            },
            thursBreakHourRule: function () {
                let required = true;

                if (this.visit_report_data.operating_hour.thursday_is_close) {
                    required = false
                }

                return {
                    required: required
                }  
            },
            thursVisitTimeStartRule: function (){
                let required = true;

                if (this.visit_report_data.operating_hour.thursday_is_close || this.visit_report_data.operating_hour.thursday_is_24_hour) {
                    required = false
                }

                return {
                    required: required
                }      
            },
            thursVisitTimeEndRule: function (){
                let required = true;
                let time_validator = false
                if (this.visit_report_data.operating_hour.thursday_is_close || this.visit_report_data.operating_hour.thursday_is_24_hour) {
                    required = false
                }
                if (this.visit_report_data.operating_hour.thursday_start > this.visit_report_data.operating_hour.thursday_end ){
                    time_validator = true
                }
                return {
                    required: required,
                    time_validator: time_validator
                }      
            },
            friBreakHourRule: function () {
                let required = true;

                if (this.visit_report_data.operating_hour.friday_is_close) {
                    required = false
                }

                return {
                    required: required
                }  
            },
            friVisitTimeStartRule: function (){
                let required = true;

                if (this.visit_report_data.operating_hour.friday_is_close || this.visit_report_data.operating_hour.friday_is_24_hour) {
                    required = false
                }

                return {
                    required: required
                }      
            },
            friVisitTimeEndRule: function (){
                let required = true;
                let time_validator = false
                if (this.visit_report_data.operating_hour.friday_is_close || this.visit_report_data.operating_hour.friday_is_24_hour) {
                    required = false
                }
                if (this.visit_report_data.operating_hour.friday_start > this.visit_report_data.operating_hour.friday_end ){
                    time_validator = true
                }
                return {
                    required: required,
                    time_validator: time_validator
                }      
            },
            satBreakHourRule: function () {
                let required = true;

                if (this.visit_report_data.operating_hour.saturday_is_close) {
                    required = false
                }

                return {
                    required: required
                }  
            },
            satVisitTimeStartRule: function (){
                let required = true;

                if (this.visit_report_data.operating_hour.saturday_is_close || this.visit_report_data.operating_hour.saturday_is_24_hour) {
                    required = false
                }

                return {
                    required: required
                }      
            },
            satVisitTimeEndRule: function (){
                let required = true;
                let time_validator = false
                if (this.visit_report_data.operating_hour.saturday_is_close || this.visit_report_data.operating_hour.saturday_is_24_hour) {
                    required = false
                }
                if (this.visit_report_data.operating_hour.saturday_start > this.visit_report_data.operating_hour.saturday_end ){
                    time_validator = true
                }
                return {
                    required: required,
                    time_validator: time_validator
                }      
            },
            sunBreakHourRule: function () {
                let required = true;

                if (this.visit_report_data.operating_hour.sunday_is_close) {
                    required = false
                }

                return {
                    required: required
                }  
            },
            sunVisitTimeStartRule: function (){
                let required = true;

                if (this.visit_report_data.operating_hour.sunday_is_close || this.visit_report_data.operating_hour.sunday_is_24_hour) {
                    required = false
                }

                return {
                    required: required
                }      
            },
            sunVisitTimeEndRule: function (){
                let required = true;
                let time_validator = false
                if (this.visit_report_data.operating_hour.sunday_is_close || this.visit_report_data.operating_hour.sunday_is_24_hour) {
                    required = false
                }
                if (this.visit_report_data.operating_hour.sunday_start > this.visit_report_data.operating_hour.sunday_end ){
                    time_validator = true
                }
                return {
                    required: required,
                    time_validator: time_validator
                }      
            },
            publicHolidayBreakHourRule: function () {
                let required = true;

                if (this.visit_report_data.operating_hour.public_holiday_is_close) {
                    required = false
                }

                return {
                    required: required
                }  
            },
            publicHolidayVisitTimeStartRule: function (){
                let required = true;

                if (this.visit_report_data.operating_hour.public_holiday_is_close || this.visit_report_data.operating_hour.public_holiday_is_24_hour) {
                    required = false
                }

                return {
                    required: required
                }      
            },
            publicHolidayVisitTimeEndRule: function (){
                let required = true;
                let time_validator = false
                if (this.visit_report_data.operating_hour.public_holiday_is_close || this.visit_report_data.operating_hour.public_holiday_is_24_hour) {
                    required = false
                }
                if (this.visit_report_data.operating_hour.public_holiday_start > this.visit_report_data.operating_hour.public_holiday_end ){
                    time_validator = true
                }
                return {
                    required: required,
                    time_validator: time_validator
                }      
            },
            operatingHourAcceptableRule: function () {

                let required = true;

                return {
                    required: required
                }
            },
            operatingHourCommentRule: function () {

                let required = false;

                if (this.visit_report_data.visit_report_doctor.operating_hour_acceptable === 'N') {
                    required = true;
                }

                return {
                    required: required
                }
            },
            /* end operating hour */ 
            satisfactoryRule: function () {
                
                let required = false;

                return {
                    required: required
                }
            },
            sopNonComplianceRule: function () {
                
                let required = false;

                return {
                    required: required
                }
            },

            otherCommentRule: function() {
                let required = false;

                if (this.visit_report_data.visit_report_doctor.other == true) {
                    required = true;
                }

                return {
                    required: required
                }  
            },

            recommendationsRule: function(){
                let required = true;

                return {
                    required: required
                }
            },
            recommendationDateRule: function(){
                let required = true;
                let recommendation = this.visit_report_data.visit_report_doctor.recommendation

                if(!recommendation || recommendation === 'SATISFACTORY') {
                    required = false
                }

                return {
                    required: required
                }
            },
            recommendationDateMin: function(){
                return moment().format("YYYY-MM-DD");
            },

            preparedByRule: function(){
                let required = true;

                return {
                    required: required
                }
            },

            preparedDateRule: function () {

                let required = true;

                return {
                    required: required
                }
            },
            foreignWorkerUnacceptableRule: function (){
                let required = false
                if (this.visit_report_data.visit_report_doctor.foreign_worker_present_acceptable === 'N') {
                    required = true
                    for (let [key, value] of Object.entries(this.unacceptable_fields.foreign_worker)) {
                        if (!key.includes("_comment")) {
                            if(value)
                                required = false;
                        }
                    }
                }
                return {
                    required: required
                }
            },
            apcUnacceptableRule: function (){
                let required = false
                if (this.visit_report_data.visit_report_doctor.apc_acceptable === 'N') {
                    required = true
                    for (let [key, value] of Object.entries(this.unacceptable_fields.apc)) {
                        if (!key.includes("_comment")) {
                            if(value)
                                required = false;
                        }
                    }
                }
                return {
                    required: required
                }
            },
            registrationNumberUnacceptableRule: function (){
                let required = false
                if (this.visit_report_data.visit_report_doctor.private_healthcare_registration_number_acceptable === 'N') {
                    required = true
                    for (let [key, value] of Object.entries(this.unacceptable_fields.registration_number)) {
                        if (!key.includes("_comment")) {
                            if(value)
                                required = false;
                        }
                    }
                }
                return {
                    required: required
                }
            },
            foreignWorkerConsentUnacceptableRule: function (){
                let required = false
                if (this.visit_report_data.visit_report_doctor.written_consent_acceptable === 'N') {
                    required = true
                    for (let [key, value] of Object.entries(this.unacceptable_fields.foreign_workers_consent)) {
                        if (!key.includes("_comment")) {
                            if(value)
                                required = false;
                        }
                    }
                }
                return {
                    required: required
                }
            },
            medicalRecordsUnacceptableRule: function (){
                let required = false
                if (this.visit_report_data.visit_report_doctor.medical_record_maintenance_acceptable === 'N') {
                    required = true
                    for (let [key, value] of Object.entries(this.unacceptable_fields.medical_records)) {
                        if (!key.includes("_comment")) {
                            if(value)
                                required = false;
                        }
                    }
                }
                return {
                    required: required
                }
            },
            notificationUnacceptableRule: function (){
                let required = false
                if (this.visit_report_data.visit_report_doctor.communicable_disease_acceptable === 'N') {
                    required = true
                    for (let [key, value] of Object.entries(this.unacceptable_fields.notification)) {
                        if (!key.includes("_comment")) {
                            if(value)
                                required = false;
                        }
                    }
                }
                return {
                    required: required
                }
            },
            vacutainerUnacceptableRule: function (){
                let required = false
                if (this.visit_report_data.visit_report_doctor.vacutainer_acceptable === 'N') {
                    required = true
                    for (let [key, value] of Object.entries(this.unacceptable_fields.vacutainer)) {
                        if (!key.includes("_comment")) {
                            if(value)
                                required = false;
                        }
                    }
                }
                return {
                    required: required
                }
            },
            adequateFacilitiesUnacceptableRule: function (){
                let required = false
                if (this.visit_report_data.visit_report_doctor.adequate_facility_acceptable === 'N') {
                    required = true
                    for (let [key, value] of Object.entries(this.unacceptable_fields.adequate_facilities)) {
                        if (!key.includes("_comment")) {
                            if(value)
                                required = false;
                        }
                    }
                }
                return {
                    required: required
                }
            },
            dispatchUnacceptableRule: function (){
                let required = false
                if (this.visit_report_data.visit_report_doctor.dispatch_record_acceptable === 'N') {
                    required = true
                    for (let [key, value] of Object.entries(this.unacceptable_fields.dispatch)) {
                        if (!key.includes("_comment")) {
                            if(value)
                                required = false;
                        }
                    }
                }
                return {
                    required: required
                }
            },
            operationHoursUnacceptableRule: function (){
                let required = false
                if (this.visit_report_data.visit_report_doctor.operating_hour_acceptable === 'N') {
                    required = true
                    for (let [key, value] of Object.entries(this.unacceptable_fields.operation_hours)) {
                        if (!key.includes("_comment")) {
                            if(value)
                                required = false;
                        }
                    }
                }
                return {
                    required: required
                }
            },
            othersUnacceptableRule: function (){
                let required = false
                return {
                    required: required
                }
            },
            // end of validation rules

            formReadOnly: function () {

                return !this.canEdit;
            },

            formDisabled: function () {

                return !this.canEdit;
            },

            readOnlyField: function (){
                return true;
            },

            operationHourDisabled: function (){
                return true;
            },
            canEdit: function () {

                if (
                    !this.visit_report_data.status
                    || this.visit_report_data.status === 'DRAFT'
                    || this.visit_report_data.status === 'REJECTED'
                ) {
                    this.satisfactoryDisabled = false;
                    this.sopNonComplianceDisabled = false;
                    this.sopNonComplianceReadOnly = false;
                    return true;
                }

                return false;
            },
            onApprove: function (){
                if(this.params.action == 'approval'){
                    return true;
                }
                return false;
            },
        },
        data: function () {
            return {
                visit_report_data: {},
                visit_report_approval_data: {
                    decision: ''
                },
                submit_action: 'save',
                selected_visitors: [],
                org_users_arr: [],
                type_of_visit: '',
                selected_by: '',
                operating_hour: {},
                last_visited_date: '',
                allocations_last_current_year : '0/0',
                last_year: moment().subtract(1, 'years').year(),
                current_year: moment().year(),
                satisfactoryDisabled: true,
                sopNonComplianceDisabled: true,
                sopNonComplianceReadOnly: true,
                clinic_address : [],
                pairArr: {
                    foreign_worker_present_acceptable: ['non_verify_original_passport_fw_not_present','non_verify_original_passport_fw_present'],
                    apc_acceptable: ['unable_to_produce_apc'],
                    private_healthcare_registration_number_acceptable: ['no_produce_borang_b'],
                    written_consent_acceptable: ['no_produce_written_consent'],
                    medical_record_maintenance_acceptable: ['no_produce_medical_record'],
                    communicable_disease_acceptable: ['non_notify_communicable_disease'],
                    vacutainer_acceptable: ['inappropriate_vacutainer'],
                    adequate_facility_acceptable: ['inadequate_equipment'],
                    dispatch_record_acceptable: ['no_produce_dispatch_record'],
                    operating_hour_acceptable: ['insufficient_operation_hour']
                },
                sopNonComplianceField: [
                    'non_verify_original_passport_fw_present',
                    'non_verify_original_passport_fw_not_present',
                    'unable_to_produce_apc',
                    'non_notify_communicable_disease',
                    'inadequate_equipment',
                    'insufficient_operation_hour',
                    'other',
                    'inappropriate_vacutainer',
                    'no_produce_dispatch_record',
                    'no_produce_written_consent',
                    'no_produce_medical_record',
                    'closed',
                    'no_produce_borang_b'
                ],
                unacceptable_fields: {
                    foreign_worker :{
                        no_medical_examination: false,
                        no_medical_examination_comment: '',
                        without_biometric_device: false,
                        without_biometric_device_comment: '',
                        without_original_passport: false,
                        without_original_passport_comment: '',
                        using_photocopy_passport: false,
                        using_photocopy_passport_comment: '',
                        using_id_card: false,
                        using_id_card_comment: '',
                        using_fake_passport: false,
                        using_fake_passport_comment: '',
                        others: false,
                        others_comment: ''
                    },
                    apc :{
                        not_available_current_year: false,
                        not_available_current_year_comment: '',
                        not_stated_in_place: false,
                        not_stated_in_place_comment: '',
                        different_name: false,
                        different_name_comment: '',
                        different_address: false,
                        different_address_comment: '',
                        others: false,
                        others_comment: ''
                    },
                    registration_number: {
                        registration_not_available: false,
                        registration_not_available_comment: '',
                        different_name: false,
                        different_name_comment: '',
                        different_address: false,
                        different_address_comment: '',
                        others: false,
                        others_comment: ''
                    },
                    foreign_workers_consent: {
                        not_available: false,
                        not_available_comment: '',
                        kept_other_premise: false,
                        kept_other_premise_comment: '',
                        not_maintained: false,
                        not_maintained_comment: '',
                        details_not_complete: false,
                        details_not_complete_comment: '',
                        unsigned_foreign_worker: false,
                        unsigned_foreign_worker_comment: '',
                        unsigned_examine_doctor: false,
                        unsigned_examine_doctor_comment: '',
                        others: false,
                        others_comment: ''
                    },
                    medical_records: {
                        not_available: false,
                        not_available_comment: '',
                        kept_other_premise: false,
                        kept_other_premise_comment: '',
                        not_maintained: false,
                        not_maintained_comment: '',
                        no_blood_pressure: false,
                        no_blood_pressure_comment: '',
                        no_pulse_rate: false,
                        no_pulse_rate_comment: '',
                        no_height_measurement: false,
                        no_height_measurement_comment: '',
                        no_weight_measurement: false,
                        no_weight_measurement_comment: '',
                        no_vision_acuity: false,
                        no_vision_acuity_comment: '',
                        others: false,
                        others_comment: ''
                    },
                    notification:{
                        not_available: false,
                        not_available_comment: '',
                        kept_other_premise: false,
                        kept_other_premise_comment: '',
                        not_notify_to_office: false,
                        not_notify_to_office_comment: '',
                        others: false,
                        others_comment: ''
                    },
                    vacutainer: {
                        reuse_urine_container: false,
                        reuse_urine_container_comment: '',
                        expired_vacutainer: false,
                        expired_vacutainer_comment: '',
                        inappropriate_urine_container: false,
                        inappropriate_urine_container_comment: '',
                        others: false,
                        others_comment: ''
                    },
                    adequate_facilities:{
                        blood_pressure: false,
                        blood_pressure_comment: '',
                        vision_acuity_test: false,
                        vision_acuity_test_comment: '',
                        weight_scale: false,
                        weight_scale_comment: '',
                        height_scale: false,
                        height_scale_comment: '',
                        biometric_device: false,
                        biometric_device_comment: '',
                        internet_access: false,
                        internet_access_comment: '',
                        others: false,
                        others_comment: ''
                    },
                    dispatch:{
                        not_available: false,
                        not_available_comment: '',
                        kept_other_premise: false,
                        kept_other_premise_comment: '',
                        not_maintained: false,
                        not_maintained_comment: '',
                        details_not_complete: false,
                        details_not_complete_comment: '',
                        signature_not_available: false,
                        signature_not_available_comment: '',
                        stamp_not_available: false,
                        stamp_not_available_comment: '',
                        others: false,
                        others_comment: ''
                    },
                    operation_hours:{
                        differ_from_system: false,
                        differ_from_system_comment: '',
                        did_not_fulfil_8h5d: false,
                        did_not_fulfil_8h5d_comment: '',
                        others: false,
                        others_comment: '',
                    },
                    others:{
                        closed_during_visit: false,
                        closed_during_visit_comment: '',
                        shifted_location: false,
                        shifted_location_comment: '',
                        does_not_exist: false,
                        does_not_exist_comment: '',
                        differ_from_registration: false,
                        differ_from_registration_comment: '',
                        doctor_resigned: false,
                        doctor_resigned_comment: '',
                        doctor_pass_away: false,
                        doctor_pass_away_comment: '',
                        doctor_withdraw: false,
                        doctor_withdraw_comment: '',
                        interrelated_facilities: false,
                        interrelated_facilities_comment: '',
                        refuse_to_cooperate: false,
                        refuse_to_cooperate_comment: '',
                        doctor_unavailable: false,
                        doctor_unavailable_comment: '',
                        med_examination_not_done: false,
                        med_examination_not_done_comment: '',
                        inhouse_clinic: false,
                        inhouse_clinic_comment: '',
                        others: false,
                        others_comment: '',
                    }
                },
                unacceptable_fields_string: ''
            }
        },
        watch: {
            'visit_report_data.visit_time_from': function (after,before){
                if(before == 'Invalid Date')
                    this.visit_report_data.visit_time_from = moment("1200", "hmm").format("HH:mm")
            },
            'visit_report_data.visit_time_to': function (after,before){
                if(before == 'Invalid Date')
                    this.visit_report_data.visit_time_to = moment("1200", "hmm").format("HH:mm")
            },
            unacceptable_fields: {
                deep: true,
                handler: function(after,before){
                    this.unacceptable_fields_string = JSON.stringify(this.unacceptable_fields)
                }
            },
            'visit_report_data.visit_report_doctor.foreign_worker_present': function (after,before){
                if(this.visit_report_data.visit_report_doctor.foreign_worker_present_acceptable == 'N'){
                    if(after <= 0){
                        this.visit_report_data.visit_report_doctor.non_verify_original_passport_fw_not_present = true
                        this.visit_report_data.visit_report_doctor.non_verify_original_passport_fw_present = false
                    }else{
                        this.visit_report_data.visit_report_doctor.non_verify_original_passport_fw_not_present = false
                        this.visit_report_data.visit_report_doctor.non_verify_original_passport_fw_present = true
                    }
                }
            },
            'unacceptable_fields.others': {
                deep: true,
                handler: function(after,before){
                    
                    if(!this.canEdit){
                        this.satisfactoryDisabled = !this.canEdit
                        this.sopNonComplianceDisabled = !this.canEdit
                    }else{
                        let satisfactory = true
                        let is_other = false
                        for (let [key, value] of Object.entries(this.unacceptable_fields.others)) {
                            if (!key.includes("_comment")) {

                                if(this.unacceptable_fields.others[key]) {
                                    satisfactory = false
                                }
                                
                                switch(key) {
                                    case 'closed_during_visit':
                                        this.visit_report_data.visit_report_doctor.closed = this.unacceptable_fields.others[key]
                                        break;
                                    default:
                                        if(this.unacceptable_fields.others[key]){
                                            is_other = true
                                        }
                                        break;
                                        // code block
                                }
                            }
                        }
                        // other field have to be before noncompliance checking
                        this.visit_report_data.visit_report_doctor.other = is_other
                        
                        //noncompliance checking
                        this.sopNonComplianceField.forEach((field) => {
                            if(this.visit_report_data.visit_report_doctor[field]){
                                satisfactory = false
                            }
                        })

                        this.satisfactoryDisabled = !satisfactory
                        this.sopNonComplianceDisabled = satisfactory
                        this.visit_report_data.visit_report_doctor.satisfactory = satisfactory
                    }
                }
            },
            'visit_report_data.visit_report_doctor.foreign_worker_present_acceptable' : {
                handler: function (after,before){
                    if(before)
                        this.acceptableChange()
                    
                    if(after == 'Y')
                        this.untickUnacceptableChecbkox('foreign_worker')
                }
            },
            'visit_report_data.visit_report_doctor.apc_acceptable' : {
                handler: function (after,before){
                    if(before)
                        this.acceptableChange()

                    if(after == 'Y')
                        this.untickUnacceptableChecbkox('apc')
                }
            },
            'visit_report_data.visit_report_doctor.private_healthcare_registration_number_acceptable' : {
                handler: function (after,before){
                    if(before)
                        this.acceptableChange()

                    if(after == 'Y')
                        this.untickUnacceptableChecbkox('registration_number')
                }
            },
            'visit_report_data.visit_report_doctor.written_consent_acceptable' : {
                handler: function (after,before){
                    if(before)
                        this.acceptableChange()

                    if(after == 'Y')
                        this.untickUnacceptableChecbkox('foreign_workers_consent')
                }
            },
            'visit_report_data.visit_report_doctor.medical_record_maintenance_acceptable' : {
                handler: function (after,before){
                    if(before)
                        this.acceptableChange()
                    
                    if(after == 'Y')
                        this.untickUnacceptableChecbkox('medical_records')
                }
            },
            'visit_report_data.visit_report_doctor.communicable_disease_acceptable' : {
                handler: function (after,before){
                    if(before)
                        this.acceptableChange()
                    
                    if(after == 'Y')
                        this.untickUnacceptableChecbkox('notification')
                }
            },
            'visit_report_data.visit_report_doctor.vacutainer_acceptable' : {
                handler: function (after,before){
                    if(before)
                        this.acceptableChange()

                    if(after == 'Y')
                        this.untickUnacceptableChecbkox('vacutainer')
                }
            },
            'visit_report_data.visit_report_doctor.adequate_facility_acceptable' : {
                handler: function (after,before){
                    if(before)
                        this.acceptableChange()

                    if(after == 'Y')
                        this.untickUnacceptableChecbkox('adequate_facilities')
                }
            },
            'visit_report_data.visit_report_doctor.dispatch_record_acceptable' : {
                handler: function (after,before){
                    if(before)
                        this.acceptableChange()

                    if(after == 'Y')
                        this.untickUnacceptableChecbkox('dispatch')
                }
            },
            'visit_report_data.visit_report_doctor.operating_hour_acceptable' : {
                handler: function (after,before){
                    if(before)
                        this.acceptableChange()

                    if(after == 'Y')
                        this.untickUnacceptableChecbkox('operation_hours')
                }
            }
        },
        methods: {
            untickUnacceptableChecbkox(unacceptableGroupName) {
                for (var key in this.unacceptable_fields[unacceptableGroupName]) {
                    if(typeof(this.unacceptable_fields[unacceptableGroupName][key]) === "boolean"){
                        this.unacceptable_fields[unacceptableGroupName][key] = false
                    }
                }
            },
            acceptableChange() {
                let satisfactory = true
                let checked_value;
                for (const [key, value] of Object.entries(this.pairArr)){
                    if (this.visit_report_data.visit_report_doctor[key] == 'N'){
                        satisfactory = false
                        checked_value = true
                    }else{
                        checked_value = false
                    }
                    value.forEach((selected) => {

                            if(key == 'foreign_worker_present_acceptable'){
                                if(checked_value){
                                    if(this.visit_report_data.visit_report_doctor.foreign_worker_present <= 0){
                                        this.visit_report_data.visit_report_doctor.non_verify_original_passport_fw_not_present = true
                                        this.visit_report_data.visit_report_doctor.non_verify_original_passport_fw_present = false
                                    }else{
                                        this.visit_report_data.visit_report_doctor.non_verify_original_passport_fw_not_present = false
                                        this.visit_report_data.visit_report_doctor.non_verify_original_passport_fw_present = true
                                    }
                                }else{
                                    this.visit_report_data.visit_report_doctor[selected] = checked_value 
                                }
                            }else{
                               this.visit_report_data.visit_report_doctor[selected] = checked_value 
                            }
                        
                    });
                }
                
                if(this.visit_report_data.visit_report_doctor.closed)
                    satisfactory = false

                this.visit_report_data.visit_report_doctor.satisfactory = satisfactory

                if(satisfactory){
                    this.sopNonComplianceDisabled = true
                    this.satisfactoryDisabled = false
                }else{
                    this.sopNonComplianceDisabled = false
                    this.satisfactoryDisabled = true
                }
            },

            approvalUpdate($event){
                this.visit_report_approval_data.decision = $event.target.value.toLowerCase()
            },
            safeAccess(object, key) {

                return _.get(object, key, 'N/A');
            },

            save() {
                this.submit_action = 'save';

                var self = this;

                Vue.nextTick(function () {
                    self.formSave();
                });
            },

            submit() {
                this.submit_action = 'submit';

                var self = this;

                Vue.nextTick(function () {
                    self.formSubmit();
                });
            },

            formSave() {
                this.$refs.visit_report_form.submit();
            },

            formSubmit() {

                this.$validator.validate().then(valid => {
                    if (valid) {
                        if($('.is-invalid').length == 0){
                            this.$refs.visit_report_form.submit();
                        }else{
                            window.scrollTo(0,0);
                            console.log('validation error');
                        }
                    }
                    else {
                        // scroll to top
                        window.scrollTo(0,0);
                        console.log('validation error');
                    }

                });
            },
            
            monClosedCheckbox: function(event){
                //disable/clear other fields
                //event.target.checked
            },

            updateInspectorateTeamSelection() {
                console.log(this.selected_visitors)
            },
            addTag(newTag) {
                const tag = {
                    id: '',
                    name: newTag       
                };
                this.org_users_arr.push(tag);
                this.selected_visitors.push(tag);
            },
            customerSelectName (option) {
                console.log(option.username)
                return `${option.username}`
            },
            updateRec(){
                console.log(this.visit_report_data.visit_report_doctor)
            },
            satisfactoryChange: function(event){
                this.sopNonComplianceDisabled = event.target.checked ? true : false
            },
            nonComplianceChange: function(event){
                let satisfactoryDisabled = false
                if(event.target.checked){
                    satisfactoryDisabled = true
                }else{
                    this.sopNonComplianceField.forEach((field) => {
                        if(this.visit_report_data.visit_report_doctor[field] && !(event.target.name == "visit_report_doctor["+field+"]")){
                            satisfactoryDisabled = true
                        }
                    })
                }
                this.satisfactoryDisabled = satisfactoryDisabled
                this.visit_report_data.visit_report_doctor.satisfactory = !satisfactoryDisabled
            },
            generateExplanationLetter: function(event){
                event.preventDefault();
                window.open($('#explanationLetterBtn').attr("href")+'?'+$('#communicable-diseases-form').serialize(), '_blank');
            }

        }
    }
</script>

<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>

<style scoped>
    
</style>
