<template>
    <q-page class="ProjectsControl-page page-background">
        <div class="ProjectsControl page-block">
            <ProjectsControlHeader />
            <q-separator class="ProjectsControl-separator" />

            <ProjectsControlTable />
        </div>

        <div class="ProjectsControl-ProjectsControlActionsBlock page-block">
            <DataPreloader
                class="ProjectsControl-preloader"
                vertical
                :loading="false"
                :info="isNoneSelected"
                :duration="50"
                infoMessage="Выберите проект из списка для просмотра информации"
            >
                <ProjectsControlActionsBlock />
            </DataPreloader>
        </div>

        <EditProjectModal />
        <EditAccessModal />
    </q-page>
</template>

<script>
import ProjectsControlHeader from '@components/ProjectsControl/ProjectsControlHeader.vue';
import ProjectsControlTable from '@components/ProjectsControl/ProjectsControlTable.vue';
import DataPreloader from '@components/common/DataPreloader.vue';
import ProjectsControlActionsBlock from '@components/ProjectsControl/ProjectsControlActionsBlock.vue';

import EditProjectModal from '@components/ProjectsControl/EditProjectModal.vue';
import EditAccessModal from '@components/ProjectsControl/EditAccessModal.vue';

import withModuleErrors from '@mixins/withModuleErrors';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'ProjectsControl',
    components: {
        ProjectsControlHeader,
        ProjectsControlTable,
        ProjectsControlActionsBlock,
        DataPreloader,
        EditProjectModal,
        EditAccessModal
    },
    mixins: [withModuleErrors('ProjectsControl')],
    computed: {
        ...mapGetters('ProjectsControl', ['selectedProjectsId']),
        ...mapGetters('Entities', ['getEntityIdByName']),

        isNoneSelected() {
            return this.selectedProjectsId.length === 0;
        }
    },
    created() {
        this.requestAllProjects();
        this.requestAllAccessGroups();

        // Запрос списка сущностей базы
        this.requestAllEntities().then(() => {
            // Находим id сущности, относящейся к проектам
            let projectEntityId = this.getEntityIdByName('project');
            this.setProjectEntityId(projectEntityId);
        });
    },
    beforeDestroy() {
        this.clearAllProjects();
    },
    methods: {
        ...mapMutations('ProjectsControl', ['setProjectEntityId']),
        ...mapMutations('Projects', ['clearAllProjects']),

        ...mapActions('Projects', ['requestAllProjects']),
        ...mapActions('GroupsControl', ['requestAllAccessGroups']),
        ...mapActions('Entities', ['requestAllEntities'])
    }
};
</script>

<style lang="sass">
.ProjectsControl
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
    &-ProjectsControlActionsBlock
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
