<template>
    <div class="OpenChevron" :class="stateName" @click="onClick">
        <q-icon v-if="!loading" class="OpenChevron-icon" name="keyboard_arrow_down" :size="size" />
        <q-spinner v-if="loading" class="OpenChevron-spinner" :size="size" />
    </div>
</template>

<script>
export default {
    name: 'OpenChevron',
    props: {
        open: {
            type: Boolean,
            required: false,
            default: false
        },
        loading: {
            type: Boolean,
            required: false,
            default: false
        },
        size: {
            type: String,
            required: false,
            default: '20px'
        }
    },
    computed: {
        stateName() {
            let state = '';

            if (this.loading) {
                state = 'loading';
            } else {
                state = this.open ? 'open' : 'close';
            }

            return state;
        }
    },
    methods: {
        onClick() {
            this.$emit('input', !this.open);
        }
    }
};
</script>

<style lang="sass">
.OpenChevron
    display: flex
    align-items: center
    justify-content: center
    &-icon
        transition: transform 250ms ease
        will-change: transform
    &-icon, &-spinner
        // color: rgba(0, 0, 0, 0.4)

    &.close
        cursor: pointer

    &.open
        cursor: pointer
        .OpenChevron-icon
            transform: rotate(-180deg)
</style>
