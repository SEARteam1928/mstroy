<template>
    <div class="edit-object">
        <q-input
            class="edit-object-field edit-object-name"
            ref="name"
            filled
            dense
            hide-bottom-space
            v-model="name"
            :disable="!layer"
            label="Название"
            :rules="[val => val.trim().length >= 1]"
        />

        <q-input
            class="edit-object-field edit-object-color"
            ref="color"
            filled
            dense
            hide-bottom-space
            v-model="color"
            :disable="!layer"
            :rules="['anyColor']"
            label="Цвет"
        >
            <template v-slot:append>
                <q-icon name="colorize" class="cursor-pointer">
                    <q-popup-proxy transition-show="scale" transition-hide="scale">
                        <q-color dense v-model="color" />
                    </q-popup-proxy>
                </q-icon>
            </template>
        </q-input>

        <q-input
            class="add-object-field add-object-coordinates"
            ref="coordinates"
            filled
            dense
            autogrow
            hide-bottom-space
            input-class="add-object-textfield"
            v-model="coordinates"
            :disable="!layer"
            label="Координаты"
            :rules="[val => val.trim().length >= 1]"
        />

        <q-input
            v-if="shape === 'Circle'"
            class="add-object-field add-object-radius"
            ref="radius"
            filled
            dense
            hide-bottom-space
            v-model="radius"
            :disable="!layer"
            label="Радиус"
            :rules="[val => val >= 1]"
        />

        <q-checkbox
            class="edit-object-field edit-object-workzone"
            dense
            v-model="is_work_area"
            label="Рабочая зона"
            color="primary"
        />

        <div class="edit-object-buttons">
            <q-btn
                class="edit-object-submit"
                outline
                color="primary"
                label="Применить"
                @click="submit"
                :loading="isLoading"
                :disable="isLoading || isDeleteLoading"
            >
                <template v-slot:loading>
                    <q-spinner-puff />
                </template>
            </q-btn>

            <q-btn
                class="edit-object-clear"
                outline
                color="warning"
                label="Отменить"
                @click="clear"
                :disable="isLoading || isDeleteLoading"
            />
        </div>

        <div class="edit-object-buttons edit-object-buttons-center">
            <q-btn
                class="edit-object-delete"
                outline
                color="negative"
                label="Удалить объект"
                @click="deleteObject"
                :loading="isDeleteLoading"
                :disable="isLoading || isDeleteLoading"
            >
                <template v-slot:loading>
                    <q-spinner-puff />
                </template>
            </q-btn>
        </div>
    </div>
</template>

<script>
import { Path } from 'leaflet';

