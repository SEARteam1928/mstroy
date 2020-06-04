<template>
    <div
        class="BlockSingleSelectedRfid"
        :class="{
            'waitDeviceScannerSignal': waitDeviceScannerSignal,
            'waitConfirmChangeRfid': waitConfirmChangeRfid,
            'waitConfirmDeleteRfid': waitConfirmDeleteRfid
        }"
    >
        <div class="BlockSingleSelectedRfid-header">
            <div class="BlockSingleSelectedRfid-title">Метка устройства</div>
            <q-btn
                v-if="isShowAddRfidBtn"
                class="BlockSingleSelectedRfid-addRfidBtn"
                dense
                no-caps
                outline
                label="Добавить метку"
                color="ms-primary"
                @click="onAddRfidBtnClick"
            />
            <q-btn
                v-if="waitDeviceScannerSignal"
                class="BlockSingleSelectedRfid-cancelScanBtn"
                dense
                no-caps
                outline
                label="Отменить сканирование"
                color="ms-primary"
                @click="onCancelScanBtnClick"
            />
        </div>

        <div class="BlockSingleSelectedRfid-body">
            <div v-if="isShowNoRfidLabel" class="BlockSingleSelectedRfid-subHeader">
                У этого устройства еще нет метки
            </div>

            <div v-if="rfidShowValue || waitDeviceScannerSignal" class="BlockSingleSelectedRfid-rfidItem">
                <div class="BlockSingleSelectedRfid-rfidValue">{{ rfidShowValue }}</div>

                <div class="BlockSingleSelectedRfid-rfidItemActions">
                    <!-- Кнопка редактирования метки -->
                    <q-btn
                        v-if="isShowEditRfidBtn"
                        class="BlockSingleSelectedRfid-editRfidBtn"
                        dense
                        round
                        flat
                        color="ms-dark"
                        size="8px"
                        @click="onEditRfidBtnClick"
                    >
                        <q-icon name="edit" color="ms-grey" size="15px" />
                    </q-btn>
                    <!-- Кнопка удаления метки -->
                    <q-btn
                        v-if="isShowDeleteRfidBtn"
                        class="BlockSingleSelectedRfid-deleteRfidBtn"
                        dense
                        round
                        flat
                        color="ms-dark"
                        size="8px"
                        @click="onDeleteRfidBtnClick"
                    >
                        <q-icon name="delete" color="ms-grey" size="15px" />
                    </q-btn>

                    <!-- Кнопка подтверждения изменений метки -->
                    <q-btn
                        v-if="isShowApplyRfidBtn"
                        class="BlockSingleSelectedRfid-applyRfidBtn"
                        dense
                        round
                        flat
                        color="ms-dark"
                        size="8px"
                        @click="onApplyRfidBtnClick"
                    >
                        <q-icon name="done" color="ms-grey" size="15px" />
                    </q-btn>
                    <!-- Кнопка отмены изменений метки -->
                    <q-btn
                        v-if="isShowCancelRfidBtn"
                        class="BlockSingleSelectedRfid-cancelRfidBtn"
                        dense
                        round
                        flat
                        color="ms-dark"
                        size="8px"
                        @click="onCancelRfidBtnClick"
                    >
                        <q-icon name="close" color="ms-grey" size="15px" />
                    </q-btn>
                </div>
            </div>

            <div class="BlockSingleSelectedRfid-rfidState">
                <div v-if="waitDeviceScannerSignal" class="BlockSingleSelectedRfid-rfidStateLabel">
                    Ожидание сканирования...
                </div>
                <div v-if="waitConfirmChangeRfid" class="BlockSingleSelectedRfid-rfidStateLabel">
                    Подтвердите изменения...
                </div>
                <div v-if="waitConfirmDeleteRfid" class="BlockSingleSelectedRfid-rfidStateLabel">
                    Подтвердите удаление
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { mapGetters, mapMutations, mapActions } from 'vuex';

