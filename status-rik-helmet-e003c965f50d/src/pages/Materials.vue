<template>
    <q-page class="Materials-page page-background">
        <iframe class="Materials-frame page-block" :src="src" allowfullscreen frameborder="no" />
    </q-page>
</template>

<script>
export default {
    name: 'Materials',
    data() {
        return {
            src:
                'https://app.powerbi.com/view?r=eyJrIjoiMzE3ZDljOTUtYzI1OS00MGUxLWFiNGUtYzJiNTI5ZjI2NDZiIiwidCI6IjMxNjVjYmUxLWRlZWUtNDcxYy04MGQyLWMyZTlkMmYzMmMyNiIsImMiOjl9'
        };
    }
};
</script>

<style lang="sass">
.Materials
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
