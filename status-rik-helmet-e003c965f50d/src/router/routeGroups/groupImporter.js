import groups from './index.js';

const getScenarioName = scenarios => {
    if (!scenarios || !(scenarios instanceof Array)) return false;

    return scenarios.length && scenarios[0].name;
};

const injectMetaGroup = routeGroup => {
    // По всем роутам группы собирает массив объектов инфы о каждом роуте
    let group = routeGroup.map(({ path, name, meta }) => ({
        path,
        name,
        title: meta.headerTitle,
        scenario: getScenarioName(meta.scenarios)
    }));

    // Проходит по всем роутам группы и добавляет каждому в их meta массив с инфой о всех роутах группы
    let result = routeGroup.map(route => {
        let { meta } = route;
        return {
            ...route,
            meta: { ...meta, group }
        };
    });

    return result;
};

const groupImporter = groupName => {
    let { routes, icon } = groups[groupName];

    return {
        routes: injectMetaGroup(routes),
        icon
    };
};

export default groupImporter;
export { groupImporter, injectMetaGroup };
