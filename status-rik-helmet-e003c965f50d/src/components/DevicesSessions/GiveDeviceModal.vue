<template>
    <q-card class="GiveDeviceModal">
        <q-btn
            class="GiveDeviceModal-close modal-close-btn-dense with-mobile"
            color="ms-dark"
            size="14px"
            icon="close"
            flat
            dense
            v-close-popup
        />
        <q-card-section class="GiveDeviceModal-header">
            <div v-if="selectedDevice" class="GiveDeviceModal-title">
                Выдача устройства
                <strong class="GiveDeviceModal-titleName">{{ selectedDevice.name }}</strong> сотруднику
            </div>
        </q-card-section>

        <q-card-section class="GiveDeviceModal-body">
            <DataPreloader
                class="GiveDeviceModal-withPreloader"
                :loading="!isConfirmWorkerStage"
                :info="!isConfirmWorkerStage && !deviceNotFound"
                infoMessage="Отсканируйте выдаваемое устройство"
                :warning="deviceNotFound"
                :warningMessage="`Не найдено устройство с меткой: ${scannedRfid}`"
            >
                <GiveDeviceModalConfirmWorker />
            </DataPreloader>
        </q-card-section>

        <q-card-actions class="GiveDeviceModal-actions" align="center">
            <q-btn
                v-if="isConfirmWorkerStage"
                class="GiveDeviceModal-giveDeviceBtn"
                unelevated
                label="Выдать устройство"
                color="ms-primary"
                :disable="isDisabledGiveDeviceBtn"
                @click="onGiveDeviceBtnClick"
            />
        </q-card-actions>
    </q-card>
</template>

<script>
import DataPreloader from '../common/DataPreloader.vue';
import GiveDeviceModalConfirmWorker from './GiveDeviceModal/GiveDeviceModalConfirmWorker.vue';

import withShowMessage from '@mixins/withShowMessage';

