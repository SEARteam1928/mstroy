<template>
    <div class="map-heat-wrap">
        <l-map class="map-heat" :maxZoom="mapOptions.maxZoom" ref="map">
            <l-tile-layer v-if="mapWasInit" :url="mapOptions.url" :attribution="mapOptions.attribution" />

            <WorkZonesObjects @bounds="onBounds" />

            <HeatLayer
                v-if="isHeatLayer"
                ref="heatLayer"
                fitBounds
                :latLngs="latLngs"
                :minOpacity="heatOptions.minOpacity"
                :radius="heatOptions.radius"
                :blur="heatOptions.blur"
                :gradient="heatOptions.gradient"
            ></HeatLayer>

            <HotLine
                v-if="isHotLine"
                ref="hotLine"
                fitBounds
                :latLngs="latLngs"
                :min="hotLineOptions.min"
                :max="hotLineOptions.max"
                :palette="hotLineOptions.palette"
                :weight="hotLineOptions.weight"
            ></HotLine>

            <TrackPlayBack
                v-if="isTrackPlayBack"
                ref="trackPlayBack"
                fitBounds
                :clockOptions="trackplaybackOptions.clockOptions"
                :targetOptions="trackplaybackOptions.targetOptions"
                :latLngs="latLngs"
                :deviceCoordinates="deviceCoordinates"
            >
                <template v-slot:controller="controllerProps">
                    <TrackPlayBackController ref="trackPlayBackController" v-bind="controllerProps" />
                </template>
            </TrackPlayBack>
        </l-map>
    </div>
</template>

<script>
import * as dataConverter from '../../services/dataConverter';

import { LMap, LTileLayer } from 'vue2-leaflet';
import 'leaflet/dist/leaflet.css';

import HeatLayer from './HeatLayer.vue';
import HotLine from './HotLine.vue';
import TrackPlayBack from './TrackPlayBack.vue';
import TrackPlayBackController from './TrackPlayBackController.vue';
import WorkZonesObjects from '../common/WorkZonesObjects.vue';

export default {
    name: 'MapHeat',
    components: {
        LMap,
        LTileLayer,
        HeatLayer,
        HotLine,
        TrackPlayBack,
        TrackPlayBackController,
        WorkZonesObjects
    },
    props: {
        mapMode: {
            type: String,
            required: false,
            default: 'heatLayer'
        },
        deviceCoordinates: {
            type: Array,
            required: false,
            default: () => []
        },
        devices: {
            type: [Object, Boolean],
            required: true
        },
        period: {
            type: Object,
            required: false
        }
    },
    data() {
        return {
            mapWasInit: false,
            mapOptions: {
                url: 'https://{s}.tile.osm.org/{z}/{x}/{y}.png',
                maxZoom: 20,
                attribution: ''
            },
            // Опции тепловой карты
            heatOptions: {
                radius: 9,
                blur: 12,
                minOpacity: 0.5,
                gradient: {
                    0.2: 'royalblue',
                    0.5: 'blue',
                    0.6: 'cyan',
                    0.7: 'lime',
                    0.8: 'yellow',
                    0.9: 'red'
                }
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
            // Опции тепловых треков
            hotLineOptions: {
                weight: 3,
                outlineWidth: 1,
                palette: {
                    0.0: 'royalblue',
                    0.2: 'blue',
                    0.4: 'cyan',
                    0.6: 'lime',
                    0.8: 'yellow',
                    1.0: 'red'
                },
                min: 0,
                max: 4095
            },
            heatLayer: null,
            hotLine: null,
            trackPlayBack: null,
            trackPlayBackController: null,
            // Конвертеры deviceCoordinates в нужные для режимов форматы
            dataConverters: {
                'heatLayer': {
                    converter: dataConverter.buildLatLngArr,
                    // converter: dataConverter.buildLatLngArrTest, // Для подгрузки тестовых данных из файла
                    options: {
                        alt: false
                    }
                },
                'hotLine': {
                    converter: dataConverter.buildLatLngArr,
                    // converter: dataConverter.buildLatLngArrTest, // Для подгрузки тестовых данных из файла
                    options: {
                        alt: true,
                        altProp: 'ActivityLevel'
                    }
                },
                'trackPlayBack': {
                    converter: dataConverter.buildTrackPlaybackData,
                    // converter: dataConverter.buildTrackPlaybackDataTest, // Для подгрузки тестовых данных из файла
                    options: {
                        alt: true,
                        altProp: 'ActivityLevel'
                    }
                }
            },
            latLngs: []
        };
    },
    computed: {
        isHeatLayer() {
            // if (!this.latLngs.length) this.latLngs = this.convertData(); // Для подгрузки тестовых данных из файла
            return this.mapMode === 'heatLayer' && this.latLngs.length;
        },
        isHotLine() {
            // if (!this.latLngs.length) this.latLngs = this.convertData(); // Для подгрузки тестовых данных из файла
            return this.mapMode === 'hotLine' && this.latLngs.length;
        },
        isTrackPlayBack() {
            // if (!this.latLngs.length) this.latLngs = this.convertData(); // Для подгрузки тестовых данных из файла
            return this.mapMode === 'trackPlayBack' && this.latLngs.length;
        }
    },
    watch: {
        mapMode(newMode, oldMode) {
            if (newMode === oldMode) return;
            this.latLngs = [];
            if (!this.devices) return;
            if (!this.deviceCoordinates.length) return;

            this.latLngs = this.convertData(this.deviceCoordinates);
        },
        deviceCoordinates(newCoordinates, oldCoordinates) {
            this.latLngs = this.convertData(newCoordinates);
        },
        devices(newDevices, oldDevices) {
            if (!newDevices) {
                this.latLngs = [];
            }
        }
    },
    created() {
        window.MapHeat = this;
    },
    methods: {
        convertData(deviceCoordinates) {
            const { converter, options } = this.dataConverters[this.mapMode];
            let convertedData = converter({
                ...options,
                // deviceCoordinates: 'testRealData4' // Для подгрузки тестовых данных из файла
                devices: this.devices,
                deviceCoordinates
            });

            if (convertedData.length) this.mapWasInit = true;

            return convertedData;
        },
        onBounds() {
            this.mapWasInit = true;
        }
    }
};
</script>

<style lang="sass" scoped>
.map-heat
    top: 0
    left: 0
    width: 100%
    height: 100%
    &-wrap
        top: 0
        left: 0
        width: 100%
        height: inherit
</style>
