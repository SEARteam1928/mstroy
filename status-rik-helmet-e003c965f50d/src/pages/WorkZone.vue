<template>
    <q-page class="workzone-page page-background">
        <div class="workzone-map-wrap page-block">
            <l-map class="workzone-map" :maxZoom="mapOptions.maxZoom" ref="map">
                <l-tile-layer v-if="zones.length" :url="mapOptions.url" :attribution="mapOptions.attribution" />

                <GeoMan :zones="zones" :lang="geoManOptions.lang" @refresh="onRefreshZones" @delete="onDeleteZone" />
            </l-map>
        </div>
    </q-page>
</template>

<script>
// leaflet
import { LMap, LTileLayer } from 'vue2-leaflet';
import 'leaflet/dist/leaflet.css';

import GeoMan from '../components/WorkZone/GeoMan.vue';

import Api from '../services/api';
import { buildObjectsCoords } from '../services/dataConverter';

export default {
    name: 'WorkZone',
    components: {
        LMap,
        LTileLayer,
        GeoMan
    },
    data() {
        return {
            ready: false,
            mapOptions: {
                url: 'https://{s}.tile.osm.org/{z}/{x}/{y}.png',
                maxZoom: 18,
                attribution: ''
            },
            geoManOptions: {
                lang: 'ru'
            },
            // TODO: пока могут пригодиться для отладки границы Тюмени
            bounds: [
                { lat: 57.279413928021704, lng: 65.94680786132814 },
                { lat: 57.049320827983976, lng: 65.24642944335939 }
            ],
            zones: []
        };
    },
    created() {
        window.WorkZone = this;

        // TODO: Для теста захардкожены полигоны
        // this.zones = [
        //     [...this.bounds],
        //     [
        //         { lat: 57.279413928021704, lng: 65.24642944335939 },
        //         { lat: 57.279413928021704, lng: 65.94680786132814 },
        //         { lat: 57.049320827983976, lng: 65.94680786132814 },
        //         { lat: 57.049320827983976, lng: 65.24642944335939 }
        //     ]
        // ];
    },
    async mounted() {
        this.onRefreshZones();

        this.ready = true;
    },
    methods: {
        getMap() {
            return this.$refs.map.mapObject;
        },
        onDeleteZone(objectId) {
            if (!this.zones) return;

            this.zones = this.zones.filter(zone => zone.object_id !== objectId);
        },
        async onRefreshZones() {
            this.zones = await this.getZones();
        },
        async getZones() {
            try {
                // TODO: вынести все это в апи, чтобы возвращались уже собранные данные
                let objectsRes = await Api.getObjects();
                let objectsCoordsRes = await Api.getObjectsCoords();
                let objectsZones = buildObjectsCoords(objectsRes.data, objectsCoordsRes.data);

                return objectsZones;
            } catch (err) {
                console.log('Ошибка получения координат объектов: ', err);

                return [];
            }
        }
    }
};
</script>

<style lang="sass">
.workzone
    &-page
        top: 0
        left: 0
        width: 100%
        height: 100%
        display: flex
        flex-direction: column
        flex-grow: 1
        position: relative
        .workzone-map-wrap
            display: flex
            flex-grow: 1
            margin:
                top: 8px
                right: 8px
                bottom: 8px
                left: 8px
        .workzone-map
            top: 0
            left: 0
            width: 100%
            height: inherit
</style>
