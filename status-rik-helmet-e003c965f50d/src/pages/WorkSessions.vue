<template>
    <q-page class="WorkSessions-page page-background">
        <div class="WorkSessions page-block">
            <WorkSessionsTable class="WorkSessionsTable" />
        </div>

        <q-page-sticky position="bottom-right" :offset="offset">
            <q-btn fab icon="add" color="pink" @click="onClickFAB">
                <q-tooltip anchor="center left" self="center right">Добавить новую сессию</q-tooltip>
            </q-btn>
        </q-page-sticky>

        <q-dialog v-model="editModalModel" :maximized="mobileMode" persistent>
            <WorkSessionsEditModal :mobileMode="mobileMode" />
        </q-dialog>

        <q-dialog v-model="deleteModalModel" persistent>
            <WorkSessionsDeleteModal />
        </q-dialog>
    </q-page>
</template>

<script>
import WorkSessionsTable from '../components/WorkSessions/WorkSessionsTable.vue';
import WorkSessionsEditModal from '../components/WorkSessions/WorkSessionsEditModal.vue';
import WorkSessionsDeleteModal from '../components/WorkSessions/WorkSessionsDeleteModal.vue';

import { startOfDay } from '../services/utils/dateUtils';
import dateISONormalize from '../services/utils/dateISONormalize';

import withModuleErrors from '@mixins/withModuleErrors';
import withProjectSwitch from '@mixins/withProjectSwitch';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'WorkSessions',
    components: {
        WorkSessionsTable,
        WorkSessionsEditModal,
        WorkSessionsDeleteModal
    },
    mixins: [withProjectSwitch('WorkSessions'), withModuleErrors('WorkSessions')],
    computed: {
        ...mapGetters('WorkSessions', ['moduleErrors', 'editModalOpen', 'deleteModalOpen', 'sessionProcessing']),

        mobileMode() {
            return this.$q.screen.xs;
        },

        dense() {
            return this.$q.screen.width <= 768;
        },

        offset() {
            let offset = [75, 16];

            if (this.dense) {
                offset = [65, 26];
            }

            return offset;
        },

        editModalModel: {
            get: function() {
                return this.editModalOpen;
            },
            set: function(isOpen) {
                this.setEditModalOpen(isOpen);
            }
        },

        deleteModalModel: {
            get: function() {
                return this.deleteModalOpen;
            },
            set: function(isOpen) {
                this.setDeleteModalOpen(isOpen);
            }
        }
    },
    created() {
        window.WorkSessions = this;

        // Изначальный запрос на загрузку данных будет инициализирован вызовом
        // projectSwitch из миксина withProjectSwitch
    },
    beforeDestroy() {
        this.reset();
    },
    data() {
        return {
            dialogModel: false
        };
    },
    methods: {
        ...mapMutations('WorkSessions', [
            'clearError',
            'setError',
            'setProjectId',
            'clearDevices',
            'clearWorkersData',
            'clearWorkersMap',
            'clearWorkSessionsData',
            'clearTimeResourceData',
            'setSelectedPeriod',
            'clearSelectedPeriod',
            'setEditModalOpen',
            'clearEditModalData',
            'setDeleteModalOpen',
            'setEditModalData'
        ]),
        ...mapActions('WorkSessions', ['requestDevices', 'requestWorkers', 'requestTimeResource', 'deleteSession']),

        onClickFAB() {
            // TODO: 1. Очищать данные модалки при открытии ее в режиме редактирования.
            // 2. Очищать данные модалки при клике на кнопку "Отмена" в самой модалке.
            // 3. В режиме добавления при закрытии модалки кликом вне ее, оставлять данные.
            this.clearEditModalData();

            let startToday = dateISONormalize(startOfDay(new Date()));
            this.setEditModalData({
                start_date: startToday
            });

            this.setEditModalOpen(true);
        },

        update() {
            console.time('WorkSessions requests');

            let requestDevices = this.requestDevices();
            let requestWorkers = this.requestWorkers();
            let requestTimeResource = this.requestTimeResource();

            Promise.all([requestDevices, requestWorkers, requestTimeResource]).then(() =>
                console.timeEnd('WorkSessions requests')
            );
        },
        reset() {
            this.setProjectId(null);
            this.clearDevices();
            this.clearWorkersData();
            this.clearWorkersMap();
            this.clearWorkSessionsData();
            this.clearTimeResourceData();
        },

        projectSwitch(newId) {
            this.reset();
            this.setProjectId(newId);
            this.update();
        }
    }
};
</script>

<style lang="sass">
.WorkSessions
    height: calc(100% - 16px)
    display: flex
    flex-direction: column
    flex-grow: 1
    max-width: calc(100% - 16px)
    border: 1px solid #000;
    margin:
        top: 8px
        right: 8px
        bottom: 8px
        left: 8px
    @media only screen and (max-width : 768px)
        max-width: 100%
        height: auto
    @media only screen and (max-width : 768px)
        margin: 0
    &-page
        overflow: hidden
        height: calc( 100vh - var(--header-height) )
        display: flex
        flex-direction: column
        @media only screen and (max-width : 768px)
            height: auto

    .WorkSessionsTable
        flex-grow: 1
        @media only screen and (max-width : 768px)
            height: auto

body.mobile
    .WorkSessions
        @media only screen and (max-width : 768px)
            height: auto
        &-page
            @media only screen and (max-width : 768px)
                height: auto

        .WorkSessionsTable
            @media only screen and (max-width : 768px)
                height: auto
</style>
