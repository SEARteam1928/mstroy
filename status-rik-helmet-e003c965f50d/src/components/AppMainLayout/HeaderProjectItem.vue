<template>
    <div class="HeaderProjectItem" :class="{ 'page-block': isLoadingProjects }">
        <div v-if="!isLoadingProjects" class="HeaderProjectItem-wrap">
            <q-expansion-item
                class="HeaderProjectItem-expansion page-block"
                :class="{ 'shadow-10': openExpandModel }"
                :duration="duration"
                :style="{ '--duration': duration }"
                header-class="HeaderProjectItem-titleSection"
                expand-icon-class="HeaderProjectItem-openBtn q-hoverable"
                :expand-icon-toggle="!drawerMobileMode"
                v-model="openExpandModel"
            >
                <template v-slot:header>
                    <div class="HeaderProjectItem-title">
                        {{ projectName }}

                        <q-tooltip
                            content-class="bg-ms-dark"
                            anchor="bottom right"
                            self="top right"
                            max-width="400px"
                            :offset="[12, 10]"
                            :delay="500"
                        >
                            {{ projectName }}
                        </q-tooltip>
                    </div>
                </template>

                <HeaderProjectSelector />
            </q-expansion-item>
        </div>
    </div>
</template>

<script>
import OpenChevron from '../common/OpenChevron.vue';
import ExpandableWrap from '../common/ExpandableWrap.vue';
import HeaderProjectSelector from './HeaderProjectSelector.vue';

import withModuleErrors from '@mixins/withModuleErrors';

import Api from '@services/api';

import { mapGetters, mapMutations, mapActions } from 'vuex';
import { debounce } from 'quasar';

export default {
    name: 'HeaderProjectItem',
    components: {
        OpenChevron,
        ExpandableWrap,
        HeaderProjectSelector
    },
    mixins: [withModuleErrors('Projects')],
    computed: {
        ...mapGetters('Projects', ['selectedProjectId', 'selectedProject', 'isLoadingProjects']),
        ...mapGetters('UI', ['drawerMobileMode']),

        projectName() {
            let name = this.selectedProject ? this.selectedProject.name : '';

            return name;
        },

        openExpandModel: {
            get() {
                return this.openExpandSection;
            },
            set(value) {
                this.onOpenChevron(value);
            }
        }
    },
    watch: {
        // После выбора другого проекта будем закрывать HeaderProjectSelector
        selectedProjectId(newProjectId) {
            this.openExpandSection = false;

            Api.setProject(newProjectId);
        }
    },
    data() {
        return {
            openExpandSection: false,
            duration: 250
        };
    },
    created() {
        this.requestAllProjects();

        this.onOpenChevron = debounce(this.onOpenChevron, 200);
    },
    methods: {
        ...mapActions('Projects', ['requestAllProjects']),

        onOpenChevron(value) {
            this.openExpandSection = value;
        },

        onOpenBtnClick() {
            this.openExpandSection = !this.openExpandSection;
        }
    }
};
</script>

<style lang="sass">
.HeaderProjectItem
    width: 100%
    height: 100%
    display: flex
    justify-content: center
    flex-direction: column
    align-items: center
    &-wrap
        width: 100%
        height: 100%
        display: flex
        flex-direction: column
        justify-content: center
        position: relative
    &-titleSection
        display: flex
        justify-content: space-between
        align-items: center
        padding: 10px 12px
        min-height: calc( var(--header-height) - 6px )
    &-title
        max-width: calc(100% - 28px)
        overflow: hidden
        display: -webkit-box
        -webkit-box-orient: vertical
        -webkit-line-clamp: 2
    &-openBtn
        color: var(--ms-dark)
        padding-left: 4px !important
        padding-right: 0
        .q-icon
            border-radius: 50% !important
    &-expansion
        position: absolute
        min-height: 100%
        top: 0
        left: 0
        right: 0
        will-change: box-shadow
        transition: box-shadow calc( var(--duration) * 1ms ) ease-in-out
        .q-expansion-item__container
            display: flex;
            flex-direction: column
            .q-expansion-item__content
                .q-card
                    border-radius: 4px
</style>
