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

export default {
    name: 'WorkSessionsDeleteModal',
    computed: {
        ...mapGetters('WorkSessions', ['deleteModalData', 'sessionProcessing'])
    },
    created() {
        window.WorkSessionsDeleteModal = this;
    },
    beforeDestroy() {
        this.clearDeleteModalData();
    },
    methods: {
        ...mapMutations('WorkSessions', ['setDeleteModalOpen', 'clearDeleteModalData']),
        ...mapActions('WorkSessions', ['deleteSession', 'requestWorkSessions']),

        onCancelClick() {
            this.setDeleteModalOpen(false);
        },
        async onDeleteClick() {
            let { work_session_id, device_id } = this.deleteModalData;
            if (work_session_id === null || work_session_id === undefined) return;

            let res = await this.deleteSession();

            // Если нет ответа, значит ошибка
            if (!res || (res instanceof Array && !res.length)) {
                this.$q.notify({
                    icon: 'close',
                    color: 'btn_red',
                    message: 'Ошибка удаления рабочей сессии'
                });
            } else if (res instanceof Array && res[0].id === work_session_id) {
                this.$q.notify({
                    icon: 'done',
                    color: 'positive',
                    message: 'Рабочая сессия удалена'
                });

                this.setDeleteModalOpen(false);
            } else {
                this.$q.notify({
                    icon: 'warning',
                    color: 'amber',
                    message: 'Неизвестная ошибка удаления сессии'
                });
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
