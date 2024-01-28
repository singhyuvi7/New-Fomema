<template>
    <div>
        <label v-if="showLabel" class="" v-bind:class="{ required: isRequired }" :for="id">{{ label }}</label>
        <input type="time"
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
                default: '',
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
            }
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
                    enableTime: true,
                    noCalendar: true,
                    dateFormat: "H:i",
                    defaultDate: this.value
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
