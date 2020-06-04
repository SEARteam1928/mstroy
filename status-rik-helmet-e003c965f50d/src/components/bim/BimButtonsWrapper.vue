<template>
    <div class="bim-btn-wrapper">
        <BimButton icon="fullscreen" @click="toggleFullscreen" />
        <BimButton icon="section" @click="toggleSectionPlane" />
        <BimButton icon="projection" withNote note="pers." />
        <BimButton icon="polygon" withNote note="obj." />
    </div>
</template>

<script>
import BimButton from './BimButton';
export default {
    components: {
        BimButton
    },
    methods: {
        toggleFullscreen() {
            this.$emit('toggle-fullscreen');
        },
        toggleNavCube() {
            this.$emit('toggle-navcube');
        },
        toggleSectionPlane() {
            this.$emit('toggle-sectionplane');
        }
    }
};
</script>

<style lang="sass">
.bim-btn-wrapper
    display: flex
    flex-direction: column
    justify-content: space-between
    align-items: center
    // width: 42px;
    position: absolute
    right: 20px
    top: 20px
    height: 220px
    z-index: 100
</style>
