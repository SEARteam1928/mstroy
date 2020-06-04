<template>
    <q-page class="PageIndex-page flex flex-center page-background">
        <div class="PageIndex page-block">
            <img
                class="PageIndex-mainLogo"
                src="statics/logos/MStroy_vertical.svg"
                alt="LogoMStroy"
                draggable="false"
            />
        </div>
    </q-page>
</template>

<script>
export default {
    name: 'PageIndex'
};
</script>

<style lang="sass">
.PageIndex
    width: 100%
    height: 100%
    display: flex
    justify-content: center
    align-items: center
    max-width: calc(100% - 16px)
    max-height: calc(100% - 16px)
    margin:
        top: 8px
        right: 8px
        bottom: 8px
        left: 8px
    &-page
        overflow: hidden
        height: calc( 100vh - var(--header-height) )
        position: relative
    &-mainLogo
        max-width: 45%
        width: 250px
</style>
