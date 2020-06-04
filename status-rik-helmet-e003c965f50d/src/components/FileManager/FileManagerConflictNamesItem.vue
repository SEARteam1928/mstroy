<template>
    <div class="FileManagerConflictNamesItem" :class="{ 'editMode': editRowModel }">
        <div class="FileManagerConflictNamesItem-nameRow">
            <q-checkbox
                class="FileManagerConflictNamesItem-checkbox"
                v-model="checkboxModel"
                :disable="editRowModel"
                :label="fileName"
                :title="fileName"
            />

            <q-btn class="FileManagerConflictNamesItem-edit" flat round color="primary" size="xs" @click="onEditClick">
                <q-icon name="create" size="18px" />
            </q-btn>
        </div>

        <div class="FileManagerConflictNamesItem-editRow">
            <ExpandableWrap class="ExpandableWrap" v-model="editRowModel" :duration="200">
                <q-input
                    class="FileManagerConflictNamesItem-input"
                    dense
                    outlined
                    v-model="newNameModel"
                    label="Новое имя"
                />
            </ExpandableWrap>
        </div>
    </div>
</template>

<script>
import ExpandableWrap from '../common/ExpandableWrap.vue';

export default {
    name: 'FileManagerConflictNamesItem',
    components: {
        ExpandableWrap
    },
    props: {
        fileName: {
            type: String,
            required: true
        },
        value: {
            type: Boolean,
            required: true
        }
    },
    data() {
        return {
            editRowModel: false,
            newName: null
        };
    },
    created() {
        this.newName = this.fileName;
    },
    computed: {
        newNameModel: {
            get() {
                return this.newName;
            },
            set(value) {
                this.newName = value;
                this.$emit('newName', value);
            }
        },
        checkboxModel: {
            get() {
                return this.value;
            },
            set(value) {
                this.$emit('input', {
                    name: this.fileName,
                    value
                });
            }
        }
    },
    methods: {
        onEditClick() {
            this.editRowModel = !this.editRowModel;
        },

        toggleCheckbox() {
            this.checkboxModel = !this.checkboxModel;
        }
    }
};
</script>

<style lang="sass">
.FileManagerConflictNamesItem
    display: flex
    flex-direction: column
    justify-content: center
    width: 100%
    overflow: hidden

    // Изначально видимая строка с чекбоксом и именем файла
    &-nameRow
        display: flex
        align-items: center
    &-checkbox
        flex-shrink: 1
        width: calc(100% - 56px)
        margin-right: 16px
        .q-checkbox__inner
            transition: opacity 150ms ease-in-out
        .q-checkbox__label
            white-space: nowrap
            max-width: inherit
            overflow: hidden
            text-overflow: ellipsis
    &-checkboxPlaceholder
        width: 40px
        height: 40px
    &-edit
        opacity: 0
        transition: opacity 150ms ease-in-out
        flex-shrink: 0
        width: 40px
        height: 40px
        &:focus
            opacity: 1

    // Изначально скрытая строка с полем редактирования имени файла
    &-editRow
        display: flex
        align-items: center
        .ExpandableWrap
            width: 100%
            margin-left: 40px
    &-input
        width: 100%
        margin-top: 4px
        margin-bottom: 16px

// Состояние наведения на весь компонент
.FileManagerConflictNamesItem:hover
    .FileManagerConflictNamesItem
        &-edit
            opacity: 1

// Состояние раскрытой строки редактирования
.FileManagerConflictNamesItem.editMode
    .FileManagerConflictNamesItem
        &-checkbox
            cursor: default !important
            opacity: 1 !important
            .q-checkbox__label
                cursor: default !important
            .q-checkbox__inner
                opacity: 0 !important
        &-edit
            opacity: 1
</style>
