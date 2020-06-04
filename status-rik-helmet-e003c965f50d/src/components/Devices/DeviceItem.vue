<template>
    <div
        class="DeviceItem"
        :class="{ 'mobileMode': mobileMode, 'mobileModeOpen': expandableWrapOpen }"
        :style="deviceStateStyle"
    >
        <div class="DeviceItem-sectionGroup DeviceItem-sectionGroupMain">
            <div class="DeviceItem-name DeviceItem-sectionSeparator" @click="toggleExpandable">
                {{ device.name }}
                <OpenChevron v-if="mobileMode" class="OpenChevron" size="28px" :open="mobileModeOpen" />
            </div>

            <DeviceItemOwner
                class="DeviceItem-section DeviceItemOwner"
                colorizeNormal
                :owner="device.owner"
                :connectTime="device.connectTime"
                :state="sectionsState.owner"
                :uid="device.uid"
            />

            <DeviceItemMoreAction v-if="mobileMode" @edit="onEditClick" @delete="onDeleteClick" @data="onShowData" />
        </div>

        <ExpandableWrap
            class="DeviceItem-expansion"
            :value="mobileModeOpen"
            @before-show="onExpandableOpen"
            @after-hide="onExpandableClose"
        >
            <div class="DeviceItem-sectionGroup DeviceItem-sectionGroupCharts">
                <DeviceItemZone
                    class="DeviceItem-section DeviceItemZone DeviceItem-sectionSeparator"
                    :zone="device.currentZone"
                />

                <DeviceItemSection
                    class="DeviceItem-section DeviceItemActivity DeviceItem-sectionSeparator"
                    title="Активность"
                    :data="device.activityLevel"
                />
                <DeviceItemSection
                    class="DeviceItem-section DeviceItemBattery DeviceItem-sectionSeparator"
                    title="Батарея"
                    :data="device.battery"
                    :state="sectionsState.battery"
                    unit="%"
                />
                <DeviceItemSection
                    class="DeviceItem-section DeviceItemTemp DeviceItem-sectionSeparator"
                    title="Температура"
                    :data="device.temperature"
                    unit="°C"
                />
                <DeviceItemSection
                    class="DeviceItem-section DeviceItemAlt DeviceItem-sectionSeparator"
                    title="Высота"
                    :data="device.altitude"
                    unit="м"
                />

                <DeviceItemMoreAction
                    v-if="!mobileMode"
                    @edit="onEditClick"
                    @delete="onDeleteClick"
                    @data="onShowData"
                />
            </div>
        </ExpandableWrap>
    </div>
</template>

<script>
import DeviceItemOwner from './DeviceItem/DeviceItemOwner.vue';
import DeviceItemSection from './DeviceItem/DeviceItemSection.vue';
import DeviceItemZone from './DeviceItem/DeviceItemZone.vue';
import DeviceItemMoreAction from './DeviceItem/DeviceItemMoreAction.vue';
import OpenChevron from '../common/OpenChevron.vue';
import ExpandableWrap from '../common/ExpandableWrap.vue';

import { mapMutations, mapGetters } from 'vuex';
import { colors as quasarColors } from 'quasar';

