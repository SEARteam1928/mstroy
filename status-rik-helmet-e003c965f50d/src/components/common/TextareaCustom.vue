<template>
    <!-- :value="value" -->
    <textarea
        class="TextareaCustom"
        :class="{ 'TextareaCustom-dense': dense }"
        rows="3"
        :value="value"
        v-bind="$attrs"
        v-on="listeners"
        ref="input"
    />
</template>

<script>
export default {
    name: 'TextareaCustom',
    props: {
        value: {
            validator: value => value === null || typeof value === 'string' || typeof value === 'number',
            required: true
        },
        dense: {
            type: Boolean,
            required: false,
            default: false
        }
    },
    computed: {
        listeners() {
            return { ...this.$listeners, input: this.inputHandler };
        }
    },
    methods: {
        focus() {
            this.$refs?.input?.focus();
        },
        blur() {
            this.$refs?.input?.blur();
        },
        inputHandler(e) {
            this.$emit('input', e.target.value);
        }
    }
};
</script>

<style lang="sass">
.TextareaCustom
    width: 100%
    padding: 4px 16px
    border-radius: 4px
    border: 1px solid var(--ms-grey)
    color: var(--ms-dark)
    background-color: #fff
    transition: background-color 250ms ease-in-out
    resize: none
    &::placeholder
        color: var(--ms-grey)
    &:focus
        background-color: var(--ms-light-grey)
        outline: none
    &-dense
        padding: 2px 8px
        line-height: 1.4em
</style>
