<template>
    <div class="HeaderProjectSelectorProjectsList">
        <q-scroll-area
            class="HeaderProjectSelectorProjectsList-scroll"
            :thumb-style="{ 'transition': 'top 100ms ease, opacity 300ms', 'background-color': 'var(--ms-dark)' }"
        >
            <q-radio
                class="HeaderProjectSelectorProjectsList-radio"
                color="ms-primary"
                v-for="project in allProjectsFiltered"
                :key="project.rowId"
                :val="project.rowId"
                v-model="selectedProject"
            >
                {{ project.name }}

                <q-tooltip
                    content-class="bg-ms-dark"
                    anchor="bottom middle"
                    self="center middle"
                    max-width="300px"
                    :offset="[0, 20]"
                    :delay="500"
                >
                    {{ project.name }}
                </q-tooltip>
            </q-radio>
        </q-scroll-area>
    </div>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'HeaderProjectSelectorProjectsList',
    computed: {
        ...mapGetters('Projects', ['selectedProjectId', 'allProjectsFiltered']),

        selectedProject: {
            get() {
                return this.selectedProjectId;
            },
            set(val) {
                this.setSelectedProjectId(val);
            }
        }
    },
    methods: {
        ...mapMutations('Projects', ['setSelectedProjectId'])
    }
};
</script>

<style lang="sass">
.HeaderProjectSelectorProjectsList
    display: flex
    flex-direction: column
    flex-grow: 1
    &-scroll
        display: flex
        flex-direction: column
        flex-grow: 1
    &-radio
        width: calc(100% - 16px)
        margin-right: 16px
        margin-left: 0
        border-radius: 4px
        &:nth-child(even)
            background-color: var(--ms-light-grey)
        .q-radio__label
            overflow: hidden
            display: -webkit-box
            -webkit-box-orient: vertical
            -webkit-line-clamp: 1
</style>
