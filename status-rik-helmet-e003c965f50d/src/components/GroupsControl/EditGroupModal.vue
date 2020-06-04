<template>
    <Modal
        contentClass="EditGroupModal"
        v-model="isOpenEditGroupModalModel"
        persistent
        @hide="onModalHide"
        @show="onModalShow"
    >
        <template v-slot:title>
            {{ modalTitle }}
        </template>

        <template v-slot:body>
            <div class="EditGroupModal-section">
                <div class="EditGroupModal-sectionLabel">Название</div>
                <div class="EditGroupModal-sectionAction">
                    <input
                        class="EditGroupModal-input"
                        type="text"
                        placeholder="Введите название группы"
                        v-model="groupNameModel"
                        ref="input"
                        @keypress.enter="onInputKeypressEnter"
                    />
                </div>
            </div>
        </template>

        <template v-slot:actions>
            <q-btn
                v-if="isCreateMode"
                class="EditGroupModal-addGroupBtn"
                unelevated
                label="Добавить группу"
                color="ms-primary"
                :disable="!hasName"
                @click="onAddGroupBtnClick"
            />
            <q-btn
                v-if="!isCreateMode"
                class="EditGroupModal-editGroupBtn"
                unelevated
                label="Редактировать группу"
                color="ms-primary"
                :disable="!hasName"
                @click="onEditGroupBtnClick"
            />
        </template>
    </Modal>
</template>

<script>
import Modal from '@components/common/Modal.vue';

import withShowMessage from '@mixins/withShowMessage';
import isFalse from '@services/utils/isFalse';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'EditGroupModal',
    components: {
        Modal
    },
    mixins: [withShowMessage()],
    computed: {
        ...mapGetters('GroupsControl', ['isOpenEditGroupModal', 'editGroupModalData']),

        isOpenEditGroupModalModel: {
            get() {
                return this.isOpenEditGroupModal;
            },
            set(val) {
                this.setIsOpenEditGroupModal(!!val);
            }
        },

        hasName() {
            return this.editGroupModalData?.name?.length > 0;
        },

        isCreateMode() {
            return isFalse(this.editGroupModalData.id);
        },

        modalTitle() {
            return this.isCreateMode ? 'Добавление группы' : 'Редактирование группы';
        },

        groupNameModel: {
            get() {
                return this.editGroupModalData.name;
            },
            set(val) {
                this.setEditGroupModalData({ name: val });
            }
        }
    },
    methods: {
        ...mapMutations('GroupsControl', [
            'setIsOpenEditGroupModal',
            'setEditGroupModalData',
            'clearEditGroupModalData'
        ]),
        ...mapActions('GroupsControl', ['requestCreateAccessGroup', 'requestUpdateAccessGroup']),

        onModalHide() {
            this.clearEditGroupModalData();
        },
        onModalShow() {
            this.$refs?.input?.focus();
        },

        onInputKeypressEnter() {
            if (!this.hasName) return;

            this.isCreateMode ? this.onAddGroupBtnClick() : this.onEditGroupBtnClick();
        },

        async onAddGroupBtnClick() {
            let { name } = this.editGroupModalData;
            let res = await this.requestCreateAccessGroup();

            if (res) {
                this.showMessage(`Группа "${name}" успешно создана`);

                this.setIsOpenEditGroupModal(false);
            } else {
                this.showMessage(`Ошибка создания группы "${name}"`, true);
            }
        },

        async onEditGroupBtnClick() {
            let { name } = this.editGroupModalData;
            let res = await this.requestUpdateAccessGroup();

            if (res) {
                this.showMessage(`Группа "${name}" успешно изменена`);

                this.setIsOpenEditGroupModal(false);
            } else {
                this.showMessage(`Ошибка изменения группы "${name}"`, true);
            }
        }
    }
};
</script>

<style lang="sass">
.EditGroupModal
    &-section
        display: flex
        align-items: center
    &-sectionLabel
        width: 100px
        max-width: 100px
        font-weight: bold
        margin-right: 8px
    &-sectionAction
        width: 100%
        flex-grow: 1
    &-input
        width: 100%
        height: 48px
        padding: 8px 16px
        border-radius: 4px
        border: 1px solid var(--ms-grey)
        color: var(--ms-dark)
        background-color: #fff
        transition: background-color 250ms ease-in-out
        &::placeholder
            color: var(--ms-grey)
        &:focus
            background-color: var(--ms-light-grey)
            outline: none
    &-addGroupBtn
        padding: 0 16px

    .Modal-card
        min-width: 450px
</style>
