<template>
    <q-page class="FileManager-page page-background">
        <div class="FileManager page-block">
            <DxFileManager
                :focusStateEnabled="true"
                :rootFolderName="rootFolderName"
                :file-provider="fileProvider"
                :upload="upload"
                :toolbar="toolbar"
                :contextMenu="contextMenu"
                :onCurrentDirectoryChanged="onCurrentDirectoryChanged"
                :customize-detail-columns="customizeDetailColumns"
                :allowed-file-extensions="allowedFileExtensions"
                :onSelectedFileOpened="onFileOpen"
                :itemView="itemViewOptions"
                ref="DxFileManager"
            >
                <DxPermissions
                    :create="true"
                    :copy="true"
                    :move="true"
                    :remove="true"
                    :rename="true"
                    :download="true"
                    :upload="true"
                />
            </DxFileManager>
        </div>

        <FileManagerViewer v-model="FileManagerViewerModel" v-bind="viewerData" @download="onDownload" />
        <FileManagerConflictNames ref="conflictModal" />
    </q-page>
</template>

<script>
import { DxFileManager, DxPermissions } from 'devextreme-vue/file-manager';

import 'devextreme/dist/css/dx.common.css';
import 'devextreme/dist/css/dx.material.blue.light.compact.css';

import CustomFileProvider from 'devextreme/ui/file_manager/file_provider/custom';
import { locale, loadMessages } from 'devextreme/localization';
import ruMessages from 'devextreme/localization/messages/ru.json';

import withToolbar from '../components/FileManager/withToolbar';
import withContextMenu from '../components/FileManager/withContextMenu';
import withShowMessage from '@mixins/withShowMessage';

import delay from '@services/utils/delay';
import saveDownload from '@services/utils/saveDownload';
import fileSelector from '@services/utils/fileSelector';

import FileManagerViewer from '../components/FileManager/FileManagerViewer.vue';
import FileManagerConflictNames from '../components/FileManager/FileManagerConflictNames.vue';

import Api from '@services/api';

