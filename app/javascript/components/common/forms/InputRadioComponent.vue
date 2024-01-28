<template>
    <div>
        
        <input type="radio"
               :name="field_name"
               v-model="value"
               :value="radio_value"
               :disabled="disabled"
               @input="updateParentValue($event.target.value)"
               v-validate="getValidationRules()"
               data-vv-delay="1000"
               :data-vv-as="validationAs"
               class="form-check-input"
               :class="{ 'is-invalid': errors.has(field_name) }"
               :id="id">

        <label class="form-check-label" v-bind:class="{ required: isRequired }" :for="id">{{ label }}</label>
        
    </div>
</template>

<script>

    export default {
        inject: ['$validator'],
        props: {
            value: {},
            radio_value: {
                required: true,
            },
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
            disabled: {
                default: false,
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
        mounted() {

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

            transformValue(value) {

                if (value) {

                    if (this.transform === 'uppercase') {
                        return value.toUpperCase();
                    }

                    if (this.transform === 'lowercase') {
                        return value.toLowerCase();
                    }
                }

                return value;

            },

            updateParentValue(value) {
                let transform_value = this.transformValue(value);

                this.$emit('input', transform_value);
            }
        }
    }

</script>
