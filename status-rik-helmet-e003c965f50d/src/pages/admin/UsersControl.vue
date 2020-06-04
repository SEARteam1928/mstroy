<template>
    <q-page class="UsersControl-page page-background">
        <div class="UsersControl page-block">
            <DataPreloader :loading="!allUsers.length" :vertical="true">
                <q-scroll-area
                    class="UsersControl-list"
                    :thumb-style="{ 'transition': 'top 100ms ease, opacity 300ms' }"
                >
                    <UsersControlItem class="UsersControlItem" v-for="user in allUsers" :key="user.id" :user="user" />
                </q-scroll-area>
            </DataPreloader>
        </div>

        <!-- Кнопка добавления пользователя -->
        <q-page-sticky
            v-if="checkScenarios('UsersControl/CreateNewUsers')"
            class="UsersControl-fab-wrap"
            position="bottom-right"
            :offset="offset"
        >
            <q-btn class="UsersControl-fab" fab icon="add" color="pink" @click="onClickFAB">
                <q-tooltip anchor="center left" self="center right">Добавить нового пользователя</q-tooltip>
            </q-btn>
        </q-page-sticky>

        <!-- Модалка добавления/редактирования пользователя -->
        <UsersControlEditModal v-if="checkScenarios(['UsersControl/CreateNewUsers', 'UsersControl/EditUsers'])" />

        <!-- Модалка удаления пользователя -->
        <UsersControlDeleteModal v-if="checkScenarios('UsersControl/DeleteUsers')" />

        <!-- Модалка добавления роли -->
        <RolesControlEditModal v-if="checkScenarios(['RolesControl/CreateNewRoles'])" />
    </q-page>
</template>

<script>
import DataPreloader from '@components/common/DataPreloader.vue';
import UsersControlItem from '@components/UsersControl/UsersControlItem.vue';
import UsersControlEditModal from '@components/UsersControl/UsersControlEditModal.vue';
import UsersControlDeleteModal from '@components/UsersControl/UsersControlDeleteModal.vue';
import RolesControlEditModal from '@components/RolesControl/RolesControlEditModal.vue';

import withModuleErrors from '@mixins/withModuleErrors';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'UsersControl',
    components: {
        DataPreloader,
        UsersControlItem,
        UsersControlEditModal,
        UsersControlDeleteModal,
        RolesControlEditModal
    },
    mixins: [withModuleErrors('UsersControl')],
    data() {
        return {
            offset: [75, 16]
        };
    },
    computed: {
        ...mapGetters('UsersControl', ['allUsers']),
        ...mapGetters('User', ['checkScenarios']),

        deleteModalModel: {
            get: function() {
                return this.deleteModalOpen;
            },
            set: function(isOpen) {
                this.setDeleteModalOpen(isOpen);
            }
        }
    },
    async created() {
        window.UsersControl = this;

        await this.requestAllUsers();
        await this.requestAllRoles();
    },
    beforeDestroy() {
        this.clearEditUserModalData();
        this.setOpenEditUserModal(false);

        this.clearDeleteUserModalData();
        this.setOpenDeleteUserModal(false);

        this.clearEditRoleModalData();
        this.setOpenEditRoleModal(false);
    },
    methods: {
        ...mapMutations('UsersControl', [
            'setOpenEditUserModal',
            'clearEditUserModalData',
            'setOpenDeleteUserModal',
            'clearDeleteUserModalData'
        ]),
        ...mapMutations('RolesControl', ['setOpenEditRoleModal', 'clearEditRoleModalData']),
        ...mapActions('UsersControl', ['requestAllUsers']),
        ...mapActions('RolesControl', ['requestAllRoles']),

        onClickFAB() {
            this.clearEditUserModalData();
            this.setOpenEditUserModal(true);
        }
    }
};
</script>

<style lang="sass">
.UsersControl
    display: flex
    flex-direction: column
    flex-grow: 1
    height: calc(100% - 16px)
    max-width: calc(100% - 16px)
    padding:
        top: 16px
        right: 0
        bottom: 8px
        left: 16px
    margin:
        top: 8px
        right: 8px
        bottom: 8px
        left: 8px
    @media only screen and (max-width : 768px)
        max-width: 100%
        height: auto
        margin:
            top: 16px
            right: 0
            bottom: 0
            left: 16px
    &-page
        overflow: hidden
        height: calc( 100vh - var(--header-height) )
        display: flex
        flex-direction: column
        // background-color: #f5f5f5
        @media only screen and (max-width : 768px)
            height: auto
    &-list
        height: 100%
        padding-right: 16px
        flex-grow: 1
        display: flex
        flex-direction: column
        .scroll
            flex-grow: 1
</style>