import withShowMessage from '@mixins/withShowMessage';
import isFalse from '@services/utils/isFalse';

export default {
    name: 'BlockSingleSelectedRfid',
    mixins: [withShowMessage()],
    computed: {
        ...mapGetters('DevicesSessions', [
            'selectedDevicesId',
            'getDeviceById',
            'waitDeviceScannerSignal',
            'waitConfirmChangeRfid',
            'waitConfirmDeleteRfid',
            'newRfid'
        ]),
        ...mapGetters('RfidController', ['noCard', 'rfidValue']),

        selectedDevice() {
            let selectedDeviceId = this.selectedDevicesId[0];

            return this.getDeviceById(selectedDeviceId);
        },

        isNoRfidOnDevice() {
            let rfid = this.selectedDevice.rfidValue;

            return isFalse(rfid);
        },

        rfidShowValue() {
            return this.newRfid ? this.newRfid : this.selectedDevice.rfidValue;
        },

        // Условие отображения кнопки "Добавить метку"
        isShowAddRfidBtn() {
            // Если нет ни метки на устройстве, ни новой метки и сейчас не идет процесс сканирования
            return !this.rfidShowValue && !this.waitDeviceScannerSignal;
        },
        // Условие отображения надписи "У этого устройства еще нет метки"
        isShowNoRfidLabel() {
            // Если нет ни метки на устройстве, ни новой метки и сейчас не идет процесс сканирования
            return !this.rfidShowValue && !this.waitDeviceScannerSignal;
        },
        // Условия отображения "Кнопка редактирования метки"
        isShowEditRfidBtn() {
            // Если есть отображаемое значение метки и нет никакой фазы работы со сканером
            return (
                this.rfidShowValue &&
                !this.waitDeviceScannerSignal &&
                !this.waitConfirmChangeRfid &&
                !this.waitConfirmDeleteRfid
            );
        },
        // Условия отображения "Кнопка удаления метки"
        isShowDeleteRfidBtn() {
            // Если есть отображаемое значение метки и нет никакой фазы работы со сканером
            return (
                this.rfidShowValue &&
                !this.waitDeviceScannerSignal &&
                !this.waitConfirmChangeRfid &&
                !this.waitConfirmDeleteRfid
            );
        },
        // Условия отображения "Кнопка подтверждения изменений метки"
        isShowApplyRfidBtn() {
            // Если есть отображаемое значение метки, не ожидается новая метка от сканера,
            // но ожидается подтверждение изменения или  удаления метки
            return (
                this.rfidShowValue &&
                !this.waitDeviceScannerSignal &&
                (this.waitConfirmChangeRfid || this.waitConfirmDeleteRfid)
            );
        },
        // Условия отображения "Кнопка отмены изменений метки"
        isShowCancelRfidBtn() {
            // Если есть отображаемое значение метки,не ожидается новая метка от сканера,
            // но ожидается подтверждение изменения или  удаления метки
            return (
                this.rfidShowValue &&
                !this.waitDeviceScannerSignal &&
                (this.waitConfirmChangeRfid || this.waitConfirmDeleteRfid)
            );
        }
    },
    watch: {
        // При выборе другого устройства из таблицы будем сбрасывать состояние
        selectedDevicesId() {
            this.clearRfidData();
        },

        rfidValue(newValue) {
            if (!newValue || !this.waitDeviceScannerSignal) return;

            this.onReceivedRfid(newValue);
        }
    },
    beforeDestroy() {
        this.clearRfidData();
    },
    methods: {
        ...mapActions('DevicesSessions', ['requestEditDevice']),
        ...mapMutations('DevicesSessions', [
            'setWaitDeviceScannerSignal',
            'setWaitConfirmChangeRfid',
            'setWaitConfirmDeleteRfid',
            'setNewRfid',
            'updateLocalDeviceData'
        ]),

        clearRfidData() {
            this.setWaitDeviceScannerSignal(false);
            this.setWaitConfirmChangeRfid(false);
            this.setWaitConfirmDeleteRfid(false);
            this.setNewRfid(null);
        },

        onAddRfidBtnClick() {
            this.setWaitDeviceScannerSignal(true);
        },
        onCancelScanBtnClick() {
            this.setWaitDeviceScannerSignal(false);
        },

        onReceivedRfid(newValue) {
            this.setNewRfid(newValue);
            this.setWaitDeviceScannerSignal(false);
            this.setWaitConfirmChangeRfid(true);
        },

        onCancelRfidBtnClick() {
            this.clearRfidData();
        },
        async onApplyRfidBtnClick() {
            let {
                id,
                name,
                lora_key: loraKey,
                send_period: sendPeriod,
                ethalon,
                rfidValue: oldRfidValue
            } = this.selectedDevice;
            let rfidValue = this.newRfid;
            let isAddRfidOperation = !isFalse(rfidValue);

            let deviceData = { id, name, loraKey, sendPeriod, ethalon, rfidValue };

            let res = await this.requestEditDevice(deviceData);
            if (res) {
                let msg = isAddRfidOperation
                    ? `Метка "${rfidValue}" связана с устройством "${name}"`
                    : `Метка "${oldRfidValue}" отвязана от устройства "${name}"`;
                this.showMessage(msg);
                this.clearRfidData();
                this.updateLocalDeviceData({ ...this.selectedDevice, rfidValue });
            } else {
                let msg = isAddRfidOperation ? 'Ошибка добавления метки' : 'Ошибка удаления метки';
                this.showMessage(msg, true);
            }
        },
        async onDeleteRfidBtnClick() {
            this.setWaitConfirmDeleteRfid(true);
        },
        onEditRfidBtnClick() {
            this.setWaitDeviceScannerSignal(true);
        }
    }
};
</script>

