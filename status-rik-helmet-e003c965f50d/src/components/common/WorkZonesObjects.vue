<template>
    <div style="display: none;">
        <slot v-if="ready"></slot>
    </div>
</template>

<script>
// leaflet
import L from 'leaflet';
import { findRealParent } from 'vue2-leaflet';
import 'leaflet/dist/leaflet.css';

import withProjectSwitch from '@mixins/withProjectSwitch';

import { mapGetters, mapMutations, mapActions } from 'vuex';

let props = {
    visible: {
        type: Boolean,
        default: true
    }
};

export default {
    name: 'WorkZonesObjects',
    mixins: [withProjectSwitch('WorkZonesObjects', false)],
    props,
    computed: {
        ...mapGetters('WorkZonesObjects', [
            'moduleErrors',
            'workZones',
            'latLngs',
            'highlight',
            'show',
            'popups',
            'tooltips',
            'constructionSiteName'
        ])
    },
    data() {
        return {
            ready: false,
            parentContainer: null,
            _map: null,
            paneObjects: null,
            panePopups: null,
            bounds: null,

            mapObjects: [],
            objectIndexMap: {},
            layerIdMap: {},

            mapPopups: [],
            notHighlightColor: '#aaa'
        };
    },
    created() {
        window.WorkZonesObjects = this;
    },
    mounted() {
        this.parentContainer = findRealParent(this.$parent);
        this._map = this.parentContainer.mapObject;

        this.paneObjects = this._map.createPane('WorkZonesObjects');
        this.paneObjects.style.zIndex = '398';

        this.panePopups = this._map.createPane('WorkZonesPopups');
        this.panePopups.style.zIndex = '399';

        // Просим хранилище загрузить информацию о рабочих зонах
        this.requestWorkZones();

        this.ready = true;
    },
    beforeDestroy() {
        // this.clearObjects();
        // this.clearObjectsCoords();
        // this.removeAllObjects();
        // this.removeAllPopups();
    },
    watch: {
        moduleErrors(newErrors, oldErrors) {
            // При разработке будут всплывать уведомления с ошибками
            if (process.env.DEV) {
                // Для нахождения свежей ошибки в объекте ошибок
                let newCopyErrors = { ...newErrors };
                Object.keys(oldErrors).forEach(err => delete newCopyErrors[err]);

                // Если ошибки нет, значит watch сработал на очистку одной из прошлых ошибок
                if (!Object.keys(newCopyErrors).length) return;

                console.log('WorkZonesObjects Error: ', newCopyErrors);
                let [type, error] = Object.entries(newCopyErrors)[0];
                this.$q.notify({
                    icon: 'close',
                    color: 'btn_red',
                    message: `[ ${type} ]: ${String(error)}`
                });
            }
        },
        // При изменении информации о рабочих зонах в хранилище, пересоздаем объекты на карте
        workZones(newZones) {
            this.updateZones(newZones);
            this.$emit('workZones', newZones);
        },
        // При изменении границ, охватывающих все объекты на карте, сообщаем об этом родителю,
        // если нужно, он сфокусирует карту так, чтобы эти границы уместились на экране
        latLngs(newLatLngs) {
            if (!newLatLngs.length) return;

            this.fitBounds(newLatLngs);

            this.$emit('latLngs', newLatLngs);
        },

        // Слежение за атрибутом highlight (чтобы не принимать его явно в пропс, иначе будет либо конфликт имен,
        // либо различающиеся имена, по которым будут задаваться нужные объекты через пропс и через хранилище)
        '$attrs.highlight': {
            handler(newHighlight, oldHighlight) {
                if (newHighlight === oldHighlight) return;

                // При изменении атрибута будем отправлять новое значение в хранилище,
                // а дальше изменение в хранилище подхватит следующий вотчер
                this.setHighlight(newHighlight);
            },
            immediate: true
        },
        highlight(newHighlight) {
            this.applyHighlight(newHighlight);
        },

        // Слежение за атрибутом show (чтобы не принимать его явно в пропс, иначе будет либо конфликт имен,
        // либо различающиеся имена, по которым будут задаваться нужные объекты через пропс и через хранилище)
        '$attrs.show': {
            handler(newShow, oldShow) {
                if (newShow === oldShow) return;

                // При изменении атрибута будем отправлять новое значение в хранилище,
                // а дальше изменение в хранилище подхватит следующий вотчер
                this.setShow(newShow);
            },
            immediate: true
        },
        show(newShow) {
            this.applyShow(newShow);
        },

        '$attrs.popups': {
            handler(newPopups, oldPopups) {
                if (newPopups === oldPopups) return;

                // При изменении атрибута будем отправлять новое значение в хранилище,
                // а дальше изменение в хранилище подхватит следующий вотчер
                this.setPopups(newPopups);
            },
            immediate: true
        },
        popups(newPopups) {
            this.$nextTick(() => this.applyPopups(newPopups));
        },

        '$attrs.tooltips': {
            handler(newTooltips, oldTooltips) {
                if (newTooltips === oldTooltips) return;

                // При изменении атрибута будем отправлять новое значение в хранилище,
                // а дальше изменение в хранилище подхватит следующий вотчер
                this.setTooltips(newTooltips);
            },
            immediate: true
        },
        tooltips(newTooltips) {
            this.applyTooltips(newTooltips);
        },

        constructionSiteName(newConstructionSiteName) {
            this.constructionSiteToBack(newConstructionSiteName);
        },

        visible(newVisible, oldVisible) {
            this.setVisible(newVisible, oldVisible);
        }
    },

    methods: {
        ...mapMutations('WorkZonesObjects', [
            'setProjectId',
            'clearObjects',
            'clearObjectsCoords',
            'setShow',
            'setHighlight',
            'setPopups',
            'setTooltips'
        ]),
        ...mapActions('WorkZonesObjects', ['requestWorkZones']),

        update() {
            this.requestWorkZones();
        },
        reset() {
            this.clearObjects();
            this.clearObjectsCoords();
            this.removeAllObjects();
            this.removeAllPopups();
        },

        // Получает границы, охватывающие все фигуры на карте
        getBounds(latLngs = this.latLngs) {
            return new L.LatLngBounds(latLngs);
        },
        // Фокусируем карту на области, охватывающей все фигуры
        fitBounds(latLngs = this.latLngs) {
            this.bounds = this.getBounds(latLngs);

            this.$emit('bounds', this.bounds);
        },
        // Очищает текущие объекты карты, соответствующие рабочим зонам и создает новые
        updateZones(newZones) {
            this.removeAllObjects();

            newZones.forEach(({ name, color, object_id, zone, radius }, index) => {
                let mapObject;
                let options = { color, radius, object_id, name, pane: this.paneObjects };

                // Если есть поле с радиусом, то будем рисовать окружность
                if (radius) mapObject = L.circle(zone[0], options);
                if (!radius) mapObject = L.polygon(zone, options);

                mapObject.bringToBack();

                // Карта: object_id -> индекс в массивах mapObjects и newZones
                this.objectIndexMap[object_id] = index;
                this.mapObjects.push(mapObject);
            });

            // Соберем массив табличек
            this.updatePopups();

            // После добавления полигонов запускаем применение отображения всплывающих подсказок,
            // если в хранилище уже лежит нужная для этого информация
            this.applyTooltips();

            // После добавления полигонов запускаем применение показа рабочих зон,
            // если в хранилище уже лежит нужная для этого информация
            this.applyShow();

            // После добавления полигонов запускаем применение выделения,
            // если в хранилище уже лежит нужная для этого информация
            this.applyHighlight();
        },
        updatePopups() {
            this.removeAllPopups();

            this.workZones.forEach(({ name, object_id, zone }) => {
                let center = L.latLngBounds(zone).getCenter();

                let popup = new L.Popup({
                    autoPan: false,
                    closeButton: false,
                    autoClose: false,
                    closeOnClick: false,
                    pane: this.panePopups,
                    object_id,
                    name
                })
                    .setLatLng(center)
                    .setContent(name);

                this.mapPopups.push(popup);
            });
        },
        removeAllPopups() {
            this.mapPopups.forEach(popup => popup.remove());
            this.mapPopups = [];
        },
        removeAllObjects() {
            this.mapObjects.forEach(object => object.remove());
            this.mapObjects = [];
        },
        setVisible(newVal, oldVal) {
            if (newVal === oldVal) return;
            if (newVal) {
                this.mapObjects.forEach(object => this._map.addLayer(object));
                this.mapPopups.forEach(popup => this._map.addLayer(popup));
            } else {
                this.mapObjects.forEach(object => this._map.removeLayer(object));
                this.mapPopups.forEach(popup => this._map.removeLayer(popup));
            }
        },
        // Отправляет объект с именем "Строительная площадка" на самый нижний уровень
        constructionSiteToBack(newConstructionSiteName = this.constructionSiteName) {
            this.mapObjects.forEach(object => {
                let { name } = object.options;
                if (name === newConstructionSiteName) {
                    object.bringToBack();
                }
            });
        },
        // Возвращает объект карты, соответствующий переданному object_id рабочей зоны
        getLayerByObjectId(object_id) {
            let result = null;
            let index = this.objectIndexMap[object_id];
            if (index !== undefined) {
                result = this.mapObjects[index];
            }

            return result;
        },
        // Возвращает объект рабочей зоны по преданному object_id рабочей зоны
        getZoneByObjectId(object_id) {
            let result = null;
            let index = this.objectIndexMap[object_id];
            if (index !== undefined) {
                result = this.workZones[index];
            }

            return result;
        },
        // Возвращает объект рабочей зоны по преданному объекту карты
        getZoneByLayer(layer) {
            let result = null;
            let { object_id } = layer.options;

            return this.getZoneByObjectId(object_id);
        },
        applyTooltips(newTooltips = this.tooltips) {
            this.mapObjects.forEach(object => {
                if (!newTooltips) {
                    object.unbindTooltip();

                    return;
                }

                let { name } = object.options;
                object.bindTooltip(name);
            });
        },
        applyShow(newShow = this.show) {
            let show = new Set(newShow);

            this.mapObjects.forEach(object => {
                let { object_id } = object.options;
                // Если массив show пустой или текущий объект есть в массиве show,
                // то выводим его на карту
                if (!show.size || show.has(object_id)) {
                    this._map.addLayer(object);

                    return;
                }

                // Если дошло до сюда, значит в show есть определенные зоны для вывода на карту,
                // но текущий объект в них не входит, значит удаляем его с карты
                this._map.removeLayer(object);
            });

            // После добавления объектов на карту в следующем тике, если нужно, добавляем к ним таблички
            // Если делать это сразу, то таблички появляются не стабильно
            this.$nextTick(() => this.applyPopups());

            // После добавления объектов на карту найдем объект с названием "Строительная площадка"
            // и отправим на самый нижний слой
            this.$nextTick(() => this.constructionSiteToBack());
        },

        applyPopups(newPopups = this.popups) {
            let show = new Set(this.show);

            this.mapPopups.forEach(popup => {
                let { object_id } = popup.options;
                // Если массив show пустой или текущий объект есть в массиве show,
                // то выводим его на карту
                if (newPopups && (!show.size || show.has(object_id))) {
                    this._map.addLayer(popup);

                    return;
                }

                // Если дошло до сюда, значит в show есть определенные зоны для вывода на карту,
                // но текущий объект в них не входит, значит удаляем его с карты
                this._map.removeLayer(popup);
            });
        },

        // Выделяет объекты рабочих зон в соответствии с информацией о выделении в хранилище
        applyHighlight(newHighlight = this.highlight) {
            let highlight = new Set(newHighlight);

            this.mapObjects.forEach(object => {
                let { object_id, color } = object.options;
                // Если массив highlight пустой или текущий объект есть в массиве highlight,
                // то даем объекту его родной цвет цвет зоны
                if (!highlight.size || highlight.has(object_id)) {
                    object.setStyle({ color });
                    object.bringToFront();

                    return;
                }

                // Если дошло до сюда, значит в highlight есть зоны для выделения,
                // но текущий объект в них не входит, значит даем ему серый цвет
                object.setStyle({ color: this.notHighlightColor });
            });
        },

        projectSwitch(newId) {
            this.reset();
            this.update();
        }
    }
};
</script>
