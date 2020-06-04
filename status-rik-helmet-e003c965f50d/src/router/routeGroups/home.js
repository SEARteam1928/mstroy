export default [
    {
        path: '',
        name: 'home',
        meta: {
            headerTitle: 'Главная'
        },
        component: () => import('pages/Index.vue')
    }
];
