export const isActiveRequestAllAccessGroups = state => state.isActiveRequestAllAccessGroups;
export const allAccessGroups = state => state.allAccessGroups;
export const allAccessGroupsMap = state => state.allAccessGroupsMap;
export const allAccessGroupsTree = state => state.allAccessGroupsTree;
export const allAccessGroupsTreeMap = state => state.allAccessGroupsTreeMap;
export const selectedGroupId = state => state.selectedGroupId;
export const isSelectedGroupId = state => id => state.selectedGroupId === id;
export const selectedGroup = state => state.allAccessGroupsTreeMap[state.selectedGroupId];
export const getGroupById = state => id => state.allAccessGroupsTreeMap[id];

export const isActiveRequestAllUsers = state => state.isActiveRequestAllUsers;
export const allUsers = state => state.allUsers;

export const isOpenEditGroupModal = state => state.isOpenEditGroupModal;
export const editGroupModalData = state => state.editGroupModalData;

export const deleteGroupModalData = state => state.deleteGroupModalData;
