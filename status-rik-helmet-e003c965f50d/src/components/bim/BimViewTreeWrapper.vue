<template>
    <div class="bimViewTreeWrapper">
        <q-expansion-item
            v-show="showModelTree"
            class="expansion shadow-2"
            default-opened
            icon="share"
            label="Дерево модели"
            caption="Развернуть"
        >
            <BimViewTree class="bimTreeContainer" ref="modelTree" :viewer="viewer" :bimModel="bimModel" />
        </q-expansion-item>
        <!-- <q-expansion-item class="expansion shadow-2" icon="share" label="Дерево модели" caption="Развернуть">
            <BimViewTree class="bimTreeContainer" ref="modelTree" :viewer="viewer" :bimModel="bimModel" />
        </q-expansion-item> -->
    </div>
</template>

<script>
import BimViewTree from './BimViewTree.vue';
export default {
    props: ['viewer', 'bimModel', 'showModelTree'],
    components: {
        BimViewTree
    },
    data() {
        return {};
    }
};
</script>

<style lang="sass">
.bimViewTreeWrapper
    position: absolute
    top: 20px
    left: 100px
    // bottom: 20px
    .expansion
        position: relative
        top: 0
        bottom: 0
        width: 300px
        background: #fff
        margin-bottom: 13px
</style>
