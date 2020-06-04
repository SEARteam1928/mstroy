<template>
    <div class="WorkSessionsPeriod">
        <div class="WorkSessionsPeriod-header">Выбор периода</div>
        <PeriodDatepickerInput
            class="PeriodDatepickerInput"
            clickableInput
            align="right"
            panel="range"
            :from="selectedPeriod.from"
            :to="selectedPeriod.to"
            @input="onPeriodInput"
        />
    </div>
</template>

<script>
import PeriodDatepickerInput from '../common/PeriodDatepickerInput.vue';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'WorkSessionsPeriod',
    components: {
        PeriodDatepickerInput
    },
    computed: {
        ...mapGetters('WorkSessions', ['selectedPeriod'])
    },
    methods: {
        ...mapMutations('WorkSessions', ['setSelectedPeriod']),

        onPeriodInput(prop) {
            this.setSelectedPeriod(prop);
        }
    }
};
</script>

<style lang="sass">
.WorkSessionsPeriod
    display: flex
    align-items: center
    &-header
            font-size: 16px
            line-height: 18px
            font-weight: 600
            margin-right: 16px
    .PeriodDatepickerInput
        width: 250px
        z-index: 1
        &-input:not(:focus):not(:active)
            border: 1px solid rgba(0,0,0,0.24)
</style>
