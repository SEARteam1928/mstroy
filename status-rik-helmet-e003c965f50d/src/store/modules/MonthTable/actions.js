import Api from '@services/api';
import { isFalse } from '@services/utils';

export const requestReportsHoursComparing = async ({ getters, commit }) => {
    let { projectId, periodDate } = getters;
    let { from, to } = periodDate;

    if (isFalse(projectId) || isFalse(from) || isFalse(to)) return;

    try {
        commit('clearError', 'requestReportsHoursComparing');
        commit('setDataIsLoading', true);

        let res = await Api.reportsHoursComparing(projectId, from, to);

        commit('setHoursData', res);
    } catch (err) {
        commit('setError', {
            type: 'requestReportsHoursComparing',
            error: err
        });
    } finally {
        commit('setDataIsLoading', false);
    }
};
