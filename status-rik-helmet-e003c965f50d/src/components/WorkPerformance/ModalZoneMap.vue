<template>
    <l-map class="ObjectMap-map" :maxZoom="mapOptions.maxZoom" ref="map">
        <l-tile-layer v-if="mapWasInit" :url="mapOptions.url" :attribution="mapOptions.attribution" />
        <WorkZonesObjects @bounds="onBounds" ref="WorkZonesObjects" />
    </l-map>
</template>

<script>
// leaflet
import { LMap, LTileLayer } from 'vue2-leaflet';
import 'leaflet/dist/leaflet.css';

import WorkZonesObjects from '../common/WorkZonesObjects.vue';

import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'ModalZoneMap',
    components: {
        LMap,
        LTileLayer,
        WorkZonesObjects
    },
    data() {
        return {
            mapOptions: {
                url: 'https://{s}.tile.osm.org/{z}/{x}/{y}.png',
                maxZoom: 18,
                attribution: ''
            },
            mapWasInit: false
        };
    },
    computed: {
        ...mapGetters('WorkPerformance', ['selectedZoneId'])
    },
    created() {
        this.setPopups(true);
        this.setShow(this.selectedZoneId);
    },
    beforeDestroy() {
        this.clearShow();
        this.setPopups(false);
    },
    methods: {
        ...mapMutations('WorkZonesObjects', ['setPopups', 'setShow', 'clearShow']),

        onBounds(bounds) {
            this.mapWasInit = true;

            if (this.$refs.WorkZonesObjects) {
                let zone = this.$refs.WorkZonesObjects.getZoneByObjectId(this.selectedZoneId);
                if (zone) {
                    bounds = L.latLngBounds(zone.zone);
                }

                this.$refs.map && this.$refs.map.fitBounds(bounds);
            }
        }
    }
};
</script>

<style></style>
