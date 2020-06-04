<template>
    <div class="BimSquareButtonsWrapper">
        <BimButton icon="tree" @click="$emit('toggle-modeltree')" />
        <BimButton icon="BCF" @click="$emit('toggle-projectstree')" />
    </div>
</template>

<script>
import BimButton from './BimButton.vue';
export default {
    components: {
        BimButton
    }
};
</script>

<style lang="sass">
.BimSquareButtonsWrapper
    display: flex
    flex-direction: column
    justify-content: space-between
    align-items: center
    position: absolute
    top: 20px
    left: 30px
    height: 100px
</style>
