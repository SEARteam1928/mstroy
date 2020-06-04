<template>
    <q-dialog class="FileManagerConflictNames" persistent ref="conflictModal">
        <q-card class="FileManagerConflictNames-card">
            <q-card-section class="FileManagerConflictNames-header">
                <div class="FileManagerConflictNames-title">
                    Заменить или переименовать файлы
                    <div>(Чекбоксы и переименование пока не работают)</div>
                </div>
            </q-card-section>

            <q-card-section class="row items-center no-wrap">
                <q-avatar color="primary" text-color="white">
                    <QIconCustom name="file-exclamation" :colors="{ primary: '#fff' }" />
                </q-avatar>
                <span class="q-ml-sm">В папке назначения уже есть файлы с такими же именами:</span>
            </q-card-section>

            <q-card-section class="FileManagerConflictNames-body items-center no-wrap">
                <FileManagerConflictNamesItem
                    v-for="fileName in names"
                    :key="fileName"
                    :fileName="fileName"
                    :value="getIsSelected(fileName)"
                    @input="setToSelected"
                />
            </q-card-section>

            <q-card-actions class="FileManagerConflictNames-actions" align="right">
                <q-btn class="FileManagerConflictNames-rewrite" flat color="red" label="Заменить" @click="onRewrite" />
                <q-btn
                    class="FileManagerConflictNames-rename"
                    flat
                    color="primary"
                    label="Переименовать"
                    @click="onRename"
                />
            </q-card-actions>
        </q-card>
    </q-dialog>
</template>

<script>
import QIconCustom from '../common/QIconCustom.vue';
import FileManagerConflictNamesItem from './FileManagerConflictNamesItem.vue';

export default {
    name: 'FileManagerConflictNames',
    components: {
        QIconCustom,
        FileManagerConflictNamesItem
    },
    data() {
        return {
            resolve: () => {},
            names: [],
            selected: [],
            rewrite: [],
            rename: []
        };
    },
    computed: {},
    methods: {
        getIsSelected(name) {
            return this.selected.includes(name);
        },
        setToSelected({ name, value }) {
            // Добавить в список выбранных
            if (value) {
                this.selected.push(name);
            } else {
                this.selected = this.selected.filter(fileName => fileName !== name);
            }
        },

        onRewrite() {
            this.rewrite = this.names;
            let rewrite = [...this.rewrite];

            this.reset();
            this.resolve({
                rewrite,
                rename: []
            });
        },
        onRename() {
            this.rename = this.names;
            let rename = [...this.rename];

            this.reset();
            this.resolve({
                rewrite: [],
                rename
            });
        },

        async confirm(names = []) {
            return new Promise(resolve => {
                if (names.length === 0) return resolve({ rewrite: [], rename: [] });

                this.resolve = resolve;
                this.names = [...names];
                this.selected = [...names];
                this.$refs.conflictModal.show();
            });
        },

        reset() {
            this.$refs.conflictModal.hide();
            this.names = [];
            this.selected = [];
            this.rewrite = [];
            this.rename = [];
        }
    }
};
</script>

<style lang="sass">
.FileManagerConflictNames
    &-card
        min-width: 300px
    &-title
        font-size: 16px
        line-height: 18px
        font-weight: 600
        margin-right: 16px
        text-align: center
</style>
