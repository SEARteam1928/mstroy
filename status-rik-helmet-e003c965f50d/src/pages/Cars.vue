<template>
    <q-page class="Cars-page page-background">
        <iframe class="Cars-frame page-block" :src="src" allowfullscreen frameborder="no" />
    </q-page>
</template>

<script>
export default {
    name: 'Cars',
    data() {
        return {
            src:
                'https://app.powerbi.com/view?r=eyJrIjoiY2U5ZDI4ZWEtODhhYy00ZWM0LTkwMWItNjM1MDE4NDNhY2E3IiwidCI6IjMxNjVjYmUxLWRlZWUtNDcxYy04MGQyLWMyZTlkMmYzMmMyNiIsImMiOjl9'
        };
    }
};
</script>

<style lang="sass">
.Cars
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
