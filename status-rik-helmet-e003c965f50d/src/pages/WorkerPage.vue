<template>
    <q-card class="column full-height full-width worker-content-card">
        
        <div class="worker-content column no-wrap">

            <q-card-section class="worker-content-header row">
                <div class="header-text row items-center">
                    <div class="text-h5" v-if="isLodedDatd">{{workerData.LN}} {{workerData.FN}}</div>
                    <div class="header-code">{{id}}</div>
                </div>
                
                <q-btn class="worker-content-close" icon="close" flat v-close-popup/>
            </q-card-section>

            <q-separator inset style="height: 1px; max-height: 1px;"/>

            <q-card-section class="tabs-section row">
                <!-- <div class="col-6 col-xs-12 column no-wrap tabs-column"> -->
                <div class="col-md-6 col-sm-12 col-xs-12 column no-wrap tabs-column">
                    <q-tabs
                        v-model="tab"
                        dense
                        class="text-grey tabs-buttons-wrap"
                        active-color="primary"
                        indicator-color="primary"
                        align="left"
                        narrow-indicator
                    >
                        <q-tab name="track" label="Траектории" />
                        <q-tab name="role" label="Должности" />
                    </q-tabs>

                    <q-separator style="height: 1px; max-height: 1px;"/>

                    <q-tab-panels v-model="tab" animated v-if="isLodedDatd">
                        <q-tab-panel name="track" class="tab-panel-track">
                            <WorkerTabTrack :id="workerData.Code"/>
                        </q-tab-panel>

                        <q-tab-panel name="role" class="tab-panel-role">
                            <WorkerTabRole/>
                        </q-tab-panel>

                    </q-tab-panels>
                </div>

                <!-- <div class="col-6 col-xs-12 map-column"> -->
                <div class="col-md-6 col-sm-12 col-xs-12 column no-wrap map-column">
                    <WorkerMap class="map-container column no-wrap"/>
                </div>

            </q-card-section>
        </div>


    </q-card>
</template>

<script>
import _workersData from '../components/Workers/workersData';
import WorkerTabTrack from '../components/WorkerPage/WorkerTabTrack.vue';
import WorkerTabRole from '../components/WorkerPage/WorkerTabRole.vue';
import WorkerMap from '../components/WorkerPage/WorkerMap.vue';

import { dom } from 'quasar';
const { height, width } = dom;

window.qHeight = height;
window.qWidth = width;

export default {
    name: 'WorkerPage',
    components: {
        WorkerTabTrack,
        WorkerTabRole,
        WorkerMap
    },
    computed: {
        routeParams() {
            return this.$route.params;
        },
        id() {
            return this.$route.params.id;
        },
        isLodedDatd() {
            return this.workerData ? true : false;
        }
    },
    methods: {
        delay(timeout) {
            return new Promise(resolve => setTimeout(resolve, timeout));
        },
        // TODO: Пока это фейковая функция, вместо запроса на апи 
        // она будет выбирать сотрудника из захардкоженного массива
        async requestWorkerData() {
            // await this.delay(2000);

            let worker = _workersData.filter(worker => worker.Code === this.id);
            if(worker.length > 0) return worker[0];
        },
    },
    data() {
        return {
            workerData: undefined,
            tab: 'track',
        }
    },
    async created() {
        window.wrk = this;
        console.log('Worker id: ', this.id);

        this.workerData = await this.requestWorkerData();
        console.log(this.workerData);
        
    },
}
</script>

<style lang="sass" scoped>
.worker-content
    height: 100%
    max-height: 100%
    max-width: 100%

.worker-content-header
    min-height: 48px
    max-width: 100%
    padding:
        top: 4px
        bottom: 0
    @media only screen and (max-width : 1023px)
        min-height: auto

.header-text
    margin-right: 60px
    @media only screen and (max-width : 1023px)
        flex-direction: column
    .text-h5
        margin-right: 10px
    .header-code
        @media only screen and (max-width : 1023px)
            display: block
            width: 100%

.worker-content-close
    position: absolute
    top: 6px
    right: 6px

.tabs-column, 
.map-column
    max-width: 100%

.tabs-column
    padding-right: 8px
    @media only screen and (max-width : 1023px)
        padding:
            right: 0
            bottom: 16px

.map-column
    flex-grow: 1
    padding-left: 8px
    @media only screen and (max-width : 1023px)
        height: 100%
        padding: 0 10px

.tabs-section
    flex-grow: 1
    overflow: auto
    flex-wrap: nowrap
    max-width: 100%
    @media only screen and (max-width : 1023px)
        flex-wrap: wrap
    
.tab-panel-track
    padding: 16px 0 0 0
    overflow: hidden

.map-container
    flex-grow: 1
    position: relative
    overflow: auto
    height: 100%

</style>

<style lang="sass">
.sessions-table.sticky
    .q-table__middle
        height: 100%
    thead
        tr
            background-color: #fff;
            border-bottom: 1px solid rgba(0,0,0, 0.12);
            th
                position: sticky;
                top: 0;
                z-index: 1;
                opacity: 1;
    .q-table th.sortable:hover, .q-table th.sorted
        opacity: 1
</style>