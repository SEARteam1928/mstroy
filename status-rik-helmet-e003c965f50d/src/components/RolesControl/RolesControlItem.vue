<template>
    <div class="RolesControlItem">
        <div class="RolesControlItem-username">{{ role.name }} | {{ role.description }}</div>

        <RolesControlItemMoreAction
            v-if="checkScenarios(['RolesControl/EditRoles', 'RolesControl/DeleteRoles'])"
            @edit="onEditAction"
            @delete="onDeleteAction"
        />
    </div>
</template>

<script>
import RolesControlItemMoreAction from './RolesControlItem/RolesControlItemMoreAction.vue';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'RolesControlItem',
    components: {
        RolesControlItemMoreAction
    },
    props: {
        role: {
            type: Object,
            required: true
        }
    },
    computed: {
        ...mapGetters('User', ['checkScenarios'])
    },
    methods: {
        ...mapMutations('RolesControl', [
            'setOpenEditRoleModal',
            'setEditRoleModalData',
            'setOpenDeleteRoleModal',
            'setDeleteRoleModalData'
        ]),

        onEditAction() {
            let { rowId, name, description, users, scenarios } = this.role;
            let _scenarios = scenarios.map(scenario => {
                let resultScenario = {};

                resultScenario = {
                    ...scenario,
                    // Если у сценария в данных модалки редактирования не будет заполнено поле rootName,
                    // то будут баги при добавлении/удалении сценариев роли
                    rootName: scenario.rootName ? scenario.rootName : scenario.name
                };

                return resultScenario;
            });

            this.setEditRoleModalData({
                id: Number(rowId),
                name,
                description,
                users,
                scenarios: _scenarios,
                step: 'role'
            });

            this.setOpenEditRoleModal(true);
        },

        onDeleteAction() {
            let { role } = this;

            this.setDeleteRoleModalData({
                id: Number(role.rowId),
                role
            });

            this.setOpenDeleteRoleModal(true);
        }
    }
};
</script>

<style lang="sass">
.RolesControlItem
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
