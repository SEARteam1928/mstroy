<template>
    <q-btn
        class="CloseModal modal-close-btn close-red with-mobile no-radius-top-left no-radius-top-right no-radius-bottom-right"
        :class="{ 'CloseModal-mobileMode': mobileMode }"
        icon="close"
        flat
        :dense="mobileMode"
        v-close-popup
    />
</template>

<script>
export default {
    name: 'CloseModal',
    props: {
        mobileMode: {
            type: Boolean,
            required: false,
            default: false
        }
    }
};
</script>

<style lang="sass">
.CloseModal
    position: absolute
    top: 0
    right: 0
    z-index: 10000
    .q-btn__wrapper
        padding: 0px 12px
        min-height: 2.15em
    &-mobileMode
        position: fixed
        &.q-btn--dense
            .q-btn__wrapper
                padding: 0.285em
                min-height: 2em
</style>
