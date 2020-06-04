<template>
    <div class="Spider-page page-background">
        <DataPreloader :loading="!ganttDataReady" :error="deviceListError" :vertical="true">
            <div class="Spider page-block">
                <SpiderGanttControl @zoomToFit="onZoomToFit" @zoomConfig="onZoomConfig" ref="SpiderGanttControl" />

                <Gantt
                    class="Spider-Gantt"
                    :tasks="allPlannedWorks"
                    @task-updated="onTaskUpdated"
                    @task-selected="onTaskSelected"
                    @link-updated="onLinkUpdated"
                    @zoomLevel="onGanttZoomLevel"
                    ref="gantt"
                />
            </div>
        </DataPreloader>
    </div>
</template>

<script>
import DataPreloader from '../components/common/DataPreloader.vue';
import Gantt from '../components/common/gantt/Gantt.vue';
import SpiderGanttControl from '../components/Spider/SpiderGanttControl';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'Spider',
    components: {
        DataPreloader,
        Gantt,
        SpiderGanttControl
    },
    watch: {
        moduleErrors(newErrors, oldErrors) {
            // При разработке будут всплывать уведомления с ошибками
            if (process.env.DEV) {
                // Для нахождения свежей ошибки в объекте ошибок
                let newCopyErrors = { ...newErrors };
                Object.keys(oldErrors).forEach(err => delete newCopyErrors[err]);

                // Если ошибки нет, значит watch сработал на очистку одной из прошлых ошибок
                if (!Object.keys(newCopyErrors).length) return;

                console.log('Spider Error: ', newCopyErrors);
                let [type, error] = Object.entries(newCopyErrors)[0];
                this.$q.notify({
                    icon: 'close',
                    color: 'btn_red',
                    message: `[ ${type} ]: ${String(error)}`
                });
            }
        }
    },
    computed: {
        ...mapGetters('Spider', ['moduleErrors', 'allPlannedWorks']),

        ganttDataReady() {
            return this.allPlannedWorks.data.length > 0;
        },

        deviceListError() {
            return this.moduleErrors.requestAllPlannedWorks !== undefined;
        }
    },
    created() {
        window.Spider = this;
    },
    mounted() {
        this.requestAllPlannedWorks();
    },
    methods: {
        ...mapActions('Spider', ['requestAllPlannedWorks']),

        // События от панельки управления
        onZoomToFit() {
            this.$refs.gantt && this.$refs.gantt.zoomToFit();
        },
        onZoomConfig(config) {
            this.$refs.gantt && this.$refs.gantt.applyConfig(config);
        },

        // События от Gantt
        onGanttZoomLevel(level) {
            this.$refs.SpiderGanttControl && this.$refs.SpiderGanttControl.setVolume(level);
        },
        onTaskUpdated(e) {
            // console.log('onTaskUpdate: ', e);
        },
        onLinkUpdated(e) {
            // console.log('onLinkUpdate: ', e);
        },
        onTaskSelected(e) {
            // console.log('onTaskSelected: ', e);
        }
    }
};
</script>

<style lang="sass">
.Spider
    display: flex
    flex-direction: column
    flex-grow: 1
    height: calc(100% - 16px)
    max-width: calc(100% - 16px)
    margin:
        top: 8px
        right: 8px
        bottom: 8px
        left: 8px
    @media only screen and (max-width : 1300px)
        height: auto
        min-height: calc( 100vh - var(--header-height) )
    &-page
        overflow: hidden
        height: calc( 100vh - var(--header-height) )
        position: relative
        @media only screen and (max-width : 1300px)
            overflow: visible
            height: auto
            min-height: calc( 100vh - var(--header-height) )

    &-Gantt
        height: 100%
        position: relative
        display: flex
        flex-direction: column
        flex-grow: 1
        @media only screen and (max-width : 1300px)
            height: auto
            min-height: calc( 100vh - var(--header-height) )

.gantt_message_area.dhtmlx_message_area
    top: 52px
    .gantt-info.dhtmlx-info.gantt-error.dhtmlx-error
        display: none !important
</style>
