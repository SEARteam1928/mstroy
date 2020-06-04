<template>
    <div class="GroupsControlActionsBlockActions">
        <q-btn
            class="GroupsControlActionsBlockActions-addChildrenGroupBtn"
            unelevated
            outline
            label="Добавить дочернюю группу"
            color="ms-blue"
            @click="onAddChildrenGroupBtnClick"
        />

        <q-btn
            class="GroupsControlActionsBlockActions-editGroupBtn"
            unelevated
            flat
            :label="editGroupBtnLabel"
            color="ms-primary"
            @click="onEditGroupBtnClick"
        />
        <q-btn
            class="GroupsControlActionsBlockActions-deleteGroupBtn"
            unelevated
            flat
            :label="deleteGroupBtnLabel"
            color="ms-red"
            @click="onDeleteGroupBtnClick"
        />
    </div>
</template>

<script>
import withShowMessage from '@mixins/withShowMessage';
import isFalse from '@services/utils/isFalse';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'GroupsControlActionsBlockActions',
    mixins: [withShowMessage()],
    computed: {
        ...mapGetters('GroupsControl', ['selectedGroupId', 'selectedGroup']),

        editGroupBtnLabel() {
            return this.isConfirmDeleteGroup ? 'Подтвердить удаление' : 'Редактировать';
        },
        deleteGroupBtnLabel() {
            return this.isConfirmDeleteGroup ? 'Отмена' : 'Удалить';
        }
    },
    watch: {
        selectedGroupId() {
            this.isConfirmDeleteGroup = false;
        }
    },
    data() {
        return {
            isConfirmDeleteGroup: false
        };
    },
    methods: {
        ...mapMutations('GroupsControl', ['setIsOpenEditGroupModal', 'setEditGroupModalData']),
        ...mapActions('GroupsControl', ['requestDeleteAccessGroups']),

        onAddChildrenGroupBtnClick() {
            this.setEditGroupModalData({ parentAccessGroupId: this.selectedGroupId });
            this.setIsOpenEditGroupModal(true);
        },
        onEditGroupBtnClick() {
            if (!this.isConfirmDeleteGroup) {
                this.editGroupHandler();
            } else {
                this.deleteGroupHandler();
            }
        },
        editGroupHandler() {
            let { rowId: id, name, parentAccessGroupId, ruleIds, userIds } = this.selectedGroup;
            this.setEditGroupModalData({ id, name, parentAccessGroupId, ruleIds, userIds });
            this.setIsOpenEditGroupModal(true);
        },
        async deleteGroupHandler() {
            this.isConfirmDeleteGroup = false;

            let { name } = this.selectedGroup;
            let res = await this.requestDeleteAccessGroups(this.selectedGroupId);
            if (isFalse(res)) {
                this.showMessage(`Ошибка удаления группы "${name}"`, true);
            } else {
                this.showMessage(`Группа "${name}" успешно удалена`);
            }
        },
        onDeleteGroupBtnClick() {
            if (!this.isConfirmDeleteGroup) {
                this.isConfirmDeleteGroup = true;
                return;
            }

            this.isConfirmDeleteGroup = false;
        }
    }
};
</script>

<style lang="sass">
.GroupsControlActionsBlockActions
    padding: 12px
    border-top: 1px solid var(--ms-grey)
    display: flex
    flex-wrap: wrap
    justify-content: space-between
    &-addChildrenGroupBtn
        width: 100%
        margin-bottom: 8px
</style>
