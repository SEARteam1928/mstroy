<template>
    <div class="BimProjectsWrapper" v-show="showProjectsTree">
        <q-expansion-item
            class="expansion shadow-2"
            default-opened
            icon="share"
            label="Дерево проекта"
            caption="Развернуть"
        >
            <ProjectElementsTree class="ProjectElementsTree" />
        </q-expansion-item>
    </div>
</template>

<script>
import ProjectElementsTree from './ProjectElementsTree.vue';

export default {
    props: ['showProjectsTree'],
    components: {
        ProjectElementsTree
    }
};
</script>

<style lang="sass">
.BimProjectsWrapper
    position: absolute
    top: 83px
    bottom: 83px
    left: 100px
    width: 350px
.ProjectElementsTree
    position: relative
    width: 350px
    height: 350px
.expansion
    background: #fff
</style>
