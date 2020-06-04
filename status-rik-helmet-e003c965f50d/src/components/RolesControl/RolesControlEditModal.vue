<template>
    <q-dialog v-model="editModalModel" :maximized="mobileMode" :persistent="roleProcessing">
        <q-card class="RolesControlEditModal">
            <q-card-section class="RolesControlEditModal-header">
                <div class="UsersControlEditModal-headerTitle RolesControlEditModal-title">{{ title }}</div>
                <q-btn
                    class="RolesControlEditModal-close modal-close-btn close-red with-mobile no-radius-top-left no-radius-top-right no-radius-bottom-right"
                    :class="{ 'RolesControlEditModal-closeMobile': mobileMode }"
                    icon="close"
                    flat
                    :dense="mobileMode"
                    v-close-popup
                />
            </q-card-section>

            <div class="RolesControlEditModal-body">
                <q-tabs
                    class="RolesControlEditModal-tabsHeader text-grey"
                    v-model="tabModel"
                    dense
                    active-color="primary"
                    indicator-color="primary"
                    align="justify"
                    narrow-indicator
                >
                    <q-tab name="role" label="Роль" />
                    <q-tab name="scenario" label="Сценарии" :disable="scenarioTabDisable" />
                </q-tabs>
                <q-separator />
                <q-tab-panels class="RolesControlEditModal-tabsBody" v-model="tabModel" animated>
                    <q-tab-panel class="RolesControlEditModal-tabPanel" name="role">
                        <RolePanel />
                    </q-tab-panel>

                    <q-tab-panel class="RolesControlEditModal-tabPanel" name="scenario">
                        <ScenarioPanel />
                    </q-tab-panel>
                </q-tab-panels>
            </div>

            <q-space />

            <q-separator class="RolesControlEditModal-separator" />

            <q-card-actions class="RolesControlEditModal-footer" align="around">
                <q-btn
                    class="RolesControlEditModal-btn RolesControlEditModal-cancel"
                    outline
                    color="red"
                    :label="cancelLabel"
                    :disable="roleProcessing"
                    @click="onCancelClick"
                />
                <q-btn
                    class="RolesControlEditModal-btn RolesControlEditModal-submit"
                    outline
                    color="primary"
                    :label="submitLabel"
                    :disable="submitDisabled"
                    :loading="roleProcessing"
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
import RolePanel from './RolesControlEditModal/RolePanel.vue';
import ScenarioPanel from './RolesControlEditModal/ScenarioPanel.vue';

