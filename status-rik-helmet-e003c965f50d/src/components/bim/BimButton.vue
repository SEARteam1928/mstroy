<template>
    <q-btn :class="{ 'bim-btn__active': clicked }" unelevated class="bim-btn" @click="emitClick">
        <q-icon-custom :name="icon" :colors="{ primary: '#2f374a' }" />
        <span class="btn-note-hidden" :class="{ 'bim-btn-note': withNote }">{{ note }}</span>
    </q-btn>
</template>

<script>
import QIconCustom from '@components/common/QIconCustom.vue';
export default {
    props: {
        icon: {
            type: String,
            required: true
        },
        withNote: {
            type: Boolean
        },
        note: {
            type: String
        }
    },
    data() {
        return {
            clicked: false
        };
    },
    methods: {
        emitClick() {
            this.clicked = !this.clicked;
            this.$emit('click');
        }
    },
    components: {
        QIconCustom
    }
};
</script>

<style lang="sass">
.bim-btn
    // padding: 2px
    position: relative
    box-shadow: 0 2px 10px 0 rgba(0,0,0,.1)
    width: 45px
    height: 45px
    background: #fff
        :hover
            background: none
    *
        overflow: visible
        padding: 0
.bim-btn__active
    background-color: #f9c72c

.btn-note-hidden
    display: hidden

.bim-btn-note
    font-weight: 600
    position: absolute
    top: -3px
    left: 3px
    color: #2f374a
    font-size: 9px
</style>
