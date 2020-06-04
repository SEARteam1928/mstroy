<template>
    <div
        class="DevicesSessionsDevicesTableRow"
        :class="{
            'DevicesSessionsDevicesTableRow-selected': isSelectedDevice,
            [`connectTimeStatus-${computeConnectTimeStatus}`]: computeConnectTimeStatus
        }"
        :style="{ '--connectTimeStatusColor': connectTimeStatusColor }"
        @click.exact="rowSetSelected"
        @click.ctrl="rowAddSelected"
    >
        <div class="DevicesSessionsDevicesTableRow-col col-checkbox" @click.stop>
            <q-checkbox dense v-model="checkboxModel" color="ms-primary" />
        </div>
        <div class="DevicesSessionsDevicesTableRow-col col-number">{{ device.name }}</div>
        <div class="DevicesSessionsDevicesTableRow-col col-worker" :title="workerFullName">{{ workerName }}</div>
        <div class="DevicesSessionsDevicesTableRow-col col-connect" :title="connectTimeDate">
            {{ connectTime.string }}
        </div>
        <div class="DevicesSessionsDevicesTableRow-col col-status"></div>
        <div class="DevicesSessionsDevicesTableRow-col col-active">{{ activityLevel }}</div>
        <div class="DevicesSessionsDevicesTableRow-col col-battery">{{ battery }}</div>
    </div>
</template>

<script>
import shortName from '@services/utils/shortName';
import isFalse from '@services/utils/isFalse';
import computeDiffTime from '@services/utils/computeDiffTime';
import dateFormat from '@services/utils/dateFormat';
import connectTimeStatus from '@services/utils/connectTimeStatus';

import { date as quasarDate } from 'quasar';

import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'DevicesSessionsDevicesTableRow',
    props: {
        device: {
            type: Object,
            required: true
        }
    },
    data() {
        return {
            connectTimeStatusColors: {
                empty: '#F4F7FA',
                normal: '#4caf50',
                warning: '#ffc107',
                error: '#f44336'
            }
        };
    },
    computed: {
        ...mapGetters('DevicesSessions', ['selectedDevicesId', 'isSelectedDeviceId']),

        isSelectedDevice() {
            return this.isSelectedDeviceId(this.device.id);
        },

        checkboxModel: {
            get() {
                return this.isSelectedDevice;
            },
            set(val) {
                if (val === true) {
                    this.addSelectedDevicesId(this.device.id);
                } else if (val === false) {
                    this.removeSelectedDevicesId(this.device.id);
                }
            }
        },

        workerName() {
            if (isFalse(this.device.owner)) return '';

            let { last_name, first_name, surname } = this.device.owner;
            return shortName(last_name, first_name, surname);
        },
        workerFullName() {
            if (isFalse(this.device.owner)) return '';

            let { last_name, first_name, surname } = this.device.owner;
            return shortName(last_name, first_name, surname, true);
        },
        connectTime() {
            return computeDiffTime(this.device.connectTime);
        },
        connectTimeDate() {
            return dateFormat(this.device.connectTime, true);
        },
        activityLevel() {
            return this.device.activityLevel[0] && this.device.activityLevel[0].value;
        },
        battery() {
            return this.device.battery[0] && this.device.battery[0].value;
        },

        computeConnectTimeStatus() {
            let diffTime = this.connectTime.number;

            return connectTimeStatus(diffTime);
        },
        connectTimeStatusColor() {
            return this.connectTimeStatusColors[this.computeConnectTimeStatus];
        }
    },
    methods: {
        ...mapMutations('DevicesSessions', [
            'addSelectedDevicesId',
            'removeSelectedDevicesId',
            'setSelectedDevicesId',
            'toggleSelectedDevicesId'
        ]),

        rowSetSelected() {
            // Если выбрано несколько строк, делаем выбранной только эту
            if (this.isSelectedDevice && this.selectedDevicesId.length > 1) {
                this.setSelectedDevicesId(this.device.id);

                // Если выбрана только эта строка, снимаем с нее выделение
            } else if (this.isSelectedDevice && this.selectedDevicesId.length === 1) {
                this.removeSelectedDevicesId(this.device.id);

                // Если эта строка не выбрана, выбираем только ее
            } else {
                this.setSelectedDevicesId(this.device.id);
            }
        },
        rowAddSelected() {
            if (this.isSelectedDevice) {
                this.removeSelectedDevicesId(this.device.id);
            } else {
                this.addSelectedDevicesId(this.device.id);
            }
        }
    }
};
</script>

<style lang="sass">
.DevicesSessionsDevicesTableRow
    width: 100%
    height: 40px
    padding: 0 8px
    display: flex
    position: relative
    background-color: #fff
    border-width: 1px 0 1px 0
    border-style: solid
    border-color: transparent transparent rgba(0,0,0,0.12) transparent
    cursor: pointer
    transition: border-color 250ms ease-in-out, background-color 250ms ease-in-out
    &:before
        content: ''
        position: absolute
        width: 8px
        left: 0
        top: -1px
        bottom: -1px
        z-index: 1
        background-color: var(--connectTimeStatusColor)
    &:hover
        background-color: var(--ms-light-grey)
    &-col
        width: 100%
        align-self: stretch
        display: flex
        align-items: center
        color: var(--ms-dark)
        transition: color 250ms ease-in-out
        padding: 4px
        &.col-number
            max-width: 48px
        &.col-checkbox
            max-width: 32px
            opacity: 0
            transition: opacity 100ms ease-in-out
            &:hover
                opacity: 1
    &-selected
        background-color: var(--ms-light-grey)
        .DevicesSessionsDevicesTableRow
            &-col
                &.col-checkbox
                    opacity: 1
</style>
