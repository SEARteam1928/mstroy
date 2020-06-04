export default [
    {
        root: true,
        name: 'Devices',
        label: 'Доступ к странице "Мониторинг устройств"',
        expandable: false,
        accessRules: [
            {
                entityName: 'device',
                read: true
            }
        ],
        children: [
            {
                name: 'Devices/CreateNewDevice',
                label: 'Возможность добавлять новые устройства',
                accessRules: [
                    {
                        entityName: 'device',
                        create: true
                    }
                ]
            },
            {
                name: 'Devices/EditDevice',
                label: 'Возможность редактировать устройства',
                accessRules: [
                    {
                        entityName: 'device',
                        update: true
                    }
                ]
            },
            {
                name: 'Devices/DeleteDevice',
                label: 'Возможность удалять устройства',
                accessRules: [
                    {
                        entityName: 'device',
                        delete: true
                    }
                ]
            }
        ]
    }
];
