<template>
    <l-map class="ModalWorkerMap">
        <l-map class="map-heat" :maxZoom="mapOptions.maxZoom" ref="map">
            <l-tile-layer :url="mapOptions.url" :attribution="mapOptions.attribution" />

            <l-control
                position="topright"
                ref="control"
                class="leaflet-control leaflet-control-layers datepicker-controls"
            >
                <PeriodDatepickerInput
                    class="PeriodDatepickerInput"
                    dense
                    clearable
                    align="top middle"
                    panel="range"
                    label="Выбор даты"
                    :from="ModalWorkerMapPeriodFrom"
                    :to="ModalWorkerMapPeriodTo"
                    :mobileMode="$q.screen.lt.sm"
                    :showControls="true"
                    :clickableInput="true"
                    v-model="dates"
                />
            </l-control>

            <MapLoadingInfo class="MapLoadingInfo" position="topright" :status="loadingInfoStatus" />

            <TrackPlayBack
                v-if="isCoordinatesLoaded"
                ref="trackPlayBack"
                fitBounds
                :clockOptions="trackplaybackOptions.clockOptions"
                :targetOptions="trackplaybackOptions.targetOptions"
                :latLngs="TrackPlayBackLatLngs"
                :deviceCoordinates="deviceCoordinates"
            >
                <template v-slot:controller="controllerProps">
                    <TrackPlayBackController ref="trackPlayBackController" v-bind="controllerProps" />
                </template>
            </TrackPlayBack>

            <l-control
                class="leaflet-control leaflet-control-layers leaflet-control-layers-expanded track-play-back-showtrack"
                style="user-select: none;"
                position="topright"
            >
                <section class="leaflet-control-layers-list">
                    <label>
                        <input
                            type="checkbox"
                            class="leaflet-control-layers-selector"
                            v-model="activeCoordinatesModel"
                        />
                        <span> Только активные координаты</span>
                    </label>
                </section>
            </l-control>

            <WorkZonesObjects />
        </l-map>
    </l-map>
</template>

<script>
import { date } from 'quasar';

import { LMap, LTileLayer, LControl } from 'vue2-leaflet';
import 'leaflet/dist/leaflet.css';

import TrackPlayBack from '../Map/TrackPlayBack.vue';
import TrackPlayBackController from '../Map/TrackPlayBackController.vue';
import PeriodDatepickerInput from '../common/PeriodDatepickerInput.vue';
import MapLoadingInfo from '../common/MapLoadingInfo.vue';
import WorkZonesObjects from '../common/WorkZonesObjects.vue';

import { dateISONormalize } from '@services/utils';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'ModalWorkerMap',
    components: {
        LMap,
        LTileLayer,
        LControl,
        TrackPlayBack,
        TrackPlayBackController,
        PeriodDatepickerInput,
        MapLoadingInfo,
        WorkZonesObjects
    },
    computed: {
        ...mapGetters('WorkPerformance', [
            'periodFrom',
            'periodTo',
            'projectId',
            'selectedWorkerId',
            'selectedWorkerHelmetId',
            'ModalWorkerMapPeriodFrom',
            'ModalWorkerMapPeriodTo',
            'deviceCoordinates',
            'deviceCoordinatesLoading',
            'TrackPlayBackLatLngs',
            'moduleErrors',
            'onlyActiveCoordinates'
        ]),

        activeCoordinatesModel: {
            get() {
                return this.onlyActiveCoordinates;
            },
            set(val) {
                this.setOnlyActiveCoordinates(val);
            }
        },

        isCoordinatesLoaded() {
            return this.TrackPlayBackLatLngs.length > 0;
        },

        loadingInfoStatus() {
            let status = 'hide';

            if (this.moduleErrors.requestDeviceCoordinates || this.moduleErrors.requestSelectedWorkerData) {
                status = 'error';
                return status;
            }

            if (!this.ModalWorkerMapPeriodFrom || !this.ModalWorkerMapPeriodTo) {
                status = 'nodate';
                return status;
            }

            if (this.deviceCoordinatesLoading) {
                status = 'loading';
                return status;
            }

            if (!this.deviceCoordinatesLoading && !this.isCoordinatesLoaded) {
                status = 'nodata';
                return status;
            }

            return status;
        }
    },
    created() {
        window.ModalWorkerMap = this;

        // // Период запроса координат будет с начала текущего дня
        // let startDay = new Date(this.periodTo);
        // startDay = date.adjustDate(startDay, { hours: 0, minutes: 0, seconds: 0, milliseconds: 0 });
        // this.setModalWorkerMapPeriodFrom(dateISONormalize(startDay));

        // // и до момента открытия этой страницы
        // let now = new Date(this.periodTo);
        // this.setModalWorkerMapPeriodTo(dateISONormalize(now));

        this.dates = {
            from: this.periodFrom,
            to: this.periodTo
        };

        // Запрашивает данные о работнике по его id
        this.requestSelectedWorkerData();
    },
    beforeDestroy() {
        this.clearSelectedWorkerId();
        this.clearSelectedWorkerData();
        this.clearDeviceCoordinates();
    },
    watch: {
        // При изменении дат календарем, обновим их в хранилище и запросим новые координаты
        dates(newDates, oldDates) {
            let { from, to } = newDates;
            if (from === oldDates.from && to === oldDates.to) return;

            this.setModalWorkerMapPeriodFrom(from);
            this.setModalWorkerMapPeriodTo(to);

            this.$nextTick(() => {
                this.refreshDeviceCoordinates();
            });
        },

        // При изменении выбранного устройства обновляет данные координат
        // Запросив в created requestSelectedWorkerData,
        // из его ответа будет взят id устройства и сработает этот вотчер
        selectedWorkerHelmetId(helmetId) {
            this.$nextTick(() => {
                this.refreshDeviceCoordinates();
            });
        },

        onlyActiveCoordinates() {
            this.$nextTick(() => {
                this.refreshDeviceCoordinates();
            });
        }
    },
    data() {
        return {
            mapOptions: {
                url: 'https://{s}.tile.osm.org/{z}/{x}/{y}.png',
                maxZoom: 18,
                attribution: ''
            },
            // Опции плеера треков
            trackplaybackOptions: {
                clockOptions: {
                    speed: 10,
                    maxSpeed: 65
                },
                targetOptions: {
                    useImg: false,
                    width: 12,
                    height: 20,
                    color: '#000',
                    fillColor: '#ffc107',
                    showText: true
                }
            },
            dates: {}
        };
    },
    methods: {
        ...mapMutations('WorkPerformance', [
            'clearSelectedWorkerId',
            'clearSelectedWorkerData',
            'setModalWorkerMapPeriodFrom',
            'setModalWorkerMapPeriodTo',
            'clearDeviceCoordinates',
            'setOnlyActiveCoordinates'
        ]),
        ...mapActions('WorkPerformance', ['requestSelectedWorkerData', 'requestDeviceCoordinates']),

        refreshDeviceCoordinates() {
            this.clearDeviceCoordinates();
            this.requestDeviceCoordinates();
        }
    }
};
</script>

<style lang="sass">
.ModalWorkerMap
    width: 100%
    height: 100%
    display: flex
    flex-direction: column
    justify-content: center
    align-items: center
    .leaflet-top.leaflet-right
        z-index: 1100
    .datepicker-controls,
    .active-controls
        margin-top: 0px
        top: 2px
        z-index: 1000
    .MapLoadingInfo

    .PeriodDatepickerInput
        width: 250px
</style>
