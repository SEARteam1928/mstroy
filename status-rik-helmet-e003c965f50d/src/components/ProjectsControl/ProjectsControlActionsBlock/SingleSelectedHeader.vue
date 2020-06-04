<template>
    <div class="SingleSelectedHeader">Информация по проекту [ id:{{ id }} ]</div>
</template>

<script>
import { mapGetters } from 'vuex';

export default {
    name: 'SingleSelectedHeader',
    props: {
        id: {
            type: [String, Number],
            required: false
        }
    }
};
</script>

<style lang="sass">
.SingleSelectedHeader
    padding: 12px
    border-bottom: 1px solid var(--ms-grey)
    text-align: center
    color: var(--ms-dark)
    &-name
        font-weight: bold
        overflow: hidden
        max-height: 40px
        line-height: 20px
        display: -webkit-box
        -webkit-box-orient: vertical
        -webkit-line-clamp: 2
</style>
