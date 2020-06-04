<template>
    <div style="display: none;">
        <slot v-if="ready"></slot>

        <l-control
            position="topright"
            ref="control"
            class="leaflet-control leaflet-control-layers geoman-controls"
            style="user-select: none;"
        >
            <q-expansion-item
                group="controls"
                v-model="expansionControls.AddObject"
                label="Добавить новый объект"
                header-class="geoman-controls-expansion-header"
            >
                <AddObject ref="AddObject" @add="onAddObject" />
            </q-expansion-item>

            <q-separator />

            <q-expansion-item
                group="controls"
                v-model="expansionControls.EditObject"
                label="Редактировать объект"
                header-class="geoman-controls-expansion-header"
            >
                <EditObject
                    ref="EditObject"
                    :object="selectedObject"
                    :layer="selectedLayer"
                    @apply="onEditApply"
                    @cancel="onEditCancel"
                    @delete="onEditDelete"
                />
            </q-expansion-item>
        </l-control>
    </div>
</template>

<script>
import L from 'leaflet';
import { LPolygon, LControl, findRealParent, propsBinder } from 'vue2-leaflet';

import Api from '../../services/api';

// geoman
import '@geoman-io/leaflet-geoman-free';
import '@geoman-io/leaflet-geoman-free/dist/leaflet-geoman.css';

import AddObject from './AddObject.vue';
import EditObject from './EditObject.vue';

const props = {
    zones: {
        type: Array,
        required: true,
        custom: true
    },
    lang: {
        type: String,
        required: false,
        default: 'ru'
    },
    visible: {
        type: Boolean,
        custom: true,
        default: true
    }
};

