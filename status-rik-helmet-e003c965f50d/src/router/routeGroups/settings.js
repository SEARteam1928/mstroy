import { UsersControl, RolesControl, GroupsControl, ProjectsControl } from '../scenarios';

export default [
    {
        path: 'userscontrol',
        name: 'userscontrol',
        meta: {
            headerTitle: 'Управление пользователями',
            scenarios: UsersControl
        },
        component: () => import('pages/admin/UsersControl.vue')
    },
    {
        path: 'rolescontrol',
        name: 'rolescontrol',
        meta: {
            headerTitle: 'Управление ролями',
            scenarios: RolesControl
        },
        component: () => import('pages/admin/RolesControl.vue')
    },
    {
        path: 'groupscontrol',
        name: 'groupscontrol',
        meta: {
            headerTitle: 'Управление группами',
            scenarios: GroupsControl
        },
        component: () => import('pages/admin/GroupsControl.vue')
    },
    {
        path: 'projectscontrol',
        name: 'projectscontrol',
        meta: {
            headerTitle: 'Управление проектами',
            scenarios: ProjectsControl
        },
        component: () => import('pages/admin/ProjectsControl.vue')
    }
];
