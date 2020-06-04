<template>
    <div style="display: none;">
        <l-control
            v-if="ready"
            position="topright"
            class="leaflet-control leaflet-control-layers leaflet-control-layers-expanded track-play-back-showtrack"
            style="user-select: none;"
        >
            <section class="leaflet-control-layers-list">
                <label>
                    <input type="checkbox" class="leaflet-control-layers-selector" v-model="showTracks" />
                    <span> Пройденный путь</span>
                </label>
            </section>

            <section class="leaflet-control-layers-list">
                <label>
                    <input type="checkbox" class="leaflet-control-layers-selector" v-model="activityTrack" />
                    <span> Активность</span>
                </label>
            </section>
        </l-control>

        <TrackPlayBackLayer
            v-if="ready && activityTrack"
            ref="TrackPlayBackLayer"
            :startTime="startTime"
            :endTime="endTime"
            :speed="speed"
            :tracks="tracks"
            :latLngs="latLngs"
            :passedPoints="passedPoints"
            :deviceCoordinates="deviceCoordinates"
            :isPlaying="_isPlaying"
            :selectedTrack="selectedTrack"
            :trackPoints="trackPoints"
            :map="_map"
        />

        <l-control
            position="bottomleft"
            ref="controller"
            style="width: 100%;"
            @isMounted="onReadyController"
            @selectedTrack="onSelectedTrack"
            @setCursor="onSetCursor"
            @tock="onTock"
            @play="onPlay"
            @slow="onSlow"
            @quick="onQuick"
        >
            <slot
                v-if="ready"
                name="controller"
                :startTime="startTime"
                :endTime="endTime"
                :speed="speed"
                :tracks="tracks"
                :deviceCoordinates="deviceCoordinates"
                :isPlaying="_isPlaying"
                :map="_map"
            ></slot>
        </l-control>
    </div>
</template>

<script>
import L from 'leaflet';
import { findRealParent, propsBinder, LControl } from 'vue2-leaflet';

import 'leaflet-plugin-trackplayback';

import TrackPlayBackLayer from './TrackPlayBackLayer.vue';

const props = {
    clockOptions: {
        type: Object,
        required: false,
        default: () => ({})
    },
    targetOptions: {
        type: Object,
        required: false,
        default: () => ({})
    },
    trackLineOptions: {
        type: Object,
        required: false,
        default: () => ({})
    },
    trackPointOptions: {
        type: Object,
        required: false,
        default: () => ({})
    },
    fitBounds: {
        type: Boolean,
        required: false,
        default: false
    },
    isOrigin: {
        type: Boolean,
        required: false,
        default: false
    },
    latLngs: {
        type: Array,
        required: true,
        custom: true
    },
    deviceCoordinates: {
        type: Array,
        required: false
    }
};

