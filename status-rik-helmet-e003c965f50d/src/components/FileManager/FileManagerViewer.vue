<template>
    <q-dialog
        class="FileManagerViewer"
        v-model="viewerModel"
        :full-width="isSupportedType"
        :full-height="isSupportedType"
        :maximized="isSupportedType && mobileMode"
        @keydown.left.exact="setPrevFile"
        @keydown.right.exact="setNextFile"
    >
        <div class="FileManagerViewer-content">
            <FileManagerViewerNotSupported v-if="!isSupportedType" :file="file" />

            <q-card v-if="isSupportedType" class="FileManagerViewer-card">
                <FileManagerViewerHeader :mobileMode="mobileMode" :viewerData="viewersData" @download="onDownload" />

                <q-card-section class="FileManagerViewer-viewerSection">
                    <FileManagerViewerArrow
                        v-if="hasArrow"
                        :compactMode="viewerCompactArrows.has(viewerType)"
                        :mobileMode="mobileMode"
                        side="left"
                        @click="onArrowClick"
                    />

                    <FileManagerViewerImg
                        v-if="viewerType === 'image'"
                        class="FileManagerViewerImg FileManagerViewer-viewerType"
                        :viewerData="viewersData"
                        @prev="onPrevFile"
                        @next="onNextFile"
                    />

                    <FileManagerViewerPdf
                        v-if="viewerType === 'pdf'"
                        class="FileManagerViewerPdf FileManagerViewer-viewerType"
                        :viewerData="viewersData"
                        @prev="onPrevFile"
                        @next="onNextFile"
                    />

                    <FileManagerViewerArrow
                        v-if="hasArrow"
                        :compactMode="viewerCompactArrows.has(viewerType)"
                        :mobileMode="mobileMode"
                        side="right"
                        @click="onArrowClick"
                    />
                </q-card-section>
            </q-card>
        </div>
    </q-dialog>
</template>

<script>
import FileManagerViewerNotSupported from './FileManagerViewerNotSupported.vue';
import FileManagerViewerHeader from './FileManagerViewerHeader.vue';
import FileManagerViewerArrow from './FileManagerViewerArrow.vue';
import FileManagerViewerImg from './FileManagerViewerImg.vue';
import FileManagerViewerPdf from './FileManagerViewerPdf.vue';

import Api from '@services/api';

