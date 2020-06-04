export const setProjectEntityId = (state, id) => (state.projectEntityId = id);
export const setSelectedProjectsId = (state, selectedProjectsId) => (state.selectedProjectsId = selectedProjectsId);
export const clearSelectedProjectsId = state => (state.selectedProjectsId = []);

export const setEditProjectModalData = (state, data) => {
    state.editProjectModalData = {
        ...state.editProjectModalData,
        ...data
    };
};
export const clearEditProjectModalData = state => {
    state.editProjectModalData = {
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
    };
};
export const setIsOpenEditProjectModal = (state, flag) => (state.isOpenEditProjectModal = flag);
export const setIsCreatingProject = (state, flag) => (state.isCreatingProject = flag);
export const setIsEditingProject = (state, flag) => (state.isEditingProject = flag);

export const setDeleteProjectModalData = (state, data) => {
    state.deleteProjectModalData = {
        ...state.deleteProjectModalData,
        ...data
    };
};
export const clearDeleteProjectModalData = state => (state.deleteProjectModalData = { id: null });
export const setIsDeletionProject = (state, flag) => (state.isDeletionProject = flag);

export const setEditAccessModalData = (state, data) => {
    state.editAccessModalData = {
        ...state.editAccessModalData,
        ...data
    };
};
export const clearEditAccessModalData = state => {
    state.editAccessModalData = {
        projectId: null,
        projectName: null,
        projectAccessRulesId: {
            createId: null,
            readId: null,
            updateId: null,
            deleteId: null
        },
        persistent: false
    };
};
export const setIsLoadingProjectAccessRules = (state, flag) => (state.isLoadingProjectAccessRules = flag);
export const setIsOpenEditAccessModal = (state, flag) => (state.isOpenEditAccessModal = flag);
