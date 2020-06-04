<template>
    <div ref="visualization"></div>
</template>

<script>
import { DataSet, DataView, Timeline } from 'vis-timeline';
import { mountVisData, translateEvent, throttle } from './utils';

export default {
    name: 'Timeline',
    props: {
        groups: {
            type: [Array, DataSet, DataView],
            default: () => []
        },
        items: {
            type: [Array, DataSet, DataView],
            default: () => []
        },
        events: {
            type: Array,
            default: () => [
                'click',
                'contextmenu',
                'currentTimeTick',
                'doubleClick',
                'drop',
                'mouseOver',
                'mouseDown',
                'mouseUp',
                'mouseMove',
                'groupDragged',
                'changed',
                'rangechange',
                'rangechanged',
                'select',
                'itemover',
                'itemout',
                'timechange',
                'timechanged'
            ]
        },
        selection: {
            type: [Array, String],
            default: () => []
        },
        options: {
            type: Object
        }
    },
    data: () => ({
        visData: {
            items: null,
            groups: null
        },
        isPatchedCustomTimes: false,

        // Методы, которые будем добавлять в прототипы
        customMethods: {
            setCustomTimeMarker: {
                method: function(updateCustomMarker, title, id, editable) {
                    let customTimes = this.customTimes.filter(component => component.options.id === id);

                    if (customTimes.length === 0) {
                        throw new Error('No custom time bar found with id '.concat(JSON.stringify(id)));
                    }

                    if (customTimes.length > 0) {
                        if (customTimes[0].bar.querySelector('.vis-custom-time-marker')) {
                            customTimes[0][updateCustomMarker].call(customTimes[0], title);
                        } else {
                            customTimes[0].setCustomMarker(title, editable);
                        }
                    }
                },
                key: Symbol('setCustomTimeMarker')
            },
            updateCustomMarker: {
                method: throttle(function(title) {
                    let marker = this.bar.querySelector('.vis-custom-time-marker');
                    let oldTitle = marker.innerHTML;
                    if (title !== oldTitle) {
                        marker.innerHTML = title;

                        let pseudoEvent = {
                            target: marker,
                            stopPropagation() {},
                            preventDefault() {}
                        };
                        this._onMarkerChange(pseudoEvent);
                        this._onMarkerChanged(pseudoEvent);
                    }
                }, 100),
                key: Symbol('updateCustomMarker')
            }
        }
    }),
    watch: {
        options: {
            deep: true,
            handler(v) {
                this.timeline.setOptions(v);
            }
        },
        selection: {
            deep: false,
            handler(v) {
                this.timeline.setSelection(v);
            }
        }
    },
    methods: {
        addCustomTime(time, id) {
            return this.timeline.addCustomTime(time, id);
        },
        destroy() {
            this.timeline.destroy();
        },
        fit() {
            this.timeline.fit();
        },
        focus(id, options) {
            this.timeline.focus(id, options);
        },
        getCurrentTime() {
            return this.timeline.getCurrentTime();
        },
        getCustomTime(id) {
            return this.timeline.getCustomTime(id);
        },
        getEventProperties(event) {
            return this.timeline.getEventProperties(event);
        },
        getItemRange() {
            return this.timeline.getItemRange();
        },
        getSelection() {
            return this.timeline.getSelection();
        },
        getVisibleItems() {
            return this.timeline.getVisibleItems();
        },
        getWindow() {
            return this.timeline.getWindow();
        },
        moveTo(time, options) {
            this.timeline.moveTo(time, options);
        },
        on(event, callback) {
            this.timeline.on(event, callback);
        },
        off(event, callback) {
            this.timeline.off(event, callback);
        },
        redraw() {
            this.timeline.redraw();
        },
        removeCustomTime(id) {
            this.timeline.removeCustomTime(id);
        },
        setCurrentTime(time) {
            this.timeline.setCurrentTime(time);
        },
        setCustomTime(time, id) {
            this.timeline.setCustomTime(time, id);

            // При установке курсора кастомного времени, один раз патчим прототип customTimes,
            // чтобы добавить возможность динамической установки контента в существующий маркер
            if (!this.isPatchedCustomTimes) {
                this.isPatchedCustomTimes = true;

                let { updateCustomMarker } = this.customMethods;
                this.timeline.customTimes[0].__proto__.constructor.prototype[updateCustomMarker.key] =
                    updateCustomMarker.method;
            }
        },
        setCustomTimeMarker(title, id, editable) {
            // Установку маркера кастомного времени будем делать через свою функцию,
            // которая позволяет обновлять контент уже существующего маркера
            let { setCustomTimeMarker } = this.customMethods;
            this.timeline[setCustomTimeMarker.key](title, id, editable);
        },
        setCustomTimeTitle(title, id) {
            this.timeline.setCustomTimeTitle(title, id);
        },
        setData(object) {
            this.timeline.setData(object);
        },
        setGroups(groups) {
            this.timeline.setGroups(groups);
        },
        setItems(items) {
            this.timeline.setItems(items);
        },
        setOptions(options) {
            this.timeline.setOptions(options);
        },
        setSelection(ids, options) {
            this.timeline.setSelection(ids, options);
        },
        setWindow(start, end, options, callback) {
            this.timeline.setWindow(start, end, options, callback);
        },
        toggleRollingMode() {
            this.timeline.toggleRollingMode();
        },
        zoomIn(percentage, options, callback) {
            this.timeline.zoomIn(percentage, options, callback);
        },
        zoomOut(percentage, options, callback) {
            this.timeline.zoomOut(percentage, options, callback);
        }
    },
    mounted() {
        const container = this.$refs.visualization;

        this.visData.items = mountVisData(this, 'items');

        if (this.groups && this.groups.length > 0) {
            this.visData.groups = mountVisData(this, 'groups');
            this.timeline = new Timeline(container, this.visData.items, this.visData.groups, this.options);
        } else {
            this.timeline = new Timeline(container, this.visData.items, this.options);
        }

        // Добавляем в инстанс таймлайна собственную функцию установки маркера кастомного времени
        let { setCustomTimeMarker, updateCustomMarker } = this.customMethods;
        this.timeline[setCustomTimeMarker.key] = setCustomTimeMarker.method.bind(this.timeline, updateCustomMarker.key);

        this.events.forEach(eventName =>
            this.timeline.on(eventName, props => this.$emit(translateEvent(eventName), props))
        );
    },
    created() {
        // This should be a Vue data property, but Vue reactivity kinda bugs Vis.
        // See here for more: https://github.com/almende/vis/issues/2524
        this.timeline = null;
    },
    beforeDestroy() {
        this.timeline.destroy();
    }
};
</script>
