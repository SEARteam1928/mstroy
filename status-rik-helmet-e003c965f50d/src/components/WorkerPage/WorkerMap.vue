<template>
    <div class="map-wrap">
        <l-map :zoom="zoom" :center="center" class="map" ref="map">
            <l-tile-layer :url="url" :attribution="attribution"></l-tile-layer>
            <!-- <l-marker :lat-lng="marker"></l-marker> -->
        </l-map>
    </div>
</template>

<script>
import {LMap, LTileLayer, LMarker } from 'vue2-leaflet';
import {Icon } from 'leaflet';
import "leaflet/dist/leaflet.css";

import jQuery from 'jquery';
window.jQuery = window.$ = jQuery;
import 'leaflet-play/dist/LeafletPlayback';
import geoJson from './res.json';

// this part resolve an issue where the markers would not appear
delete Icon.Default.prototype._getIconUrl;
Icon.Default.mergeOptions({
  iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),
  iconUrl: require('leaflet/dist/images/marker-icon.png'),
  shadowUrl: require('leaflet/dist/images/marker-shadow.png')
});

export default {
    name: 'WorkerMap',
    components: {
        LMap,
        LTileLayer,
        LMarker
    },
    data() {
        return {
            zoom:11,
            // center: L.latLng(47.413220, -1.219482),
            center: L.latLng(57.1609282, 65.5595994),
            url:'http://{s}.tile.osm.org/{z}/{x}/{y}.png',
            // attribution:'&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
            attribution:'',
            marker: L.latLng(57.1609282, 65.5595994),
        }
    },
    created() {
        window.wm = this;
        
    },
    mounted() {
        this.$nextTick(function() {
            this.$refs.map.mapObject._onResize();

            // Playback options
            let playbackOptions = {
                playControl: true,
                dateControl: true,
                sliderControl: true     
            };
            
            // Initialize playback
            let playback = new L.Playback(this.$refs.map.mapObject, geoJson, null, playbackOptions);
        }); 
    }
}
</script>

<style lang="sass" scoped>
.map-wrap
    position: relative

.map
    // TODO: Возможно это было проблемой на айфоне
    // position: absolute
    top: 0
    left: 0
    width: 100%
    height: 100%
</style>