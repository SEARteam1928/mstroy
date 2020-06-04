<template>
    <div class="ProjectsControlHeader">
        <q-btn
            class="ProjectsControlHeader-addProjectBtn"
            unelevated
            label="+ Добавить проект"
            color="ms-primary"
            @click="onAddProjectBtnClick"
        />
    </div>
</template>

<script>
import { mapMutations } from 'vuex';

export default {
    name: 'ProjectsControlHeader',
    methods: {
        ...mapMutations('ProjectsControl', ['setIsOpenEditProjectModal']),

        onAddProjectBtnClick() {
            this.setIsOpenEditProjectModal(true);
        }
    }
};
</script>

<style lang="sass">
.ProjectsControlHeader
    width: 100%
    padding: 8px 12px
    display: flex
    align-items: center
    &-addProjectBtn
        margin-right: 16px
        min-width: 175px
</style>
