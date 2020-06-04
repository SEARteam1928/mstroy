<template>
    <div class="track-play-back-controller" :class="{ 'is-playing': isPlaying }">
        <TrackPlayBackControllerButtons
            :isPlaying="isPlaying"
            :speed="speed"
            @play="onPlayHandler"
            @slow="onSlowHandler"
            @quick="onQuickHandler"
        />

        <Timeline
            class="track-play-back-timeline"
            v-if="ready"
            :events="['timechange', 'select', 'click']"
            @timechange="onTimechangeHandler"
            @select="onSelectItemHandler"
            @click="onTimelineClickHandler"
            ref="timeline"
            :items="items"
            :options="options"
        />
    </div>
</template>

<script>
// leaflet
import { DomEvent, Map } from 'leaflet';
import { findRealParent } from 'vue2-leaflet';

// vis-timeline
import Timeline from '../common/vis/Timeline.vue';
import { DataSet, moment } from 'vis-timeline';
import 'vis-timeline/dist/vis-timeline-graph2d.min.css';

import TrackPlayBackControllerButtons from './TrackPlayBackControllerButtons.vue';

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
    deviceCoordinates: {
        type: Array,
        required: false,
        custom: true
    },
    map: {
        type: Map,
        required: false,
        custom: true
    }
};

export default {
    name: 'TrackPlayBackController',
    components: {
        TrackPlayBackControllerButtons,
        Timeline
    },
    props,
    data() {
        return {
            ready: false,
            timeline: null,
            _map: null,
            items: new DataSet([]),
            selectedItem: undefined,
            timeMask: 'HH:mm:ss'
        };
    },
    watch: {
        // При изменении треков в TrackPlayBack
        tracks(newTracks) {
            // сгенерируем новые items для таймлайна
            this.selectedItem = undefined;
            this.items = new DataSet(newTracks);
            this.timeline.setItems(this.items);

            // Установим курсор времени на начальное время из TrackPlayBack
            this.updateCustomTime();
        }
    },
    computed: {
        options() {
            let opts = {
                locale: 'ru_RU',
                width: '100%',
                margin: {
                    item: 1
                },
                // На 1% отодвигаем границы отображения таймлайна от времени трека,
                // чтобы были отступы трека от границ контейнера
                end: this.endTime + this.percent(this.endTime - this.startTime, 1),
                start: this.startTime - this.percent(this.endTime - this.startTime, 1)
            };

            return opts;
        }
    },
    created() {
        window.TrackPlayBackController = this;
        this.items = new DataSet(this.tracks);

        this.ready = true;
    },
    beforeDestroy() {
        DomEvent.off(this.timeline.$el, 'mousewheel wheel scroll', DomEvent.stopPropagation);
        this.$parent.$off('tick', this.onTick);
        this.$parent.$off('isPlay', this.onPlay);
        this.$parent.$off('isStop', this.onStop);

        this.ready = false;
    },
    mounted() {
        // Получаем инстансы карты и таймлайна
        this._map = findRealParent(this.$parent).mapObject._map;
        this.timeline = this.$refs.timeline;

        // Добавляем кастомный курсор времени на таймлайн
        this.timeline.addCustomTime(this.startTime);

        // Останавливаем всплытие событий из таймлайна, чтобы при скролле таймлайна не масштабировалась карта
        DomEvent.on(this.timeline.$el, 'mousewheel wheel scroll', DomEvent.stopPropagation);

        // Подписываемся на события от TrackPlayBack
        this.bindEvents();

        // Сообщаем TrackPlayBack о том, что контроллер готов к работе, в ответ прилетит tick от TrackPlayBack
        this.$parent.$emit('isMounted');
    },
    methods: {
        percent(total, per) {
            return (total / 100) * per;
        },
        updateCustomTime(time = this.startTime) {
            this.timeline.setCustomTime(time);

            // И добавим ему маркер с временем
            let timeTitle = moment(time).format(this.timeMask);
            this.timeline.setCustomTimeMarker(timeTitle);
        },
        bindEvents() {
            this.$parent.$on('tick', this.onTick);
            this.$parent.$on('isPlay', this.onPlay);
            this.$parent.$on('isStop', this.onStop);
        },
        // Обработчик ручного изменения времени курсора на таймлайне
        onTimechangeHandler(e) {
            this.$parent.$emit('setCursor', +e.time);
        },
        // Обработчик выбора треков на таймлайне
        onSelectItemHandler(e) {
            // Если выбран новый трек, запоминаем его
            if (this.selectedItem !== e.items[0]) {
                this.selectedItem = e.items[0];
                this.$parent.$emit('selectedTrack', this.selectedItem);

                // Если сейчас не воспроизводится трек, запрашиваем tick принудительно
                if (!this.isPlaying) {
                    this.$parent.$emit('tock');
                }

                // Если выбран тот же трек, что уже был отмеченным, снимаем с него выделение
            } else {
                this.selectedItem = undefined;
                this.timeline.setSelection([]);
                this.$parent.$emit('selectedTrack', this.selectedItem);
            }
        },
        // Обработчик клика на таймлайне
        onTimelineClickHandler(e) {
            // Если клик по оси времени, то установим время из события в TrackPlayBack
            if (e.what === 'axis') {
                this.onTimechangeHandler(e);
            }
        },
        // Обработчик события play на TrackPlayBack
        onPlay() {},
        // Обработчик события stop на TrackPlayBack
        onStop() {},
        // Обработчик тиков от TrackPlayBack
        onTick(e) {
            let { time, latLngs } = e;
            // Синхронизируем курсор времени с временем тика TrackPlayBack
            this.updateCustomTime(time);

            // Если есть выбранный трек, передвигаем карту на его координаты
            if (this.selectedItem !== undefined && latLngs[this.selectedItem]) {
                this._map.panTo(latLngs[this.selectedItem]);
            }
        },
        onPlayHandler() {
            this.$parent.$emit('play');
        },
        onSlowHandler() {
            this.$parent.$emit('slow');
        },
        onQuickHandler() {
            this.$parent.$emit('quick');
        }
    }
};
</script>

