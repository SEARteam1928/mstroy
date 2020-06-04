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
    name: 'UsersControlDeleteModal',
    components: {
        DeleteModal
    },
    mixins: [withShowMessage()],
    data() {
        return {
            deleteText: 'Вы действительно хотите удалить пользователя?',
            waitDelete: false,

            successDelete: 'Пользователь успешно удален',
            errorDelete: 'Ошибка удаления пользователя'
        };
    },
    computed: {
        ...mapGetters('UsersControl', ['openDeleteUserModal', 'deleteUserModalData']),

        deleteTitle() {
            let { username } = this.deleteUserModalData.user;

            return `Удаление пользователя "${username}"`;
        },

        deleteModalModel: {
            get: function() {
                return this.openDeleteUserModal;
            },
            set: function(isOpen) {
                this.setOpenDeleteUserModal(isOpen);
            }
        }
    },
    methods: {
        ...mapMutations('UsersControl', ['setOpenDeleteUserModal', 'clearDeleteUserModalData', 'deleteOneUser']),
        ...mapActions('UsersControl', ['requestDeleteUser']),

        // При подтверждении удаления от модалки, запустим операцию удаления
        async onDeleteSubmit() {
            let { id } = this.deleteUserModalData;

            this.waitDelete = true;
            let deletedUser = await this.requestDeleteUser();
            this.waitDelete = false;

            if (deletedUser) {
                this.deleteOneUser(id);
                this.showMessage(this.successDelete);
                this.setOpenDeleteUserModal(false);
            } else {
                this.showMessage(this.errorDelete, true);
            }
        },
        // При закрытии модалки будем очищать данные об удаляемом пользователе из хранилища
        onDeleteModalHide() {
            this.clearDeleteUserModalData();
        }
    }
};
</script>

<style></style>
