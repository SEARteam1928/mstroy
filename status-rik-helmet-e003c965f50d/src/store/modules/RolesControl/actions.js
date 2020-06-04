import Api from '@services/api';

export const requestAllRoles = async ({ commit }) => {
    try {
        commit('clearError', 'requestAllRoles');

        let res = await Api.allRoles();
        let allRoles = res.data.allRoles;

        commit('setAllRoles', allRoles);
    } catch (err) {
        commit('setError', {
            type: 'requestAllRoles',
            error: err
        });
    }
};

export const requestAllScenarios = async ({ commit }) => {
    try {
        commit('clearError', 'requestAllScenarios');

        let res = await Api.allScenarios();
        let allScenarios = res.data.allScenarios;

        commit('setAllScenarios', allScenarios);
        commit('setScenariosTree', allScenarios);
    } catch (err) {
        commit('setError', {
            type: 'requestAllScenarios',
            error: err
        });
    }
};

export const requestCreateRole = async ({ getters, commit }) => {
    let { name, description } = getters.editRoleModalData;

    if (!name || !description) return;

    try {
        commit('setRoleProcessing', true);
        commit('clearError', 'requestCreateRole');

        let res = await Api.createRole({ name, description });
        let newRole = res.data.createRole.role;

        return newRole;
    } catch (err) {
        commit('setError', {
            type: 'requestCreateRole',
            error: err
        });
    } finally {
        commit('setRoleProcessing', false);
    }
};

export const requestDeleteRole = async ({ getters, commit }) => {
    let { id } = getters.deleteRoleModalData;

    if (id === null) return;

    try {
        commit('setRoleProcessing', true);
        commit('clearError', 'requestDeleteRole');

        let res = await Api.deleteRole(id);
        let deletedRole = res.data.deleteRole.role;

        return deletedRole;
    } catch (err) {
        commit('setError', {
            type: 'requestDeleteRole',
            error: err
        });
    } finally {
        commit('setRoleProcessing', false);
    }
};

export const requestUpdateRole = async ({ getters, commit }) => {
    let { id, name, description, scenarios } = getters.editRoleModalData;

    if (id === null || !name || !description) return;

    try {
        commit('setRoleProcessing', true);
        commit('clearError', 'requestUpdateRole');

        // Собираем айдишники сценариев из объектов сценариев в данных у модалки
        let scenarioIds = scenarios.map(({ rowId }) => rowId);

        let res = await Api.updateRole({ id, name, description, scenarioIds });
        let updatedRole = res.data.updateRole.role;

        return updatedRole;
    } catch (err) {
        commit('setError', {
            type: 'requestUpdateRole',
            error: err
        });
    } finally {
        commit('setRoleProcessing', false);
    }
};
