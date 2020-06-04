<template>
    <q-card>
        <q-card-section class="WorkSessionsDeleteModal-header">
            <div class="WorkSessionsDeleteModal-title">Удаление рабочей сессии</div>
        </q-card-section>

        <q-card-section class="row items-center no-wrap">
            <q-avatar icon="delete" color="primary" text-color="white" />
            <span class="q-ml-sm">Вы действительно хотите удалить рабочую сессию?</span>
        </q-card-section>

        <q-card-actions class="WorkSessionsDeleteModal-actions" align="right">
            <q-btn
                class="WorkSessionsDeleteModal-cancel"
                flat
                :disable="sessionProcessing"
                label="Отмена"
                color="primary"
                @click="onCancelClick"
            />
            <q-btn
                class="WorkSessionsDeleteModal-delete"
                flat
                :disable="sessionProcessing"
                :loading="sessionProcessing"
                label="Удалить"
                color="red"
                @click="onDeleteClick"
            >
                <template v-slot:loading>
                    <q-spinner-puff />
                </template>
            </q-btn>
        </q-card-actions>
    </q-card>
</template>

<script>
import { mapGetters, mapMutations, mapActions } from 'vuex';

import withShowMessage from '@mixins/withShowMessage';

import isFalse from '@services/utils/isFalse';

export default {
    name: 'WorkSessionsDeleteModal',
    mixins: [withShowMessage()],
    computed: {
        ...mapGetters('DevicesSessions', ['deleteSessionModalData', 'sessionProcessing'])
    },
    created() {
        window.WorkSessionsDeleteModal = this;
    },
    beforeDestroy() {
        this.clearDeleteSessionModalData();
    },
    methods: {
        ...mapMutations('DevicesSessions', ['setDeleteSessionModalOpen', 'clearDeleteSessionModalData']),
        ...mapActions('DevicesSessions', ['requestDeleteSession']),

        onCancelClick() {
            this.setDeleteSessionModalOpen(false);
        },
        async onDeleteClick() {
            let { id } = this.deleteSessionModalData;
            if (isFalse(id)) return;

            let res = await this.requestDeleteSession();

            // Если нет ответа, значит ошибка
            if (!res) {
                this.showMessage('Ошибка удаления рабочей сессии', true);
            } else {
                this.showMessage('Рабочая сессия удалена');
                this.setDeleteSessionModalOpen(false);
            }
        }
    }
};
</script>

<style lang="sass">
.WorkSessionsDeleteModal
    &-title
        font-size: 16px
        line-height: 18px
        font-weight: 600
        margin-right: 16px
        text-align: center
</style>
