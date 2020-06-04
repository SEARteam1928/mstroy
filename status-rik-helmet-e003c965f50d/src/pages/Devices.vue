<template>
    <q-page class="Devices-page page-background">
        <div class="Devices page-block">
            <DeviceTopBar />

            <DataPreloader :loading="!deviceList.length" :error="deviceListError" :vertical="true">
                <q-scroll-area class="Devices-list" :thumb-style="{ 'transition': 'top 100ms ease, opacity 300ms' }">
                    <DeviceItem
                        class="DeviceItem"
                        v-for="device in deviceListWithFilters"
                        :key="device.id"
                        :device="device"
                    />
                </q-scroll-area>
            </DataPreloader>
        </div>

        <!-- Плавающая кнопка добавления нового устройства -->
        <q-page-sticky
            v-if="checkScenarios('Devices/CreateNewDevice')"
            class="Devices-fab-wrap"
            position="bottom-right"
            :offset="offset"
        >
            <q-btn class="Devices-fab" fab icon="add" color="pink" @click="onClickFAB">
                <q-tooltip anchor="center left" self="center right">Добавить новое устройство</q-tooltip>
            </q-btn>
        </q-page-sticky>

        <!-- Модалка добавления/редактирования устройства -->
        <q-dialog
            v-if="checkScenarios(['Devices/CreateNewDevice', 'Devices/EditDevice'])"
            v-model="editModalModel"
            :maximized="$q.screen.xs"
            persistent
        >
            <DeviceEditModal />
        </q-dialog>

        <!-- Модалка удаления устройства -->
        <q-dialog v-if="checkScenarios('Devices/DeleteDevice')" v-model="deleteModalModel" persistent>
            <DeviceDeleteModal />
        </q-dialog>

        <!-- Модалка просмотра сырых данных с устройства -->
        <q-dialog full-height full-width :maximized="$q.screen.sm || $q.screen.xs" v-model="dataModalModel" persistent>
            <DeviceDataModal />
        </q-dialog>
    </q-page>
</template>

<script>
import DataPreloader from '../components/common/DataPreloader.vue';
import DeviceItem from '../components/Devices/DeviceItem.vue';
import DeviceEditModal from '../components/Devices/DeviceEditModal.vue';
import DeviceDeleteModal from '../components/Devices/DeviceDeleteModal.vue';
import DeviceDataModal from '../components/Devices/DeviceDataModal.vue';
import DeviceTopBar from '../components/Devices/DeviceTopBar.vue';

import withModuleErrors from '@mixins/withModuleErrors';
import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'Devices',
    components: {
        DeviceItem,
        DataPreloader,
        DeviceEditModal,
        DeviceDeleteModal,
        DeviceDataModal,
        DeviceTopBar
    },
    mixins: [withModuleErrors('Devices')],
    watch: {
        deviceList: {
            handler() {
                this.autoUpdateTimer();
            },
            deep: true
        },

        mobileMode: {
            handler(newMobileMode) {
                let historySize;

                if (newMobileMode) {
                    // В мобильном режиме будет запрос только одного последнего значения данных мониторинга
                    historySize = this.historySizeModes.mobile;
                } else {
                    // В десктопном режиме будут запрашиваться 100 последних значений данных мониторинга
                    // для отрисовки графиков
                    historySize = this.historySizeModes.desktop;
                }

                this.setHistorySize(historySize);
                this.setMobileMode(newMobileMode);
            },
            immediate: true
        },

        autoUpdate(newAutoUpdate) {
            this.clearAutoUpdateTimer();

            if (newAutoUpdate) {
                this.autoUpdateTimer();
            }
        }
    },
    computed: {
        ...mapGetters('Devices', [
            'moduleErrors',
            'deviceList',
            'editModalOpen',
            'editModalData',
            'deleteModalOpen',
            'dataModalOpen',
            'deviceListWithFilters',
            'autoUpdate'
        ]),
        ...mapGetters('User', ['checkScenarios']),

        deviceListError() {
            return this.moduleErrors.requestDeviceList !== undefined;
        },

        editModalModel: {
            get() {
                return this.editModalOpen;
            },
            set(isOpen) {
                this.setEditModalOpen(isOpen);
            }
        },

        deleteModalModel: {
            get() {
                return this.deleteModalOpen;
            },
            set(isOpen) {
                this.setDeleteModalOpen(isOpen);
            }
        },

        dataModalModel: {
            get() {
                return this.dataModalOpen;
            },
            set(isOpen) {
                this.setDataModalOpen(isOpen);
            }
        },

        mobileMode() {
            return this.$q.screen.width < 768;
        }
    },
    data() {
        return {
            offset: [75, 16],
            // intervalPeriod: 30000,
            intervalPeriod: 15000,
            timeout: null,
            historySizeModes: {
                // Количество последних данных с устройства, запрашиваемых в десктопном режиме
                desktop: 50,
                // Количество последних данных с устройства, запрашиваемых в мобильном режиме
                // Так как графики на телефоне не рисуются, достаточно одной последней записи с устройства
                mobile: 1
            }
        };
    },
    created() {
        window.Devices = this;

        this.requestDeviceList();
    },
    beforeDestroy() {
        this.clearAutoUpdateTimer();

        this.clearDeviceList();
        this.clearDeviceListMap();
    },
    methods: {
        ...mapActions('Devices', ['requestDeviceList']),
        ...mapMutations('Devices', [
            'setHistorySize',
            'setMobileMode',
            'setEditModalOpen',
            'setEditModalData',
            'clearEditModalData',
            'setDeleteModalOpen',
            'setDataModalOpen',
            'clearDeviceList',
            'clearDeviceListMap'
        ]),

        onClickFAB() {
            this.clearEditModalData();
            this.setEditModalOpen(true);
        },

        autoUpdateTimer() {
            if (!this.autoUpdate) return;

            this.timeout = setTimeout(() => {
                this.requestDeviceList();
            }, this.intervalPeriod);
        },
        clearAutoUpdateTimer() {
            clearTimeout(this.timeout);
        }
    }
};
</script>

<style lang="sass">
.Devices
    height: calc(100% - 16px)
    display: flex
    flex-direction: column
    flex-grow: 1
    max-width: calc(100% - 16px)
    padding: 16px
    margin:
        top: 8px
        right: 8px
        bottom: 8px
        left: 8px
    @media only screen and (max-width : 768px)
        max-width: 100%
        height: auto
        margin:
            top: 6px
            right: 0
            bottom: 0
            left: 0
    &-page
        overflow: hidden
        height: calc( 100vh - var(--header-height) )
        display: flex
        flex-direction: column
        @media only screen and (max-width : 768px)
            height: auto

    &-list
        height: 100%
        padding-right: 16px
        flex-grow: 1
        display: flex
        flex-direction: column
        .scroll
            flex-grow: 1
    .DeviceItem
        &:not(:last-child)
            margin-bottom: 10px
        &:last-child
            margin-bottom: 30px
        &.mobileMode
            margin-left: 16px
            margin-right: 0

    &-fab
        &-wrap
            z-index: 10
</style>
