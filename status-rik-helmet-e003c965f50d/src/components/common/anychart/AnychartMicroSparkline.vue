<template>
    <div class="Anychart AnychartMicroSparkline" ref="anychart"></div>
</template>

<script>
// import Anychart from 'anychart';
// window.Anychart = Anychart;

// import { sparkline } from 'anychart';
// window.sparkline = sparkline;

import './anychart-core.min';
import './anychart-sparkline.min';

export default {
    name: 'AnychartMicroSparkline',
    props: {
        data: {
            type: Array,
            required: true,
            default: () => []
        }
    },
    data() {
        return {
            chart: null
        };
    },
    created() {
        window.Sparkline = this;
    },
    mounted() {
        this.chart = anychart.sparkline().data(this.data);
        this.chart.container(this.$refs.anychart);

        this.chart.draw();
    }
};
</script>

<style lang="sass">
.Anychart
    width: 100%
    height: 100%
</style>
