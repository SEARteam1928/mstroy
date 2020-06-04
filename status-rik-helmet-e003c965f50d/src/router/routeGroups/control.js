import { ViolationLog } from '../scenarios';

export default [
    {
        path: 'violationlog',
        name: 'violationlog',
        meta: {
            headerTitle: 'Журнал нарушений',
            scenarios: ViolationLog
        },
        component: () => import('pages/ViolationLog.vue')
    }
];
