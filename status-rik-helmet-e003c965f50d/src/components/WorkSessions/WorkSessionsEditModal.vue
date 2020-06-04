<template>
    <q-card class="WorkSessionsEditModal">
        <q-card-section class="WorkSessionsEditModal-header">
            <div class="WorkSessionsEditModal-title">{{ title }}</div>

            <q-btn
                class="WorkSessionsEditModal-close modal-close-btn close-red with-mobile no-radius-top-left no-radius-top-right no-radius-bottom-right"
                :class="{ 'WorkSessionsEditModal-closeMobile': mobileMode }"
                icon="close"
                flat
                :dense="mobileMode"
                v-close-popup
            />
        </q-card-section>

        <q-space />

        <div class="WorkSessionsEditModal-body">
            <DeviceSection class="WorkSessionsEditModal-deviceSection" />

            <WorkerSection class="WorkSessionsEditModal-workerSection" />

            <DateSection class="WorkSessionsEditModal-dateSection" />
        </div>

        <q-card-section />

        <q-space />

        <q-separator class="WorkSessionsEditModal-separator" />

        <q-card-actions class="WorkSessionsEditModal-footer" align="around">
            <q-btn
                class="WorkSessionsEditModal-btn WorkSessionsEditModal-cancel"
                v-close-popup
                outline
                color="red"
                :label="cancelBtnLabel"
                :disable="sessionProcessing"
                @click="onCancelClick"
            />
            <q-btn
                class="WorkSessionsEditModal-btn WorkSessionsEditModal-submit"
                outline
                color="primary"
                :label="submitBtnLabel"
                :disable="!editModalDataReady || sessionProcessing"
                :loading="sessionProcessing"
                @click="onSubmitClick"
            >
                <template v-slot:loading>
                    <q-spinner-puff />
                </template>
            </q-btn>
        </q-card-actions>
    </q-card>
</template>

<script>
import DeviceSection from './WorkSessionsEditModal/DeviceSection.vue';
import WorkerSection from './WorkSessionsEditModal/WorkerSection.vue';
import DateSection from './WorkSessionsEditModal/DateSection.vue';

import withShowMessage from '@mixins/withShowMessage';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'WorkSessionsEditModal',
    components: {
        DeviceSection,
        WorkerSection,
        DateSection
    },
    mixins: [withShowMessage()],
    props: {
        mobileMode: {
            type: Boolean,
            required: false,
            default: false
        }
    },
    computed: {
        ...mapGetters('WorkSessions', ['editModalData', 'editModalDataReady', 'sessionProcessing']),

        isEditMode() {
            let { work_session_id } = this.editModalData;

            return work_session_id !== null;
        },

        title() {
            let title = this.addTitle;
            if (this.isEditMode) title = this.editTitle;

            return title;
        },

        submitBtnLabel() {
            let label = this.addSubmitBtnTitle;
            if (this.isEditMode) label = this.editSubmitBtnTitle;

            return label;
        }
    },
    data() {
        return {
            addTitle: 'Добавление рабочей сессии',
            editTitle: 'Редактирование рабочей сессии',
            addSubmitBtnTitle: 'Добавить',
            editSubmitBtnTitle: 'Применить',
            cancelBtnLabel: 'Отмена'
        };
    },
    methods: {
        ...mapMutations('WorkSessions', ['setEditModalOpen', 'setEditModalData', 'clearEditModalData']),
        ...mapActions('WorkSessions', ['createSession', 'updateSession']),

        onCancelClick() {
            this.clearEditModalData();
        },
        async onSubmitClick() {
            // Режим добавления сессии
            if (!this.isEditMode) {
                let res = await this.createSession();

                // Если нет ответа, значит ошибка
                if (!res) {
                    this.showMessage('Ошибка добавления рабочей сессии', true);
                } else if (res.result === 'success') {
                    this.showMessage('Рабочая сессия добавлена');

                    this.setEditModalOpen(false);
                }
            } else {
                let res = await this.updateSession();

                // Если нет ответа, значит ошибка
                if (!res) {
                    this.showMessage('Ошибка изменения рабочей сессии', true);
                } else if (res.result) {
                    this.showMessage('Рабочая сессия изменена');

                    this.setEditModalOpen(false);
                }
            }
        }
    }
};
</script>

<style lang="sass">
.WorkSessionsEditModal
    display: flex
    flex-direction: column
    &-header
        @media only screen and (max-width : 599px)
            margin-top: 16px
    &-close
        position: absolute
        top: 0
        right: 0
    &-closeMobile
        top: -16px
    &-title
        font-size: 16px
        line-height: 18px
        font-weight: 600
        margin-right: 16px
        text-align: center
    &-body
        width: 480px
        display: flex
        flex-direction: column
        align-items: center
        @media only screen and (max-width : 599px)
            max-width: none
            width: 100%
    &-deviceSection, &-workerSection, &-dateSection
        width: 100%
    &-separator
        flex-grow: 0
    &-footer
        padding: 16px 8px
        @media only screen and (max-width : 599px)
            padding: 24px 8px
    &-btn
        width: 30%
        @media only screen and (max-width : 599px)
            width: 40%
</style>
