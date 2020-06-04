<template>
    <q-card-section class="WorkSessionsEditModal-dateSection">
        <PeriodDatepickerInput
            class="PeriodDatepickerInput"
            clickableInput
            clearable
            dense
            align="top middle"
            panel="range"
            label="Выбор даты"
            :from="start_date"
            :to="finish_date"
            @input="onInput"
            @reset="onReset"
        />
    </q-card-section>
</template>

<script>
import PeriodDatepickerInput from '@components/common/PeriodDatepickerInput.vue';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'DateSection',
    components: {
        PeriodDatepickerInput
    },
    computed: {
        ...mapGetters('WorkSessions', ['editModalData']),

        start_date() {
            return this.editModalData.start_date;
        },
        finish_date() {
            return this.editModalData.finish_date;
        }
    },
    methods: {
        ...mapMutations('WorkSessions', ['setEditModalData']),

        onInput(prop) {
            let { from, to } = prop;

            this.setEditModalData({
                start_date: from,
                finish_date: to
            });
        },
        onReset() {
            this.setEditModalData({
                start_date: null,
                finish_date: null
            });
        }
    }
};
</script>

<style lang="sass">
.WorkSessionsEditModal
    &-dateSection
</style>
