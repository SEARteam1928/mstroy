<template>
    <DeleteModal
        v-model="deleteModalModel"
        :wait="waitDelete"
        :title="deleteTitle"
        :text="deleteText"
        @submit="onDeleteSubmit"
        @hide="onDeleteModalHide"
    />
</template>

<script>
import DeleteModal from '@components/common/DeleteModal.vue';

import withShowMessage from '@mixins/withShowMessage';
import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'RolesControlDeleteModal',
    components: {
        DeleteModal
    },
    mixins: [withShowMessage()],
    data() {
        return {
            deleteText: 'Вы действительно хотите удалить роль?',
            waitDelete: false,

            successDelete: 'Роль успешно удалена',
            errorDelete: 'Ошибка удаления роли'
        };
    },
    computed: {
        ...mapGetters('RolesControl', ['openDeleteRoleModal', 'deleteRoleModalData']),

        deleteTitle() {
            let { name } = this.deleteRoleModalData.role;

            return `Удаление роли "${name}"`;
        },

        deleteModalModel: {
            get: function() {
                return this.openDeleteRoleModal;
            },
            set: function(isOpen) {
                this.setOpenDeleteRoleModal(isOpen);
            }
        }
    },
    methods: {
        ...mapMutations('RolesControl', ['setOpenDeleteRoleModal', 'clearDeleteRoleModalData', 'deleteOneRole']),
        ...mapActions('RolesControl', ['requestDeleteRole']),

        // При подтверждении удаления от модалки, запустим операцию удаления
        async onDeleteSubmit() {
            let { id } = this.deleteRoleModalData;

            this.waitDelete = true;
            let deletedRole = await this.requestDeleteRole();
            this.waitDelete = false;

            if (deletedRole) {
                this.deleteOneRole(id);
                this.showMessage(this.successDelete);
                this.setOpenDeleteRoleModal(false);
            } else {
                this.showMessage(this.errorDelete, true);
            }
        },
        // При закрытии модалки будем очищать данные об удаляемой роли из хранилища
        onDeleteModalHide() {
            this.clearDeleteRoleModalData();
        }
    }
};
</script>
