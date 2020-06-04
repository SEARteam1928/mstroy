<template>
    <q-page class="RolesControl-page page-background">
        <div class="RolesControl page-block">
            <DataPreloader :loading="!dataReady" :vertical="true">
                <q-scroll-area
                    class="RolesControl-list"
                    :thumb-style="{ 'transition': 'top 100ms ease, opacity 300ms' }"
                >
                    <RolesControlItem class="RolesControlItem" v-for="role in allRoles" :key="role.id" :role="role" />
                </q-scroll-area>
            </DataPreloader>
        </div>

        <!-- Кнопка добавления роли -->
        <q-page-sticky
            v-if="checkScenarios('RolesControl/CreateNewRoles')"
            class="RolesControl-fab-wrap"
            position="bottom-right"
            :offset="offset"
        >
            <q-btn class="RolesControl-fab" fab icon="add" color="pink" @click="onClickFAB">
                <q-tooltip anchor="center left" self="center right">Добавить новую роль</q-tooltip>
            </q-btn>
        </q-page-sticky>

        <!-- Модалка добавления/редактирования роли -->
        <RolesControlEditModal v-if="checkScenarios(['RolesControl/CreateNewRoles', 'RolesControl/EditRoles'])" />

        <!-- Модалка удаления роли -->
        <RolesControlDeleteModal v-if="checkScenarios('RolesControl/DeleteRoles')" />
    </q-page>
</template>

<script>
import DataPreloader from '@components/common/DataPreloader.vue';
import RolesControlItem from '@components/RolesControl/RolesControlItem.vue';
import RolesControlEditModal from '@components/RolesControl/RolesControlEditModal.vue';
import RolesControlDeleteModal from '@components/RolesControl/RolesControlDeleteModal.vue';

import withModuleErrors from '@mixins/withModuleErrors';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'RolesControl',
    components: {
        DataPreloader,
        RolesControlItem,
        RolesControlEditModal,
        RolesControlDeleteModal
    },
    mixins: [withModuleErrors('RolesControl')],
    data() {
        return {
            offset: [75, 16]
        };
    },
    computed: {
        ...mapGetters('RolesControl', ['allRoles', 'allScenarios']),
        ...mapGetters('User', ['checkScenarios']),

        dataReady() {
            return this.allRoles.length > 0 && this.allScenarios.length > 0;
        }
    },
    async created() {
        window.RolesControl = this;

        await this.requestAllRoles();
        await this.requestAllScenarios();
    },
    beforeDestroy() {
        this.clearEditRoleModalData();
        this.setOpenEditRoleModal(false);

        this.clearDeleteRoleModalData();
        this.setOpenDeleteRoleModal(false);
    },
    methods: {
        ...mapMutations('RolesControl', [
            'setOpenEditRoleModal',
            'clearEditRoleModalData',
            'setOpenDeleteRoleModal',
            'clearDeleteRoleModalData'
        ]),
        ...mapActions('RolesControl', ['requestAllRoles', 'requestAllScenarios']),

        onClickFAB() {
            this.clearEditRoleModalData();
            this.setOpenEditRoleModal(true);
        }
    }
};
</script>

<style lang="sass">
.RolesControl
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