export default {
    name: 'TrackPlayBack',
    components: {
        LControl,
        TrackPlayBackLayer
    },
    props,
    data() {
        return {
            trackplayback: null,
            passedPoints: [],
            selectedTrack: undefined,
            _map: null,
            ready: false,
            latestPosition: {
                isOrigin: [],
                notOrigin: []
            },
            tracks: [],
            showTracks: true,
            activityTrack: true
        };
    },
    created() {
        window.TrackPlayBack = this;
    },
    mounted() {
        this.init();
    },
    beforeDestroy() {
        L.DomEvent.off(this.trackplayback, {
            ...this.$listeners,
            'tick': this.onTickHandler
        });

        this.remove();
    },
    computed: {
        startTime() {
            return this.trackplayback.getStartTime() * 1000;
        },
        endTime() {
            return this.trackplayback.getEndTime() * 1000;
        },
        speed() {
            return this.trackplayback.getSpeed();
        },
        trackPoints() {
            return this.trackplayback.tracks;
        },
        _isPlaying() {
            return this.trackplayback && this.trackplayback.clock._isPlaying;
        },
        _isOrigin() {
            return this.isOrigin ? 'isOrigin' : 'notOrigin';
        }
    },
    watch: {
        // При изменении состояния плагина play/stop вызывает соответствующие события
        _isPlaying(newIsPlaying, oldIsPlaying) {
            if (newIsPlaying && !oldIsPlaying) {
                this.emit('isPlay');
            } else if (!newIsPlaying && oldIsPlaying) {
                this.emit('isStop');
            }
        },
        showTracks(isShow) {
            this.onShowTracks(isShow);
        },
        activityTrack(isShow) {
            // Если выключается тепловой трек, но показывается пройденный путь - рисуем простые линии пути
            if(!isShow && this.showTracks) {
                this.showTrackLine();

                // Если включается тепловой трек, и показывается пройденный путь - убираем простые линии
            } else if(isShow && this.showTracks) {
                this.hideTrackLine();
            }
        }
    },
    methods: {
        // Дублирует события на этом компоненте и на контроллере
        emit(name, data) {
            this.$emit(name, data);
            this.$refs.controller.$emit(name, data);
            this.$refs.TrackPlayBackLayer && this.$refs.TrackPlayBackLayer.$emit(name, data);
        },
        tick() {
            // Установка курсора генерирует tick
            this.trackplayback.setCursor(this.trackplayback.getCurTime());
        },
        onSelectedTrack(trackIndex) {
            this.selectedTrack = trackIndex;
        },
        onShowTracks(isShow) {
            if (isShow) {
                // Показывать простые линии пройденного пути только если тепловой трек выключен
                !this.activityTrack && this.showTrackLine();
                this.showTrackPoint();
            } else {
                this.hideTrackLine();
                this.hideTrackPoint();
            }
        },
        onPlay() {
            if (this._isPlaying) {
                this.stop();
            } else if (!this._isPlaying && this.getCurTime() >= this.getEndTime()) {
                this.rePlaying();
            } else {
                this.start();
            }
        },
        onSlow() {
            this.slowSpeed();
        },
        onQuick() {
            this.quickSpeed();
        },
        // Обработчик события изменения времени от контроллера
        onSetCursor(time) {
            if (!time) return;

            if (time > this.endTime) {
                this.trackplayback.setCursor(this.endTime / 1000);
            } else if (time < this.startTime) {
                this.trackplayback.setCursor(this.startTime / 1000);
            } else {
                this.trackplayback.setCursor(time / 1000);
            }
        },
        // Когда контроллер готов, делает tick для того, чтобы он получил начальную информацию о состоянии
        onReadyController() {
            this.tick();
        },
        // В ответ на tock от контроллера посылает tick
        onTock() {
            this.tick();
        },
        // Перехватывает tick от плагина, добавляет в объект события текущие lat и lng и генерирует свой tick
        onTickHandler(e) {
            // Получаем буфер отрисованных точек
            let bufferTracks = e.target.clock._trackController._draw._bufferTracks;
            // Обнуляем прошлые точки
            this.latestPosition = {
                isOrigin: [],
                notOrigin: []
            };

            let passedPoints = this.getPassedPoints(true);
            if (this.diffPoints(passedPoints, this.passedPoints)) {
                this.passedPoints = passedPoints;
            }

            e.latestPoint = [];

            // Для нескольких воспроизводимых треков нужен цикл
            bufferTracks.forEach((bufferTrack, index) => {
                let latestPoint = bufferTracks[index][bufferTrack.length - 1];
                e.latestPoint[index] = latestPoint;
                // Последняя отрисованная точка может быть не из оригинального массива данных,
                // а промежуточно рассчитанная для текущего положения маркера
                // Добавляем ее сразу в массив, который может содержать и оригинальные и не оригинальные точки
                this.latestPosition.notOrigin.push({
                    ...latestPoint,
                    time: latestPoint.time * 1000
                });

                // Если точка была не оригинальной, то берем предыдущую.
                // Только последняя точка может быть не оригинальной
                if (!latestPoint['isOrigin'] && bufferTrack.length > 1) {
                    latestPoint = bufferTracks[index][bufferTrack.length - 2];
                }

                // Добавляем точку в массив, который может содержать только точки,
                // присутствующие в оригинальном массиве данных
                this.latestPosition.isOrigin.push({
                    ...latestPoint,
                    time: latestPoint.time * 1000
                });
            });

            // Добавляем к событию тика массив с текущими координатами всех треков на момент тика
            e.latLngs = this.getCurrentLatLng();
            // Плеер работает с временем в секундах, отдавая время наружу из этого компонента,
            // будем приводить его к миллисекундам
            e.time = e.time * 1000;

            // Генерируем событие тика с подправленным объектом события
            this.emit('tick', e);

            if (e.time >= this.endTime) {
                this.trackplayback.clock._isPlaying = false;
            }
        },
        // В плагине флагом, определяющим состояние play/stop, служит _intervalID,
        // который содержит либо id интервала для анимации, либо null.
        // При этом, computed и watch, отслеживающие изменения состояния,
        // будут при каждом тике сообщать о состоянии play, а не только при изменении стояния с play на stop
        // Чтобы этого избежать надо поправить в прототипе clock то, как отмечается состояние
        patch(trackplayback) {
            trackplayback.clock._isPlaying = false;
            trackplayback.clock.start = function() {
                this.__proto__.start.call(this);
                this._isPlaying = true;
            };

            trackplayback.clock.stop = function() {
                this.__proto__.stop.call(this);
                this._isPlaying = false;
            };

            trackplayback.clock.isPlaying = function() {
                return this._isPlaying ? true : false;
            };

            return trackplayback;
        },
        diffPoints(newPassedPoints, oldPassedPoints) {
            let difference = false;
            for (let i = 0; i < newPassedPoints.length; i++) {
                if (!oldPassedPoints[i] || oldPassedPoints[i].length !== newPassedPoints[i].length) {
                    difference = true;
                    break;
                }
            }

            return difference;
        },
        init() {
            if (!this.latLngs.length) {
                this.ready = false;
                this.remove();
                return;
            }

            this.tracks = [];

            // Собираем опции из props, предназначенные для плагина
            const { clockOptions, targetOptions, trackLineOptions, trackPointOptions } = this;
            const options = {
                clockOptions,
                targetOptions,
                trackLineOptions,
                trackPointOptions
            };

            try {
                // Получаем компонент и сам инстанс карты
                this.parentContainer = findRealParent(this.$parent);
                this._map = this.parentContainer.mapObject;

                // Создаем инстанс плагина и его контроллера
                let trackplayback = L.trackplayback(this.latLngs, this._map, options);
                this.trackplayback = this.patch(trackplayback);
                propsBinder(this, this.trackplayback, props);

                this.onShowTracks(this.showTracks);

                // Делаем первый tick, чтобы метка появилась на карте
                this.tick();

                // Пробрасываем обработчики событий, tick заменяем на свой
                L.DomEvent.on(this.trackplayback, {
                    ...this.$listeners,
                    'tick': this.onTickHandler
                });

                // Если в props есть параметр для фокусирования карты на области, охватывающей все точки треков
                if (this.fitBounds) this.setFitBounds(true);

                // Получаем массив объектов краткой информации о треках
                this.tracks = this.getTracks();

                this.ready = true;

                this.$emit('mounted');
            } catch (err) {
                console.error('TrackPlayBack init failed: ', err);
            }
        },

        setLatLngs(newLatLngs, oldLatLngs) {
            this.remove();
            this.init();
        },
        getController() {
            return this.$refs.controller.$children[0];
        },
        // Собирает краткую информацию о треках:
        // Время начала и конца трека, id(index) и content(имя)
        getTracks() {
            return this.trackplayback.tracks.map((track, index) => {
                // _timeTick - объект, где временные штампы являются ключами,
                // простым способом не получится взять время начала и конца трека
                let { _timeTick, _trackPoints } = track;
                let start = Infinity;
                let end = -Infinity;
                for (let time in _timeTick) {
                    let num = Number(time);
                    if (num < start) start = num;
                    if (num > end) end = num;
                }

                start *= 1000;
                end *= 1000;

                let content = _trackPoints[0].info[0].value;
                let id = index;

                return { id, content, start, end };
            });
        },
        getBounds() {
            return L.latLngBounds(this.latLngs);
        },
        setFitBounds(newVal, oldVal) {
            if (newVal === oldVal) return;
            if (newVal) {
                this._map.fitBounds(this.getBounds());
            }
        },
        remove() {
            // this.ready = false;
            try {
                this.trackplayback.dispose();
                this.trackplayback = null;
            } catch (err) {}
        },
        getCurrentPoint(isOrigin = this.isOrigin) {
            return this.latestPosition[this._isOrigin];
        },
        getCurrentLatLng(isOrigin = this.isOrigin) {
            let points = this.getCurrentPoint(isOrigin);
            let latLngs = points.map(point => {
                return {
                    lat: point.lat,
                    lng: point.lng
                };
            });

            return latLngs;
        },
        // Возвращает массив уже пройденных точек точек
        getPassedPoints(isOrigin = this.isOrigin) {
            let bufferTracks = this.trackplayback.draw._bufferTracks;

            let passedPoints = bufferTracks.map(track => {
                if (isOrigin && track.length > 1) {
                    let result;
                    let lastIndex = track.length - 1;
                    let lastPoint = track[lastIndex];
                    if (!lastPoint.isOrigin) {
                        result = track.slice(0, -1);
                    } else {
                        result = track;
                    }

                    return result;
                } else {
                    return track;
                }
            });

            return passedPoints;
        },
        getTracksPoint() {
            return this.trackplayback.tracks;
        },

        // Родные методы плагина
        start() {
            return this.trackplayback.start();
        },
        stop() {
            return this.trackplayback.stop();
        },
        rePlaying() {
            return this.trackplayback.rePlaying();
        },
        slowSpeed() {
            return this.trackplayback.slowSpeed();
        },
        quickSpeed() {
            return this.trackplayback.quickSpeed();
        },
        getSpeed() {
            return this.trackplayback.getSpeed();
        },
        getCurTime() {
            return this.trackplayback.getCurTime();
        },
        getStartTime() {
            return this.trackplayback.getStartTime();
        },
        getEndTime() {
            return this.trackplayback.getEndTime();
        },
        isPlaying() {
            return this.trackplayback.isPlaying();
        },
        setCursor(time) {
            return this.trackplayback.setCursor(time);
        },
        setSpeed(speed) {
            return this.trackplayback.setSpeed(speed);
        },
        showTrackPoint() {
            return this.trackplayback.showTrackPoint();
        },
        hideTrackPoint() {
            return this.trackplayback.hideTrackPoint();
        },
        showTrackLine() {
            return this.trackplayback.showTrackLine();
        },
        hideTrackLine() {
            return this.trackplayback.hideTrackLine();
        },
        dispose() {
            return this.trackplayback.dispose();
        }
    }
};
</script>
