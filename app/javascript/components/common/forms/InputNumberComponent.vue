<template>
    <div>
        <label v-if="showLabel" class="" v-bind:class="{ required: isRequired }" :for="id">{{ label }}</label>
        <input type="number"
               :name="field_name"
               :value="transformInputValue"
               :id="id"
               :placeholder="placeholder"
               :readonly="readonly"
               @input="updateParentValue($event.target.value)"
               v-validate="getValidationRules()"
               :data-vv-as="validationAs"
               class="form-control"
               :class="{ 'is-invalid': errors.has(field_name) }"
               ref="input">
        <div class="invalid-feedback">{{ errors.first(field_name) }}</div>
    </div>
</template>

<script>

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

            transformInputValue() {
                return this.transformValue(this.value);
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
