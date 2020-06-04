<template>
    <div class="SingleSelected">
        <SingleSelectedHeader :id="selectedProjectId" />

        <q-scroll-area
            class="SingleSelected-scrollArea"
            :thumb-style="{ 'transition': 'top 100ms ease, opacity 300ms', 'background-color': 'var(--ms-dark)' }"
        >
            <SingleSelectedInfo v-if="selectedProject" :project="selectedProject" />
        </q-scroll-area>

        <SingleSelectedActions />
    </div>
</template>

<script>
import SingleSelectedHeader from './SingleSelectedHeader.vue';
import SingleSelectedInfo from './SingleSelectedInfo.vue';
import SingleSelectedActions from './SingleSelectedActions.vue';

import { mapGetters } from 'vuex';

export default {
    name: 'SingleSelected',
    components: {
        SingleSelectedHeader,
        SingleSelectedInfo,
        SingleSelectedActions
    },
    computed: {
        ...mapGetters('ProjectsControl', ['selectedProjectsId']),
        ...mapGetters('Projects', ['getSelectedProject']),

        selectedProjectId() {
            return this.selectedProjectsId[0];
        },
        selectedProject() {
            let id = this.selectedProjectId;
            return this.getSelectedProject(id);
        }
    }
};
</script>

<style lang="sass">
.SingleSelected
    position: relative
    height: 100%
    align-self: stretch
    color: var(--ms-dark)
    display: flex
    flex-direction: column
    &-scrollArea
        flex-grow: 1
        height: 100%
</style>
