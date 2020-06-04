import { Spider, Cars, Materials } from '../scenarios';

export default [
    {
        path: 'cars',
        name: 'cars',
        meta: {
            headerTitle: 'Движения автотранспорта',
            scenarios: Cars
        },
        component: () => import('pages/Cars.vue')
    },
    {
        path: 'materials',
        name: 'materials',
        meta: {
            headerTitle: 'Анализ материалов',
            scenarios: Materials
        },
        component: () => import('pages/Materials.vue')
    },
    {
        path: 'spider',
        name: 'spider',
        meta: {
            headerTitle: 'График работ',
            scenarios: Spider
        },
        component: () => import('pages/Spider.vue')
    }
];
