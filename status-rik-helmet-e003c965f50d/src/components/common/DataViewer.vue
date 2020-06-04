<template>
    <q-scroll-area class="DataViewer" :thumb-style="{ 'transition': 'top 100ms ease, opacity 300ms' }">
        <json-viewer class="DataViewer-code" :value="data" :expand-depth="expandDepth" />
    </q-scroll-area>
</template>

<script>
export default {
    name: 'DataViewer',
    props: {
        data: {
            required: true
        },
        expandDepth: {
            type: Number,
            required: false,
            default: 0
        }
    }
};
</script>

<style lang="sass">
.DataViewer
    height: 100%
    width: 100%
    background-color: #efefef
    overflow: hidden
    border-radius: 4px
    box-shadow: 0 1px 0 0 rgba(0,0,0,0.24), 0 0 0 1px rgba(0,0,0,0.24)
    &-code.jv-container
        width: 100%
        flex-grow: 1
        margin: 0
        overflow: visible
        &.jv-light
            background-color: #efefef
        .jv-code
            padding: 16px
            @media only screen and (max-width : 600px)
                padding: 6px
        .jv-ellipsis
            background-color: #ddd
        .jv-item
            &.jv-boolean
                color: #fc1e70
            &.jv-number
                color: #6F4BFF
            &.jv-string
                color: #0AB267
</style>
