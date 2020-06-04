<template>
    <q-dialog v-model="editModalModel" :maximized="mobileMode" :persistent="userProcessing">
        <q-card class="UsersControlEditModal">
            <q-card-section class="UsersControlEditModal-header">
                <div class="UsersControlEditModal-headerTitle UsersControlEditModal-title">{{ title }}</div>
                <q-btn
                    class="UsersControlEditModal-close modal-close-btn close-red with-mobile no-radius-top-left no-radius-top-right no-radius-bottom-right"
                    :class="{ 'UsersControlEditModal-closeMobile': mobileMode }"
                    icon="close"
                    flat
                    :dense="mobileMode"
                    v-close-popup
                />
            </q-card-section>

            <div class="UsersControlEditModal-body">
                <q-tabs
                    class="UsersControlEditModal-tabsHeader text-grey"
                    v-model="tabModel"
                    dense
                    active-color="primary"
                    indicator-color="primary"
                    align="justify"
                    narrow-indicator
                >
                    <q-tab name="user" label="Пользователь" />
                    <q-tab name="role" label="Роли" :disable="roleTabDisable" />
                </q-tabs>
                <q-separator />
                <q-tab-panels class="UsersControlEditModal-tabsBody" v-model="tabModel" animated>
                    <q-tab-panel class="UsersControlEditModal-tabPanel" name="user">
                        <UserPanel />
                    </q-tab-panel>

                    <q-tab-panel class="UsersControlEditModal-tabPanel" name="role">
                        <RolePanel />

                        <div
                            v-if="checkScenarios(['RolesControl/CreateNewRoles'])"
                            class="UsersControlEditModal-addRole text-primary"
                        >
                            <span class="UsersControlEditModal-addRoleBtn" @click="onAddRoleClick"
                                >+ Добавить новую роль</span
                            >
                        </div>
                    </q-tab-panel>
                </q-tab-panels>
            </div>

            <q-space />

            <q-separator class="UsersControlEditModal-separator" />

            <q-card-actions class="UsersControlEditModal-footer" align="around">
                <q-btn
                    class="UsersControlEditModal-btn UsersControlEditModal-cancel"
                    outline
                    color="red"
                    :label="cancelLabel"
                    :disable="userProcessing"
                    @click="onCancelClick"
                />
                <q-btn
                    class="UsersControlEditModal-btn UsersControlEditModal-submit"
                    outline
                    color="primary"
                    :label="submitLabel"
                    :disable="submitDisabled"
                    :loading="userProcessing"
                    @click="onSubmitClick"
                >
                    <template v-slot:loading>
                        <q-spinner-puff />
                    </template>
                </q-btn>
            </q-card-actions>
        </q-card>
    </q-dialog>
</template>

<script>
import UserPanel from './UsersControlEditModal/UserPanel.vue';
import RolePanel from './UsersControlEditModal/RolePanel.vue';

