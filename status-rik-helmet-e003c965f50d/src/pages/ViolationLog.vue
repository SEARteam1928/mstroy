<template>
    <q-page class="ViolationLog-page page-background">
        <iframe class="ViolationLog-frame page-block" :src="src" allowfullscreen frameborder="no" />
    </q-page>
</template>

<script>
export default {
    name: 'ViolationLog',
    data() {
        return {
            src: 'https://ms11-sandbox.mxapps.io/'
        };
    }
};
</script>

<style lang="sass">
.ViolationLog
    position: relative
    &-frame
        position: absolute
        height: calc(100% - 16px)
        width: calc(100% - 16px)
        margin:
            top: 8px
            right: 8px
            bottom: 8px
            left: 8px
</style>
