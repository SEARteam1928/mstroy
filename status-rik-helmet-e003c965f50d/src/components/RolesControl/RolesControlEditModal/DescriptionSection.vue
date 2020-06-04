<template>
    <q-card-section class="RolesControlEditModal-descriptionSection">
        <q-input outlined dense clearable label="Описание" v-model="descriptionModel" />
    </q-card-section>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'DescriptionSection',
    computed: {
        ...mapGetters('RolesControl', ['editRoleModalData']),

        descriptionModel: {
            get() {
                return this.editRoleModalData.description;
            },
            set(description) {
                this.setEditRoleModalData({ description });
            }
        }
    },
    methods: {
        ...mapMutations('RolesControl', ['setEditRoleModalData'])
    }
};
</script>