export default {
    name: 'DeviceItem',
    components: {
        DeviceItemOwner,
        DeviceItemSection,
        DeviceItemZone,
        DeviceItemMoreAction,
        OpenChevron,
        ExpandableWrap
    },
    props: {
        device: {
            type: Object,
            required: true
        }
    },
    watch: {
        // При изменении данных от устройства будем проводить валидацию состояния
        device: {
            handler(newDevice) {
                this.sectionsState.owner = this.ownerState(newDevice);
                this.sectionsState.battery = this.batteryState(newDevice);

                this.deviceStateValue = this.deviceState();
            },
            deep: true,
            immediate: true
        }

        // mobileMode: {
        //     handler(newMobileMode) {
        //         this.mobileModeOpen = !newMobileMode;
        //     },
        //     immediate: true
        // }
    },
    computed: {
        ...mapGetters('Devices', ['mobileMode', 'deviceListMap', 'deviceListRaw']),

        mobileModeOpen: {
            get() {
                return this.mobileMode ? this.mobileModeOpen_ : true;
            },
            set(open) {
                if (typeof open !== 'boolean') return;

                this.mobileModeOpen_ = open;
            }
        },

        deviceStateStyle() {
            let style = {};
            let stateColor;
            let colorOffset = 0.1;

            let stateName = this.sectionsState.owner && this.sectionsState.owner.name;
            if (stateName === 'normal') {
                stateColor = '#4bc0c0';
                colorOffset = 0.25;
            } else {
                stateColor = this.sectionsState.owner && this.sectionsState.owner.color;
            }

            if (!stateColor) return style;

            style = {
                '--border-color': stateColor,
                '--background-color': quasarColors.changeAlpha(stateColor, colorOffset)
            };

            return style;
        }
    },
    data() {
        return {
            // Общий статус устройства
            deviceStateValue: 'normal',
            // Статусы по секциям
            sectionsState: {
                owner: {},
                battery: {}
            },
            // Цвета статусов
            stateColor: {
                // normal: undefined,
                normal: '#4bc0c0',
                none: '#888888',
                warning: '#ff9f40',
                error: '#E91E63'
            },
            // Флаг раскрытия блока с данными от устройства в мобильном режиме
            mobileModeOpen_: false,
            expandableWrapOpen: false
        };
    },
    methods: {
        ...mapMutations('Devices', [
            'setEditModalOpen',
            'setEditModalData',
            'clearEditModalData',
            'setDeleteModalOpen',
            'setDeleteModalData',
            'clearDeleteModalData',
            'setDataModalOpen',
            'setDataModalData'
        ]),

        toggleExpandable() {
            if (!this.mobileMode) return;

            this.mobileModeOpen = !this.mobileModeOpen;
        },
        onExpandableOpen() {
            this.expandableWrapOpen = true;
        },
        onExpandableClose() {
            this.expandableWrapOpen = false;
        },

        onShowData() {
            let { rawData } = this.device;

            this.setDataModalData(rawData);
            this.setDataModalOpen(true);
        },

        onEditClick() {
            this.clearEditModalData();
            this.setEditModalData({
                id: this.device.id,
                name: this.device.name,
                loraKey: this.device.lora_key,
                assetsNumber: parseInt(this.device.name),
                sendPeriod: this.device.send_period,
                ethalon: this.device.ethalon
            });
            this.setEditModalOpen(true);
        },
        onDeleteClick() {
            this.setDeleteModalData({ id: this.device.id });
            this.setDeleteModalOpen(true);
        },

        // Валидация данных секции Владельца/Последнего соединения
        ownerState(newDevice = this.device) {
            let state = {
                name: 'none',
                color: this.stateColor.none
            };

            if (!newDevice.connectTime) return state;

            let now = new Date();
            let lastTS = new Date(newDevice.connectTime);
            // Получаем разнице в мс между текущим временем и временем последнего соединения с устройством
            let diffTime = now - lastTS;

            switch (true) {
                // 5 - 15 мин
                case diffTime > 6 * 60 * 1000 && diffTime < 16 * 60 * 1000:
                    state.name = 'warning';
                    break;

                // > 15 мин
                case diffTime > 16 * 60 * 1000:
                    state.name = 'error';
                    break;

                // < 5 мин
                default:
                    state.name = 'normal';
                    break;
            }

            state.color = this.stateColor[state.name];

            return state;
        },
        // Валидация данных секции Заряда батареи
        batteryState(newDevice = this.device) {
            let state = {
                name: 'normal',
                color: this.stateColor.normal
            };

            if (!newDevice.battery.length) return state;

            // Берем последнее(актуальное) значение заряда батареи
            let battery = newDevice.battery[newDevice.battery.length - 1].value;

            switch (true) {
                case battery <= 15:
                    state.name = 'error';
                    break;

                case battery > 15 && battery <= 35:
                    state.name = 'warning';
                    break;

                // > 35%
                default:
                    state.name = 'normal';
                    break;
            }

            state.color = this.stateColor[state.name];

            return state;
        },
        // Общая валидация по статусу устройству
        deviceState() {
            let result = 'normal';

            let state = {
                normal: 'normal',
                warning: false,
                error: false
            };

            // Перебираем статусы по всем секциям
            for (let section in this.sectionsState) {
                let stateName = this.sectionsState[section].name;
                state[stateName] = stateName;
            }

            // Если есть хоть одна ошибка, то статус будет error,
            // если error нет, но есть warning, то статус будет warning,
            // если нет ни error, ни warning, то нормальное состояние устройства
            result = state.error || state.warning || state.normal;

            return result;
        }
    }
};
</script>

