<template>
    <q-page class="DevicesSessions-page page-background">
        <!-- Блок со списком устройств -->
        <div class="DevicesSessions page-block">
            <DevicesSessionsHeader />

            <q-separator class="DevicesSessions-separator" />

            <DevicesSessionsDevicesTable />
        </div>

        <!-- Блок с информацией и действиями для выбранного устройства -->
        <div class="DevicesSessions-DevicesSessionsActionsBlock page-block">
            <DevicesSessionsActionsBlock />
        </div>

        <q-dialog v-model="editSessionModalModel" :maximized="mobileMode" persistent>
            <WorkSessionsEditModal :mobileMode="mobileMode" />
        </q-dialog>
        <q-dialog v-model="deleteSessionModalModel" :maximized="mobileMode" persistent>
            <WorkSessionsDeleteModal :mobileMode="mobileMode" />
        </q-dialog>

        <!-- Модалка выдачи устройств -->
        <q-dialog
            content-class="GiveDeviceModalDialog"
            :maximized="$q.screen.sm || $q.screen.xs"
            v-model="giveDeviceModalModel"
            persistent
        >
            <GiveDeviceModal />
        </q-dialog>
    </q-page>
</template>

<script>
import DevicesSessionsHeader from '../components/DevicesSessions/DevicesSessionsHeader.vue';
import DevicesSessionsDevicesTable from '../components/DevicesSessions/DevicesSessionsDevicesTable.vue';
import DevicesSessionsActionsBlock from '../components/DevicesSessions/DevicesSessionsActionsBlock.vue';
import WorkSessionsEditModal from '../components/DevicesSessions/WorkSessionsEditModal.vue';
import WorkSessionsDeleteModal from '../components/DevicesSessions/WorkSessionsDeleteModal.vue';
import GiveDeviceModal from '../components/DevicesSessions/GiveDeviceModal.vue';

import withModuleErrors from '../mixins/withModuleErrors';
import withProjectSwitch from '../mixins/withProjectSwitch';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'DevicesSessions',
    components: {
        DevicesSessionsHeader,
        DevicesSessionsDevicesTable,
        DevicesSessionsActionsBlock,
        WorkSessionsEditModal,
        WorkSessionsDeleteModal,
        GiveDeviceModal
    },
    mixins: [withModuleErrors('DevicesSessions'), withProjectSwitch('DevicesSessions')],
    computed: {
        ...mapGetters('DevicesSessions', [
            'editSessionModalOpen',
            'deleteSessionModalOpen',
            'giveDeviceModalOpen',
            'waitDeviceScannerSignal',
            'giveDeviceModalOpen',
            'getDeviceByRfid'
        ]),
        ...mapGetters('RfidController', ['rfidValue']),

        mobileMode() {
            return this.$q.screen.xs;
        },

        editSessionModalModel: {
            get: function() {
                return this.editSessionModalOpen;
            },
            set: function(isOpen) {
                this.setEditSessionModalOpen(isOpen);

                if (!isOpen) {
                    this.clearEditSessionModalData();
                }
            }
        },

        deleteSessionModalModel: {
            get: function() {
                return this.deleteSessionModalOpen;
            },
            set: function(isOpen) {
                this.setDeleteSessionModalOpen(isOpen);

                if (!isOpen) {
                    this.clearDeleteSessionModalData();
                }
            }
        },

        giveDeviceModalModel: {
            get() {
                return this.giveDeviceModalOpen;
            },
            set(val) {
                this.setGiveDeviceModalOpen(val);
            }
        }
    },
    watch: {
        // Если сейчас произошло сканирование, не ожидается сканирование метки для связывания с устройством и
        // не открыта модалка добавления сессий, то соответствующее устройство делаем выбранным в таблице
        rfidValue(newRfidValue) {
            if (!newRfidValue || this.waitDeviceScannerSignal || this.giveDeviceModalOpen) return;

            let device = this.getDeviceByRfid(newRfidValue);
            if (!device) return;

            this.setSelectedDevicesId(device.id);
        }
    },
    created() {
        // TODO: Убрать после отладки
        window.DevicesSessions = this;
        this.requestAllDevices();
    },
    methods: {
        ...mapMutations('DevicesSessions', [
            'setEditSessionModalOpen',
            'clearEditSessionModalData',
            'setDeleteSessionModalOpen',
            'clearDeleteSessionModalData',
            'setGiveDeviceModalOpen',
            'setSelectedDevicesId'
        ]),
        ...mapActions('DevicesSessions', ['requestAllDevices', 'subscriptionNewCoords', 'requestAllTimeResources']),

        projectSwitch(newId) {
            this.requestAllTimeResources();
        }
    }
};
</script>

<style lang="sass">
.DevicesSessions
    width: 100%
    height: 100%
    display: flex
    flex-direction: column
    overflow: hidden
    max-height: calc(100% - 16px)
    margin:
        top: 8px
        right: 8px
        bottom: 8px
        left: 8px
    &-page
        overflow: hidden
        height: calc( 100vh - var(--header-height) )
        position: relative
        display: flex
    &-separator
        max-height: 1px
    &-DevicesSessionsActionsBlock
        width: 350px
        min-width: 350px
        max-height: calc(100% - 16px)
        margin:
            top: 8px
            right: 8px
            bottom: 8px
            left: 0

.GiveDeviceModalDialog
    .q-dialog__backdrop
        background: rgba(19, 43, 77, 0.3)
        backdrop-filter: blur(3px)
</style>
