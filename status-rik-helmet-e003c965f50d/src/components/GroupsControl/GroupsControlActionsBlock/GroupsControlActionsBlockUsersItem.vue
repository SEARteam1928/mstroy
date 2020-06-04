<template>
    <div class="GroupsControlActionsBlockUsersItem">
        <div class="GroupsControlActionsBlockUsersItem-name">{{ user.username }}</div>
        <div class="GroupsControlActionsBlockUsersItem-actions">
            <MiniBtnDelete v-if="!isDeleteUser" :size="10" @click="onDeleteBtnClick" />

            <MiniBtnDone v-if="isDeleteUser" class="MiniBtnDone" :size="10" @click="$emit('delete', user)" />
            <MiniBtnClose v-if="isDeleteUser" :size="10" @click="onCloseBtnClick" />
        </div>
    </div>
</template>

<script>
import MiniBtnDelete from '@components/common/MiniBtn/MiniBtnDelete.vue';
import MiniBtnDone from '@components/common/MiniBtn/MiniBtnDone.vue';
import MiniBtnClose from '@components/common/MiniBtn/MiniBtnClose.vue';

export default {
    name: 'GroupsControlActionsBlockUsersItem',
    components: {
        MiniBtnDelete,
        MiniBtnDone,
        MiniBtnClose
    },
    props: {
        user: {
            type: Object,
            required: true
        }
    },
    data() {
        return {
            isDeleteUser: false
        };
    },
    methods: {
        onDeleteBtnClick() {
            this.isDeleteUser = true;
        },
        onCloseBtnClick() {
            this.isDeleteUser = false;
        }
    }
};
</script>

<style lang="sass">
.GroupsControlActionsBlockUsersItem
    display: flex
    justify-content: space-between
    padding: 4px 8px
    margin-bottom: 4px
    cursor: default
    transition: background-color 250ms ease-in-out
    &:hover
        background-color: var(--ms-light-grey)
    &-name
    &-actions
        opacity: 0
        transition: opacity 150ms ease-in-out
        & > .MiniBtnDone
            margin-right: 4px

// Состояние при ховере на сам айтем
.GroupsControlActionsBlockUsersItem
    &:hover
        .GroupsControlActionsBlockUsersItem
            &-actions
                opacity: 1
</style>