import withShowMessage from '@mixins/withShowMessage';
import { compareSimpleArray } from '@services/utils';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'UsersControlEditModal',
    components: {
        UserPanel,
        RolePanel
    },
    mixins: [withShowMessage()],
    data() {
        return {
            addTitle: 'Создание нового пользователя',
            editTitle: 'Редактирование пользователя',

            addSubmitBtnTitle: 'Готово',
            nextSubmitBtnTitle: 'Создать',
            editSubmitBtnTitle: 'Применить',
            cancelBtnLabel: 'Отмена',
            backBtnLabel: 'Назад',

            addSuccess: 'Пользователь успешно добавлен',
            addError: 'Ошибка добавления пользователя',

            editSuccess: 'Пользователь успешно изменен',
            editError: 'Ошибка редактирования пользователя',

            deleteSuccess: 'Пользователь удален',
            deleteError: 'Ошибка удаления пользователя'
        };
    },
    created() {
        window.UsersControlEditModal = this;
    },
    computed: {
        ...mapGetters('UsersControl', ['allUsers', 'userProcessing', 'openEditUserModal', 'editUserModalData']),
        ...mapGetters('User', ['checkScenarios']),

        editModalModel: {
            get: function() {
                return this.openEditUserModal;
            },
            set: function(isOpen) {
                this.setOpenEditUserModal(isOpen);
            }
        },

        tabModel: {
            get() {
                return this.editUserModalData.step;
            },
            set(step) {
                this.setEditUserModalData({ step });
            }
        },

        mobileMode() {
            return this.$q.screen.xs;
        },

        dataUserReady() {
            let ready = false;
            let { email, username, password } = this.editUserModalData;

            // В режиме создания юзера, нужен заполненный пароль
            if (!this.isEditMode && email && username && password) {
                ready = true;

                // В режиме редактирования пароль можно не заполнять, должен оставаться старый
            } else if (this.isEditMode && email && username) {
                ready = true;
            }

            return ready;
        },

        isEditMode() {
            let { id } = this.editUserModalData;

            return id !== null;
        },

        title() {
            let title = this.addTitle;

            if (this.isEditMode) {
                let { username } = this.editUserModalData;
                title = `${this.editTitle} "${username}"`;
            }

            return title;
        },

        cancelLabel() {
            let { step } = this.editUserModalData;
            return step === 'user' ? this.cancelBtnLabel : this.backBtnLabel;
        },
        submitLabel() {
            let label = '';
            let { step } = this.editUserModalData;

            // Если режим создания нового пользователя и активна вкладка пользователя
            if (!this.isEditMode && step === 'user') {
                label = this.nextSubmitBtnTitle;

                // Если редактирование пользователя, активна вкладка пользователя и нет изменений данных
            } else if (this.isEditMode && step === 'user' && !this.hasChangeUserInfo) {
                label = this.addSubmitBtnTitle;

                // Если редактирование пользователя, активна вкладка пользователя и изменения данных есть
            } else if (this.isEditMode && step === 'user' && this.hasChangeUserInfo) {
                label = this.editSubmitBtnTitle;

                // Если активна вкладка ролей и есть изменения в составе ролей пользователя
            } else if (step === 'role' && this.hasChangeRoles) {
                label = this.editSubmitBtnTitle;

                // Если активна вкладка ролей и изменений в составе ролей пользователя нет
            } else if (step === 'role' && !this.hasChangeRoles) {
                label = this.addSubmitBtnTitle;
            }

            return label;
        },
        submitDisabled() {
            let disabled = false;

            // Если идет операция с запросом или не заполнены данные пользователя, то блокируем кнопку
            if (this.userProcessing || !this.dataUserReady) disabled = true;

            return disabled;
        },

        roleTabDisable() {
            let { id } = this.editUserModalData;

            return id === null;
        },

        hasChangeUserInfo() {
            let result = false;

            let { id, email, username, password, active } = this.editUserModalData;
            let originalUser = this.allUsers.find(({ rowId }) => rowId === id);
            if (!originalUser) return result;

            // Если есть что-то в поле с паролем или email || username || active не совпадают с тем, что было раньше
            if (
                password ||
                email !== originalUser.email ||
                username !== originalUser.username ||
                active !== originalUser.active
            )
                result = true;

            return result;
        },

        hasChangeRoles() {
            let result = false;

            let { id, roles } = this.editUserModalData;
            let originalUser = this.allUsers.find(({ rowId }) => rowId === id);
            if (!originalUser) return result;

            let originalRoleIds = originalUser.roles.map(({ rowId }) => rowId);
            let newRoleIds = roles.map(({ rowId }) => rowId);

            // Если массивы не равны, значит были изменения, поэтому инверсия
            result = !compareSimpleArray(originalRoleIds, newRoleIds);

            return result;
        }
    },
    methods: {
        ...mapMutations('UsersControl', [
            'setEditUserModalData',
            'setOpenEditUserModal',
            'clearEditUserModalData',
            'addAllUsers',
            'updateOneUser'
        ]),
        ...mapMutations('RolesControl', ['setOpenEditRoleModal', 'clearEditRoleModalData']),
        ...mapActions('UsersControl', ['requestCreateUser', 'requestUpdateUser']),

        onAddRoleClick() {
            this.clearEditRoleModalData();
            this.setOpenEditRoleModal(true);
        },

        closeModal() {
            this.setOpenEditUserModal(false);
            this.clearEditUserModalData();
        },

        onCancelClick() {
            let { step } = this.editUserModalData;
            if (step === 'role') {
                this.setEditUserModalData({ step: 'user' });
            } else {
                this.closeModal();
            }
        },
        async onSubmitClick() {
            let { step } = this.editUserModalData;

            // Если Submit нажат на вкладке пользователя и сейчас режим создания пользователя
            if (step === 'user' && !this.isEditMode) {
                let result = await this.createUser();

                if (result) {
                    this.setEditUserModalData({
                        id: result.rowId,
                        step: 'role'
                    });
                }

                // Если Submit нажат на вкладке пользователя, сейчас режим редактирования и есть изменения
            } else if (step === 'user' && this.isEditMode && this.hasChangeUserInfo) {
                let result = await this.updateUser();

                if (result) {
                    this.setEditUserModalData({
                        step: 'role'
                    });
                }

                // Если Submit нажат на вкладке пользователя, сейчас режим редактирования и изменений нет
            } else if (step === 'user' && this.isEditMode && !this.hasChangeUserInfo) {
                // Просто переходим на вкладку ролей
                this.setEditUserModalData({
                    step: 'role'
                });

                // Если  Submit нажат на вкладке ролей и есть изменения в составе ролей пользователя
            } else if (step === 'role' && this.hasChangeRoles) {
                // Обновляем данные
                let result = await this.updateUser();

                // И закрываем модалку
                if (result) {
                    this.closeModal();
                }

                // Если  Submit нажат на вкладке ролей и изменений в составе ролей пользователя нет
            } else if (step === 'role' && !this.hasChangeRoles) {
                // Просто закрываем модалку
                this.closeModal();
            }
        },

        async updateUser() {
            let newUser = await this.requestUpdateUser();

            // Если редактирование роли прошло успешно
            if (newUser) {
                this.updateOneUser(newUser);
                this.showMessage(this.editSuccess);

                return newUser;

                // Если роль не была создана
            } else {
                this.showMessage(this.editError, true);

                return false;
            }
        },

        async createUser() {
            let newUser = await this.requestCreateUser();

            // Если создание пользователя прошло успешно
            if (newUser) {
                this.addAllUsers(newUser);
                this.showMessage(this.addSuccess);

                return newUser;

                // Если пользователь не был создан
            } else {
                this.showMessage(this.addError, true);

                return false;
            }
        }
    }
};
</script>

