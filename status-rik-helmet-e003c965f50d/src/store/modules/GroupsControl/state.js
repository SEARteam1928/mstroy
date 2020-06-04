export default {
    isActiveRequestAllAccessGroups: false,
    allAccessGroups: [],
    allAccessGroupsMap: {},
    allAccessGroupsTree: [],
    allAccessGroupsTreeMap: {},
    selectedGroupId: null,

    isActiveRequestAllUsers: false,
    allUsers: [],

    isOpenEditGroupModal: false,
    editGroupModalData: {
        id: null,
        name: null,
        parentAccessGroupId: null,
        ruleIds: [],
        userIds: []
    },

    deleteGroupModalData: {
        id: null
    },

    moduleErrors: {
        requestAllAccessGroups: false,
        requestAllUsers: false,
        requestUpdateAccessGroup: false,
        requestCreateAccessGroup: false,
        requestDeleteAccessGroups: false
    }
};
