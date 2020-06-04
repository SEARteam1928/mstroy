export default {
    allRoles: [],
    allScenarios: [],
    scenariosTree: [],

    openEditRoleModal: false,
    editRoleModalData: {
        id: null,
        name: '',
        description: '',
        users: [],
        scenarios: [],
        step: 'role'
    },

    openDeleteRoleModal: false,
    deleteRoleModalData: {
        id: null,
        role: {}
    },

    // Флаг, отмечающий активные операции с апи
    roleProcessing: false,

    moduleErrors: {
        requestAllRoles: false,
        requestAllScenarios: false,
        requestCreateRole: false,
        requestUpdateRole: false,
        requestDeleteRole: false
    }
};
