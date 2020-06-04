<template>
    <div class="GroupsControlTree">
        <q-scroll-area
            class="GroupsControlTree-scrollArea"
            :thumb-style="{ 'transition': 'top 100ms ease, opacity 300ms', 'background-color': 'var(--ms-dark)' }"
        >
            <q-tree
                class="GroupsControlTree-tree"
                :nodes="allAccessGroupsTree"
                :selected.sync="selected"
                :expanded.sync="expanded"
                node-key="rowId"
                selected-color="ms-dark"
            >
                <template v-slot:default-header="prop">
                    <GroupsControlTreeNode
                        class="GroupsControlTreeNode"
                        :prop="prop"
                        labelKey="name"
                        @add="onAddChildrenGroup"
                    />
                </template>
            </q-tree>
        </q-scroll-area>
    </div>
</template>

<script>
import GroupsControlTreeNode from './GroupsControlTreeNode.vue';

import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'GroupsControlTree',
    components: {
        GroupsControlTreeNode
    },
    computed: {
        ...mapGetters('GroupsControl', ['allAccessGroupsTree', 'selectedGroupId']),

        selected: {
            get() {
                return this.selectedGroupId;
            },
            set(val) {
                this.setSelectedGroupId(val);
            }
        }
    },
    data() {
        return {
            expanded: []
        };
    },
    methods: {
        ...mapMutations('GroupsControl', ['setSelectedGroupId', 'setIsOpenEditGroupModal', 'setEditGroupModalData']),

        onAddChildrenGroup(prop) {
            let { rowId } = prop;

            this.setEditGroupModalData({ parentAccessGroupId: rowId });
            this.setIsOpenEditGroupModal(true);
        }
    }
};
</script>

<style lang="sass">
.GroupsControlTree
    width: 100%
    height: 100%
    overflow: hidden
    display: flex
    flex-direction: column
    background-color: #fff
    border-radius: 4px
    &-scrollArea
        flex-grow: 1
        height: 100%
    &-tree
        padding: 10px 16px
        .q-tree__node
            display: flex
            flex-direction: column
            align-items: flex-start
            padding-bottom: 0
            padding-top: 6px
            &:after
                top: 0px
                left: -12px
            .q-tree__node-header
                background-color: var(--ms-light-grey)
                color: var(--ms-grey)
                padding-right: 8px
                margin-top: 0
                border: 1px solid
                border-color: transparent
                transition: border-color 150ms ease-in-out
                margin-right: 32px
                &:before
                    top: -8px
                .GroupsControlTreeNode
                    &-actions
                        opacity: 0
                        transition: opacity 250ms ease-in-out
                &:hover
                    .GroupsControlTreeNode
                        &-actions
                            opacity: 1
                &.q-tree__node--selected
                    border-color: var(--ms-grey)
                & > .q-focus-helper
                    background-color: var(--ms-light-grey)
                    color: var(--ms-dark)
                    top: -1px
                    bottom: -1px
                    left: -1px
                    right: -1px
                    width: auto
                    height: auto
                .q-icon
                    color: var(--ms-grey)
                .q-tree__node-header-content
                    color: var(--ms-dark)
</style>
