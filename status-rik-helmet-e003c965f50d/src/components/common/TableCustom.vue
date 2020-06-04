<template>
    <div class="TableCustom" :class="{ 'TableCustom-selectable': selectable || multiselect }" ref="TableCustom">
        <div class="TableCustomHeader">
            <div
                v-if="multiselect"
                class="TableCustomHeaderCell cell-checkbox"
                :class="{ 'isShowMasterCheckbox': isShowMasterCheckbox }"
            >
                <q-checkbox dense v-model="masterCheckboxModel" color="ms-primary" />
            </div>
            <div
                class="TableCustomHeaderCell"
                :class="[`cell-${cell.field}`, `flex-${cell.align || 'center'}`]"
                :style="{ 'flex-grow': cell.grow || 1 }"
                v-for="cell in model"
                :key="cell.field"
                :ref="cell.field"
            >
                {{ cell.label }}
            </div>

            <q-resize-observer @resize="onResize" />
        </div>

        <DataPreloader
            class="TableCustom-preloader"
            :loading="loading"
            :loadingMessage="loadingMessage"
            :error="error"
            :errorMessage="errorMessage"
            :warning="warning"
            :warningMessage="warningMessage"
            :info="info"
            :infoMessage="infoMessage"
            :vertical="true"
        >
            <q-scroll-area
                class="TableCustom-scroll"
                :thumb-style="{ 'transition': 'top 100ms ease, opacity 300ms', 'background-color': 'var(--ms-dark)' }"
            >
                <div
                    class="TableCustomRow"
                    :class="{ 'TableCustomRow-selected': isSelectedRow(row[keyField]) }"
                    v-for="row in data"
                    :key="row[keyField] || uid()"
                    @click.exact="onRowClick(row[keyField])"
                    @click.ctrl="onRowCtrlClick(row[keyField])"
                >
                    <div v-if="selectable || multiselect" class="TableCustomCell cell-checkbox" @click.stop>
                        <q-checkbox
                            dense
                            :value="isSelectedRow(row[keyField])"
                            color="ms-primary"
                            @input="onInputRowCheckbox(row[keyField], $event)"
                        />
                    </div>
                    <div
                        class="TableCustomCell"
                        :class="[`cell-${cell.field}`, `flex-${cell.align || 'center'}`]"
                        :style="{
                            'flex-grow': cell.grow || 1,
                            'max-width': `var(--cellsWidth-${cell.field})`
                        }"
                        v-for="cell in model"
                        :key="cell.field"
                        :title="row[cell.field]"
                    >
                        {{ row[cell.field] }}
                    </div>
                </div>
            </q-scroll-area>
        </DataPreloader>
    </div>
</template>

<script>
import DataPreloader from '@components/common/DataPreloader.vue';

import checkIntersectionArrays from '@services/utils/checkIntersectionArrays';

import { uid } from 'quasar';

