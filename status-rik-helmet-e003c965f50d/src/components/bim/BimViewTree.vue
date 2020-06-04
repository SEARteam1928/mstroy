<template>
    <q-scroll-area
        v-show="showTree"
        class="bimTreeContainer"
        :class="{ 'bimTreeContainer-show': isShowComponentTreeModel }"
    >
        <div ref="bimTreeContainer" />
    </q-scroll-area>
</template>

<script>
import { TreeViewPlugin } from '@xeokit/xeokit-sdk/src/plugins/TreeViewPlugin/TreeViewPlugin.js';

import createTreeViewContextMenu from './treeViewContextMenu';

import { mapGetters } from 'vuex';

export default {
    name: 'BimViewTree',
    props: {
        viewer: {
            type: Object
        },
        bimModel: {
            type: Object
        }
    },
    data() {
        return {
            treeView: null,
            treeViewContextMenu: null,
            showTree: false
        };
    },
    computed: {
        ...mapGetters('Bim', ['isShowComponentTreeModel'])
    },
    created() {
        this.showTree = this.bimModel ? true : false;
    },
    mounted() {
        this.init();
        this.treeViewContextMenu = createTreeViewContextMenu();
    },
    beforeDestroy() {
        this.destroy();
    },
    watch: {
        viewer: {
            handler(newValue, prevValue) {
                this.destroy();

                if (!newValue) return;

                this.init();
            }
        },
        bimModel: {
            handler(newValue, prevValue) {
                if (prevValue) {
                    if (newValue && newValue.id === prevValue.id) {
                        this.showTree = true;

                        return;
                    }

                    if (!this.treeView) return;
                    this.treeView.removeModel(prevValue.id);
                }

                if (!newValue) {
                    this.showTree = false;
                    return;
                }

                if (!this.treeView) return;

                try {
                    this.treeView.addModel(newValue.id);
                    this.showTree = true;
                } catch (error) {
                    console.log('Ошибка добавления модели в treeView', error);
                }
            },
            immediate: true
        }
    },
    methods: {
        init(viewer = this.viewer) {
            if (!viewer) return false;

            this.treeView = new TreeViewPlugin(viewer, {
                containerElement: this.$refs.bimTreeContainer,
                autoExpandDepth: 2
            });

            this.treeView.on('contextmenu', e => {
                this.treeViewContextMenu.context = {
                    // Must set context before opening menu
                    viewer: e.viewer,
                    treeViewPlugin: e.treeViewPlugin,
                    treeViewNode: e.treeViewNode,
                    entity: e.viewer.scene.objects[e.treeViewNode.objectId]
                };
                console.log(e);
                this.treeViewContextMenu.show(e.event.pageX, e.event.pageY);
            });

            return true;
        },
        destroy() {
            this.showTree = false;

            if (!this.treeView) return;

            this.treeView.destroy();
            this.treeView = null;
        }
    }
};
</script>

<style lang="sass">
.bimTreeContainer
    background-color: #fff
    // position: absolute
    // left: 0px
    // top: 0px
    // bottom: 0
    width: 300px
    height: 250px
    // overflow: auto
    opacity: 0
    // transform: translateX(-100%)
    // transition: opacity 100ms 150ms ease-in-out, transform 250ms ease-in-out
    &-show
        opacity: 1
        // transform: translateX(0)
        // transition: opacity 100ms ease-in-out, transform 250ms ease-in-out
    ul
        list-style: none
        padding-left: 1.2em
        li
            a
                text-decoration: none
                padding-right: 0.5em
                font-size: 18px
            input[type="checkbox"]
                margin-right: 4px
            span
                cursor: default
</style>
