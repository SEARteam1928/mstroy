<template>
    <div class="UsersControlEditModal-RolePanel">
        <q-card-section class="UsersControlEditModal-roleSection">
            <div class="UsersControlEditModal-title">Назначение ролей</div>

            <q-scroll-area
                class="UsersControlEditModal-roleWrapScroll"
                :thumb-style="{ 'transition': 'top 100ms ease, opacity 300ms' }"
            >
                <RoleCheckboxItem
                    class="RoleCheckboxItem"
                    v-for="role in allRoles"
                    :key="role.rowId"
                    :role="role"
                    @input="onRoleCheckboxInput"
                />
            </q-scroll-area>
        </q-card-section>
    </div>
</template>

<script>
import RoleCheckboxItem from './RoleCheckboxItem.vue';

import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'RolePanel',
    components: {
        RoleCheckboxItem
    },
    computed: {
        ...mapGetters('UsersControl', ['editUserModalData']),
        ...mapGetters('RolesControl', ['allRoles', 'getRoleById'])
    },
    methods: {
        ...mapMutations('UsersControl', ['setEditUserModalData']),

        onRoleCheckboxInput(payload) {
            let { value, id } = payload;

            // Если галочка устанавливается на роль
            if (value) {
                this.addRoleToModalData(id);

                // Если галочка снимается с роли
            } else {
                this.removeRoleFromModalData(id);
            }
        },

        addRoleToModalData(id) {
            let role = this.getRoleById(id);
            if (role) {
                let { roles } = this.editUserModalData;
                this.setEditUserModalData({
                    roles: [...roles, role]
                });
            }
        },
        removeRoleFromModalData(id) {
            let { roles } = this.editUserModalData;
            let newRoles = roles.filter(({ rowId }) => rowId !== id);

            this.setEditUserModalData({
                roles: newRoles
            });
        }
    }
};
</script>

<style lang="sass">
.UsersControlEditModal
    &-RolePanel
        height: 100%
        display: flex
        flex-direction: column
        overflow: hidden
        .UsersControlEditModal
            &-roleSection
                padding: 0
                display: flex
                flex-direction: column
                flex-grow: 1
                overflow: hidden
            &-roleWrapScroll
                display: flex
                flex-direction: column
                flex-grow: 1
                overflow: hidden
                margin-top: 10px
                border: 1px solid rgba(0,0,0,0.24)
                border-radius: 4px
                padding: 14px
                padding-left: 0

                // Для того, чтобы содержимое q-scroll-area не схлопнулось в 0 по высоте,
                // потому что сам контент в ней размещается абсолютом,
                // нужно явно задать высоту, при этом, указанное такое большое значение не будет столько занимать по высоте,
                // а ограничится высотой контента, но на практике выяснил,
                // что значение высоты здесь должно быть больше фактической высоты контента
                & > .scroll
                    height: 100000px !important
</style>