export default {
    name: 'EditObject',
    props: {
        object: {
            type: Object,
            default: undefined
        },
        layer: {
            type: Path,
            default: undefined
        }
    },
    data() {
        return {
            name: '',
            color: '',
            radius: '',
            project_id: 1,
            is_work_area: true,
            shape: '',
            isLoading: false,
            isDeleteLoading: false
        };
    },
    computed: {
        coordinates: {
            get() {
                if (!this.layer) return '';

                return this.stringifyCoordinates(this.getCoordinates(this.layer));
            },
            set(coordString) {
                setTimeout(() => {
                    this.setCoordinates(this.parseCoordinates(coordString));
                }, 1000);
            }
        }
    },
    watch: {
        object(newObject, oldObject) {
            console.log('newObject: ', newObject);
            if (!newObject) {
                return;
            }
            let { name, color, radius, zone, is_work_area } = newObject;

            this.name = name;
            this.color = color;
            this.radius = radius;
            this.is_work_area = is_work_area;

            if (this.layer) this.shape = this.detectShape(this.layer);
        },
        layer(newLayer, oldLayer) {
            if (!newLayer) {
                this.clear();
                this.$emit('cancel');
            } else if (newLayer && !this.object) {
                this.name = '';
                this.color = newLayer.options.color || '#3388ff';
                this.radius = newLayer.getRadius ? newLayer.getRadius() : null;
                this.is_work_area = true;

                this.shape = this.detectShape(newLayer);
            }
        }
    },
    created() {
        window.EditObject = this;
    },
    methods: {
        // Метод установки состояния ошибки, вызывается родителем
        error() {
            this.isLoading = false;
            this.isDeleteLoading = false;
        },
        // Метод установки состояния успешного добавления, вызывается родителем
        success() {
            this.isLoading = false;
            this.isDeleteLoading = false;

            this.clear();
        },
        submit() {
            let nameValid = this.$refs.name.validate();
            let colorValid = this.$refs.color.validate();
            let coordinatesValid = this.$refs.coordinates.validate();
            let radiusValid = this.$refs.radius ? this.$refs.radius.validate() : true;
            // Если не пройдена валидация хотя бы одним полем - выходим
            if (!nameValid || !colorValid || !coordinatesValid || !radiusValid) return;

            let objectData = {};

            if (this.object) {
                let { object_id } = this.object;
                objectData.object_id = object_id;
            }

            let { name, color, radius, coordinates, is_work_area } = this;
            coordinates = this.parseCoordinates(coordinates);
            if (!coordinates || !coordinates.length) {
                return;
            }

            // TODO: Пока project_id захардкожен на 1
            objectData.project_id = this.project_id;

            objectData.name = name;
            objectData.color = color;
            objectData.radius = radius;
            objectData.coordinates = coordinates;
            objectData.is_work_area = is_work_area;

            this.isLoading = true;
            this.$emit('apply', objectData);
        },
        clear() {
            this.name = '';
            this.color = '';
            this.radius = '';
            this.is_work_area = true;

            this.$nextTick(() => {
                this.$refs.name.resetValidation();
                this.$refs.color.resetValidation();
                this.$refs.coordinates.resetValidation();
                if (this.$refs.radius) this.$refs.radius.resetValidation();
            });
        },
        deleteObject() {
            this.isDeleteLoading = true;
            this.$emit('delete', { layer: this.layer });
        },
        detectShape(layer = this.layer) {
            let shape;
            if (layer._radius !== undefined && layer.getLatLng) {
                shape = 'Circle';
            } else if (layer.getLatLngs && layer.getLatLngs() > 1) {
                shape = 'Polygon';
            }

            return shape;
        },
        setCoordinates(coordinates, layer = this.layer) {
            if (!coordinates || !coordinates.length || !layer) return;

            if (layer.setLatLngs) {
                layer.setLatLngs(coordinates);
            } else if (layer.setLatLng) {
                layer.setLatLngs(coordinates[0]);
            }

            layer.pm._initMarkers();
        },
        getCoordinates(layer = this.layer) {
            if (!layer) return;
            let latLngs = [];
            let coordinates;

            if (layer.getLatLngs) {
                latLngs = layer.getLatLngs();
                coordinates = latLngs[0].map(({ lat, lng }) => [lat, lng]);
            } else if (layer.getLatLng) {
                latLngs = layer.getLatLng();
                coordinates = [[latLngs.lat, latLngs.lng]];
            }

            return coordinates;
        },
        parseCoordinates(coordString) {
            return coordString
                .split(/\n/)
                .filter(row => row.trim())
                .map(row => row.split(/\s*?,\s*?/))
                .map(coord => {
                    let lat = Number(coord[0]);
                    let lng = Number(coord[1]);

                    if (isNaN(lat) || isNaN(lng)) return;

                    return [lat, lng];
                })
                .filter(coord => coord);
        },
        stringifyCoordinates(coordinates) {
            // debugger;
            let coordString = coordinates.reduce((acc, coord) => (acc += coord.join(',') + '\n'), '');

            return coordString;
        }
    }
};
</script>

<style lang="sass">
.edit-object
    margin: 10px
    &-field
        min-width: 250px
        margin-bottom: 10px
    &-buttons
        display: flex
        justify-content: space-between
        margin: 6px 10px 12px
        &-center
            justify-content: center
    &-delete
        width: 100%
</style>