<style lang="sass">
.UsersControlEditModal
    display: flex
    flex-direction: column
    max-width: 600px !important
    width: 100%
    &-header
        position: relative
        // @media only screen and (max-width : 599px)
        //     margin-top: 16px
    &-close
        position: absolute
        top: 0
        right: 0
    &-headerTitle
        margin-right: 56px
        @media only screen and (max-width : 599px)
            margin-right: 32px
    &-title
        font-size: 16px
        line-height: 18px
        font-weight: 600
        text-align: center
    &-body
        width: 100%
        height: 100%
        overflow: hidden
        display: flex
        flex-direction: column
        align-items: center
        @media only screen and (max-width : 599px)
            max-width: none
            width: 100%
        .q-separator--horizontal
            max-height: 1px
    &-tabsHeader
        width: 100%
    &-tabsBody
        display: flex
        flex-direction: column
        flex-grow: 1
        margin: 16px
        width: calc(100% - 32px)
        .q-panel
            display: flex
            flex-direction: column
            flex-grow: 1
            overflow: hidden
    &-tabPanel
        display: flex
        flex-direction: column
        justify-content: center
        flex-grow: 1
        overflow: hidden
        padding: 0
    &-addRole
        padding: 16px 16px 0 16px
    &-addRoleBtn
        cursor: pointer
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
