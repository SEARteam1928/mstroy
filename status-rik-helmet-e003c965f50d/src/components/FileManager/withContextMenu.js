export default () => {
    return {
        data() {
            return {
                contextMenu: {
                    items: [
                        'create',
                        'upload',
                        'rename',
                        'move',
                        'copy',
                        'delete',
                        {
                            text: 'Файлами',
                            icon: 'download',
                            beginGroup: true,
                            onClick: () => this.downloadFiles()
                        },
                        {
                            text: 'Архивом',
                            icon: 'download',
                            onClick: () => this.downloadZip()
                        },
                        'refresh'
                    ]
                }
            };
        }
    };
};
