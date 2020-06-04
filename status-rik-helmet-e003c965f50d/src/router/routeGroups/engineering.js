import { BimModels } from '../scenarios';

export default [
    {
        path: 'bim-models',
        name: 'bim-models',
        meta: {
            headerTitle: 'Модели BIM',
            scenarios: BimModels
        },
        component: () => import('pages/Bim.vue')
    }
];
