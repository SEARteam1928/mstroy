<template>
    <div class="FileManagerViewerArrow cursor-pointer" :class="arrowClasses" @click="$emit('click', side)">
        <q-icon class="FileManagerViewerArrow-icon" :name="`keyboard_arrow_${side}`" color="white" size="70px" />
    </div>
</template>

<script>
export default {
    name: 'FileManagerViewerArrow',
    props: {
        side: {
            type: String,
            required: true
        },
        mobileMode: {
            type: Boolean,
            required: false,
            default: false
        },
        compactMode: {
            type: Boolean,
            required: false,
            default: false
        }
    },
    computed: {
        arrowClasses() {
            let classes = `FileManagerViewerArrow-${this.side}`;
            classes += this.mobileMode ? ' mobileMode' : '';
            classes += this.compactMode ? ' compactMode' : '';

            return classes;
        }
    }
};
</script>

<style lang="sass">
.FileManagerViewerArrow
    position: absolute
    display: flex
    align-items: center
    z-index: 10
    text-shadow: 0 0 10px rgba(0, 0, 0, 0.5)
    opacity: 0.3
    transition: opacity 250ms ease
    // Full-size
    width: 20%
    top: 0
    bottom: 0
    &:hover
        opacity: 0.8
    .material-icons
        pointer-events: none
    &-background
        position: absolute
        top: 0
        bottom: 0
        left: 0
        right: 0
        z-index: -1
        opacity: 0
        transition: opacity 250ms ease
        &:hover
            opacity: 0.7
    &-left
        left: 0
        justify-content: flex-start
        padding-left: 30px
    &-right
        right: 0
        justify-content: flex-end
        padding-right: 30px

    // Компактный режим
    &.compactMode
        top: 50%
        transform: translateY(-50%)
        bottom: auto
        width: auto

    // Мобильный режим
    &.mobileMode
        &.FileManagerViewerArrow-left
            padding-left: 0
        &.FileManagerViewerArrow-right
            padding-right: 0
</style>
