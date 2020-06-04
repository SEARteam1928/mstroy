import { buildObjectsCoords } from '@services/dataConverter';

export const projectId = state => state.projectId;

export const constructionSiteName = state => state.constructionSiteName;

export const objects = state => state.objects;
export const objectsCoords = state => state.objectsCoords;

// Собранный массив рабочих зон, производный от objects и objectsCoords
export const workZones = state => {
    let { objects, objectsCoords } = state;
    if (!objects.length || !objectsCoords.length) return [];

    return buildObjectsCoords(objects, objectsCoords);
};

// Массив массивов точек рабочих зон
export const latLngs = (state, getters) => {
    let result = [];
    let { workZones } = getters;
    if (!workZones || !workZones.length) return result;

    result = workZones.map(({ zone }) => zone);

    return result;
};

// Режим показываемых объектов
export const show = state => state.show;
// Режим показываемых объектов
export const highlight = state => state.highlight;

export const popups = state => state.popups;
export const tooltips = state => state.tooltips;

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
