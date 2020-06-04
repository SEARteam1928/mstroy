<template>
    <div class="RoleCheckboxItem">
        <q-checkbox class="RoleCheckboxItem-checkbox" v-model="checkboxModel" :label="role.description" />
    </div>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'RoleCheckboxItem',
    props: {
        role: {
            type: Object,
            required: true
        }
    },
    computed: {
        ...mapGetters('UsersControl', ['editUserModalData']),

        checkboxModel: {
            get() {
                let checked = false;
                let { roles } = this.editUserModalData;
                let roleIndex = roles.findIndex(({ rowId }) => rowId === this.role.rowId);
                if (roleIndex > -1) checked = true;

                return checked;
            },
            set(value) {
                this.$emit('input', {
                    value,
                    id: this.role.rowId
                });
            }
        }
    }
};
</script>

<style lang="sass">
.RoleCheckboxItem
</style>
