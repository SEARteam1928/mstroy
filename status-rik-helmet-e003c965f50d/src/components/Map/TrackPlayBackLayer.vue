<template>
    <div>
        <HotLine
            v-for="(track, index) in passedPoints"
            :key="index"
            ref="hotLine"
            :latLngs="passedPoints[index]"
            :min="hotLineOptions.min"
            :max="hotLineOptions.max"
            :palette="hotLineOptions.palette"
            :weight="hotLineOptions.weight"
            :visible="selectedTrack === undefined || selectedTrack === index"
        />
    </div>
</template>

<script>
// leaflet
import { Map } from 'leaflet';

import { byPercent, toPercent } from '../../services/utils';

import HotLine from './HotLine.vue';

const props = {
    tracks: {
        type: Array,
        required: true,
        default: () => [],
        custom: true
    },
    startTime: {
        type: Number,
        required: true,
        custom: true
    },
    endTime: {
        type: Number,
        required: true,
        custom: true
    },
    speed: {
        type: Number,
        required: true,
        custom: true
    },
    isPlaying: {
        type: Boolean,
        required: false,
        default: false,
        custom: true
    },
    latLngs: {
        type: Array,
        required: false,
        custom: true
    },
    passedPoints: {
        type: Array,
        required: true,
        custom: true
    },
    deviceCoordinates: {
        type: Array,
        required: false,
        custom: true
    },
    selectedTrack: {
        type: [Number, undefined],
        required: false,
        default: undefined
    },
    trackPoints: {
        type: Array,
        required: false,
        default: []
    },
    map: {
        type: Map,
        required: false,
        custom: true
    }
};

export default {
    name: 'TrackPlayBackLayer',
    components: {
        HotLine
    },
    props,
    data() {
        return {
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
            // Хранит следующую реальную точку для каждого трека
            nextPoints: [],
            // Хранит разницу времени и активности между последней реальной пройденной точкой
            // и следующей реальной точкой для каждого трека
            difference: [],
            // Хранит время последней добавленной рассчитанной точки для каждого трека
            lastTimeDiff: [],
            // Минимальное время(сек), через которое можно добавить следующую рассчитанную точку к тепловому треку
            throttleSec: 10
        };
    },
    watch: {
        // Срабатывает когда TrackPlayBack помечает реальную точку пройденной
        // newPassedPoints - массив пройденных точек для каждого трека
        passedPoints(newPassedPoints) {
            // Обнуляем все данные, участвующие в расчете промежуточных значений активности
            this.nextPoints = [];
            this.difference = [];
            this.lastTimeDiff = [];

            newPassedPoints.forEach((track, index) => {
                // Находим следующую реальную точку за той, что сейчас отметилась как пройденная
                this.nextPoints[index] = this.trackPoints[index]._trackPoints[track.length];

                let passPoint = track[track.length - 1];
                let nextPoint = this.nextPoints[index];

                // Вычисляем разницу времени и активности между последней реальной пройденной точкой и следующей
                this.difference[index] = {
                    time: nextPoint.time - passPoint.time,
                    alt: nextPoint.alt - passPoint.alt
                };

                // Обнуляем время последнего добавления точки к тепловому треку
                this.lastTimeDiff[index] = 0;
            });
        }
    },
    created() {
        window.TrackPlayBackLayer = this;

        // TrackPlayBack будет эмитить tick на этот компонент
        this.$on('tick', this.onTick);
    },
    methods: {
        onTick(e) {
            // В latestPoint текущие на момент тика координаты и время маркера
            let { latestPoint } = e;

            // Цикл именно по passedPoints потому что компоненты HotLine отрисовываются тоже о нему
            this.passedPoints.forEach((track, index) => {
                let passPoint = track[track.length - 1];
                let nextPoint = this.nextPoints[index];
                if (!passPoint || !nextPoint) return;

                // Получаем текущую на момент тика разницу между
                // временем последней реальной пройденной точки и текущим временем маркера
                let currentTimeDiff = Math.round(latestPoint[index].time - passPoint.time);
                // Чтобы не добавлять много очень близких точек,
                // которые будут происходить при низкой скорости воспроизведения - проверяем с учетом троттлинга
                if (currentTimeDiff <= this.lastTimeDiff[index] + this.throttleSec) return;
                this.lastTimeDiff[index] = currentTimeDiff;

                // Вычисляем процентное расположение текущего тика в пределах
                // между последней реальной пройденной точкой и следующей
                let percentBetweenPoints = toPercent(currentTimeDiff, this.difference[index].time);
                // Из разницы активности между точками и процентному расположению тика
                // получаем рассчитанное значение активности для текущей точки
                let currentAlt = Math.round(
                    passPoint.alt + byPercent(this.difference[index].alt, percentBetweenPoints)
                );

                // Без таймаута маркер на карте оказывается под тепловым треком
                setTimeout(() => {
                    // Не будем добавлять точку если нет нужного инстанса hotLine или он не отображается сейчас на карте
                    if (!this.$refs.hotLine[index] || !this.$refs.hotLine[index].visible) return;

                    this.$refs.hotLine[index].mapObject.addLatLng([
                        latestPoint[index].lat,
                        latestPoint[index].lng,
                        currentAlt
                    ]);
                }, 0);
            });
        }
    }
};
</script>
