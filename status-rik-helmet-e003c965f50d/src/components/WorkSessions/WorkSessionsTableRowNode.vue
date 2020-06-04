<template>
    <div class="WorkSessionsTableRowNode">
        <div class="WorkSessionsTableRowNode-item WorkSessionsTableRowNode-name">{{ name }}</div>
        <div class="WorkSessionsTableRowNode-item WorkSessionsTableRowNode-period">{{ period }}</div>
        <div class="WorkSessionsTableRowNode-item WorkSessionsTableRowNode-timeResourceName">
            {{ timeResourceName }}

            <q-tooltip anchor="top middle" self="bottom middle" :offset="[0, 0]" :delay="500">
                {{ timeResourceName }}
            </q-tooltip>
        </div>
        <div class="WorkSessionsTableRowNode-actions">
            <MoreActionBtn class="WorkSessionsTableRowNode-actions-btn">
                <q-list>
                    <q-item
                        class="WorkSessionsTableRowNode-actions-btn-item"
                        clickable
                        v-close-popup
                        @click="onEditClick"
                    >
                        <q-item-section avatar>
                            <q-icon name="edit" />
                        </q-item-section>
                        <q-item-section>
                            <q-item-label>Редактировать</q-item-label>
                        </q-item-section>
                    </q-item>

                    <q-separator inset />

                    <q-item
                        class="WorkSessionsTableRowNode-actions-btn-item"
                        clickable
                        v-close-popup
                        @click="onDeleteClick"
                    >
                        <q-item-section avatar>
                            <q-icon name="delete" />
                        </q-item-section>
                        <q-item-section>
                            <q-item-label>Удалить</q-item-label>
                        </q-item-section>
                    </q-item>
                </q-list>
            </MoreActionBtn>
        </div>
    </div>
</template>

<script>
import MoreActionBtn from '../common/MoreActionBtn.vue';

import { dateFormat } from '../../services/utils';

import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'WorkSessionsTableRowNode',
    components: {
        MoreActionBtn
    },
    props: {
        nodeData: {
            type: Object,
            require: true
        }
    },
    computed: {
        ...mapGetters('WorkSessions', ['timeResource', 'workerData']),

        currentTimeResource() {
            let { time_resource_id } = this.nodeData;
            return this.timeResource(time_resource_id);
        },
        currentWorker() {
            if (!this.currentTimeResource) return;

            let { worker_id } = this.currentTimeResource;
            return this.workerData(worker_id);
        },

        name() {
            let name = '';
            if (!this.currentWorker) return name;

            name += this.currentWorker.last_name;
            name += ` ${this.currentWorker.first_name} ${this.currentWorker.surname}`;

            return name;
        },

        period() {
            let period = '';
            let { start_date, finish_date } = this.nodeData;

            start_date = dateFormat(start_date);
            finish_date = dateFormat(finish_date);

            period = `${start_date} - ${finish_date}`;
            return period;
        },

        timeResourceName() {
            if (!this.currentTimeResource) return;

            let timeResourceName = '';
            let { name } = this.currentTimeResource;
            if (name) timeResourceName = name;

            return timeResourceName;
        }
    },
    created() {
        window.WorkSessionsTableRowNode = this;
    },
    data() {
        return {
            emptyImg: 'img:data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=='
        };
    },
    methods: {
        ...mapMutations('WorkSessions', [
            'setEditModalOpen',
            'setEditModalData',
            'clearEditModalData',
            'setDeleteModalOpen',
            'setDeleteModalData'
        ]),

        onEditClick() {
            let { id, device_id, time_resource_id, start_date, finish_date } = this.nodeData;
            this.clearEditModalData();
            this.setEditModalData({
                work_session_id: id,
                device_id,
                time_resource_id,
                start_date,
                finish_date
            });

            this.setEditModalOpen(true);
        },

        onDeleteClick() {
            let { id, device_id } = this.nodeData;
            this.setDeleteModalData({
                work_session_id: id,
                device_id
            });
            this.setDeleteModalOpen(true);
        }
    }
};
</script>

<style lang="sass">
.WorkSessionsTableRowNode
    position: relative
    width: 100%
    display: flex
    justify-content: space-between
    align-items: center
    // Чтобы кнопки действий не заходили под скроллбар
    padding-right: 16px
    @media only screen and (max-width : 768px)
        flex-direction: column
        padding-right: 56px
    &-name
        white-space: nowrap
        overflow: hidden
        text-overflow: ellipsis
        padding: 0 6px
        width: 40%
        min-width: 250px
    &-period
        width: 15%
        min-width: 170px
        padding: 0 6px
    &-timeResourceName
        width: 35%
        white-space: nowrap
        overflow: hidden
        text-overflow: ellipsis
        padding: 0 6px
    &-item
        @media only screen and (max-width : 768px)
            width: 100%
            min-width: 100%
    &-actions
        @media only screen and (max-width : 768px)
            position: absolute
            top: 50%
            right: 16px
            transform: translateY(-50%)
        &-btn
            .q-btn__wrapper
                padding: 4px
            .q-btn__content
                width: 28px
                height: 28px
                @media only screen and (max-width : 768px)
                    width: 36px
                    height: 36px
                .q-icon
                    font-size: 24px
                .q-btn-dropdown__arrow
                    display: none
            &-item
                .q-item__section--avatar
                    width: 42px
                    min-width: 42px
                    height: 32px

body.mobile
    .WorkSessionsTableRowNode
        &-actions
            @media only screen and (max-width : 768px)
                right: 6px
</style>
