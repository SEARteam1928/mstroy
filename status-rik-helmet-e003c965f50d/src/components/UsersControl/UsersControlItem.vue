<template>
    <div class="UsersControlItem">
        <div class="UsersControlItem-username">{{ user.username }}</div>

        <UsersControlItemMoreAction
            v-if="checkScenarios(['UsersControl/EditUsers', 'UsersControl/DeleteUsers'])"
            @edit="onEditAction"
            @delete="onDeleteAction"
        />
    </div>
</template>

<script>
import UsersControlItemMoreAction from './UsersControlItem/UsersControlItemMoreAction.vue';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'UsersControlItem',
    components: {
        UsersControlItemMoreAction
    },
    props: {
        user: {
            type: Object,
            required: true
        }
    },
    computed: {
        ...mapGetters('User', ['checkScenarios'])
    },
    methods: {
        ...mapMutations('UsersControl', [
            'setOpenEditUserModal',
            'setEditUserModalData',
            'setOpenDeleteUserModal',
            'setDeleteUserModalData'
        ]),

        onEditAction() {
            let { rowId, email, username, active, roles } = this.user;

            this.setEditUserModalData({
                id: rowId,
                email,
                username,
                password: '',
                active,
                roles,
                step: 'user'
            });

            this.setOpenEditUserModal(true);
        },

        onDeleteAction() {
            let { user } = this;

            this.setDeleteUserModalData({
                id: user.rowId,
                user
            });

            this.setOpenDeleteUserModal(true);
        }
    }
};
</script>

<style lang="sass">
.UsersControlItem
    width: 100%
    min-height: 75px
    display: flex
    align-items: center
    justify-content: space-between
    border: 1px solid #888
    border-radius: 4px
    margin-bottom: 10px
    padding: 6px
    background-color: #fff
</style>
