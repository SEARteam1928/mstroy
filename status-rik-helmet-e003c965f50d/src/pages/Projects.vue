<template>
    <q-page>
        <iframe class="project_frame" :src="src" allowfullscreen frameborder="no"></iframe>
    </q-page>
</template>

<script>
export default {
    name: 'Projects',
    meta: {
        title: 'Проекты',
        titleTemplate: title => `${title} - BIM-портал`
    },
    data() {
        return {
            src: 'http://bim.ms11.ru/bim/#/view/396'
        };
    }
};
</script>

<style lang="sass" scoped>
.project_frame
    position: absolute
    width: 100%
    height: 100%
    left: 0
    top: 0
</style>
