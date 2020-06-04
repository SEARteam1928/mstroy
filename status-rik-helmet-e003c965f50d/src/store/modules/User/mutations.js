// commit
export const setId = (state, id) => (state.id = id);
export const setEmail = (state, email) => (state.email = email);
export const setUsername = (state, username) => (state.username = username);
export const setToken = (state, token) => (state.token = token);
export const clearUserInfo = state => {
    state.id = null;
    state.email = null;
    state.username = null;
    state.token = null;
};

export const setRoles = (state, roles) => (state.roles = roles);
export const clearRoles = state => (state.roles = {});
export const addRole = (state, role) => {
    let name = role.name;
    state.roles = {
        ...state.roles,
        [name]: role
    };
};

export const setScenarios = (state, scenarios) => (state.roles = scenarios);
export const clearScenarios = state => (state.scenarios = {});
export const addScenario = (state, scenario) => {
    let name = scenario.name.toLowerCase();
    state.scenarios = {
        ...state.scenarios,
        [name]: scenario
    };
};
