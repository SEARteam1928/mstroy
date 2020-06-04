export const allUsers = state => state.allUsers;
export const userById = state => id => state.allUsers.find(({ rowId }) => id === rowId);

export const openEditUserModal = state => state.openEditUserModal;
export const editUserModalData = state => state.editUserModalData;

export const openDeleteUserModal = state => state.openDeleteUserModal;
export const deleteUserModalData = state => state.deleteUserModalData;

export const userProcessing = state => state.userProcessing;

// Для обработки ошибок
export const moduleErrors = state => {
    let errors = {};
    Object.keys(state.moduleErrors).forEach(err => {
        let error = state.moduleErrors[err];
        if (error) errors[err] = error;
    });

    return errors;
};
export const showErrors = (state, getters) => {
    return JSON.stringify(getters.moduleErrors, ' ', 4);
};
