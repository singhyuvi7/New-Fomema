<template>
    <div>
        <label v-if="showLabel" class="" v-bind:class="{ required: isRequired }" :for="id">{{ label }}</label>
        <input type="date"
               :name="field_name"
               :value="value"
               :id="id"
               :placeholder="placeholder"
               :readonly="readonly"
               @input="updateParentValue($event.target.value)"
               v-validate="getValidationRules()"
               :data-vv-as="validationAs"
               class="form-control"
               :class="{ 'is-invalid': errors.has(field_name) }"
               ref="input"
               :min="min_date"
               :max="max_date"
               :disabled="readonly"> 
        <div class="invalid-feedback">{{ errors.first(field_name) }}</div>
    </div>
</template>

<script>
import Flatpickr from 'flatpickr'
    export default {
        inject: ['$validator'],
        props: {
            value: {},
            field_name: {
                required: true,
            },
            label: {
                required: true,
            },
            validation_label: {
                default: null,
                required: false,
            },
            readonly: {
                default: false,
            },
            placeholder: {
                default: 'dd/mm/yyyy',
            },
            id: {
                default: '',
            },
            rules: {
                default: () => {},
                type: Object
            },
            transform: {
                default: null,
                type: String
            },
            min_date:{
                default: null,
                required: false
            },
            max_date:{
                default: null,
                required: false
            },
        },
        data: function() {
            return {
                datepicker: {}
            }
        },
        mounted() {
            this.datepicker = new Flatpickr('#'+this.id, {
                    locale: null,
                    altInput: true,
                    altFormat: 'd/m/Y',
                    dateFormat: 'Y-m-d',
                    defaultDate: this.value,
                    minDate: this.min_date,
                    maxDate: this.max_date,
                    allowInput: true,
                    onClose(dates, currentdatestring, picker) {
                        picker.setDate(picker.altInput.value, true, picker.config.altFormat)
                    }
            })
        },
        computed: {

            showLabel() {

                if (this.label.length < 1) {
                    return false;
                }

                return true;
            },

            isRequired() {

                if (!this.rules) {
                    return false;
                }

                if ('required' in this.rules) {
                    if (this.rules.required === true) {
                        return true;
                    }
                }

                return false;

            },

            validationAs() {

                if (this.validation_label) {
                    return this.validation_label;
                }

                return this.label;

            },

        },
        watch: {
            min_date: function (newMin, oldMin) {
                this.datepicker.set("minDate", newMin);
            }
        },
        methods: {

            getValidationRules() {
                return this.rules;
            },

            updateParentValue(value) {

                this.$emit('input', value);
            }
        }
    }

</script>
