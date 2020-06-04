<template>
    <MoreActionBtn class="UsersControlItemMoreAction">
        <q-list>
            <!-- Редактировать -->
            <q-item
                v-if="checkScenarios('UsersControl/EditUsers')"
                class="UsersControlItemMoreAction-item UsersControlItemMoreAction-item-edit"
                clickable
                v-close-popup
                @click="$emit('edit')"
            >
                <q-item-section avatar>
                    <q-icon name="edit" />
                </q-item-section>
                <q-item-section>
                    <q-item-label>Редактировать</q-item-label>
                </q-item-section>
            </q-item>

            <q-separator v-if="checkScenarios(['UsersControl/EditUsers', 'UsersControl/DeleteUsers'], true)" inset />

            <!-- Удалить -->
            <q-item
                v-if="checkScenarios('UsersControl/DeleteUsers')"
                class="UsersControlItemMoreAction-item UsersControlItemMoreAction-item-delete"
                clickable
                v-close-popup
                @click="$emit('delete')"
            >
                <q-item-section avatar>
                    <q-icon name="delete" />
                </q-item-section>
                <q-item-section>
                    <q-item-label>Удалить</q-item-label>
                </q-item-section>
            </q-item>
        </q-list>
    </MoreActionBtn>
</template>

<script>
import MoreActionBtn from '@components/common/MoreActionBtn.vue';

import { mapGetters } from 'vuex';

export default {
    name: 'UsersControlItemMoreAction',
    components: {
        MoreActionBtn
    },
    computed: {
        ...mapGetters('User', ['checkScenarios'])
    }
};
</script>
