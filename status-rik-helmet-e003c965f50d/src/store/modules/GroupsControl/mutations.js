import buildIdMap from '@services/utils/buildIdMap';
import buildDataTree from '@services/utils/buildDataTree';

export const setIsActiveRequestAllAccessGroups = (state, flag) => (state.isActiveRequestAllAccessGroups = flag);
export const setAllAccessGroups = (state, allAccessGroups) => (state.allAccessGroups = allAccessGroups);
export const setAllAccessGroupsMap = (state, allAccessGroupsMap) => (state.allAccessGroupsMap = allAccessGroupsMap);
export const clearAllAccessGroups = state => (state.allAccessGroups = []);
export const setAllAccessGroupsTree = (state, tree) => (state.allAccessGroupsTree = tree);
export const clearAllAccessGroupsTree = state => (state.allAccessGroupsTree = []);
export const setAllAccessGroupsTreeMap = (state, treeMap) => (state.allAccessGroupsTreeMap = treeMap);
export const clearAllAccessGroupsTreeMap = state => (state.allAccessGroupsTreeMap = {});
export const setSelectedGroupId = (state, id) => (state.selectedGroupId = id);

export const updateAccessGroup = (state, accessGroup) => {
    let index = state.allAccessGroupsMap[accessGroup.rowId];
    let oldAccessGroup = state.allAccessGroups[index];
    let newAccessGroup = { ...oldAccessGroup, ...accessGroup };

    state.allAccessGroups.splice(index, 1, newAccessGroup);

    let { tree, map } = buildDataTree(state.allAccessGroups, 'rowId', 'parentAccessGroupId');
    state.allAccessGroupsTree = tree;
    state.allAccessGroupsTreeMap = map;
};
export const addAccessGroup = (state, accessGroup) => {
    state.allAccessGroups.push(accessGroup);
    state.allAccessGroupsMap = buildIdMap(state.allAccessGroups);

    let { tree, map } = buildDataTree(state.allAccessGroups, 'rowId', 'parentAccessGroupId');
    state.allAccessGroupsTree = tree;
    state.allAccessGroupsTreeMap = map;
};

export const setIsActiveRequestAllUsers = (state, flag) => (state.isActiveRequestAllUsers = flag);
export const setAllUsers = (state, allUsers) => (state.allUsers = allUsers);
export const clearAllUsers = state => (state.allUsers = []);

export const setIsOpenEditGroupModal = (state, flag) => (state.isOpenEditGroupModal = flag);
export const setEditGroupModalData = (state, data) => {
    state.editGroupModalData = {
        ...state.editGroupModalData,
        ...data
    };
};
export const clearEditGroupModalData = state => {
    state.editGroupModalData = { id: null, name: null, parentAccessGroupId: null, ruleIds: [], userIds: [] };
};

export const setDeleteGroupModalData = (state, data) => {
    state.deleteGroupModalData = {
        ...state.deleteGroupModalData,
        ...data
    };
};
export const clearDeleteGroupModalData = state => {
    state.deleteGroupModalData = { id: null };
};
