// commit
export const setAllUsers = (state, allUsers) => (state.allUsers = allUsers);
export const addAllUsers = (state, user) => state.allUsers.push(user);
export const updateOneUser = (state, user) => {
    let index = state.allUsers.findIndex(({ rowId }) => user.rowId === rowId);
    if (index === -1) return;

    state.allUsers.splice(index, 1, user);
};
export const deleteOneUser = (state, userId) => {
    let index = state.allUsers.findIndex(({ rowId }) => userId === rowId);
    if (index === -1) return;

    state.allUsers.splice(index, 1);
};

export const setOpenEditUserModal = (state, open) => (state.openEditUserModal = open);
export const setEditUserModalData = (state, data) => {
    state.editUserModalData = {
        ...state.editUserModalData,
        ...data
    };
};
export const clearEditUserModalData = state => {
    state.editUserModalData = {
        id: null,
        email: '',
        username: '',
        password: '',
        active: null,
        roles: [],
        step: 'user'
    };
};

export const setOpenDeleteUserModal = (state, open) => (state.openDeleteUserModal = open);
export const setDeleteUserModalData = (state, data) => {
    state.deleteUserModalData = {
        ...state.deleteUserModalData,
        ...data
    };
};
export const clearDeleteUserModalData = state => {
    state.deleteUserModalData = {
        id: null,
        user: {}
    };
};

// Для обработки ошибок
export const setError = (state, errorData) => {
    let { type, error } = errorData;
    state.moduleErrors[type] = error;
};
export const clearError = (state, errorType) => {
    state.moduleErrors[errorType] = false;
};
