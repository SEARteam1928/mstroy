import { isFalse } from '@services/utils';

export const id = state => state.id;
export const email = state => state.email;
export const username = state => state.username;
export const token = state => state.token;

export const roles = state => state.roles;
export const scenarios = state => state.scenarios;

export const isAdmin = state => (state.roles.admin ? true : false);
export const isAuthorized = state => (state.token && !isFalse(state.id) ? true : false);

export const checkScenarios = (state, getters) => (scenarios = '', andMode = false) => {
    if (!(scenarios instanceof Array) && !(typeof scenarios === 'string')) return false;

    if (typeof scenarios === 'string') scenarios = [scenarios];

    if (getters.isAdmin) return true;

    let allow = false;

    for (let index = 0; index < scenarios.length; index++) {
        let scenario = scenarios[index].toLowerCase();

        if (andMode) {
            if (state.scenarios[scenario]) {
                allow = true;
            } else {
                allow = false;
                break;
            }
        } else {
            if (state.scenarios[scenario]) {
                allow = true;
                break;
            }
        }
    }

    return allow;
};
