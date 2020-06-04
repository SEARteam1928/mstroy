export default () => {
    return {
        data() {
            return {
                toolbar: {
                    items: [
                        {
                            name: 'showNavPane',
                            visible: true
                        },
                        'separator',
                        'create',
                        // 'upload',
                        {
                            widget: 'dxButton',
                            options: {
                                text: 'Загрузить файлы',
                                icon: 'upload'
                            },
                            location: 'before',
                            onClick: () => this.selectFilesToUpload()
                        },
                        {
                            widget: 'dxButton',
                            options: {
                                text: '[Тест конфликта имен]',
                                icon: 'upload'
                            },
                            location: 'before',
                            onClick: async () => {
                                let confirmedNames = await this.$refs.conflictModal.confirm([
                                    '1.jpg',
                                    '2.jpg',
                                    '012479169109d5a46cac8471d fe4ca298bba2dc2ad0e64e4c08 aaf02989c88ce4c08aaf02989c aaf02989c88ce4c08aaf02989c 88ce4c08aaf02989c88c.jpg',
                                    '012479169109d5a46cac8471ddfe4ca298bba2dc2ad0e64e4c08aaf02989c88ce4c08aaf02989c88ce4c08aaf02989c88c.jpg'
                                ]);
                                console.log('confirmedNames: ', confirmedNames);
                            }
                        },
                        'refresh',
                        'viewSwitcher'
                    ],
                    fileSelectionItems: [
                        {
                            widget: 'dxButton',
                            options: {
                                text: 'Файлами',
                                icon: 'download'
                            },
                            location: 'before',
                            onClick: () => this.downloadFiles()
                        },
                        {
                            widget: 'dxButton',
                            options: {
                                text: 'Архивом',
                                icon: 'download'
                            },
                            location: 'before',
                            visible: true,
                            onClick: () => this.downloadZip()
                        },

                        {
                            name: 'separator',
                            visible: true,
                            location: 'center'
                        },
                        {
                            name: 'move',
                            visible: true,
                            location: 'center'
                        },
                        {
                            name: 'copy',
                            visible: true,
                            location: 'center'
                        },
                        {
                            name: 'rename',
                            visible: true,
                            location: 'center'
                        },
                        {
                            name: 'delete',
                            visible: true,
                            location: 'center'
                        },
                        {
                            name: 'separator',
                            visible: true,
                            location: 'center'
                        },
                        'refresh',
                        'clear'
                    ]
                }
            };
        },
        methods: {
            async selectFilesToUpload() {
                let files = await this.fileSelector();
                files = [...files];
                console.log('selectFilesToUpload -> files', files);
                // Если не были выбраны файлы, то выходим
                if (files.length === 0) return;

                // debugger;

                let { conflictModal } = this.$refs;
                // Получаем текущую папку, в которую нужно загружать файлы
                let { fileItem: destinationPath } = this.getCurrentDirectory();
                destinationPath.relativeName = this.clearRepoNamePrefix(destinationPath.relativeName);
                // Нужно для совместимости с методом загрузки файлов, который вызывает сам DxFileManager
                let chunksInfo = {};

                let fileNames = files.map(({ name }) => name);
                let conflictedNames = fileNames.filter(name => this.checkConflictName(name));
                let nonConflictedNames = fileNames.filter(name => !this.checkConflictName(name));

                let { rewrite, rename } = await conflictModal.confirm(conflictedNames);

                let uploadNames = [...nonConflictedNames, ...rename];
                console.log('selectFilesToUpload -> uploadNames', uploadNames);

                let updateNames = rewrite;
                console.log('selectFilesToUpload -> updateNames', updateNames);

                // Мапим файлы в массив промисов, чтобы дождаться все разом
                let requests = files.map(fileData => {
                    let { name } = fileData;

                    let update = updateNames.includes(name);
                    return this.uploadFileChunk(fileData, chunksInfo, destinationPath, update);
                });

                try {
                    await Promise.all(requests);

                    this.refresh();
                } catch (err) {
                    this.showMessage(`Ошибка загрузки`, true);
                }
            },
            renameRealFile(file, newName) {
                let { type, lastModified } = file;

                return new File([file], newName, { type, lastModified });
            }
        }
    };
};
