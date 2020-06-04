<template>
    <div class="SpiderGanttControl">
        <q-space />

        <q-item class="SpiderGanttControl-zoomControl">
            <q-item-section side>
                <q-icon v-ripple class="SpiderGanttControl-zoomOut cursor-pointer" name="zoom_out" @click="zoomDec" />
            </q-item-section>
            <q-item-section>
                <q-slider v-model="volume" :min="min" :max="max" />
            </q-item-section>
            <q-item-section side>
                <q-icon v-ripple class="SpiderGanttControl-zoomIn cursor-pointer" name="zoom_in" @click="zoomInc" />
            </q-item-section>
        </q-item>

        <q-btn
            class="SpiderGanttControl-zoomToFit"
            size="sm"
            color="primary"
            label="Подогнать масштаб"
            @click="onZoomToFitClick"
        />
    </div>
</template>

<script>
import scaleConfigs from '../common/gantt/scaleConfigs';

export default {
    name: 'SpiderGanttControl',
    data() {
        return {
            min: 0,
            max: scaleConfigs.length - 1,
            volume: 0,
            settingVolume: null,
            scaleConfigs,
            activeConfig: {}
        };
    },
    watch: {
        volume(newVolume, oldVolume) {
            if (newVolume === oldVolume || newVolume === this.settingVolume) return;

            this.settingVolume = null;

            this.$emit('zoomLevel', newVolume);

            this.activeConfig = this.scaleConfigs[newVolume];
            this.$emit('zoomConfig', this.activeConfig);
        }
    },
    methods: {
        setVolume(volume) {
            if (volume < this.min || volume > this.max) return;

            this.settingVolume = volume;
            this.volume = volume;
        },
        onZoomToFitClick() {
            this.$emit('zoomToFit');
        },
        zoomInc() {
            if (this.volume < this.max) {
                this.volume++;
            }
        },
        zoomDec() {
            if (this.volume > this.min) {
                this.volume--;
            }
        }
    }
};
</script>

<style lang="sass">
.SpiderGanttControl
    display: flex
    align-items: center
    // padding: 6px 16px
    padding: 0 16px
    &-zoomControl
        width: 250px
        min-height: 30px
        padding: 0
        margin: 0 16px
    &-zoomIn
        border-radius: 50%
        padding: 4px
        box-sizing: content-box
    &-zoomOut
        border-radius: 50%
        padding: 4px
        box-sizing: content-box
</style>
