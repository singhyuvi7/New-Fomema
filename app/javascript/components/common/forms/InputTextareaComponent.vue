<template>
    <div>
        <label v-if="showLabel" class="" v-bind:class="{ required: isRequired }" :for="id">{{ label }}</label>
        <textarea
                :name="field_name"
                :value="transformInputValue"
                :id="id"
                :placeholder="placeholder"
                :readonly="readonly"
                @input="updateParentValue($event.target.value)"
                :data-vv-as="validationAs"
                class="form-control no-uppercase"
                :class="{ 'is-invalid': (rules.required && !value) }"
                :rows="rows"></textarea>
            <div class="invalid-feedback" v-if="rules.required && !value">This field is required</div>
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
            rows: {
                default: 2,
                type: Number
            },
            rules: {
                type: Object,
                default () {
                    return {
                        required: false
                    }
                }
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

            transformValue(value) {
                return value;
            },

            updateParentValue(value) {

                let transform_value = this.transformValue(value);

                this.$emit('input', transform_value);
            }
        }
    }

</script>
