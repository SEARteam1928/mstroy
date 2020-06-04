export default [
    {
        root: true,
        name: 'UsersControl',
        label: 'Доступ к странице "Управление пользователями"',
        expandable: false,
        accessRules: [],
        children: [
            {
                name: 'UsersControl/CreateNewUsers',
                label: 'Возможность добавлять новых пользователей',
                accessRules: []
            },
            {
                name: 'UsersControl/EditUsers',
                label: 'Возможность редактировать пользователей',
                accessRules: []
            },
            {
                name: 'UsersControl/DeleteUsers',
                label: 'Возможность удалять пользователей',
                accessRules: []
            }
        ]
    }
];
