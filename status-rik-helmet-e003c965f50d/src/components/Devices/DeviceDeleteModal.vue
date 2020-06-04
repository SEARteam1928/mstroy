<template>
    <q-card>
        <q-card-section class="DeviceDeleteModal-header">
            <div class="DeviceDeleteModal-title">Удаление устройства</div>
        </q-card-section>

        <q-card-section class="row items-center no-wrap">
            <q-avatar icon="delete" color="primary" text-color="white" />
            <span class="q-ml-sm">Вы действительно хотите удалить устройство</span>
        </q-card-section>

        <q-card-actions class="DeviceDeleteModal-actions" align="right">
            <!-- :disable="sessionProcessing" -->
            <q-btn class="DeviceDeleteModal-cancel" flat label="Отмена" color="primary" @click="onCancelClick" />
            <!-- :disable="sessionProcessing" -->
            <!-- :loading="sessionProcessing" -->
            <q-btn class="DeviceDeleteModal-delete" flat label="Удалить" color="red" @click="onDeleteClick">
                <template v-slot:loading>
                    <q-spinner-puff />
                </template>
            </q-btn>
        </q-card-actions>
    </q-card>
</template>

<script>
import withShowMessage from '@mixins/withShowMessage';
import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'DeviceDeleteModal',
    mixins: [withShowMessage()],
    computed: {
        ...mapGetters('Devices', ['deleteModalData'])
    },
    data() {
        return {
            deleteSuccess: 'Устройство удалено',
            deleteError: 'Ошибка удаления устройства'
        };
    },
    created() {
        window.DeviceDeleteModal = this;
    },
    beforeDestroy() {
        this.clearDeleteModalData();
    },
    methods: {
        ...mapMutations('Devices', ['setDeleteModalOpen', 'clearDeleteModalData', 'deleteOneDevice']),
        ...mapActions('Devices', ['requestDeleteDevice']),

        onCancelClick() {
            this.setDeleteModalOpen(false);
        },
        async onDeleteClick() {
            let { id } = this.deleteModalData;

            // Удаляем устройство
            let res = await this.requestDeleteDevice();

            if (res) {
                // Сообщаем об успешном удалении
                this.showMessage(this.deleteSuccess);

                this.deleteOneDevice(id);

                // Закрываем модалку
                this.setDeleteModalOpen(false);
            } else {
                this.showMessage(this.deleteError, true);
            }
        }
    }
};
</script>

<style lang="sass">
.DeviceDeleteModal
    &-title
        font-size: 16px
        line-height: 18px
        font-weight: 600
        margin-right: 16px
        text-align: center
</style>
