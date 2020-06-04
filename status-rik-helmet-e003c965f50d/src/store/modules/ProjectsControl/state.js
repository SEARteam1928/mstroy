export default {
    projectEntityId: null,
    projectsFilter: '',
    selectedProjectsId: [],

    editProjectModalData: {
        id: null,
        name: null,
        shortName: null,
        dateBegin: null,
        dateComplete: null,
        cost: null,
        timeZoneOffset: null,
        latitude: null,
        longitude: null,
        repoId: null,
        characteristics: null
    },
    isOpenEditProjectModal: false,
    isCreatingProject: false,
    isEditingProject: false,

    deleteProjectModalData: {
        id: null
    },
    isDeletionProject: false,

    editAccessModalData: {
        projectId: null,
        projectName: null,
        projectAccessRulesId: {
            createId: null,
            readId: null,
            updateId: null,
            deleteId: null
        },
        persistent: false
    },
    isLoadingProjectAccessRules: false,
    isOpenEditAccessModal: false,

    moduleErrors: {
        requestCreateProject: false,
        requestEditProject: false,
        requestDeleteProject: false,
        requestProjectAccessRules: false,
        requestCreateAccessRuleForNewProject: false
    }
};
