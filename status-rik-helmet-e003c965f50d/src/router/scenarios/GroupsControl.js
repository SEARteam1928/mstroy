export default [
    {
        root: true,
        name: 'GroupsControl',
        label: 'Доступ к странице "Управление группами"',
        expandable: false,
        accessRules: [],
        children: [
            {
                name: 'GroupsControl/CreateNewGroups',
                label: 'Возможность добавлять новые группы',
                accessRules: []
            },
            {
                name: 'GroupsControl/EditGroups',
                label: 'Возможность редактировать группы',
                accessRules: []
            },
            {
                name: 'GroupsControl/DeleteGroups',
                label: 'Возможность удалять группы',
                accessRules: []
            }
        ]
    }
];