<style lang="sass">
.DeviceItem
    --background-color: #fff
    --background-color: transparent
    --border-color: #888
    --shadow-color: transparent
    --text-color: #000
    position: relative
    display: flex
    align-items: flex-start
    &-expansion
        width: 100%
    &-sectionGroup
        position: relative
        display: flex
        flex-grow: 1
        align-items: center
        height: 50px
        padding: 6px 12px 6px 3px
        border: 1px solid
        // Цвет рамки вокруг блока устройства будет определяться рассчитанным состоянием устройства
        border-color: #888
        border-radius: 4px
        background-color: #fff
    &-sectionGroupMain
        min-width: 300px
        padding: 6px 3px
        flex-grow: 0
        border-color: var(--border-color)
        box-shadow: 0 0 9px -5px var(--border-color)
        background-color: var(--background-color)
        transition: border-color 500ms ease, box-shadow 500ms ease
        margin-right: 10px
    &-sectionGroupCharts
        padding: 2px 12px 2px 3px
    &-name
        position: relative
        height: 100%
        min-width: 60px
        padding: 0 3px
        display: flex
        flex-direction: column
        justify-content: center
        align-items: center
        font-size: 32px
        font-weight: 300
        opacity: 0.8
        color: var(--text-color)
        line-height: 40px;
        .OpenChevron
            opacity: 0.5
    &-section
        --section-color: transparent
        border-radius: 4px
        margin: 0 3px
        padding: 3px
        display: flex
        position: relative
        justify-content: flex-end
        align-items: center
        height: 100%
        flex-grow: 1
        overflow: hidden
        // Рамка вокруг секции на псевдоэлементе для того,
        // чтобы перекрывала вертикальный разделитель, когда секция должна будет выделяться цветом
        &:before
            content: ''
            display: block
            position: absolute
            top: -1px
            right: -1px
            bottom: -1px
            left: -1px
            border: 1px solid
            // Рамка вокруг секции будет появляться при наличии у секции состояния warning или error
            // border-color: var(--section-color)
            border-color: transparent
            border-radius: 4px
            pointer-events: none
            user-select: none
            transition: border-color 500ms ease
            z-index: 2
        &.DeviceItemOwner
            width: 200px
            flex-grow: 3
            justify-content: space-between
        &.DeviceItemZone
            justify-content: flex-start
        &.DeviceItemTemp
            width: 140px
            .DeviceItem-sectionHeader
                order: 1
        &.DeviceItemActivity,
            .DeviceItem-sectionHeader
                order: 1
        &.DeviceItemBattery,
            .DeviceItem-sectionHeader
                order: 1
        &.DeviceItemAlt
            .DeviceItem-sectionHeader
                order: 1
    &-sectionSeparator
        padding-right: 5px
        &:after
            content: ''
            display: block
            position: absolute
            width: 1px
            height: calc(100% - 8px)
            right: 0px
            top: 50%
            transform: translateY(-50%)
            background-color: rgba(0, 0, 0, 0.24)
            z-index: 1
    &-sectionHeader
        display: flex
        line-height: 16px
        z-index: 2
        pointer-events: none
        user-select: none
    &-noData
        font-weight: bold
        user-select: none
    &-sectionValue
        font-weight: bold
        padding-left: 4px
        color: var(--value-color)
        transition: color 500ms ease
    &-sectionChart
        width: 100%
        height: 100%
        left: 0
        right: 0
        top: 0
        bottom: 0
        &:before
            content: ''
            display: block
            position: absolute
            left: 0
            right: 0
            top: 0
            bottom: 0
            pointer-events: none
            user-select: none
            box-shadow: inset 0 0 8px 3px #fff
            border-radius: 4px
        .chartjs
            border-radius: 4px

    &-actions
        &-btn
            &-item
                .q-item__section--avatar
                    width: 42px
                    min-width: 42px
                    height: 32px

.DeviceItem
    &.mobileMode
        flex-direction: column
        .DeviceItem
            &-sectionGroup
                width: 100%
                flex-grow: 1
            &-sectionGroupMain
                min-width: auto
                margin-right: 0
                height: 75px
            &-sectionGroupCharts
                flex-direction: column
                height: unset
                padding: 6px 12px
                border-radius: 0 0 4px 4px
                border-top: none
            &-section
                width: 100%
                padding: 6px 3px
                &:not(.DeviceItemOwner)
                    flex-direction: row
            &-name
                cursor: pointer
            &-sectionHeader
                width: 100%
                flex-direction: row
                justify-content: space-between
            &-noData
                flex-grow: 1
                width: 100%
                text-align: right
            &-sectionSeparator
                &:after
                        height: calc(100% - 4px)
            &-DeviceItemOwner
                padding: 1px 3px
                flex-direction: column
                .DeviceItem-headerOwner
                    flex-direction: column
                    .DeviceItem-sectionValue
                        padding: 0
                .DeviceItem-headerConnectTime
                    justify-content: unset
                    .DeviceItem-sectionValue
                        padding-left: 6px

.DeviceItem
    &.mobileMode.mobileModeOpen
        .DeviceItem
            &-sectionGroupMain
                border-radius: 4px 4px 0 0
            &-sectionGroupCharts
</style>
