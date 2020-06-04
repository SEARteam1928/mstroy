<template>
    <q-btn-dropdown
        class="MoreActionBtn"
        dropdown-icon="img:data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=="
        menu-anchor="bottom right"
        icon="more_vert"
        :value="value"
        :auto-close="autoClose"
        :persistent="persistent"
        :disable="disable"
        :rounded="rounded"
        :flat="flat"
        @input="$emit('input', $event)"
        @show="$emit('show', $event)"
        @before-show="$emit('before-show', $event)"
        @hide="$emit('hide', $event)"
        @before-hide="$emit('before-hide ', $event)"
        @click="$emit('click ', $event)"
    >
        <slot />
    </q-btn-dropdown>
</template>

<script>
export default {
    name: 'MoreActionBtn',
    props: {
        value: {
            type: Boolean,
            required: false,
            default: false
        },
        autoClose: {
            type: Boolean,
            required: false,
            default: false
        },
        persistent: {
            type: Boolean,
            required: false,
            default: false
        },
        disable: {
            type: Boolean,
            required: false,
            default: false
        },
        rounded: {
            type: Boolean,
            required: false,
            default: true
        },
        flat: {
            type: Boolean,
            required: false,
            default: true
        }
    }
};
</script>

<style lang="sass">
.MoreActionBtn
    .q-btn__wrapper
        padding: 4px
    .q-btn__content
        width: 28px
        height: 28px
        @media only screen and (max-width : 768px)
            width: 36px
            height: 36px
        .q-icon
            font-size: 24px
        .q-btn-dropdown__arrow
            display: none
</style>
