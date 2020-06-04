<template>
    <div class="MonthTableTableLegend">
        <div class="MonthTableTableLegend-item">
            <MonthTableTableBadge class="MonthTableTableBadge" type="excel" /> Данные по табелю
        </div>
        <div class="MonthTableTableLegend-item">
            <MonthTableTableBadge class="MonthTableTableBadge" type="device" /> Данные по устройствам
        </div>
    </div>
</template>

<script>
import MonthTableTableBadge from './MonthTableTableBadge.vue';

export default {
    name: 'MonthTableTableLegend',
    components: {
        MonthTableTableBadge
    }
};
</script>

<style lang="sass">
.MonthTableTableLegend
    display: flex
    // flex-direction: column
    &-item
        display: flex
        align-items: center
        margin-right: 10px
        margin-bottom: 4px
    .MonthTableTableBadge
        margin-right: 6px
</style>
