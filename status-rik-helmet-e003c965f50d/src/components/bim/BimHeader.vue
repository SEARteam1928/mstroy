<template>
    <div class="BimHeader">
        <!-- <q-btn class="showComponentTree" color="ms-primary" @click="onShowComponentTreeClick">
            {{ showComponentTreeText }}
        </q-btn> -->

        <q-select
            class="BimProjectSelect"
            outlined
            dense
            label="Выберите проект"
            v-model="selectedProjectModel"
            :options="projects"
            :loading="projectsRequested"
            :disable="projectsRequested"
            option-value="oid"
            option-label="name"
            :display-value="`${selectedProject ? selectedProject.name : ''}`"
        />
    </div>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'BimHeader',
    data() {
        return {
            showComponentTree: {
                hide: 'Скрыть панель',
                show: 'Показать панель'
            }
        };
    },
    computed: {
        ...mapGetters('Bim', ['projectsRequested', 'projects', 'selectedProject', 'isShowComponentTreeModel']),

        showComponentTreeText() {
            if (this.isShowComponentTreeModel) {
                return this.showComponentTree.hide;
            } else {
                return this.showComponentTree.show;
            }
        },

        selectedProjectModel: {
            get() {
                return this.selectedProject;
            },
            set(project) {
                this.setSelectedProject(project);
            }
        }
    },
    methods: {
        ...mapMutations('Bim', ['setSelectedProject', 'setIsShowComponentTreeModel']),

        onShowComponentTreeClick() {
            this.setIsShowComponentTreeModel(!this.isShowComponentTreeModel);
        }
    }
};
</script>

<style lang="sass">
.BimHeader
    display: flex
    justify-content: flex-end
    align-items: center
    height: 100%
    padding: 10px
    .BimProjectSelect
        width: 350px
        background-color: #fff
    .showComponentTree
        margin-right: 8px
</style>
