<template>
    <div class="GroupsControlActionsBlockUsers">
        <div class="GroupsControlActionsBlockUsers-title">Пользователи в группе</div>
        <GroupsControlActionsBlockUsersItem
            v-for="user in selectedGroupUsers"
            :key="user.rowId"
            :user="user"
            @delete="onUserDelete"
        />

        <div class="GroupsControlActionsBlockUsers-actions">
            <q-btn
                v-if="!addUserActive"
                class="GroupsControlActionsBlockUsers-addUserBtn"
                dense
                no-caps
                flat
                label="Добавить пользователя"
                color="ms-primary"
                @click="onAddUserBtnClick"
            />

            <WorkerPicker
                v-if="addUserActive"
                open
                :workers="availableUsers"
                nodeKey="rowId"
                labelKey="username"
                @input="onUserSelect"
                @hide="onWorkerPickerClose"
            />
        </div>
    </div>
</template>

<script>
import GroupsControlActionsBlockUsersItem from './GroupsControlActionsBlockUsersItem.vue';
import WorkerPicker from '@components/common/WorkerPicker.vue';

import withShowMessage from '@mixins/withShowMessage';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'GroupsControlActionsBlockUsers',
    components: {
        GroupsControlActionsBlockUsersItem,
        WorkerPicker
    },
    mixins: [withShowMessage()],
    computed: {
        ...mapGetters('GroupsControl', ['selectedGroupId', 'selectedGroup', 'allUsers']),

        selectedGroupUsers() {
            if (!this?.selectedGroup?.associationUsers) return [];

            return this.selectedGroup.associationUsers.map(({ user }) => user);
        },
        selectedGroupUsersIdSet() {
            if (!this?.selectedGroup?.userIds) return new Set();

            return new Set(this.selectedGroup.userIds);
        },
        availableUsers() {
            return this.allUsers.filter(({ rowId }) => !this.selectedGroupUsersIdSet.has(rowId));
        }
    },
    data() {
        return {
            addUserActive: false
        };
    },
    methods: {
        ...mapMutations('GroupsControl', ['updateAccessGroup']),
        ...mapActions('GroupsControl', ['requestUpdateAccessGroup']),

        async onUserDelete(user) {
            // Убираем id удаляемого юзера из массива юзеров у роли
            let userIds = this.selectedGroup.userIds.filter(userId => userId !== user.rowId);

            // Собираем данные для обновления группы
            let { rowId: id, name, parentAccessGroupId, ruleIds } = this.selectedGroup;
            let newGroupData = { id, name, parentAccessGroupId, ruleIds, userIds };

            let res = await this.requestUpdateAccessGroup(newGroupData);

            if (res) {
                this.showMessage(`Пользователь ${user.username} удален из группы "${name}"`);
            } else {
                this.showMessage(`Ошибка удаления пользователя ${user.username} из группы "${name}"`, true);
            }
        },
        onAddUserBtnClick() {
            this.addUserActive = true;
        },
        async onUserSelect(user) {
            // Добавляем id выбранного юзера к имеющемуся массиву юзеров
            let userIds = [...this.selectedGroup.userIds, user.rowId];

            // Собираем данные для обновления группы
            let { rowId: id, name, parentAccessGroupId, ruleIds } = this.selectedGroup;
            let newGroupData = { id, name, parentAccessGroupId, ruleIds, userIds };

            let res = await this.requestUpdateAccessGroup(newGroupData);

            if (res) {
                this.showMessage(`Пользователь ${user.username} добавлен в группу "${name}"`);
            } else {
                this.showMessage(`Ошибка добавления пользователя ${user.username} в группу "${name}"`, true);
            }
        },
        onWorkerPickerClose() {
            this.addUserActive = false;
        }
    }
};
</script>

<style lang="sass">
.GroupsControlActionsBlockUsers
    padding: 12px
    &-title
        font-weight: bold
        margin-bottom: 8px
    &-actions
        display: flex
        justify-content: flex-end
</style>
