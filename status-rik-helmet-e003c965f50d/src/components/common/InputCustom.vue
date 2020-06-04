<template>
    <input
        class="InputCustom"
        :class="{ 'InputCustom-dense': dense }"
        :value="value"
        v-bind="$attrs"
        v-on="listeners"
        ref="input"
    />
</template>

<script>
export default {
    name: 'InputCustom',
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
.InputCustom
    width: 100%
    height: 40px
    padding: 4px 16px
    border-radius: 4px
    border: 1px solid var(--ms-grey)
    color: var(--ms-dark)
    background-color: #fff
    transition: background-color 250ms ease-in-out
    &::placeholder
        color: var(--ms-grey)
    &:focus
        background-color: var(--ms-light-grey)
        outline: none
    &-dense
        height: 32px
        padding: 4px 8px
</style>
