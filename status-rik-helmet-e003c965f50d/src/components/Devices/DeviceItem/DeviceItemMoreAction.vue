<template>
    <MoreActionBtn class="DeviceItem-actions">
        <q-list>
            <!-- Редактировать -->
            <q-item
                v-if="checkScenarios('Devices/EditDevice')"
                class="DeviceItem-actions-btn-item"
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

            <!-- Удалить -->
            <q-item
                v-if="checkScenarios('Devices/DeleteDevice')"
                class="DeviceItem-actions-btn-item"
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

            <q-separator v-if="checkScenarios(['Devices/EditDevice', 'Devices/DeleteDevice'])" inset />

            <!-- Данные -->
            <q-item class="DeviceItem-actions-btn-item" clickable v-close-popup @click="$emit('data')">
                <q-item-section avatar>
                    <q-icon name="settings_ethernet" />
                </q-item-section>
                <q-item-section>
                    <q-item-label>Данные</q-item-label>
                </q-item-section>
            </q-item>
        </q-list>
    </MoreActionBtn>
</template>

<script>
import MoreActionBtn from '@components/common/MoreActionBtn.vue';

import { mapGetters } from 'vuex';

export default {
    name: 'DeviceItemMoreAction',
    components: {
        MoreActionBtn
    },
    computed: {
        ...mapGetters('User', ['checkScenarios'])
    }
};
</script>