<style>
.leaflet-bottom.leaflet-left {
    width: 100%;
    margin-left: -10px;
    margin-bottom: -10px;
}

.track-play-back-controller {
    --translate-y: 12px;
    --translate-y-timeline: 10px;
    --color-button: rgb(213, 221, 246);
    --color-button-opacity: rgba(213, 221, 246, 0.6);
    --color-button-stroke: #97b0f8;
    --color-button-active: rgb(255, 247, 133);
    --color-button-active-opacity: rgba(255, 247, 133, 0.4);
    --color-button-stroke-active: #ffc200;
    --color-border: #d3d3d3;
    display: flex;
    transform: translateY(var(--translate-y));
    user-select: none;
}

@supports (backdrop-filter: blur(2px)) {
    .track-play-back-control,
    .track-play-back-timeline {
        backdrop-filter: blur(2px);
        background-color: rgba(255, 255, 255, 0.2);
    }
}

@supports not (backdrop-filter: blur(2px)) {
    .track-play-back-control,
    .track-play-back-timeline {
        background-color: rgba(255, 255, 255, 0.3);
    }
}

/* vis */
.vis-timeline {
    border: none;
    border-top: 1px solid var(--color-border);
}

.vis-itemset {
    margin-top: 2px;
}

.vis-item {
    background-color: var(--color-button-opacity);
}

.vis-item.vis-selected {
    background-color: var(--color-button-active-opacity);
}

.vis-item .vis-item-content {
    padding: 1px 5px;
    font-size: 11px;
}

.vis-custom-time {
    width: 3px;
}

.vis-timeline .vis-custom-time > div:not(.vis-custom-time-marker) {
    width: 32px !important;
    left: -16px !important;
}

.vis-timeline .vis-custom-time > .vis-custom-time-marker {
    padding: 0px 3px;
    font-size: 11px;
    bottom: 38px;
    top: unset;
}

.vis-time-axis.vis-foreground {
    transform: translateY(4px);
}

.vis-time-axis .vis-text {
    padding: 0 3px;
}
</style>