export default {
    name: 'TableCustom',
    components: {
        DataPreloader
    },
    props: {
        model: {
            type: Array,
            required: true
        },
        data: {
            type: Array,
            required: true
        },
        keyField: {
            type: [Number, String],
            required: true
        },
        loading: {
            type: Boolean,
            required: false,
            default: false
        },
        loadingMessage: {
            type: String,
            required: false
        },
        error: {
            type: Boolean,
            required: false,
            default: false
        },
        errorMessage: {
            type: String,
            required: false
        },
        warning: {
            type: Boolean,
            required: false,
            default: false
        },
        warningMessage: {
            type: String,
            required: false
        },
        info: {
            type: Boolean,
            required: false,
            default: false
        },
        infoMessage: {
            type: String,
            required: false
        },
        selectable: {
            type: Boolean,
            required: false,
            default: false
        },
        multiselect: {
            type: Boolean,
            required: false,
            default: false
        }
    },
    data() {
        return {
            uid,
            // selectedSetTrigger - это хак для реактивности Vue,
            // механизмы которой не поддерживают отслеживание изменений в типах Set и Map.
            // При любых изменениях этих типов нужно изменять этот триггер.
            // Так же при использовании этих типов в computed полях, нужно задействовать проверку этого триггера
            selectedSetTrigger: 1,
            selected: new Set()
        };
    },
    computed: {
        isSelectedRow() {
            return rowId => this.selectedSetTrigger && this.selected.has(rowId);
        },
        allDataKeys() {
            return this.data.map(el => el[this.keyField]);
        },
        masterCheckboxModel: {
            get() {
                return this.selectedSetTrigger && checkIntersectionArrays(this.allDataKeys, [...this.selected]);
            },
            set(val) {
                if (val) {
                    this.selectAll();
                } else {
                    this.clearSelected();
                }
            }
        },
        isShowMasterCheckbox() {
            return this.masterCheckboxModel !== false;
        }
    },
    methods: {
        // Вызывается при изменении размеров шапки таблицы. Проходит циклом по ячейкам таблицы,
        // собирает их ширину и через css-переменные назначает соответствующую ширину ячеек в строках таблицы.
        // Это нужно чтобы столбцы таблицы не разваливались по вертикали, а были все одинаковой ширины
        onResize(size) {
            let { TableCustom } = this.$refs;
            if (!TableCustom) return;

            // Цикл по модели, чтобы получить имена ячеек шапки
            this.model.forEach(({ field }) => {
                let headerCell = this.$refs[field][0];
                // Получаем ширину соответствующей ячейки
                let cellWidth = headerCell.scrollWidth;

                // И присваиваем ширину ячейки в виде css-переменной на родительский элемент таблицы
                TableCustom.style.setProperty(`--cellsWidth-${field}`, cellWidth + 'px');
            });
        },

        addSelected(rowId) {
            if (!(rowId instanceof Array)) rowId = [rowId];

            rowId.forEach(id => this.selected.add(id));
            this.selectedSetTrigger++;

            this.$emit('selected', [...this.selected]);
        },
        selectAll() {
            this.selected = new Set(this.allDataKeys);
            this.selectedSetTrigger++;

            this.$emit('selected', [...this.selected]);
        },
        clearSelected() {
            this.selected.clear();
            this.selectedSetTrigger++;

            this.$emit('selected', [...this.selected]);
        },
        setSelected(rowId) {
            this.selected.clear();
            this.addSelected(rowId);
        },
        removeSelected(rowId) {
            if (!(rowId instanceof Array)) rowId = [rowId];

            rowId.forEach(id => this.selected.delete(id));
            this.selectedSetTrigger++;

            this.$emit('selected', [...this.selected]);
        },

        onInputRowCheckbox(rowId, val) {
            if (val) {
                // Если режим множественного выбора, то добавим новую строку к ранее выбранным
                if (this.multiselect) {
                    this.addSelected(rowId);

                    // Если режим одиночного выбора, то установим выбор только на эту строку
                } else {
                    this.setSelected(rowId);
                }
            } else {
                this.removeSelected(rowId);
            }
        },

        // Простой клик по строке таблицы
        onRowClick(rowId) {
            if (!this.selectable && !this.multiselect) return;

            // Если эта строка уже была выбрана и так же есть еще выбранные строки кроме нее
            if (this.isSelectedRow(rowId) && this.selected.size > 1) {
                // то оставляем выбранной только эту строку
                this.setSelected(rowId);

                // Если эта строка уже выбрана и нет других выбранных строк, то снимаем выбор со всех
            } else if (this.isSelectedRow(rowId) && this.selected.size === 1) {
                this.clearSelected();

                // Если строка не выбрана, то выбираем только ее
            } else {
                this.setSelected(rowId);
            }
        },
        // Клик по строке с зажатым CTRL
        onRowCtrlClick(rowId) {
            // Если режим множественного выбора,
            if (this.multiselect) {
                // и строка уже была выбрана, удаляем эту строку из выбранных
                if (this.isSelectedRow(rowId)) {
                    this.removeSelected(rowId);

                    // Если эта строка еще не выбрана, добавляем ее к выбранным
                } else {
                    this.addSelected(rowId);
                }

                // Если режим одиночного выбора, то передаем клик в обработчик простых кликов
            } else {
                this.onRowClick(rowId);
            }
        }
    }
};
</script>

<style lang="sass">
.TableCustom
    display: flex
    flex-direction: column
    position: relative
    height: 100%
    flex-grow: 1
    align-self: stretch
    overflow: hidden
    &-scroll
        height: 100%
        flex-grow: 1
        align-self: stretch
    .TableCustomHeader
        width: 100%
        display: flex
        height: 40px
        cursor: default
        border-bottom: 1px solid rgba(0,0,0,0.12)
        .TableCustomHeaderCell
            width: 100%
            align-self: stretch
            display: flex
            align-items: center
            flex-basis: 1px
            color: var(--ms-grey)
            transition: color 250ms ease-in-out
            padding: 0 8px
            &:hover
                color: var(--ms-dark)
            &.flex-left
                justify-content: flex-start
            &.flex-center
                justify-content: center
            &.flex-right
                justify-content: flex-end
            &.cell-checkbox
                [role="checkbox"]
                    max-width: 32px
                    opacity: 0
                    transition: opacity 100ms ease-in-out
                    &:hover
                        opacity: 1
                // Когда нужно принудительно отобразить мастер-чекбокс в шапке таблицы
                &.isShowMasterCheckbox
                    [role="checkbox"]
                        opacity: 1
    .TableCustomRow
        height: 40px
        display: flex
        align-items: center
        cursor: default
        border-bottom: 1px solid rgba(0,0,0,0.12)
        transition: background-color 150ms ease-in-out
        .TableCustomCell
            display: flex
            padding: 0 8px
            overflow: hidden
            &.cell-checkbox [role="checkbox"]
                max-width: 32px
                opacity: 0
                transition: opacity 100ms ease-in-out
                &:hover, &:focus
                    opacity: 1

        // Состояние выбранной строки
        &-selected
            background-color: var(--ms-light-grey)
            .TableCustomCell
                // Когда строка выбрана, покажем ее чекбокс
                &.cell-checkbox [role="checkbox"]
                    opacity: 1

// Когда есть возможность выбирать строки таблицы
.TableCustom-selectable
    .TableCustomRow
        cursor: pointer
        &:hover
            background-color: var(--ms-light-grey)
</style>
