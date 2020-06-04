export default [
    {
        root: true,
        name: 'RolesControl',
        label: 'Доступ к странице "Управление ролями"',
        expandable: false,
        accessRules: [],
        children: [
            {
                name: 'RolesControl/CreateNewRoles',
                label: 'Возможность добавлять новые роли',
                accessRules: []
            },
            {
                name: 'RolesControl/EditRoles',
                label: 'Возможность редактировать роли',
                accessRules: []
            },
            {
                name: 'RolesControl/DeleteRoles',
                label: 'Возможность удалять роли',
                accessRules: []
            }
        ]
    }
];
