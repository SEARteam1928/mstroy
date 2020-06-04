<template>
    <q-page class="ObjectMap-page page-background">
        <div class="ObjectMap-map-wrap page-block">
            <l-map class="ObjectMap-map" :maxZoom="mapOptions.maxZoom" ref="map">
                <l-tile-layer v-if="mapWasInit" :url="mapOptions.url" :attribution="mapOptions.attribution" />

                <WorkZonesObjects :popups="popups" @bounds="onBounds" />
            </l-map>
        </div>
    </q-page>
</template>

<script>
// leaflet
import { LMap, LTileLayer } from 'vue2-leaflet';
import 'leaflet/dist/leaflet.css';

import WorkZonesObjects from '../components/common/WorkZonesObjects.vue';

import { mapMutations } from 'vuex';

export default {
    name: 'ObjectMap',
    components: {
        LMap,
        LTileLayer,
        WorkZonesObjects
    },
    created() {
        window.ObjectMap = this;
    },
    data() {
        return {
            mapOptions: {
                url: 'https://{s}.tile.osm.org/{z}/{x}/{y}.png',
                maxZoom: 18,
                attribution: ''
            },
            mapWasInit: false,
            popups: true
        };
    },
    beforeDestroy() {
        this.clearShow();
        this.clearHighlight();
    },
    methods: {
        ...mapMutations('WorkZonesObjects', ['clearShow', 'clearHighlight']),

        onBounds(bounds) {
            this.mapWasInit = true;

            this.$refs.map && this.$refs.map.fitBounds(bounds);
        }
    }
};
</script>

<style lang="sass">
.ObjectMap
    &-page
        top: 0
        left: 0
        width: 100%
        height: 100%
        display: flex
        flex-direction: column
        flex-grow: 1
        position: relative
        .ObjectMap-map-wrap
            display: flex
            flex-grow: 1
            background-color: #dedede
            margin:
                top: 8px
                right: 8px
                bottom: 8px
                left: 8px
        .ObjectMap-map
            top: 0
            left: 0
            width: 100%
            height: inherit
</style>
