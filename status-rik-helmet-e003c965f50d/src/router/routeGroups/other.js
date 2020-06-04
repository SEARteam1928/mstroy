import { Table, GoogleTable, Workers, BimModels, Projects } from '../scenarios';

export default [
    {
        path: 'table',
        name: 'table',
        meta: {
            headerTitle: 'Таблица сырых данных',
            scenarios: Table
        },
        component: () => import('pages/Table.vue')
    },
    {
        path: 'googletable',
        name: 'googletable',
        meta: {
            headerTitle: 'Таблица Google',
            scenarios: GoogleTable
        },
        component: () => import('pages/GoogleTable.vue')
    },
    {
        path: 'workers',
        name: 'workers',
        meta: {
            headerTitle: 'Сотрудники',
            scenarios: Workers
        },
        component: () => import('pages/Workers.vue'),
        children: [
            // Дочерняя страница с сотрудником в модалке на странице таблицы сотрудников
            {
                path: '/workers/:id',
                name: 'worker',
                props: true,
                component: () => import('pages/WorkerPage.vue')
            }
        ]
    },
    {
        path: 'projects',
        name: 'projects',
        meta: {
            headerTitle: 'BIM-портал',
            scenarios: Projects
        },
        component: () => import('pages/Projects.vue')
    }
];
