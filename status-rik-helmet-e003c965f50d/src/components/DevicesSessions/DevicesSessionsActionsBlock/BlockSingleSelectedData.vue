<template>
    <div class="BlockSingleSelectedData">
        <div class="BlockSingleSelectedData-header">
            <div class="BlockSingleSelectedData-title">Данные</div>
            <q-btn
                class="BlockSingleSelectedSessions-lastDataBtn"
                dense
                no-caps
                unelevated
                :label="lastDataBtnTitle"
                color="ms-primary"
                outline
            />
        </div>

        <div class="BlockSingleSelectedData-subHeader">
            Данные за период времени:
        </div>
        <PeriodTimePicker class="PeriodTimePicker" dense toISO @change="onChangePeriod" />
        <div class="BlockSingleSelectedData-actionSection">
            <q-btn
                class="BlockSingleSelectedSessions-showDataBtn"
                dense
                no-caps
                unelevated
                label="Показать"
                color="ms-primary"
            />
            <q-btn
                class="BlockSingleSelectedSessions-saveDataBtn"
                dense
                no-caps
                label="Сохранить в .CSV"
                color="ms-primary"
                outline
            />
        </div>
    </div>
</template>

<script>
import PeriodTimePicker from '@components/common/PeriodTimePicker.vue';
export default {
    name: 'BlockSingleSelectedData',
    components: {
        PeriodTimePicker
    },
    computed: {
        lastDataBtnTitle() {
            return `Последние 50 пакетов`;
        }
    },
    methods: {
        onChangePeriod() {}
    }
};
</script>

<style lang="sass">
.BlockSingleSelectedData
    padding: 12px 16px
    &-header
        display: flex
        justify-content: space-between
        align-items: center
        padding-bottom: 8px
    &-title
        font-size: 14px
        font-weight: bold
    &-subHeader
    &-actionSection
        display: flex
        justify-content: space-between
        align-items: center

    .PeriodTimePicker
        width: 100%
        flex-direction: column
        padding: 8px 0
        .period-picker-delimit
            display: none
        &-sectionWrap
            width: 100%
            padding-left: 30px
            padding-right: 0
            position: relative
            &:before
                position: absolute
                top: 0
                bottom: 0
                display: flex
                align-items: center
                left: 0
        &-fromWrap
            padding-bottom: 8px
            &:before
                content: 'c:'
        &-toWrap
            &:before
                content: 'по:'
</style>
