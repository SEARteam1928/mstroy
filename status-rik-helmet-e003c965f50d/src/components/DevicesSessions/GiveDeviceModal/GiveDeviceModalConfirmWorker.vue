<template>
    <div class="GiveDeviceModalConfirmWorker">
        <!-- Селект с выбором сотрудника из общего списка доступных -->
        <div class="GiveDeviceModalConfirmWorker-section GiveDeviceModalConfirmWorker-sectionWorkerPicker">
            <div class="GiveDeviceModalConfirmWorker-label">Сотрудник</div>
            <div class="GiveDeviceModalConfirmWorker-workerSelect">
                <WorkerPicker :workers="availableWorkers" v-model="selectedWorker" />
            </div>
        </div>

        <!-- Выбор сотрудника из списка ранее получавших это устройство -->
        <div class="GiveDeviceModalConfirmWorker-section GiveDeviceModalConfirmWorker-sectionLastWorkersList">
            <div class="GiveDeviceModalConfirmWorker-label">Ранее выдавалось</div>
            <div class="GiveDeviceModalConfirmWorker-workerSelect">
                <div class="GiveDeviceModalConfirmWorker-lastWorkersList">
                    <div
                        class="GiveDeviceModalConfirmWorker-lastWorkerItem"
                        v-for="worker in uniqLastWorkers"
                        :key="worker.id"
                        @click="onLastWorkerItem(worker)"
                    >
                        {{ worker.name }}
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import WorkerPicker from '@components/common/WorkerPicker.vue';

import shortName from '@services/utils/shortName';

import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'GiveDeviceModalConfirmWorker',
    components: {
        WorkerPicker
    },
    data() {
        return {
            selectedWorker: null
        };
    },
    computed: {
        ...mapGetters('DevicesSessions', ['availableWorkers', 'giveDeviceModalData', 'getWorkerByTRId']),

        lastSessions() {
            return this.giveDeviceModalData.lastSessions;
        },
        uniqLastWorkers() {
            let uniqLastWorkers = new Map();

            this.lastSessions.forEach((session, index) => {
                let { workers, timeResourceId: id } = session;
                let name = shortName(workers[0].lastName, workers[0].firstName, workers[0].surname, true);
                let worker_id = workers[0].rowId;

                let worker = { id, name, worker_id };
                uniqLastWorkers.set(id, worker);
            });

            return [...uniqLastWorkers.values()];
        }
    },
    watch: {
        lastSessions(newLastSessions, oldNewLastSessions) {
            // Не будем устанавливать последнего сотрудника, если его нет или если этот вотчер вызывается повторно
            if (newLastSessions.length === 0 || oldNewLastSessions.length !== 0) return;

            let lastSession = newLastSessions[0];
            let { timeResourceId } = lastSession;
            let lastWorker = this.getWorkerByTRId(timeResourceId);
            if (!lastWorker) return;

            this.selectedWorker = lastWorker;
        },
        selectedWorker(newSelectedWorker, oldSelectedWorker) {
            let { id } = newSelectedWorker;
            this.setGiveDeviceModalData({ timeResourceId: id });
        }
    },
    methods: {
        ...mapMutations('DevicesSessions', ['setGiveDeviceModalData']),

        onLastWorkerItem(worker) {
            this.selectedWorker = worker;
        }
    }
};
</script>

<style lang="sass">
.GiveDeviceModalConfirmWorker
    height: 100%
    display: flex
    flex-direction: column
    align-items: center
    margin:
        top: 0
        bottom: 0
        left: 16px
        right: 28px
    &-section
        width: 100%
        display: flex
        justify-content: center
    &-sectionWorkerPicker
        align-items: center
        align-self: flex-start
    &-sectionLastWorkersList
        align-items: flex-start
        margin-top: 16px
    &-label
        width: 100px
        max-width: 100px
        color: var(--ms-dark)
        font-weight: bold
        margin-right: 8px
    &-workerSelect
        width: 100%
        flex-grow: 1
    &-lastWorkersList
    &-lastWorkerItem
        width: 100%
        height: 36px
        padding: 8px
        margin-bottom: 8px
        display: flex
        align-items: center
        color: var(--ms-dark)
        border-radius: 4px
        cursor: pointer
        transition: background-color 150ms ease-in-out
        &:hover
            background-color: var(--ms-light-grey)
</style>
