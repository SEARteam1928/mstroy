export const allRoles = state => state.allRoles;
export const getRoleById = state => id => state.allRoles.find(({ rowId }) => id === rowId);

export const allScenarios = state => state.allScenarios;
export const scenariosTree = state => state.scenariosTree;

export const openEditRoleModal = state => state.openEditRoleModal;
export const editRoleModalData = state => state.editRoleModalData;

export const openDeleteRoleModal = state => state.openDeleteRoleModal;
export const deleteRoleModalData = state => state.deleteRoleModalData;

export const roleProcessing = state => state.roleProcessing;

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
