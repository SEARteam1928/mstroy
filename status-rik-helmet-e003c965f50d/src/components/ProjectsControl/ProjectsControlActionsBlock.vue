<template>
    <div class="ProjectsControlActionsBlock">
        <NoneSelected v-if="isNoneSelected" />
        <SingleSelected v-if="isSingleSelected" />
        <MultiSelected v-if="isMultiSelected" />
    </div>
</template>

<script>
import NoneSelected from './ProjectsControlActionsBlock/NoneSelected.vue';
import SingleSelected from './ProjectsControlActionsBlock/SingleSelected.vue';
import MultiSelected from './ProjectsControlActionsBlock/MultiSelected.vue';

import { mapGetters } from 'vuex';

export default {
    name: 'ProjectsControlActionsBlock',
    components: {
        NoneSelected,
        SingleSelected,
        MultiSelected
    },
    computed: {
        ...mapGetters('ProjectsControl', ['selectedProjectsId']),
        ...mapGetters('Projects', ['allProjects', 'allProjectsMap']),

        isNoneSelected() {
            return this.selectedProjectsId.length === 0;
        },
        isSingleSelected() {
            return this.selectedProjectsId.length === 1;
        },
        isMultiSelected() {
            return this.selectedProjectsId.length > 1;
        }
    }
};
</script>

<style lang="sass">
.ProjectsControlActionsBlock
    position: relative
    height: 100%
    align-self: stretch
    display: flex
    flex-direction: column
</style>
