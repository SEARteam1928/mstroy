export default {
    allUsers: [],

    openEditUserModal: false,
    editUserModalData: {
        id: null,
        email: '',
        username: '',
        password: '',
        active: null,
        roles: [],
        step: 'user'
    },

    openDeleteUserModal: false,
    deleteUserModalData: {
        id: null,
        user: {}
    },

    // Флаг, отмечающий активные операции с апи
    userProcessing: false,

    moduleErrors: {
        requestAllUsers: false,
        requestCreateUser: false,
        requestUpdateUser: false,
        requestDeleteUser: false
    }
};
