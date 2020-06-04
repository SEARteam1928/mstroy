import { FileManager } from '../scenarios';

export default [
    {
        path: 'filemanager',
        name: 'filemanager',
        meta: {
            headerTitle: 'Файловый менеджер',
            scenarios: FileManager,
            isNotShowHeader: true
        },
        component: () => import('pages/FileManager.vue')
    }
];
