// commit
export const setAllRoles = (state, allRoles) => (state.allRoles = allRoles);
export const addAllRoles = (state, role) => state.allRoles.push(role);
export const updateOneRole = (state, role) => {
    let id = role.rowId;
    let index = state.allRoles.findIndex(({ rowId }) => id == rowId);
    if (index === -1) return;

    state.allRoles.splice(index, 1, role);
};
export const deleteOneRole = (state, roleId) => {
    let index = state.allRoles.findIndex(({ rowId }) => roleId == rowId);
    if (index === -1) return;

    state.allRoles.splice(index, 1);
};

export const setAllScenarios = (state, allScenarios) => (state.allScenarios = allScenarios);
export const setScenariosTree = (state, allScenarios) => {
    let scenariosTree = [];
    let scenariosTreeMap = {};

    // Проходит по плоскому массиву сценариев и выстраивает их иерархию по полю rootName
    allScenarios.forEach(scenario => {
        scenario = { ...scenario };
        let { name, rootName } = scenario;

        // Если у сценария есть поле rootName, то это дочерний сценарий
        if (rootName) {
            // Находим индекс родительского сценария и добавляем текущий сценарий в children родительского
            let index = scenariosTreeMap[rootName];
            scenariosTree[index].children.push(scenario);

            // Если поля rootName нет, то это родительский сценарий,
            // подготавливаем его для содержания дочерних сценариев
            // и для правильного отображения в компоненте разворачивающегося дерева
        } else {
            // Отмечаем индекс сценария в карте "Имя": Индекс
            let index = scenariosTree.length;
            scenariosTreeMap[name] = index;

            // Даем ему поле rootName, по его соответствию с именем сценария будет работать система
            // зависимого снятия галочек с дочерних сценариев, если была снята галочка с родительского
            scenario.rootName = name;
            scenario.children = [];
            scenario.expandable = false;
            scenariosTree.push(scenario);
        }
    });

    state.scenariosTree = scenariosTree;
};

export const setOpenEditRoleModal = (state, open) => (state.openEditRoleModal = open);
export const setEditRoleModalData = (state, data) => {
    state.editRoleModalData = {
        ...state.editRoleModalData,
        ...data
    };
};
export const clearEditRoleModalData = state => {
    state.editRoleModalData = {
        id: null,
        name: '',
        description: '',
        users: [],
        scenarios: [],
        step: 'role'
    };
};

export const setOpenDeleteRoleModal = (state, open) => (state.openDeleteRoleModal = open);
export const setDeleteRoleModalData = (state, data) => {
    state.deleteRoleModalData = {
        ...state.deleteRoleModalData,
        ...data
    };
};
export const clearDeleteRoleModalData = state => {
    state.deleteRoleModalData = {
        id: null,
        role: {}
    };
};

export const setRoleProcessing = (state, proc) => (state.roleProcessing = proc);

// Для обработки ошибок
export const setError = (state, errorData) => {
    let { type, error } = errorData;
    state.moduleErrors[type] = error;
};
export const clearError = (state, errorType) => {
    state.moduleErrors[errorType] = false;
};
