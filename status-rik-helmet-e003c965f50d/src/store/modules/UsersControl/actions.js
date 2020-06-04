import Api from '@services/api';

export const requestAllUsers = async ({ commit }) => {
    try {
        commit('clearError', 'requestAllUsers');

        let res = await Api.allUsers();
        let allUsers = res.data.allUsers;

        commit('setAllUsers', allUsers);
    } catch (err) {
        commit('setError', {
            type: 'requestAllUsers',
            error: err
        });
    }
};

export const requestCreateUser = async ({ getters, commit }) => {
    let { email, username, password, workerId } = getters.editUserModalData;

    if (!email || !username || !password) return;

    try {
        commit('clearError', 'requestCreateUser');

        let res = await Api.createUser({ email, username, password, workerId });
        let newUser = res.data.createUser.user;

        return newUser;
    } catch (err) {
        commit('setError', {
            type: 'requestCreateUser',
            error: err
        });
    }
};

export const requestUpdateUser = async ({ getters, commit }) => {
    let { id, email, username, password, roles } = getters.editUserModalData;

    if ((id === null, !email || !username)) return;

    try {
        commit('clearError', 'requestUpdateUser');

        // Собираем айдишники ролей из объектов ролей в данных у модалки
        let roleIds = roles.map(({ rowId }) => rowId);

        let res = await Api.updateUser({ id, email, username, password, roleIds });
        let updatedUser = res.data.updateUser.user;

        return updatedUser;
    } catch (err) {
        commit('setError', {
            type: 'requestUpdateUser',
            error: err
        });
    }
};

export const requestDeleteUser = async ({ getters, commit }) => {
    let { id } = getters.deleteUserModalData;

    if (id === null) return;

    try {
        commit('clearError', 'requestDeleteUser');

        let res = await Api.deleteUser(id);
        let deletedUser = res.data.deleteUser.user;

        return deletedUser;
    } catch (err) {
        commit('setError', {
            type: 'requestDeleteUser',
            error: err
        });
    }
};