export default {
    name: 'FileManager',
    components: {
        DxFileManager,
        DxPermissions,
        FileManagerViewer,
        FileManagerConflictNames
    },
    mixins: [withToolbar(), withContextMenu(), withShowMessage()],
    data() {
        return {
            instance: null,
            itemView: null,
            filesView: null,
            fileProvider: null,
            conflictModal: null,
            seaLibID: null,
            rootFolderName: 'Проекты',
            itemViewOptions: {
                // mode: "thumbnails",
                mode: 'details',
                showFolders: true,
                showParentFolder: true
            },
            upload: {},
            headers: {
                name: 'Имя',
                size: 'Размер',
                dateModified: 'Дата изменения',
                modifier_name: 'Кем изменено'
            },
            reposMap: {},
            reposMapNames: {},
            currentFiles: [],
            allowedFileExtensions: [],
            maxFileSize: 2147483648,

            uploadUrls: {},
            saveDownload,
            fileSelector,

            // Модель для открытия модалки просмотра контента файла
            viewerData: {
                viewerModel: false,
                file: null,
                folder: null,
                path: null
            }
        };
    },
    computed: {
        FileManagerViewerModel: {
            get() {
                return this.viewerData.viewerModel;
            },
            set(val) {
                this.viewerData.viewerModel = val;

                if (!val) {
                    this.viewerData.file = null;
                    this.viewerData.folder = null;
                    this.viewerData.path = null;
                }
            }
        }
    },
    created() {
        window.FileManager = this;

        loadMessages(ruMessages);
        locale('ru');

        this.upload.maxFileSize = this.maxFileSize;

        this.fileProvider = new CustomFileProvider({
            getItems: this.getItems,
            createDirectory: this.createDirectory,
            deleteItem: this.deleteItem,
            renameItem: this.renameItem,
            downloadItems: this.downloadItems,
            uploadFileChunk: this.uploadFileChunk,
            abortFileUpload: this.abortFileUpload,
            moveItem: this.moveItem,
            copyItem: this.copyItem,

            // uploadChunkSize: 10000
            // 2ГБ
            uploadChunkSize: this.maxFileSize
        });
    },
    mounted() {
        this.instance = this.$refs.DxFileManager.instance;
        this.itemView = this.instance._itemView;
        this.filesView = this.itemView._filesView;
        this.conflictModal = this.$refs.conflictModal;
    },
    methods: {
        /* Обработчики событий */
        // Событие скачивания файла из просмотрщика
        onDownload(item) {
            if (!item) return;

            this.downloadItems([item]);
        },

        // Событие открытия файла по двойному клику
        onFileOpen(props) {
            let { fileItem } = props;

            this.viewerData.file = fileItem;
            this.viewerData.folder = this.getCurrentFiles();

            let { fileItem: folderItem } = this.getCurrentDirectory();
            this.viewerData.path = this.clearRepoNamePrefix(folderItem.relativeName);
            this.FileManagerViewerModel = true;
        },
        // Событие перехода в папку
        onCurrentDirectoryChanged(...props) {
            // console.log('onCurrentDirectoryChanged', this.instance.getCurrentDirectory());

            this.seaLibID = this.getCurrentRepoId();
        },

        /* Служебные методы для работы с айтемами фалов/папок в файловом менеджере */
        async refresh() {
            await this.instance._controller.refresh();
            this.instance._redrawComponent();
        },
        showProgressPanel() {
            this.instance._notificationControl.tryShowProgressPanel();
        },
        hideProgressPanel() {
            this.instance._notificationControl._hideProgressPanel();
        },
        showPopup(msg) {
            this.instance._notificationControl._showPopup(msg);
        },
        getCurrentRepoName() {
            let { relativeName } = this.instance.getCurrentDirectory();
            let repoName = relativeName.split('/')[0];

            return repoName;
        },
        clearRepoNamePrefix(relativeName) {
            let repoName = this.getCurrentRepoName();
            relativeName = relativeName.replace(repoName, '');

            return relativeName;
        },
        getCurrentRepoId() {
            let repoName = this.getCurrentRepoName();
            let repoId = this.reposMapNames[repoName];

            return repoId;
        },
        getCurrentPath() {
            let { relativeName } = this.instance.getCurrentDirectory();
            let path = this.clearRepoNamePrefix(relativeName);

            return path;
        },
        getCurrentDirectory() {
            return this.instance._getCurrentDirectory();
        },
        getCurrentItems() {
            let { items } = this.getCurrentDirectory();
            items = items.map(({ fileItem }) => fileItem);

            return items;
        },
        getCurrentFiles() {
            let items = this.getCurrentItems();
            items = items.map(fileItem => (fileItem.isDirectory ? false : fileItem)).filter(item => item);

            return items;
        },

        getSelectedFiles() {
            return this.instance.getSelectedItems().filter(({ isDirectory }) => !isDirectory);
        },
        selectItems(items = []) {
            let paths = items;
            // Берем один item для того, чтобы посмотреть, переданы просто строки с путями или объекты айтемов файлов
            let testItem = items instanceof Array ? items[0] : items;

            // Если передан объект айтемов файлов, то нам нужно из него свойство relativeName
            if (testItem instanceof Object) {
                if (items instanceof Array) {
                    paths = items.map(({ relativeName }) => relativeName);
                } else {
                    paths = items.relativeName;
                }
            }

            this.filesView.selectRows(paths);
        },
        deselectItems() {
            this.filesView.deselectAll();
        },

        // Проверяет совпадение имени с именами папок/файлов в текущей папке
        checkConflictName(itemName) {
            let currentItems = this.getCurrentItems();
            let conflictIndex = currentItems.findIndex(({ name }) => name === itemName);

            return conflictIndex === -1 ? false : true;
        },

        filterUniqRepos(repos) {
            let uniqReposId = new Set();
            repos = repos.filter(({ id }) => {
                if (!uniqReposId.has(id)) {
                    uniqReposId.add(id);
                    return true;
                }
                return false;
            });

            return repos;
        },

        collectReposMap(repos) {
            let reposMap = {};
            let reposMapNames = {};
            repos.forEach(({ id, name }) => {
                reposMap[id] = name;
                reposMapNames[name] = id;
            });

            this.reposMap = reposMap;
            this.reposMapNames = reposMapNames;
        },

        // При переходе в папку, получает ее содержимое от сервера
        async getItems(pathInfo) {
            // console.log('getItems: ', pathInfo);
            let result = [];

            // Если pathInfo пустой, то сейчас запрашивается список репозиториев
            if (pathInfo.length === 0) {
                result = await Api.getRepos();
                let repos = this.filterUniqRepos(result);
                this.collectReposMap(repos);

                return this.transformResult(repos);
            }

            let path = pathInfo[pathInfo.length - 1];

            // Если в pathInfo один элемент, то сейчас запрашивается корневая папка репозитория
            if (pathInfo.length === 1) {
                // Перед запросом содержимого
                this.seaLibID = path.key;
                path = '';
            }

            // Если элементов в pathInfo несколько, то это путь вглубь папки
            if (pathInfo.length > 1) {
                let repoInfo = pathInfo[0];
                let repoName = this.reposMap[repoInfo.key];
                this.seaLibID = repoInfo.key;

                // path = this.getCurrentPath();
                path = this.clearRepoNamePrefix(path.key);
            }

            result = await Api.getDir(this.seaLibID, path);
            this.currentFiles = this.transformResult(result);
            return this.currentFiles;

            return this.availableRepos;
        },

        // Трансформирует ответ от апи SeaFile в формат, нужный плагину для отображения содержимого папок
        transformResult(filesArray = []) {
            let result = filesArray.map(item => {
                let newItem = {
                    name: item.name,
                    isDirectory: item.type === 'dir',
                    size: item.size,
                    dateModified: item.mtime ? item.mtime * 1000 : undefined,
                    modifier_name: item.modifier_name,
                    repoID: this.seaLibID,
                    repoName: this.reposMap[this.seaLibID]
                };

                if (item.type === 'repo' || item.type === 'grepo' || item.type === 'srepo') {
                    newItem.isDirectory = true;
                    newItem.key = item.id;
                }

                return newItem;
            });

            return result;
        },

        async createDirectory(parentDir, name) {
            // console.log('createDirectory: ', parentDir, name);

            let relativeName = this.getCurrentPath();
            let path = `${relativeName}/${name}`;

            return await Api.createDir(this.seaLibID, path);
        },

        // Метод удаления, вызываемый плагином, если удаляется папка, он вызывает deleteDir
        async deleteItem(item) {
            // console.log('deleteItem: ', item);
            let { name } = item;

            let path = this.getCurrentPath();
            let items = [name];

            return await Api.syncDeleteItems(this.seaLibID, path, items);
        },

        // Метод переименовывания, вызываемый плагином, если переименовывается папка, он вызывает renameDir
        async renameItem(item, newName) {
            // console.log('renameItem: ', item, newName);
            let { isDirectory } = item;

            // Переименовывание папки
            if (isDirectory) return await this.renameDir(item, newName);

            // Переименовывание файла
            return await this.renameFile(item, newName);
        },
        async renameDir(item, newName) {
            let { relativeName } = item;
            relativeName = this.clearRepoNamePrefix(relativeName);
            return await Api.renameDir(this.seaLibID, relativeName, newName);
        },
        async renameFile(item, newName) {
            let { relativeName } = item;
            relativeName = this.clearRepoNamePrefix(relativeName);
            return await Api.renameFile(this.seaLibID, relativeName, newName);
        },

        async moveItem(item, destinationDir) {
            // console.log('moveItem: ', item, destinationDir);

            let path = this.clearRepoNamePrefix(item.parentPath);
            let items = [item.name];
            let destinationPath = destinationDir.relativeName;
            destinationPath = this.clearRepoNamePrefix(destinationPath);

            return await Api.syncMoveItems(this.seaLibID, path, items, destinationPath);
        },

        async copyItem(item, destinationDir) {
            // console.log('copyItem: ', item, destinationDir);

            let path = this.clearRepoNamePrefix(item.parentPath);
            let items = [item.name];
            let destinationPath = destinationDir.relativeName;
            destinationPath = this.clearRepoNamePrefix(destinationPath);

            return await Api.syncCopyItems(this.seaLibID, path, items, destinationPath);
        },

        async downloadItems(items) {
            let { relativeName, name } = items[0];
            relativeName = this.clearRepoNamePrefix(relativeName);

            // Получаем прямую ссылку на файл
            let url = await Api.downloadFile(this.seaLibID, relativeName);

            // Отправляем ссылку на скачивание через программный клик по тегу <a> с этой ссылкой
            saveDownload(url, name);
        },

        // TODO: Загрузка файлов пока не работает
        // FIXME: Этот метод позволяет загружать файл фрагментами, он вызывается для каждого фрагмента,
        // получает полный файл, blob фрагмента и информацию о пути, куда нужно грузить этот файл.
        // Плагин файлового менеджера отображает прогресс загрузки после завершения вызовов этого метода.
        // Размер фрагмента настраивается свойством uploadChunkSize в this.fileProvider
        async uploadFileChunk2(fileData, chunksInfo, destinationDir) {
            console.log('uploadFileChunk: ', fileData, chunksInfo, destinationDir);

            try {
                let { relativeName } = destinationDir;
                let url = '';

                if (!this.uploadUrls[relativeName]) {
                    url = await Api.getUploadLinkFile(this.seaLibID, relativeName);
                    this.uploadUrls[relativeName] = url;
                } else {
                    url = this.uploadUrls[relativeName];
                }

                let { chunkBlob, bytesUploaded } = chunksInfo;
                let { name, size } = fileData;

                return await Api.uploadChunkFile({
                    url,
                    path: relativeName,
                    name,
                    chunkBlob,
                    // chunkBlob: fileData,
                    bytesUploaded,
                    total: size
                });
            } catch (err) {
                console.log('uploadFileChunk: ', err);

                throw err;
            }
        },

        // TODO: Этот метод загрузки работает. Но он загружает файл целиком, а не по фрагментам.
        // Минусы: плагин не отображает прогресс загрузки и иногда делает запрос содержимого папки,
        // в которую грузится этот файл, слишком рано, пока файл еще не загрузился, т.е. визуально,
        // после окончания загрузки, файл не появляется, нужно обновлять вручную
        async uploadFileChunk(fileData, chunksInfo, destinationDir, update = false) {
            // console.log('uploadFileChunk: ', fileData, chunksInfo, destinationDir);

            // debugger;

            try {
                let { relativeName } = destinationDir;
                relativeName = this.clearRepoNamePrefix(relativeName);
                let url = '';

                this.showMessage(`Начало загрузки файла: ${fileData.name}`);

                // Если передан аргумент update, то перезаписываем файл
                if (update) {
                    let { name: fileName } = fileData;
                    url = await Api.getUpdateLinkFile(this.seaLibID, relativeName);
                    return await Api.updateFile(url, relativeName + fileName, fileData);

                    // Иначе просто загружаем. Если в загружаемой папке уже есть файл с таким именем,
                    // то он автоматически переименуется по шаблону "имя_файла (1).расширение"
                } else {
                    url = await Api.getUploadLinkFile(this.seaLibID, relativeName);
                    return await Api.uploadFile(url, relativeName, fileData);
                }
            } catch (err) {
                if (process.env.DEV) {
                    let { name: fileName } = fileData;
                    console.log('uploadFileChunk err: ', err);
                    this.showMessage(`Ошибка загрузки файла: ${fileName}`, true);
                }

                throw err;
            }
        },

        // TODO: Этот метод должен отменять загрузку файла на сервер,
        // для этого нужно настроить axios на возможность отменяемых запросов
        async abortFileUpload(fileData, chunksInfo, destinationDir) {
            console.log('abortFileUpload: ', fileData, chunksInfo, destinationDir);

            await delay(5000);
        },

        /* Операции по скачиванию для контекстного меню и тулбара */
        async downloadQueue() {
            // Собираем массив айтемов файлов для загрузки
            let items = this.getSelectedFiles();
            // Отрезаем первый файл из очереди
            let currentItem = items.shift();
            // Выделяем в окне файлов те, что еще остались в очереди на загрузку
            this.selectItems(items);

            // Если нет файла - очередь закончилась. Тут выход из рекурсии
            if (!currentItem) return;

            try {
                await this.downloadItems([currentItem]);
            } catch (error) {
                let { name } = currentItem;
                this.showMessage(`Ошибка скачивания файла: ${name}`, true);
            }

            // Если убрать задержку между стартами закачек, браузер может проигнорить некоторые
            await delay(1000);

            // Рекурсивно вызываем этот метод для загрузки следующего файла
            await this.downloadQueue();
        },

        async downloadFiles() {
            // Вызываем рекурсивную функцию загрузки очереди
            await this.downloadQueue();
        },

        async waitReadyZip(zipToken) {
            // Ждем и делаем проверку готовности архива
            await delay(1000);
            let res = await Api.checkZipToken(zipToken);
            let { zipped, total } = res;

            // Условие выхода из рекурсии
            if (zipped === total) return true;

            // Если архив еще не готов, снова вызываем проверку
            await this.waitReadyZip(zipToken);
        },

        async downloadZip() {
            // Получаем текущую открытую директорию
            let path = this.instance.getCurrentDirectory();
            path = path.relativeName;
            path = this.clearRepoNamePrefix(path);

            // Получаем выбранные в ней файлы
            let items = this.instance.getSelectedItems();
            items = items.map(({ name }) => name);

            try {
                // Получаем токен операции подготовки массива для скачивания
                let { zip_token } = await Api.asyncDownloadMultipleItems(this.seaLibID, path, items);

                // Снимаем выделение с тех айтемов, которые только что отправили на упаковку в архив для закачки
                this.deselectItems();

                // Ждем готовности массива для скачивания
                await this.waitReadyZip(zip_token);

                // Получаем по токену операции путь для скачивания массива
                let zipUrl = await Api.getUrlByZipToken(zip_token);

                // Отправляем этот путь на скачивание браузером
                this.saveDownload(zipUrl);
            } catch (error) {
                this.showMessage(`Ошибка скачивания архива`, true);
            }
        },

        // Кастомизация колонок с информацией о файлах в основном окне файлового менеджера
        customizeDetailColumns(columns) {
            // console.log('customizeDetailColumns: ', columns);

            columns.push({ dataField: 'modifier_name' });

            // Устанавливает русские имена заголовкам столбцов
            columns.forEach(column => {
                let { dataField } = column;
                let caption = this.headers[dataField];

                if (caption) column.caption = caption;
            });

            return columns;
        }
    }
};
</script>

<style lang="sass">
.FileManager

    display: flex
    flex-direction: column
    flex-grow: 1
    height: calc(100% - 16px)
    max-width: calc(100% - 16px)
    margin:
        top: 8px
        right: 8px
        bottom: 8px
        left: 8px
    &-page
        overflow: hidden
        height: calc( 100vh - var(--header-height) )
        display: flex
        flex-direction: column
        @media only screen and (max-width : 768px)
            height: auto

    .dx-filemanager
        flex-grow: 1
        // Блок под дерево репозиториев
        .dx-filemanager-container .dx-filemanager-dirs-panel
            max-width: none
        .dx-filemanager-breadcrumbs
            background-color: #fff
</style>