import isFalse from '@services/utils/isFalse';
import startOfDay from '@services/utils/dateUtils/startOfDay';
import endOfDay from '@services/utils/dateUtils/endOfDay';
import parse from '@services/utils/dateUtils/parse';
import computeDiffTime from '@services/utils/computeDiffTime';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'GiveDeviceModal',
    components: {
        DataPreloader,
        GiveDeviceModalConfirmWorker
    },
    mixins: [withShowMessage()],
    computed: {
        ...mapGetters('DevicesSessions', [
            'giveDeviceModalData',
            'getDeviceByRfid',
            'getDeviceById',
            'getWorkerByTRId'
        ]),
        ...mapGetters('RfidController', ['rfidValue']),

        isDisabledGiveDeviceBtn() {
            let { deviceId, timeResourceId, startDate, finishDate } = this.giveDeviceModalData;
            return isFalse(deviceId) || isFalse(timeResourceId) || isFalse(startDate) || isFalse(finishDate);
        },

        isConfirmWorkerStage() {
            return !this.isWaitScanDevice && !isFalse(this.giveDeviceModalData.deviceId);
        },

        scannedRfid() {
            return this.giveDeviceModalData.scannedRfid;
        },

        deviceNotFound() {
            return this.giveDeviceModalData.deviceNotFound;
        },

        isWaitScanDevice() {
            let { scannedRfid } = this.giveDeviceModalData;
            return isFalse(scannedRfid);
        },

        selectedDevice() {
            let index = this.giveDeviceModalData.deviceId;
            return this.getDeviceById(index);
        }
    },
    watch: {
        async rfidValue(scannedRfid) {
            if (isFalse(scannedRfid)) return;

            this.onReceiveRfidValue(scannedRfid);
        }
    },
    data() {
        return {
            // Лимит количества запрашиваемых последних сессий по устройству
            lastSessionsLimit: 3,
            HOURS_12: 43200000
        };
    },
    beforeDestroy() {
        this.clearGiveDeviceModalData();
    },
    methods: {
        ...mapMutations('DevicesSessions', [
            'setGiveDeviceModalData',
            'clearGiveDeviceModalData',
            'updateLocalDeviceData'
        ]),
        ...mapActions('DevicesSessions', ['requestCreateSession', 'requestUpdateSession', 'requestAllWorkSessions']),

        onReceiveRfidValue(scannedRfid) {
            let device = this.getDeviceByRfid(scannedRfid);

            if (!device) {
                // Если по полученному rfid не найдено устройства, устанавливаем данные для сообщения об этом
                this.setGiveDeviceModalData({ scannedRfid, deviceNotFound: true });
            } else {
                // Если найдено устройство по метке, заполняем данные, необходимые для создания сессии
                let { id: deviceId } = device;
                let now = new Date();
                let startDate = startOfDay(now);
                let finishDate = endOfDay(now);
                this.setGiveDeviceModalData({
                    deviceId,
                    scannedRfid,
                    startDate,
                    finishDate,
                    lastSessions: []
                });

                // Запрос последних сессий для найденного устройства.
                // Нужно для подстановки последнего владельца сразу в выбор сотрудника,
                // для вывода списка последних владельцев для быстрого выбора
                // и для чтобы определить, нужно ли продлевать последнюю сессию или создавать новую
                this.requestLastSessions(deviceId);
            }
        },

        async requestLastSessions(deviceId) {
            let lastSessions = await this.requestAllWorkSessions({
                filters: { deviceIdEq: deviceId },
                pagination: { limit: this.lastSessionsLimit },
                orderBy: { startDateDesc: true }
            });

            this.setGiveDeviceModalData({ lastSessions });
        },

        checkContinuousSequenceDays(date1, date2) {
            date1 = parse(date1);
            date2 = parse(date2);

            return date2 - date1 < this.HOURS_12;
        },

        async onGiveDeviceBtnClick() {
            let { deviceId, timeResourceId, startDate, finishDate, lastSessions } = this.giveDeviceModalData;

            let isEditSession = false;
            let res;

            if (lastSessions.length > 0) {
                let { finishDate: lastFinishDate, timeResourceId: lastTimeResourceId } = lastSessions[0];

                if (
                    timeResourceId === lastTimeResourceId &&
                    this.checkContinuousSequenceDays(lastFinishDate, startDate)
                ) {
                    isEditSession = true;
                }
            }

            if (isEditSession) {
                let { rowId, startDate } = lastSessions[0];
                startDate = parse(startDate);

                res = await this.requestUpdateSession({ id: rowId, deviceId, timeResourceId, startDate, finishDate });
            } else {
                res = await this.requestCreateSession({ deviceId, timeResourceId, startDate, finishDate });
            }

            if (res) {
                this.showMessage('Рабочая сессия добавлена');
                this.clearGiveDeviceModalData();

                let worker = this.getWorkerByTRId(timeResourceId);
                let device = this.getDeviceById(deviceId);
                if (isFalse(worker) || isFalse(device)) return;

                let updatedDevice = {
                    ...device,
                    owner: worker.owner
                };

                this.updateLocalDeviceData(updatedDevice);
            } else {
                this.showMessage('Ошибка добавления рабочей сессии', true);
            }
        }
    }
};
</script>

<style lang="sass">
.GiveDeviceModal
    position: relative
    width: 600px
    height: 330px
    display: flex
    flex-direction: column
    overflow: visible !important
    box-shadow: var(--shadow10) !important
    &-close
    &-header
        min-height: 54px
        width: 100%
        text-align: center
        font-size: 16px
        color: var(--ms-dark)
    &-titleName
        font-size: 18px
        font-weight: bold
    &-body
        height: 100%
        padding-bottom: 0
        flex-grow: 1
        align-self: stretch
        display: flex
        flex-direction: column
        justify-content: center
        z-index: 10
    &-withPreloader
        height: 100%
        background-color: #fff
    &-actions
        min-height: 64px
        padding-bottom: 16px
    &-giveDeviceBtn
        padding: 0 16px
</style>
