<template>
    <div class="BlockSingleSelectedSessions">
        <div class="BlockSingleSelectedSessions-header">
            <div class="BlockSingleSelectedSessions-title">Рабочие сессии</div>
            <q-btn
                class="BlockSingleSelectedSessions-addSessionBtn"
                dense
                no-caps
                outline
                label="Добавить сессию"
                color="ms-primary"
                @click="onAddSessionBtnClick"
            />
        </div>
        <div class="BlockSingleSelectedSessions-lastSessions">
            <SessionItem
                class="SessionItem"
                v-for="session in sessions"
                :key="session.rowId"
                :session="session"
                @edit="onSessionEdit"
                @delete="onSessionDelete"
            />

            <q-btn
                v-if="isHasSessions"
                class="BlockSingleSelectedSessions-showAllSessionsBtn"
                dense
                no-caps
                flat
                :label="showAllSessionsBtnLabel"
                color="ms-primary"
                @click="onShowAllSessionsBtnClick"
            />
        </div>
    </div>
</template>

<script>
import SessionItem from './SessionItem.vue';

import isFalse from '@services/utils/isFalse';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'BlockSingleSelectedSessions',
    components: {
        SessionItem
    },
    computed: {
        ...mapGetters('DevicesSessions', ['selectedDevicesId']),

        isHasSessions() {
            return this.sessions.length > 0;
        },

        selectedDeviceId() {
            return this.selectedDevicesId[0];
        },

        showAllSessionsBtnLabel() {
            return this.showOnlyLastSession ? 'Показать все' : 'Показать последнюю';
        }
    },
    watch: {
        selectedDevicesId: {
            // При выборе разных устройств из таблицы, будем для них получать записи координат за текущие сутки
            handler(newSelectedDevicesId, oldSelectedDevicesId) {
                if (oldSelectedDevicesId && newSelectedDevicesId[0] === oldSelectedDevicesId[0]) return;

                // При смене выбранного устройства первым делом очищаем сессии. оставшиеся от прошлого устройства
                this.sessions = [];
                this.showOnlyLastSession = true;
                this.requestWorkSessions();
            }
        }
    },
    data() {
        return {
            showOnlyLastSession: true,
            sessions: []
        };
    },
    created() {
        this.requestWorkSessions();
    },
    methods: {
        ...mapMutations('DevicesSessions', [
            'setEditSessionModalOpen',
            'setEditSessionModalData',
            'setDeleteSessionModalData',
            'setDeleteSessionModalOpen'
        ]),
        ...mapActions('DevicesSessions', ['requestAllWorkSessions']),

        async requestWorkSessions() {
            if (isFalse(this.selectedDeviceId)) return;

            let params = {
                filters: { deviceIdEq: this.selectedDeviceId },
                orderBy: { startDateDesc: true }
            };

            // Если нужно показывать только одну последнюю сессию, то ставим в параметры limit: 1
            if (this.showOnlyLastSession) {
                params.pagination = {
                    limit: 1
                };
            }

            let res = await this.requestAllWorkSessions(params);
            if (res) {
                this.sessions = [...res].reverse();
            }
        },

        onAddSessionBtnClick() {
            let deviceId = this.selectedDeviceId;
            this.setEditSessionModalData({ deviceId });
            this.setEditSessionModalOpen(true);
        },
        async onShowAllSessionsBtnClick() {
            this.showOnlyLastSession = !this.showOnlyLastSession;

            this.requestWorkSessions();
        },

        onSessionEdit(session) {
            let { rowId: id, deviceId, startDate, finishDate, timeResourceId } = session;
            this.setEditSessionModalData({ id, deviceId, startDate, finishDate, timeResourceId });
            this.setEditSessionModalOpen(true);
        },
        onSessionDelete(session) {
            let { rowId: id } = session;

            this.setDeleteSessionModalData({ id });
            this.setDeleteSessionModalOpen(true);
        }
    }
};
</script>

<style lang="sass">
.BlockSingleSelectedSessions
    padding: 12px 16px 8px 16px
    &-header
        display: flex
        justify-content: space-between
        align-items: center
        padding-bottom: 8px
    &-title
        font-size: 14px
        font-weight: bold
    &-lastSessions
        display: flex
        flex-direction: column
        align-items: flex-end
        justify-content: flex-end
        min-height: 66px
    &-showAllSessionsBtn
        margin-top: 4px

    .SessionItem
        width: 100%
</style>
