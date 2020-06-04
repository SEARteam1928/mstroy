<template>
    <q-card-section class="RolesControlEditModal-nameSection">
        <q-input outlined dense clearable label="Название" v-model="nameModel" />
    </q-card-section>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'NameSection',
    computed: {
        ...mapGetters('RolesControl', ['editRoleModalData']),

        nameModel: {
            get() {
                return this.editRoleModalData.name;
            },
            set(name) {
                this.setEditRoleModalData({ name });
            }
        }
    },
    methods: {
        ...mapMutations('RolesControl', ['setEditRoleModalData'])
    }
};
</script>