export default {
    name: 'FileManagerViewer',
    components: {
        FileManagerViewerNotSupported,
        FileManagerViewerHeader,
        FileManagerViewerArrow,
        FileManagerViewerImg,
        FileManagerViewerPdf
    },
    props: {
        value: {
            type: Boolean,
            required: true
        },
        file: {
            validator: prop => prop instanceof Object || prop === null || prop === undefined,
            default: null
        },
        folder: {
            validator: prop => prop instanceof Array || prop === null || prop === undefined,
            default: null
        },
        path: {
            validator: prop => typeof prop === 'string' || prop === null || prop === undefined,
            default: null
        }
    },
    data() {
        return {
            viewerTypesExt: {
                image: new Set(['.jpg', '.jpeg', '.png', '.gif', '.svg']),
                pdf: new Set(['.pdf'])
            },

            viewersData: {
                currentFileUrl: null,
                currentFileName: null,
                currentIndex: null,
                total: null
            },

            viewerCompactArrows: new Set(['pdf'])
        };
    },
    computed: {
        // Модель для открытия/закрытия модалки просмотра файла
        viewerModel: {
            get() {
                return this.value;
            },
            set(val) {
                this.$emit('input', val);
            }
        },

        // Мобильный режим модалки
        mobileMode() {
            return this.$q.screen.lt.md;
        },

        // Флаг поддерживаемого типа открытого файла
        isSupportedType() {
            return this.viewerType ? true : false;
        },

        // Строковое имя типа открытого файла
        viewerType() {
            let type = null;
            if (!this.file) return type;

            type = this.getFileType(this.file.name);

            return type;
        },

        // Массив файлов из текущей папки, соответствующего типа открытому файлу
        viewerTypeFiles() {
            if (!this.folder || !this.isSupportedType) return [];

            return this.folder.filter(({ name }) => this.typeCheck(name, this.viewerType));
        },

        // Возвращает текущий файл по его индексу в массиве файлов соответствующего типа
        currentFile() {
            let { currentIndex } = this.viewersData;

            return this.viewerTypeFiles[currentIndex];
        },

        // Определяет, должны ли показываться стрелки переключения файлов
        // (если в массиве файлов этого типа больше одного элемента)
        hasArrow() {
            return this.viewerTypeFiles.length > 1;
        }
    },
    watch: {
        file: {
            handler(newFile) {
                if (!newFile) {
                    this.viewersData.currentIndex = null;
                    this.viewersData.total = null;
                    this.viewersData.currentFileName = null;
                    this.viewersData.currentFileUrl = null;
                } else {
                    let index = this.getFileIndex();
                    this.setFileByIndex(index);
                }
            },
            deep: true
        }
    },
    methods: {
        // Обработчик клика по стрелкам переключения файлов
        onArrowClick(side) {
            if (side === 'left') this.setPrevFile();
            if (side === 'right') this.setNextFile();
        },

        // Обработчик запроса на скачивание файла из просмотрщика
        onDownload() {
            this.$emit('download', this.currentFile);
        },

        // Загружает в просмотрщик предыдущий файл
        setPrevFile() {
            if (!this.hasArrow) return;

            let { currentIndex, total } = this.viewersData;
            let nextIndex = --currentIndex;
            let index = nextIndex < 0 ? total - 1 : nextIndex;

            this.setFileByIndex(index);
        },

        // Загружает в просмотрщик следующий файл
        setNextFile() {
            if (!this.hasArrow) return;

            let { currentIndex, total } = this.viewersData;
            let nextIndex = ++currentIndex;
            let index = nextIndex >= total ? 0 : nextIndex;

            this.setFileByIndex(index);
        },

        // По полученному индексу устанавливает данные в просмотрщике,
        // соответствующие файлу с тем же индексом из массива viewerTypeFiles
        async setFileByIndex(index) {
            let total = this.viewerTypeFiles.length;

            if (!this.isSupportedType || index >= total) return;

            this.viewersData.currentIndex = index;
            this.viewersData.total = total;

            let { dataItem, name, relativeName } = this.currentFile;
            let { repoID, repoName } = dataItem;
            relativeName = this.clearRepoNamePrefix(relativeName, repoName);
            this.viewersData.currentFileName = name;

            // Если здесь перед запросом обнулять currentFileUrl, при переключении старая картинка будет сразу исчезать,
            // а только через некоторое время появляться новая
            // this.viewersData.currentFileUrl = null;
            let url = await Api.downloadFile(repoID, relativeName);
            this.viewersData.currentFileUrl = url;
        },

        // Получая имя файла, возвращает его расширение с точкой в начале
        getExt(name) {
            let ext = null;
            let fileExt = name.match(/\.\w+$/);
            if (fileExt) ext = fileExt[0];

            return ext;
        },

        // Получая имя файла, возвращает к какому типу он принадлежит
        getFileType(name) {
            let type = null;

            for (let typeName in this.viewerTypesExt) {
                let check = this.typeCheck(name, typeName);
                if (check) {
                    type = typeName;
                    break;
                }
            }

            return type;
        },

        // Проверяет принадлежность имени файла к определенному типу
        typeCheck(name, typeName) {
            let viewerTypeSet = this.viewerTypesExt[typeName];
            if (!viewerTypeSet) return false;

            return viewerTypeSet.has(this.getExt(name));
        },

        // Получает индекс ИЗНАЧАЛЬНО открытого файла в массиве файлов соответствующего типа
        getFileIndex() {
            let index = -1;
            if (!this.isSupportedType) return index;

            index = this.viewerTypeFiles.findIndex(({ name }) => name === this.file.name);

            return index;
        },

        clearRepoNamePrefix(relativeName, repoName) {
            relativeName = relativeName.replace(repoName, '');

            return relativeName;
        },

        onPrevFile() {},
        onNextFile() {}
    }
};
</script>

<style lang="sass">
.FileManagerViewer
    &-content
        background-color: #fff
        position: relative
    &-card
        display: flex
        flex-direction: column
        height: 100%
    &-viewerSection
        position: relative
        flex-grow: 1
        height: 100%
        overflow: hidden
        padding: 0
    &-viewerType
        flex-grow: 1
        height: 100%
</style>
