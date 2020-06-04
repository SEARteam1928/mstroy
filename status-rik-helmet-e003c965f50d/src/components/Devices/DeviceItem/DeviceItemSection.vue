<template>
    <div class="DeviceItem-section" ref="section">
        <div class="DeviceItem-sectionHeader">
            <div v-if="mobileMode" class="DeviceItem-sectionTitle">{{ title }}</div>
            <div v-if="hasData" class="DeviceItem-sectionValue">{{ lastLevel }}</div>
        </div>

        <ChartJsMicroLine
            v-if="shownChart"
            class="DeviceItem-sectionChart"
            fill
            tooltip
            cursor
            :data="data"
            :unit="unit"
            :padding="[0, 3, 3, 3]"
            :color="chartColor"
        />

        <div v-if="!hasData" class="DeviceItem-noData">
            {{ noDataTitle }}
        </div>
    </div>
</template>

<script>
import ChartJsMicroLine from '@components/common/chartjs/ChartJsMicroLine.vue';

import withState from './withState';

import { mapGetters } from 'vuex';

export default {
    name: 'DeviceItemSection',
    mixins: [withState()],
    components: {
        ChartJsMicroLine
    },
    props: {
        title: {
            type: String,
            required: true
        },
        noDataTitle: {
            type: String,
            required: false,
            default: 'Нет данных'
        },
        data: {
            type: Array,
            required: true
        },
        unit: {
            type: String,
            required: false,
            default: ''
        }
    },
    computed: {
        ...mapGetters('Devices', ['mobileMode']),

        shownChart() {
            return this.hasData && !this.mobileMode;
        },

        hasData() {
            return this.data.length > 0;
        },
        lastLevel() {
            return this.data[this.data.length - 1].value + this.unit;
        },
        chartColor() {
            let color = this.state.color;

            if (!this.colorizeNormal && this.state.name === 'normal') {
                color = '#5499e0';
            }

            return color;
        }
    }
};
</script>

<style lang="sass">
.DeviceItem
    &-section
        width: 124px
        &-sectionChart
            z-index: 100
</style>