import withShowMessage from '@mixins/withShowMessage';
import { compareSimpleArray } from '@services/utils';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'RolesControlEditModal',
    components: {
        RolePanel,
        ScenarioPanel
    },
    mixins: [withShowMessage()],
    data() {
        return {
            addTitle: 'Создание новой роли',
            editTitle: 'Редактирование роли',

            addSubmitBtnTitle: 'Готово',
            nextSubmitBtnTitle: 'Создать',
            editSubmitBtnTitle: 'Применить',
            cancelBtnLabel: 'Отмена',
            backBtnLabel: 'Назад',

            addSuccess: 'Роль успешно добавлена',
            addError: 'Ошибка добавления роли',

            editSuccess: 'Роль успешно изменена',
            editError: 'Ошибка редактирования роли',

            deleteSuccess: 'Роль удалена',
            deleteError: 'Ошибка удаления роли'
        };
    },
    created() {
        window.RolesControlEditModal = this;
    },
    computed: {
        ...mapGetters('RolesControl', ['roleProcessing', 'allRoles', 'openEditRoleModal', 'editRoleModalData']),

        editModalModel: {
            get: function() {
                return this.openEditRoleModal;
            },
            set: function(isOpen) {
                this.setOpenEditRoleModal(isOpen);
            }
        },

        mobileMode() {
            return this.$q.screen.xs;
        },

        tabModel: {
            get() {
                return this.editRoleModalData.step;
            },
            set(step) {
                this.setEditRoleModalData({ step });
            }
        },

        dataRoleReady() {
            let ready = false;
            let { name, description } = this.editRoleModalData;

            if (name && description) ready = true;

            return ready;
        },

        isEditMode() {
            let { id } = this.editRoleModalData;

            return id !== null;
        },

        title() {
            let title = this.addTitle;

            if (this.isEditMode) {
                let { description } = this.editRoleModalData;
                title = `${this.editTitle} "${description}"`;
            }

            return title;
        },

        cancelLabel() {
            let { step } = this.editRoleModalData;
            return step === 'role' ? this.cancelBtnLabel : this.backBtnLabel;
        },
        submitLabel() {
            let label = '';
            let { step } = this.editRoleModalData;

            // Если режим создания новой роли и активна вкладка роли
            if (!this.isEditMode && step === 'role') {
                label = this.nextSubmitBtnTitle;

                // Если режим редактирования роли, активна вкладка роли и были изменения названия/описания
            } else if (this.isEditMode && step === 'role' && this.hasChangeRoleInfo) {
                label = this.editSubmitBtnTitle;

                // Если режим редактирования роли, активна вкладка роли и изменений названия/описания не было
            } else if (this.isEditMode && step === 'role' && !this.hasChangeRoleInfo) {
                label = this.addSubmitBtnTitle;

                // Если активна вкладка сценария и были изменения в массиве сценариев
            } else if (step === 'scenario' && this.hasChangeScenarios) {
                label = this.editSubmitBtnTitle;

                // Если активна вкладка сценария и изменений в массиве сценариев не было
            } else if (step === 'scenario' && !this.hasChangeScenarios) {
                label = this.addSubmitBtnTitle;
            }

            return label;
        },
        submitDisabled() {
            let disabled = false;

            // Если идет операция с запросом или не заполнены данные пользователя, то блокируем кнопку
            if (this.roleProcessing || !this.dataRoleReady) disabled = true;

            return disabled;
        },

        scenarioTabDisable() {
            let { id } = this.editRoleModalData;

            return id === null;
        },

        hasChangeRoleInfo() {
            let result = false;

            let { id, name, description } = this.editRoleModalData;
            let originalRole = this.allRoles.find(({ rowId }) => rowId === id);
            if (!originalRole) return result;

            // Если название или описание в модалке не соответствуют данным роли, которые пришли с апи
            if (name !== originalRole.name || description !== originalRole.description) result = true;

            return result;
        },

        hasChangeScenarios() {
            let result = false;

            let { id, scenarios } = this.editRoleModalData;
            let originalRole = this.allRoles.find(({ rowId }) => rowId === id);
            if (!originalRole) return result;

            let originalScenarioIds = originalRole.scenarios.map(({ rowId }) => rowId);
            let newScenarioIds = scenarios.map(({ rowId }) => rowId);

            // Если массивы не равны, значит были изменения, поэтому инверсия
            result = !compareSimpleArray(originalScenarioIds, newScenarioIds);

            return result;
        }
    },
    methods: {
        ...mapMutations('RolesControl', [
            'setEditRoleModalData',
            'setOpenEditRoleModal',
            'clearEditRoleModalData',
            'addAllRoles',
            'updateOneRole'
        ]),
        ...mapActions('RolesControl', ['requestCreateRole', 'requestUpdateRole']),

        onCancelClick() {
            let { step } = this.editRoleModalData;

            // Если Cancel нажат на вкладке сценариев, то вернемся на вкладку данных роли
            if (step === 'scenario') {
                this.setEditRoleModalData({ step: 'role' });

                // Иначе закрываем модалку и очищаем все данные модалки из хранилища
            } else {
                this.setOpenEditRoleModal(false);
                this.clearEditRoleModalData();
            }
        },
        async onSubmitClick() {
            let { step } = this.editRoleModalData;
            // Если Submit нажат на вкладке роли и сейчас режим создания роли,
            // отправим данные на создание
            if (step === 'role' && !this.isEditMode) {
                let result = await this.createRole();

                if (result) {
                    this.setEditRoleModalData({
                        id: result.rowId,
                        step: 'scenario'
                    });
                }

                // Если Submit нажат на вкладке роли, сейчас режим редактирования роли и
                // были изменения в названии/описании роли, отправим данные на редактирование
            } else if (step === 'role' && this.isEditMode && this.hasChangeRoleInfo) {
                let result = await this.updateRole();

                if (result) {
                    this.setEditRoleModalData({
                        step: 'scenario'
                    });
                }

                // Если Submit нажат на вкладке роли, сейчас режим редактирования роли и
                // изменений в названии/описании роли не было, просто переходим на вкладку со сценариями
            } else if (step === 'role' && this.isEditMode && !this.hasChangeRoleInfo) {
                this.setEditRoleModalData({
                    step: 'scenario'
                });

                // Если Submit нажат на вкладке сценариев и были изменения в составе сценариев у роли,
                // отправим данные на редактирование
            } else if (step === 'scenario' && this.hasChangeScenarios) {
                let result = await this.updateRole();

                // Если редактирование прошло успешно, закрываем модалку
                if (result) {
                    this.editModalModel = false;
                }

                // Если Submit нажат на вкладке сценариев и в составе сценариев у роли не было изменений,
                // просто закрываем модалку
            } else if (step === 'scenario' && !this.hasChangeScenarios) {
                this.editModalModel = false;
            }
        },
        async updateRole() {
            let newRole = await this.requestUpdateRole();

            // Если редактирование роли прошло успешно
            if (newRole) {
                this.updateOneRole(newRole);
                this.showMessage(this.editSuccess);

                return newRole;

                // Если роль не была создана
            } else {
                this.showMessage(this.editError, true);

                return false;
            }
        },
        async createRole() {
            let newRole = await this.requestCreateRole();

            // Если создание роли прошло успешно
            if (newRole) {
                this.addAllRoles(newRole);
                this.showMessage(this.addSuccess);

                return newRole;

                // Если роль не была создана
            } else {
                this.showMessage(this.addError, true);

                return false;
            }
        }
    }
};
</script>

<style lang="sass">
.RolesControlEditModal
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
