<template>
    <q-page class="map-page page-background">
        <div class="control-block page-block">
            <DevicesSelect dense class="devices-select" label="Устройства" @change="onChangeDevices" />

            <PeriodPicker dense class="period-picker" toISO @change="onChangePeriod" />

            <AdditionalSelect
                dense
                class="mode-select"
                label="Режим карты"
                :options="modeOptions"
                :defaultValue="mapMode"
                @change="onChangeMode"
            />
        </div>

        <div class="status-block">
            <StatusBar
                :loading="status.loading"
                :size="status.size"
                :loaded="status.loaded"
                :shown="status.shown"
                :error="status.error"
            />
        </div>

        <div class="map-block page-block">
            <MapHeat
                :mapMode="mapMode"
                :deviceCoordinates="deviceCoordinates"
                :devices="devicesObject"
                :period="period"
                @shown="onShownHandler"
                @reset="onResetHandler"
                ref="MapHeat"
            />
        </div>
    </q-page>
</template>

<script>
import DevicesSelect from '../components/Map/DevicesSelect.vue';
import AdditionalSelect from '../components/Map/AdditionalSelect.vue';
import PeriodPicker from '../components/Map/PeriodPicker.vue';
import StatusBar from '../components/Map/StatusBar.vue';
import MapHeat from '../components/Map/MapHeat.vue';

import api from '../services/api';

export default {
    name: 'Map',
    components: {
        DevicesSelect,
        AdditionalSelect,
        PeriodPicker,
        StatusBar,
        MapHeat
    },
    data() {
        return {
            period: {
                from: null,
                to: null
            },
            devices: null,
            activeOptions: [
                {
                    name: 'Все',
                    value: null
                },
                {
                    name: 'Активные',
                    value: true
                },
                {
                    name: 'Не активные',
                    value: false
                }
            ],
            active: null,
            modeOptions: [
                {
                    name: 'Тепловая карта',
                    value: 'heatLayer'
                },
                {
                    name: 'Тепловой трек',
                    value: 'hotLine'
                },
                {
                    name: 'Режим трека',
                    value: 'trackPlayBack'
                }
            ],
            // mapMode: 'heatLayer',
            mapMode: 'trackPlayBack',
            deviceCoordinates: [],
            status: {
                loading: false,
                size: null,
                loaded: null,
                shown: null,
                error: false
            }
        };
    },
    computed: {
        // Из массива устройств делает объект, где по ключу lora_key лежат объекты устройств,
        //  нужно для MapHeat, будет использовано при разборе deviceCoordinates на отдельные треки устройств
        devicesObject() {
            let obj = {};

            if (this.devices instanceof Array && this.devices.length) {
                this.devices.forEach(device => {
                    obj[device.lora_key] = device;
                });
            } else {
                obj = false;
            }

            return obj;
        }
    },
    methods: {
        onChangePeriod(period) {
            console.log('onChangePeriod: ', period);
            this.period = period;
            this.getCoordinates();
        },
        onChangeDevices(devices) {
            console.log('onChangeDevices', devices);
            this.devices = devices;
            this.getCoordinates();
        },
        onChangeActive(active) {
            this.active = active;
            this.getCoordinates();
        },
        onChangeMode(mode) {
            this.mapMode = mode;
        },
        onShownHandler(shown) {
            this.status.shown = shown ? shown : null;
        },
        onResetHandler() {
            console.log('onResetHandler');

            this.deviceCoordinates = [];

            this.status.loading = false;
            this.status.size = null;
            this.status.loaded = null;
            this.status.shown = null;
        },
        async getCoordinates() {
            // Если не выбраны устройства - сбрасываем данные с карты и выходим
            if (!this.devices) {
                return false;
            }

            // Если не заполнен период - выходим
            if (!this.period.from || !this.period.to) {
                return false;
            }

            try {
                this.status.loading = true;
                this.status.size = null;
                this.status.loaded = null;
                this.status.shown = null;
                this.status.error = false;

                let res = await api.getDevicesCoordinates(this.devices, this.period, this.active);

                // Если есть ответ от сервера
                if (res) {
                    this.status.loading = false;
                    console.log('getCoordinates: ', res.data.length);
                    this.status.loaded = res.data.length;
                    this.status.size = res.headers['content-length'] ? +res.headers['content-length'] : null;

                    this.deviceCoordinates = res.data;
                } else {
                    this.status.loading = false;
                }
            } catch (err) {
                this.status.loading = false;
                this.status.size = null;
                this.status.loaded = null;
                this.status.shown = null;
                this.status.error = true;

                console.log('Ошибка запроса координат устройств: ', err);
            }
        },
        created() {
            window.MapPage = this;
        }
    }
};
</script>

<style lang="sass" scoped>
.map-page
    display: flex
    flex-direction: column
    .control-block
        display: flex
        align-items: flex-start
        margin: 8px
        padding: 8px
        @media only screen and (max-width : 600px)
            flex-wrap: wrap
            justify-content: space-between
            .devices-select
                width: 45%
            .mode-select
                width: 45%
            .period-picker
                order: 2
                margin: 0
        .devices-select
            min-width: 160px
        .period-picker
            margin: 0 16px
        .mode-select
            white-space: nowrap
    .map-block
        display: flex
        flex-grow: 1
        margin:
            top: 0
            right: 8px
            bottom: 8px
            left: 8px
    .status-block
        margin-top: 0
        @media only screen and (max-width : 600px)
            margin-top: 6px
</style>
