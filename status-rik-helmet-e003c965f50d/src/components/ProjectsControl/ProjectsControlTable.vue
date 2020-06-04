<template>
    <div class="ProjectsControlTable">
        <TableCustom
            selectable
            :model="projectsTableModel"
            :data="allProjects"
            keyField="rowId"
            :loading="isLoadingTableData"
            @selected="onRowsSelected"
        />
    </div>
</template>

<script>
import TableCustom from '@components/common/TableCustom.vue';

import projectsTableModel from './projectsTableModel';

import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'ProjectsControlTable',
    components: {
        TableCustom
    },
    computed: {
        ...mapGetters('Projects', ['allProjects', 'isLoadingProjects']),

        isLoadingTableData() {
            return this.allProjects.length === 0 && this.isLoadingProjects;
        }
    },
    data() {
        return {
            projectsTableModel
        };
    },
    beforeDestroy() {
        this.clearSelectedProjectsId();
    },
    methods: {
        ...mapMutations('ProjectsControl', ['setSelectedProjectsId', 'clearSelectedProjectsId']),

        onRowsSelected(selected) {
            this.setSelectedProjectsId(selected);
        }
    }
};
</script>

<style lang="sass">
.ProjectsControlTable
    display: flex
    flex-direction: column
    position: relative
    height: 100%
    flex-grow: 1
    align-self: stretch
    overflow: hidden

    .TableCustomRow
        .TableCustomCell
            color: var(--ms-dark)
            &.cell-name
                display: -webkit-box
                -webkit-box-orient: vertical
                -webkit-line-clamp: 1
</style>
