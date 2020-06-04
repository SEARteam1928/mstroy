<template>
    <div style="display: none;">
        <slot v-if="ready"></slot>
    </div>
</template>

<script>
import L from 'leaflet';
import { findRealParent, propsBinder } from 'vue2-leaflet';
import 'leaflet.heat';

const props = {
    latLngs: {
        type: Array,
        default: () => [],
        custom: false
    },
    minOpacity: {
        type: Number,
        custom: true
    },
    maxZoom: {
        type: Number,
        custom: true
    },
    max: {
        type: Number,
        custom: true
    },
    radius: {
        type: Number,
        custom: true
    },
    blur: {
        type: Number,
        custom: true
    },
    gradient: {
        type: Object,
        custom: true
    },
    visible: {
        type: Boolean,
        custom: true,
        default: true
    },
    fitBounds: {
        type: Boolean,
        custom: true,
        default: false
    }
};

export default {
    name: 'HeatLayer',
    props,
    data() {
        return {
            ready: false
        };
    },
    mounted() {
        const options = {};
        const optionsKeys = ['minOpacity', 'maxZoom', 'max', 'radius', 'blur', 'gradient'];
        optionsKeys.forEach(key => {
            if (this[key]) options[key] = this[key];
        });

        this.mapObject = L.heatLayer(this.latLngs, options);
        L.DomEvent.on(this.mapObject, this.$listeners);
        propsBinder(this, this.mapObject, props);
        this.ready = true;
        this.parentContainer = findRealParent(this.$parent);
        this.parentContainer.addLayer(this, !this.visible);

        if (this.fitBounds) this.setFitBounds(true);
    },
    beforeDestroy() {
        this.parentContainer.removeLayer(this);
    },
    methods: {
        setMinOpacity(newVal, oldVal) {
            this.mapObject.setOptions({ min: newVal });
        },
        setMaxZoom(newVal, oldVal) {
            this.mapObject.setOptions({ maxZoom: newVal });
        },
        setMax(newVal, oldVal) {
            this.mapObject.setOptions({ max: newVal });
        },
        setRadius(newVal, oldVal) {
            this.mapObject.setOptions({ radius: newVal });
        },
        setBlur(newVal, oldVal) {
            this.mapObject.setOptions({ blur: newVal });
        },
        setGradient(newVal, oldVal) {
            this.mapObject.setOptions({ gradient: newVal });
        },
        setVisible(newVal, oldVal) {
            if (newVal === oldVal) return;
            if (newVal) {
                this.parentContainer.addLayer(this);
            } else {
                this.parentContainer.removeLayer(this);
            }
        },
        setFitBounds(newVal, oldVal) {
            if (newVal === oldVal) return;
            if (newVal) {
                let bounds = L.latLngBounds(this.latLngs);
                this.parentContainer.mapObject.fitBounds(bounds);
            }
        },

        // Родные методы
        setOptions(options) {
            this.mapObject.setOptions(options);
        },
        addLatLng(latlng) {
            this.mapObject.addLatLng(latlng);
        },
        setLatLngs(latlngs) {
            this.mapObject.setLatLngs(latlngs);
        },
        redraw() {
            this.mapObject.redraw();
        }
    }
};
</script>
