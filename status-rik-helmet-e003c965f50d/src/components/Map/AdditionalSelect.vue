<template>
    <q-select
        :dense="dense"
        filled
        emit-value
        fill-input
        :display-value="selectedName"
        v-model="model"
        :label="label"
        :options="options"
        @input="onChange"
        option-label="name"
        option-value="value"
    />
</template>

<script>
export default {
    name: 'AdditionalSelect',
    props: {
        label: {
            type: String,
            required: true
        },
        dense: {
            required: false
        },
        options: {
            type: Array,
            required: true
        },
        defaultValue: {
            required: false
        }
    },
    data() {
        return {
            model: null
        };
    },
    computed: {
        // Для отображения имени свойства в селекте, а не значения
        selectedName() {
            let name = '';
            for (let i = 0; i < this.options.length; i++) {
                if (this.options[i].value === this.model) {
                    name = this.options[i].name;
                    break;
                }
            }

            return name;
        }
    },
    methods: {
        onChange(value) {
            this.$emit('change', value);
        }
    },
    created() {
        this.model = this.defaultValue ? this.defaultValue : null;
    }
};
</script>

<style lang="sass"></style>
