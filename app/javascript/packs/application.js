/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
import "core-js/stable";
import "regenerator-runtime/runtime";

// initialize global Vue instance

import Vue from 'vue/dist/vue.esm';

// import js components
import Multiselect from 'vue-multiselect'
import VeeValidate from 'vee-validate';
import VueFlatPickr from 'vue-flatpickr-component';
import 'flatpickr/dist/flatpickr.css';

// define global JS plugin

window.Vue = Vue;
window.axios = require('axios');
window.dayjs = require('dayjs');
var _ = require('lodash');
Vue.use(VeeValidate);
Vue.use(VueFlatPickr);

// import common form components

import VText from '../components/common/forms/InputTextComponent.vue';
import VTextArea from '../components/common/forms/InputTextareaComponent.vue';
import VNumber from '../components/common/forms/InputNumberComponent.vue';
import VRadio from '../components/common/forms/InputRadioComponent.vue';
import VTime from '../components/common/forms/InputTimeComponent.vue';
import VDate from '../components/common/forms/InputDateComponent.vue';

// import application components

import App from '../app.vue';
import VisitApprovalPlanForm from '../components/internal/visit_plan_approvals/_form.vue';
import VisitPlanForm from '../components/internal/visit_plans/_form.vue';
import VisitPlanClinicForm from '../components/internal/visit_plans/clinics/_form.vue';
import VisitPlanClinicProvider from '../components/internal/visit_plans/clinics/provider.vue';
import VisitReportClinicForm from '../components/internal/visit_reports/clinics/_form.vue';
import VisitReportXrayFacilityForm from '../components/internal/visit_reports/xray_facilities/_form.vue';
import LaboratoryBulkReallocateForm from '../components/internal/laboratories/_form.vue';
import XrayFacilityBulkReallocateForm from '../components/internal/xray_facilities/_form.vue';


// register common Vue components

Vue.component('v-text', VText);
Vue.component('v-textarea', VTextArea);
Vue.component('v-number', VNumber);
Vue.component('v-radio', VRadio);
Vue.component('v-time', VTime);
Vue.component('v-date', VDate);

// register Vue components

Vue.component('app', App);
Vue.component('multiselect', Multiselect);
Vue.component('visitplanapprovalform', VisitApprovalPlanForm);
Vue.component('visitplanform', VisitPlanForm);
Vue.component('visitplanclinicform', VisitPlanClinicForm);
Vue.component('visitplan_clinicprovider', VisitPlanClinicProvider);
Vue.component('visitreportclinicform', VisitReportClinicForm);
Vue.component('visitreportxrayfacilityform', VisitReportXrayFacilityForm);
Vue.component('laboratorybulkreallocateform', LaboratoryBulkReallocateForm);
Vue.component('xrayfacilitybulkreallocateform', XrayFacilityBulkReallocateForm);

// end of register Vue components

document.addEventListener('DOMContentLoaded', () => {

    var element = document.querySelector('[data-behaviour="vue"]');

    if (element != null) {

        const app = new Vue({
            el: '[data-behaviour="vue"]',
        })

    }
});
