// commit
export const setProjectId = (state, id) => (state.projectId = id);

export const setConstructionSiteName = (state, name) => (state.constructionSiteName = name);

export const setObjects = (state, objects) => (state.objects = objects);
export const clearObjects = state => (state.objects = []);

export const setObjectsCoords = (state, objectsCoords) => (state.objectsCoords = objectsCoords);
export const clearObjectsCoords = state => (state.objectsCoords = []);

export const setShow = (state, show) => {
    if (show instanceof Array) {
        state.show = show;
    } else if (typeof show === 'number') {
        state.show = [show];
    } else {
        state.show = [];
    }
};
export const clearShow = state => (state.show = []);

export const setHighlight = (state, highlight) => {
    if (highlight instanceof Array) {
        state.highlight = highlight;
    } else if (typeof highlight === 'number') {
        state.highlight = [highlight];
    } else {
        state.highlight = [];
    }
};
export const clearHighlight = state => (state.highlight = []);

export const setPopups = (state, popups) => (state.popups = popups);
export const setTooltips = (state, tooltips) => (state.tooltips = tooltips);

// Для обработки ошибок
export const setError = (state, errorData) => {
    let { type, error } = errorData;
    state.moduleErrors[type] = error;
};
export const clearError = (state, errorType) => {
    state.moduleErrors[errorType] = false;
};
