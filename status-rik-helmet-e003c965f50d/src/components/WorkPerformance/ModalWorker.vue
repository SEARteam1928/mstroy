<template>
    <q-card class="ModalWorker column full-height full-width ModalWorker-card">
        <q-btn
            class="ModalWorker-close modal-close-btn close-red with-mobile no-radius-top-left no-radius-top-right no-radius-bottom-right"
            :class="{ 'ModalWorker-closeMobile': closeMobile }"
            icon="close"
            flat
            :dense="closeMobile"
            v-close-popup
        />

        <div class="ModalWorker-content">
            <div class="ModalWorker-content-left">
                <ModalWorkerMap />
            </div>
            <div class="ModalWorker-content-right">
                <PerformanceAnalyzeZones
                    class="PerformanceAnalyzeZones sticky-header sticky-bottom compact table-blue-header table-blue-grid table-no-border-radius"
                    :tableData="ModalWorkerTableData"
                    :tableTitle="PerformanceAnalyzeZonesTitle"
                    :error="PerformanceAnalyzeZonesError"
                    autoRowHeight
                    :minRowHeight="minRowHeight"
                />
            </div>
        </div>
    </q-card>
</template>

<script>
import { date } from 'quasar';

import PerformanceAnalyzeZones from './PerformanceAnalyzeZones.vue';
import ModalWorkerMap from './ModalWorkerMap.vue';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'ModalWorker',
    components: {
        PerformanceAnalyzeZones,
        ModalWorkerMap
    },
    computed: {
        ...mapGetters('WorkPerformance', [
            'periodFrom',
            'periodTo',
            'ModalWorkerTableData',
            'selectedWorkerShortName',
            'moduleErrors'
        ]),

        minRowHeight() {
            let minRowHeight = 18;

            if (this.$q.screen.width <= 768) minRowHeight = 28;

            return minRowHeight;
        },

        PerformanceAnalyzeZonesTitle() {
            let title = 'Анализ трудозатрат';
            if (this.selectedWorkerShortName) {
                title += ` "${this.selectedWorkerShortName}"`;
            }

            let fromTS = new Date(this.periodFrom);
            let toTS = new Date(this.periodTo);

            let fromFormat = date.formatDate(fromTS, 'DD/MM/YYYY');
            let toFormat = date.formatDate(toTS, 'DD/MM/YYYY');

            title += ` с ${fromFormat} по ${toFormat}`;

            return title;
        },

        PerformanceAnalyzeZonesError() {
            return this.moduleErrors.requestWorkAnalyzeWorkCostWorker !== undefined;
        },

        closeMobile() {
            return this.$q.screen.lt.md;
        }
    },
    created() {
        window.ModalWorker = this;

        this.update();
    },
    beforeDestroy() {
        this.clearModalWorkerTableData();
    },
    methods: {
        ...mapMutations('WorkPerformance', ['clearModalWorkerTableData']),
        ...mapActions('WorkPerformance', ['requestWorkAnalyzeWorkCostWorker']),

        update() {
            this.requestWorkAnalyzeWorkCostWorker();
        }
    }
};
</script>

<style lang="sass">
.ModalWorker
    height: 100%
    overflow: auto
    &-close
        position: absolute
        top: 0
        right: 0
        z-index: 10000
        .q-btn__wrapper
            padding: 0px 12px
            min-height: 2.15em
    &-closeMobile
        position: fixed
        &.q-btn--dense
            .q-btn__wrapper
                padding: 0.285em
                min-height: 2em
    &-content
        display: flex
        height: 100%
        max-width: 100%
        @media only screen and (max-width : 768px)
            flex-direction: column
        &-left
            width: 50%
            max-width: 50%
            flex-grow: 1
            height: 100%
            display: flex
            flex-direction: column
            justify-content: center
            align-items: center
            @media only screen and (max-width : 768px)
                width: 100%
                max-width: 100%
                min-height: 80vh
                margin-bottom: 16px
        &-right
            width: 50%
            max-width: 50%
            flex-grow: 1
            display: flex
            flex-direction: column
            height: calc(100% - 16px)
            margin-bottom: 16px
            position: relative
            @media only screen and (max-width : 768px)
                display: block
                width: 100%
                max-width: 100%
                height: auto

    .PerformanceAnalyzeZones
        margin: 0 16px
        @media only screen and (max-width : 768px)
            margin: 0
        .q-table
            border: 1px solid rgba(0, 0, 0, 0.12)
            border-top-width: 0

        .q-table__top
            padding: 12px 16px
</style>
