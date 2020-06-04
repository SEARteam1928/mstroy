import { injectMetaGroup, groupsKeys, groups } from './routeGroups';
import otherGroup from './routeGroups/other';
import homeGroup from './routeGroups/home';

let routesFromGroups = [];
groupsKeys.forEach(groupsKey => {
    let routes = groups[groupsKey].routes || groups[groupsKey].route;
    routesFromGroups = [...routesFromGroups, ...routes];
});

const routes = [
    {
        path: '/',
        component: () => import('layouts/AppMainLayout.vue'),
        children: [
            // Роут с домашней страницей. Должен выводиться в меню особым образом, поэтому не включен в группы
            ...injectMetaGroup(homeGroup),

            // Массив роутов, импортированных из групп с заполненной метаинформацией о
            ...routesFromGroups,

            // Эти роуты не будут выводиться в меню, поэтому не включены в группы
            ...injectMetaGroup(otherGroup)
        ]
    },
    {
        path: '/login',
        name: 'login',
        component: () => import('layouts/LoginPage.vue')
    }
];

// Always leave this as last one
if (process.env.MODE !== 'ssr') {
    routes.push({
        path: '/error403',
        name: 'error403',
        meta: {
            headerTitle: 'Защищенная страница'
        },
        component: () => import('pages/Error403.vue')
    });

    routes.push({
        path: '*',
        meta: {
            headerTitle: 'Страница не найдена'
        },
        component: () => import('pages/Error404.vue')
    });
}

export default routes;
