import Api from '@services/api';
import buildDataTree from '@services/utils/buildDataTree';
import isFalse from '@services/utils/isFalse';
import buildIdMap from '@services/utils/buildIdMap';
import checkIntersectionArrays from '@services/utils/checkIntersectionArrays';

export const requestAllAccessGroups = async ({ commit }) => {
    try {
        commit('clearError', 'requestAllAccessGroups');
        commit('setIsActiveRequestAllAccessGroups', true);

        let res = await Api.allAccessGroups();
        let allAccessGroups = res.data.allAccessGroups;
        let allAccessGroupsMap = buildIdMap(allAccessGroups);
        let { tree, map } = buildDataTree(allAccessGroups, 'rowId', 'parentAccessGroupId');

        commit('setAllAccessGroups', allAccessGroups);
        commit('setAllAccessGroupsMap', allAccessGroupsMap);
        commit('setAllAccessGroupsTree', tree);
        commit('setAllAccessGroupsTreeMap', map);
    } catch (err) {
        commit('setError', {
            type: 'requestAllAccessGroups',
            error: err
        });
    } finally {
        commit('setIsActiveRequestAllAccessGroups', false);
    }
};

export const requestUpdateAccessGroup = async ({ getters, commit }, newGroupData) => {
    newGroupData = newGroupData ? { ...newGroupData } : { ...getters.editGroupModalData };
    let { id, name, parentAccessGroupId, ruleIds, userIds } = newGroupData;
    if (isFalse(id)) return;

    // groupDataToUpdate - это тот набор данных, что отправится на редактирование
    let groupDataToUpdate = { id };
    // Получаем старую версию группы
    let originGroup = getters.getGroupById(id);
    if (isFalse(originGroup)) originGroup = {};

    // Логика проверок ниже:
    // Если свойство присутствует в полученном объекте данных, которые хотим отправить на редактирование,
    // то сравниваем его значение со старым значением этого свойства.
    // Если они различаются, тогда добавим это свойство в объект данных, который отправится в запросе.
    // Это нужно для того, чтобы передавать только те свойства, которые реально изменились
    if (!isFalse(name) && name !== originGroup.name) groupDataToUpdate.name = name;
    if (!isFalse(parentAccessGroupId) && parentAccessGroupId !== originGroup.parentAccessGroupId) {
        groupDataToUpdate.parentAccessGroupId = parentAccessGroupId;
    }
    if (!isFalse(ruleIds) && !checkIntersectionArrays(ruleIds, originGroup.ruleIds)) {
        groupDataToUpdate.ruleIds = ruleIds;
    }
    if (!isFalse(userIds) && !checkIntersectionArrays(userIds, originGroup.userIds)) {
        groupDataToUpdate.userIds = userIds;
    }

    try {
        commit('clearError', 'requestUpdateAccessGroup');

        let res = await Api.updateAccessGroup(groupDataToUpdate);
        let accessgroup = res.data.updateAccessGroup.accessgroup;

        // Обновляем группу в хранилище теми данными, что вернул запрос изменения группы
        commit('updateAccessGroup', accessgroup);
        let allAccessGroups = getters.allAccessGroups;

        // После обновления группы снова соберем дерево групп
        let { tree, map } = buildDataTree(allAccessGroups, 'rowId', 'parentAccessGroupId');
        commit('setAllAccessGroupsTree', tree);
        commit('setAllAccessGroupsTreeMap', map);
        return accessgroup;
    } catch (err) {
        commit('setError', {
            type: 'requestUpdateAccessGroup',
            error: err
        });
    }
};

export const requestCreateAccessGroup = async ({ getters, commit }, newGroupData) => {
    newGroupData = newGroupData ? newGroupData : getters.editGroupModalData;
    let { name, parentAccessGroupId } = newGroupData;
    if (isFalse(name)) return;

    try {
        commit('clearError', 'requestCreateAccessGroup');

        let res = await Api.createAccessGroup({ name, parentAccessGroupId });
        let accessgroup = res.data.createAccessGroup.accessgroup;

        // Добавляем новую группу с данными, возвращенными запросом ее создания
        commit('addAccessGroup', accessgroup);
        let allAccessGroups = getters.allAccessGroups;

        // После добавления группы снова соберем дерево групп
        let { tree, map } = buildDataTree(allAccessGroups, 'rowId', 'parentAccessGroupId');
        commit('setAllAccessGroupsTree', tree);
        commit('setAllAccessGroupsTreeMap', map);

        return accessgroup;
    } catch (err) {
        commit('setError', {
            type: 'requestCreateAccessGroup',
            error: err
        });
    }
};

export const requestDeleteAccessGroups = async ({ getters, commit }, id) => {
    id = isFalse(id) ? getters.deleteGroupModalData.id : id;
    if (isFalse(id)) return;

    try {
        commit('clearError', 'requestDeleteAccessGroups');

        let res = await Api.deleteAccessGroup(id);
        let deletedId = res.data.deleteAccessGroup.accessgroup.rowId;
        let clearedAllAccessGroups = [];

        getters.allAccessGroups.forEach(group => {
            // Если находим удаленную группу, то пропускаем итерацию и в итоге не добавим эту группу в новый массив
            if (group.rowId === deletedId) return;

            // Если удаленная группа была родительской для группы на текущей итерации,
            // заменяем id родительской группы на null, чтобы вынести эту группу на верхний уровень в дереве
            if (group.parentAccessGroupId === deletedId) {
                group = { ...group, parentAccessGroupId: null };
            }

            // Собираем новый массив исправленных и почищенных групп
            clearedAllAccessGroups.push(group);
        });

        // По новому массиву групп собираем новую карту id: индекс в массиве
        let allAccessGroupsMap = buildIdMap(clearedAllAccessGroups);
        commit('setAllAccessGroups', clearedAllAccessGroups);
        commit('setAllAccessGroupsMap', allAccessGroupsMap);

        // По новому массиву групп заново соберем дерево групп
        let { tree, map } = buildDataTree(clearedAllAccessGroups, 'rowId', 'parentAccessGroupId');
        commit('setAllAccessGroupsTree', tree);
        commit('setAllAccessGroupsTreeMap', map);

        return deletedId;
    } catch (err) {
        commit('setError', {
            type: 'requestDeleteAccessGroups',
            error: err
        });
    }
};

export const requestAllUsers = async ({ commit }) => {
    try {
        commit('clearError', 'requestAllUsers');
        commit('setIsActiveRequestAllUsers', true);

        let res = await Api.allUsers();
        let allUsers = res.data.allUsers;

        commit('setAllUsers', allUsers);
    } catch (err) {
        commit('setError', {
            type: 'requestAllUsers',
            error: err
        });
    } finally {
        commit('setIsActiveRequestAllUsers', false);
    }
};