export default {
    name: 'GeoMan',
    props,
    components: {
        LControl,
        LPolygon,
        AddObject,
        EditObject
    },
    data() {
        return {
            ready: false,
            geoManControlOptions: {
                position: 'topleft',
                drawMarker: false,
                drawCircleMarker: true
            },
            expansionControls: {
                AddObject: true,
                EditObject: false
            },
            workZones: [],
            parentContainer: null,
            _map: null,
            pm: null,
            wasInitControls: false,
            latLngs: [],
            mapObjects: [],
            selectedLayer: undefined,
            objectIdMap: {},
            objectIndexMap: {},
            layerIdMap: {}
        };
    },
    computed: {
        selectedObject() {
            if (!this.selectedLayer) return;

            let layerId = this.selectedLayer._leaflet_id;
            let objectId = this.layerIdMap[layerId];
            let objectIndex = this.objectIndexMap[objectId];

            return this.zones[objectIndex];
        }
    },
    created() {
        window.GeoMan = this;
    },
    mounted() {
        this.$nextTick(() => {
            if (this.$refs.control.$el) {
                L.DomEvent.on(this.$refs.control.$el, 'mousewheel wheel scroll click', L.DomEvent.stopPropagation);
            }
        });

        this.parentContainer = findRealParent(this.$parent);
        this._map = this.parentContainer.mapObject;

        // GeoMan активируется автоматически при импорте его скрипта, встраивает свой класс в L.PM
        // А свои инстансы добавляет в объект карты и слои с фигурами на карте
        this.pm = this._map.pm;
        propsBinder(this, this.pm, props);

        // Для инициализации вручную запустим процесс вывода фигур на карту
        this.setZones(this.zones);

        // Установка русского языка
        this.pm.setLang(this.lang);

        // Подписка на события
        this._map.on('pm:create', this.onPmCreated, this);
        this._map.on('pm:cut', this.onPmCut, this);
        this._map.on('pm:remove', this.onPmRemove, this);
        this._map.on('click', this.onMapClick, this);

        this.ready = true;
    },
    beforeDestroy() {
        this.removeAllObjects();

        // Отписка от событий на карте
        this._map.off('pm:create', this.onPmCreated, this);
        this._map.off('pm:cut', this.onPmCut, this);
        this._map.off('pm:remove', this.onPmRemove, this);
        this._map.off('click', this.onMapClick, this);
    },
    methods: {
        async onEditApply(objectData) {
            try {
                let res = await Api.addObject(objectData);
                // this.clearSelectedLayer();

                this.$emit('refresh');

                this.$refs.EditObject.success();
                this.$q.notify({
                    icon: 'done',
                    color: 'positive',
                    message: `Объект изменен: ${objectData.name}`
                });
            } catch (err) {
                console.log('Ошибка изменения объекта: ', err);

                this.$refs.EditObject.error();
                this.$q.notify({
                    icon: 'close',
                    color: 'btn_red',
                    message: `Ошибка изменения объекта: ${objectData.name}`
                });
            }
        },
        onEditCancel() {
            this.clearSelectedLayer();
            this.redraw();
        },
        async onEditDelete(e) {
            console.log('onEditDelete: ', e);

            let resDelete = await this.onPmRemove(e);
            console.log('resDelete: ', resDelete);

            if (resDelete) {
                this.$refs.EditObject.success();
                let layerId = e.layer._leaflet_id;
                let objectId = this.layerIdMap[layerId];
                this.$emit('delete', objectId);
            } else {
                this.$refs.EditObject.error();
            }
        },
        // Обработчик события добавления объекта от формы AddObject
        async onAddObject(objectData) {
            // console.log('onAddObject(objectData): ', objectData);

            try {
                let res = await Api.addObject(objectData);

                this.$emit('refresh');

                this.$refs.AddObject.success();
                this.$q.notify({
                    icon: 'done',
                    color: 'positive',
                    message: `Объект добавлен: ${objectData.name}`
                });
            } catch (err) {
                console.log('Ошибка добавления объекта: ', err);
                this.$refs.AddObject.error();
                this.$q.notify({
                    icon: 'close',
                    color: 'btn_red',
                    message: `Ошибка добавления объекта: ${objectData.name}`
                });
            }
        },
        onPmDrawstart(e) {
            console.log('onPmDrawstart: ', e);
        },
        onPmDrawend(e) {
            console.log('onPmDrawend: ', e);
        },
        onPmCreated(e) {
            console.log('onPmCreated: ', e);

            this.clearSelectedLayer();
            e.layer.pm.enable();
            this.selectedLayer = e.layer;

            this.expansionControls.EditObject = true;

            // После добавления фигуры снова соберем все
            this.mapObjects = this.findLayers();
        },
        // Этот обработчик срабатывает на любые изменения фигуры:
        // добавление точки, удаление точки, перемещение точки, перемещение всей фигуры целиком
        onPmEdit(e) {
            console.log('onPmEdit: ', e);
        },
        // Обработчик на событие отрезания части от фигуры. С ним не так все просто,
        // потому что после отрезания создается новый слой, надо наблюдать
        onPmCut(e) {
            console.log('onPmCut: ', e);
        },
        async onPmRemove(e) {
            console.log('onPmRemove: ', e);

            let layerId = e.layer._leaflet_id;
            let objectId = this.layerIdMap[layerId];
            let objectIndex = this.objectIndexMap[objectId];
            if (!objectIndex) return;

            let objectName = this.zones[objectIndex].name;

            try {
                let res = await Api.deleteObject(objectId);

                if (e.layer) this._map.removeLayer(e.layer);

                this.$q.notify({
                    icon: 'done',
                    color: 'positive',
                    message: `Объект удален: ${objectName}`
                });

                return true;
            } catch (err) {
                console.log(`Ошибка удаления объекта ${objectName}: `, err);

                this.$q.notify({
                    icon: 'close',
                    color: 'btn_red',
                    message: `Ошибка удаления объекта: ${objectName}`
                });

                return false;
            }
        },
        // Обработчик клика на фигуру
        onObjectClick({ target }) {
            let enabled = target.pm.enabled();
            let dragging = this.pm._globalDragMode;
            let removal = this.pm._globalRemovalMode;

            if (enabled) {
                this.clearSelectedLayer();

                // Включим редактирование фигуры только если не активированы
                // глобальные режимы перемещения или удаления
            } else if (!enabled && !dragging && !removal) {
                this.clearSelectedLayer();

                target.pm.enable();
                this.selectedLayer = target;

                this.expansionControls.EditObject = true;
            }
        },
        onMapClick(e) {
            // console.log('onMapClick: ', e);
            // FIXME: По клику на пустой области карты нужно сбрасывать выбранный объект
            // Пока этого делать не нужно, при любом клике вне формы будет сбрасываться прогресс редактирования
            // Нужно придумать как это разрешить, возможно алерт показывать с запросом подтверждения
            // this.clearSelectedLayer();
        },
        clearSelectedLayer() {
            if (!this.selectedLayer) return;

            this.selectedLayer.pm.disable();
            this.selectedLayer = undefined;
        },
        // Получает границы, охватывающие все фигуры на карте
        getBounds() {
            return new L.LatLngBounds(this.latLngs);
        },
        // Установка фигур для отрисовки на карте
        setZones(newZones) {
            if (!newZones.length) return;

            this.clearSelectedLayer();
            this.removeAllObjects();

            newZones.forEach(({ name, color, object_id, zone, radius }, index) => {
                this.latLngs.push(zone);
                let mapObject;
                let options = { color };
                if (radius) options.radius = radius;

                // От количества координат в объекте будем рисовать разные фигуры
                switch (zone.length) {
                    case 0:
                        return;
                        break;
                    case 1:
                        mapObject = L.circle(zone[0], options);
                        break;
                    case 2:
                        mapObject = L.polyline(zone, options);
                        break;
                    default:
                        mapObject = L.polygon(zone, options);
                        break;
                }

                // Привязываем к фигуре всплывающую подсказку и выводим на карту
                let layer = mapObject.bindTooltip(name).addTo(this._map);
                if(name === 'Строительная площадка') {
                    mapObject.bringToBack()
                }

                this.objectIdMap[object_id] = layer._leaflet_id;
                this.layerIdMap[layer._leaflet_id] = object_id;
                this.objectIndexMap[object_id] = index;
            });

            if (this.zones.length) {
                // После любых добавлений фигур надо собирать их массив,
                // нужно будет для удаления их с карты при обновлении
                this.mapObjects = this.findLayers();

                // Фокусируем карту на области, охватывающей все фигуры
                this.bounds = this.getBounds();
                this._map.fitBounds(this.bounds);

                if (!this.wasInitControls) {
                    this.wasInitControls = true;

                    // Вывод контролов на карту. Контролы не обязательны, все можно активировать программно
                    this.pm.addControls(this.geoManControlOptions);
                }
            }
        },
        redraw() {
            this.setZones(this.zones);
        },
        findLayers() {
            let mapObjects = this.pm.findLayers();

            mapObjects.forEach(object => {
                L.DomEvent.off(object, 'click', L.DomEvent.stopPropagation);
                L.DomEvent.on(object, 'click', L.DomEvent.stopPropagation);

                object.off('click', this.onObjectClick, this);
                object.on('click', this.onObjectClick, this);

                // По клику на фигуру будем вкл/выкл ее редактирование
                object.off('pm:edit', this.onPmEdit, this);
                object.on('pm:edit', this.onPmEdit, this);
            });

            return mapObjects;
        },
        removeAllObjects() {
            this.mapObjects.forEach(object => object.remove());

            this.mapObjects = [];
            this.objectIdMap = {};
            this.layerIdMap = {};
            this.objectIndexMap = {};
        },
        setVisible(newVal, oldVal) {
            if (newVal === oldVal) return;
            if (newVal) {
                this.mapObjects.forEach(object => this._map.addLayer(object));
            } else {
                this.mapObjects.forEach(object => this._map.removeLayer(object));
            }
        }
    }
};
</script>

<style lang="sass">
.geoman
    &-controls
        width: 330px
        &-expansion
            &-header
                font-size: 16px
                padding: 10px 15px
</style>
