<template>
    <q-expansion-item
        class="ExpandableWrap"
        header-class="ExpandableWrap-header"
        :value="value"
        :duration="duration"
        :disable="disable"
        @input="$emit('input', $event)"
        @before-show="$emit('before-show', $event)"
        @show="$emit('show', $event)"
        @after-show="$emit('after-show', $event)"
        @before-hide="$emit('before-hide', $event)"
        @hide="$emit('hide', $event)"
        @after-hide="$emit('after-hide', $event)"
    >
        <template v-slot:header>
            <div></div>
        </template>

        <slot />
    </q-expansion-item>
</template>

<script>
export default {
    name: 'ExpandableWrap',
    props: {
        value: {
            type: Boolean,
            required: true
        },
        duration: {
            type: Number,
            required: false,
            default: 300
        },
        disable: {
            type: Boolean,
            required: false,
            default: false
        }
    }
};
</script>

<style lang="sass">
.ExpandableWrap
    &-header
        display: none
</style>
