<template>
    <!-- Выводит не пустые ячейки с данными о часах -->
    <q-td
        v-if="showCell && !isEmpty && isHoursData"
        class="MonthTableTableTdRender MonthTableTableTdRender-hoursData"
        :class="{ [`MonthTableTableTdRender-${customClassName}`]: isCustomCell }"
        :props="{ value, row, col }"
    >
        <MonthTableTableBadge class="MonthTableTableBadgeExcel" :value="value.excel_hours" type="excel" />
        <MonthTableTableBadge class="MonthTableTableBadgeDevice" :value="value.device_hours" type="device" />
    </q-td>

    <!-- Выводит не пустые ячейки, в которых может быть простое текстовое содержимое или кастомное форматирование -->
    <q-td
        v-else-if="showCell && !isEmpty && !isHoursData"
        class="MonthTableTableTdRender"
        :class="{
            'MonthTableTableTdRender-hasTitle': hasTitle,
            [`MonthTableTableTdRender-${customClassName}`]: isCustomCell
        }"
        :title="hasTitle && value.title"
        :props="{ value, row, col }"
    >
        {{ cellValue }}
    </q-td>

    <!-- Выводит пустые ячейки -->
    <q-td
        v-else-if="showCell"
        class="MonthTableTableTdRender MonthTableTableTdRender-isEmpty"
        :class="{ [`MonthTableTableTdRender-${customClassName}`]: isCustomCell }"
        :props="{ value, row, col }"
    ></q-td>
</template>

<script>
import MonthTableTableBadge from './MonthTableTableBadge.vue';

export default {
    name: 'MonthTableTableTdRender',
    components: {
        MonthTableTableBadge
    },
    props: {
        value: {
            required: true
        },
        row: {
            type: Object,
            required: true
        },
        col: {
            type: Object,
            required: true
        }
    },
    computed: {
        isEmpty() {
            let result = false;

            if (this.isHoursData && this.value.excel_hours === 0 && this.value.device_hours === 0 && !this.value.active)
                result = true;

            return result;
        },
        isHoursData() {
            let result = false;
            if (
                this.value instanceof Object &&
                this.value.excel_hours !== undefined &&
                this.value.device_hours !== undefined
            )
                result = true;

            return result;
        },

        hasTitle() {
            let result = false;
            if (this.value instanceof Object && this.value.title !== undefined && this.value.value !== undefined)
                result = true;

            return result;
        },

        isCustomCell() {
            return this.value instanceof Object && this.value.custom;
        },

        customClassName() {
            let className = '';

            if (this.isCustomCell) {
                className = `${this.value.cell_type}-${this.value.cell}`;
            }

            return className;
        },

        cellValue() {
            let value = '';

            if (this.value instanceof Object && this.value.value !== undefined) {
                value = this.value.value;
            } else if (typeof this.value === 'string' || typeof this.value === 'number') {
                value = this.value;
            }

            return value;
        },

        colspan() {
            let colspan = 1;
            if (this.value instanceof Object && this.value.colspan !== undefined) colspan = this.value.colspan;

            return colspan;
        },

        showCell() {
            let show = true;
            if (this.value instanceof Object && this.value.render === false) show = false;

            return show;
        }
    }
};
</script>

<style lang="sass">
td.MonthTableTableTdRender
    &.MonthTableTableTdRender-hoursData
        padding: 2px 2px
    .MonthTableTableBadgeWrap
        width: 100%
        display: flex
        justify-content: center
    .MonthTableTableBadgeExcel
        margin-bottom: 1px
        display: block
    .MonthTableTableBadgeDevice
        display: block
</style>
