<template>
    <div class="status-bar">
        <div v-if="error" class="status-bar-error">Ошибка загрузки данных!</div>
        <div v-if="loading" class="status-bar-loading">Идет загрузка данных...</div>
        <div v-if="loadedText" class="status-bar-loaded">{{ loadedText }}</div>
        <div v-if="nullText" class="status-bar-null">{{ nullText }}</div>
    </div>
</template>

<script>
import { fileSize } from '../../services/utils';

export default {
    name: 'StatusBar',
    props: {
        loading: {
            type: Boolean,
            required: false,
            default: false
        },
        size: {
            type: [Number, null],
            required: false,
            default: 0
        },
        loaded: {
            type: [Number, null],
            required: false,
            default: 0
        },
        shown: {
            type: [Number, null],
            required: false,
            default: 0
        },
        error: {
            type: Boolean,
            required: false,
            default: false
        }
    },
    computed: {
        loadedText() {
            return this.loaded > 0 ? `${this.sizeText}Загружено координат: ${this.loaded} ${this.shownText}` : false;
        },
        shownText() {
            return this.shown > 0 ? `| Отображено координат: ${this.shown}` : '';
        },
        sizeText() {
            return this.size > 0 ? `(${fileSize(this.size)}) | ` : '';
        },
        nullText() {
            return this.loaded === 0 && !this.error ? 'Не найдено координат по указанным параметрам' : false;
        }
    },
    methods: {
        fileSize
    }
};
</script>

<style lang="sass">
.status-bar
</style>
