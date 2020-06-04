// dispatch

export const setRoles = ({ commit, dispatch }, roles) => {
    commit('clearRoles');
    commit('clearScenarios');

    if (!(roles instanceof Array)) return;

    roles.forEach(role => {
        commit('addRole', role);
        dispatch('setScenarios', role.scenarios);
    });
};

export const setScenarios = ({ commit }, scenarios) => {
    if (!(scenarios instanceof Array)) return;

    scenarios.forEach(scenario => {
        commit('addScenario', scenario);
    });
};
