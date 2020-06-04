import Api from '@services/api';

export const requestAllEntities = async ({ getters, commit }) => {
    try {
        commit('clearError', 'requestAllEntities');

        let result = await Api.allEntities();
        let allEntities = result.data.allEntities;

        commit('setAllEntities', allEntities);

        return allEntities;
    } catch (err) {
        commit('setError', {
            type: 'requestAllEntities',
            error: err
        });
    }
};
