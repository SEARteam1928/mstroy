import Api from '@services/api';
import { buildAllPlannedWorks } from '@services/dataConverter';

export const requestAllPlannedWorks = async ({ commit }) => {
    try {
        commit('clearError', 'requestAllPlannedWorks');

        let res = await Api.allPlannedWorks();
        let result = buildAllPlannedWorks(res);

        commit('setAllPlannedWorks', result);
    } catch (err) {
        commit('setError', {
            type: 'requestAllPlannedWorks',
            error: err
        });
    }
};