<style lang="sass">
.BlockSingleSelectedRfid
    padding: 12px 16px 0 16px
    &-header
        display: flex
        justify-content: space-between
        align-items: center
        padding-bottom: 8px
        min-height: 40px
    &-title
        font-size: 14px
        font-weight: bold
    &-body
        display: flex
        align-items: center
        height: 42px
    &-rfidItem
        height: 30px
        min-width: 145px
        display: flex
        justify-content: space-between
        padding: 4px
        border-radius: 4px
        transition: background-color 250ms ease-in-out
        &:hover
            background-color: var(--ms-light-grey)
            .BlockSingleSelectedRfid
                &-rfidItemActions
                    opacity: 1
    &-rfidValue
        padding-right: 4px
    &-rfidItemActions
        opacity: 0
        transition: opacity 250ms ease-in-out
    &-editRfidBtn,
    &-deleteRfidBtn
        transition: color 250ms ease-in-out
        .q-icon
            transition: color 250ms ease-in-out
    &-editRfidBtn,
    &-applyRfidBtn,
        margin-right: 4px
        &:hover
            color: var(--ms-primary) !important
            .q-icon
                color: var(--ms-primary) !important
    &-deleteRfidBtn,
    &-cancelRfidBtn
        &:hover
            color: var(--ms-red) !important
            .q-icon
                color: var(--ms-red) !important

    &-rfidState
        padding-left: 8px
        font-size: 12px
        color: var(--ms-grey)

    // Состояние ожидания сканирования метки
    &.waitDeviceScannerSignal
        .BlockSingleSelectedRfid
            &-rfidItem
                background-color: var(--ms-light-grey)
    // Состояние ожидания подтверждения изменения метки
    &.waitConfirmChangeRfid
        .BlockSingleSelectedRfid
            &-rfidItem
                background-color: var(--ms-light-grey)
            &-rfidItemActions
                opacity: 1
    // Состояние ожидания подтверждения удаления метки
    &.waitConfirmDeleteRfid
        .BlockSingleSelectedRfid
            &-rfidItem
                background-color: var(--ms-light-grey)
            &-rfidItemActions
                opacity: 1
</style>
