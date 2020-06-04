<template>
    <q-page class="GroupsControl-page page-background">
        <!-- Блок со списком групп -->
        <div class="GroupsControl page-block">
            <GroupsControlHeader />

            <q-separator class="GroupsControl-separator" />

            <GroupsControlTree />
        </div>

        <!-- Блок с информацией и действиями для выбранной группы -->
        <div class="GroupsControl-GroupsControlActionsBlock page-block">
            <DataPreloader
                class="GroupsControlActionsBlock-preloader"
                vertical
                :loading="false"
                :info="isNotSelectedGroup"
                :duration="50"
                infoMessage="Выберите группу из списка для просмотра информации"
            >
                <GroupsControlActionsBlock />
            </DataPreloader>
        </div>

        <EditGroupModal />
    </q-page>
</template>

<script>
import DataPreloader from '@components/common/DataPreloader.vue';
import GroupsControlHeader from '@components/GroupsControl/GroupsControlHeader.vue';
import GroupsControlTree from '@components/GroupsControl/GroupsControlTree.vue';
import GroupsControlActionsBlock from '@components/GroupsControl/GroupsControlActionsBlock.vue';
import EditGroupModal from '@components/GroupsControl/EditGroupModal.vue';

import withModuleErrors from '@mixins/withModuleErrors';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'GroupsControl',
    components: {
        DataPreloader,
        GroupsControlHeader,
        GroupsControlTree,
        GroupsControlActionsBlock,
        EditGroupModal
    },
    mixins: [withModuleErrors('GroupsControl')],
    computed: {
        ...mapGetters('GroupsControl', ['selectedGroupId', 'isOpenEditGroupModal']),

        isNotSelectedGroup() {
            return this.selectedGroupId === null;
        }
    },
    created() {
        this.requestAllAccessGroups();
        this.requestAllUsers();
    },
    beforeDestroy() {
        this.clearAllAccessGroups();
        this.clearAllAccessGroupsTree();
        this.clearAllAccessGroupsTreeMap();
        this.clearAllUsers();
        this.clearEditGroupModalData();
        this.clearDeleteGroupModalData();
    },
    methods: {
        ...mapMutations('GroupsControl', [
            'clearAllAccessGroups',
            'clearAllAccessGroupsTree',
            'clearAllAccessGroupsTreeMap',
            'clearAllUsers',
            'clearEditGroupModalData',
            'clearDeleteGroupModalData'
        ]),
        ...mapActions('GroupsControl', ['requestAllAccessGroups', 'requestAllUsers'])
    }
};
</script>

<style lang="sass">
.GroupsControl
    display: flex
    flex-direction: column
    flex-grow: 1
    height: calc(100% - 16px)
    max-width: calc(100% - 16px)
    padding: 0
    margin:
        top: 8px
        right: 8px
        bottom: 8px
        left: 8px
    &-page
        overflow: hidden
        height: calc( 100vh - var(--header-height) )
        display: flex
        @media only screen and (max-width : 768px)
            height: auto
    &-separator
        max-height: 1px
    &-GroupsControlActionsBlock
        position: relative
        width: 350px
        min-width: 350px
        max-height: calc(100% - 16px)
        display: flex
        flex-direction: column
        margin:
            top: 8px
            right: 8px
            bottom: 8px
            left: 0
</style>
