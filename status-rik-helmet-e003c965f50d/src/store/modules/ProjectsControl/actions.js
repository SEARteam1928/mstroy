import Api from '@services/api';
import isFalse from '@services/utils/isFalse';
import buildProjectAccessRules from '@services/dataConverter/buildProjectAccessRules';

export const requestCreateProject = async ({ getters, commit }, createData) => {
    createData = isFalse(createData) ? getters.editProjectModalData : createData;
    let {
        name,
        shortName,
        dateBegin,
        dateComplete,
        cost,
        timeZoneOffset,
        latitude,
        longitude,
        repoId,
        characteristics
    } = createData;

    if (isFalse(name) || isFalse(shortName)) return;

    cost = parseFloat(cost);
    timeZoneOffset = parseInt(timeZoneOffset);
    latitude = parseFloat(latitude);
    longitude = parseFloat(longitude);

    try {
        commit('clearError', 'requestCreateProject');
        commit('setIsCreatingProject', true);

        let result = await Api.createProject({
            name,
            shortName,
            dateBegin,
            dateComplete,
            cost,
            timeZoneOffset,
            latitude,
            longitude,
            repoId,
            characteristics
        });
        let createdProject = result.data.createProject.project;

        return createdProject;
    } catch (err) {
        commit('setError', {
            type: 'requestCreateProject',
            error: err
        });
    } finally {
        commit('setIsCreatingProject', false);
    }
};

export const requestEditProject = async ({ getters, commit }, editData) => {
    editData = isFalse(editData) ? getters.editProjectModalData : editData;
    let {
        id,
        name,
        shortName,
        dateBegin,
        dateComplete,
        cost,
        timeZoneOffset,
        latitude,
        longitude,
        repoId,
        characteristics
    } = editData;

    if (isFalse(id) || isFalse(name) || isFalse(shortName)) return;

    cost = parseFloat(cost);
    timeZoneOffset = parseInt(timeZoneOffset);
    latitude = parseFloat(latitude);
    longitude = parseFloat(longitude);

    try {
        commit('clearError', 'requestEditProject');
        commit('setIsEditingProject', true);

        let result = await Api.updateProject({
            id,
            name,
            shortName,
            dateBegin,
            dateComplete,
            cost,
            timeZoneOffset,
            latitude,
            longitude,
            repoId,
            characteristics
        });
        let updatedProject = result.data.updateProject.project;

        return updatedProject;
    } catch (err) {
        commit('setError', {
            type: 'requestEditProject',
            error: err
        });
    } finally {
        commit('setIsEditingProject', false);
    }
};

export const requestDeleteProject = async ({ getters, commit }, id) => {
    id = isFalse(id) ? getters.deleteProjectModalData.id : id;
    if (isFalse(id)) return;

    try {
        commit('clearError', 'requestDeleteProject');
        commit('setIsDeletionProject', true);

        let result = await Api.deleteProject(id);
        let deletedId = result.data.deleteProject.project.rowId;

        return deletedId;
    } catch (err) {
        commit('setError', {
            type: 'requestDeleteProject',
            error: err
        });
    } finally {
        commit('setIsDeletionProject', false);
    }
};

export const requestCreateAccessRuleForNewProject = async ({ getters, commit }, params) => {
    let { projectEntityId } = getters;
    let { projectId, projectName, withRead = false, withUpdate = false, withDelete = false } = params;

    if (isFalse(projectEntityId) || isFalse(projectId) || isFalse(projectName)) return;

    try {
        commit('clearError', 'requestCreateAccessRuleForNewProject');

        let result = await Api.createAccessRuleForNewProject({
            projectEntityId,
            projectId,
            projectName,
            withRead,
            withUpdate,
            withDelete
        });

        let readId = result.data?.readAccessRule?.accessrule?.rowId;
        let updateId = result.data?.updateAccessRule?.accessrule?.rowId;
        let deleteId = result.data?.deleteAccessRule?.accessrule?.rowId;
        let res = { readId, updateId, deleteId };

        return res;
    } catch (err) {
        commit('setError', {
            type: 'requestCreateAccessRuleForNewProject',
            error: err
        });
    }
};

export const requestProjectAccessRules = async ({ getters, commit }, projectId) => {
    let { projectEntityId } = getters;
    if (isFalse(projectEntityId) || isFalse(projectId)) return;

    let filters = {
        accessRowIdEq: projectId,
        entityIdEq: projectEntityId
    };

    try {
        commit('clearError', 'requestProjectAccessRules');
        commit('setIsLoadingProjectAccessRules', true);

        let result = await Api.allAccessRules({ filters, forceFetch: true });
        let allAccessRules = result.data.allAccessRules;
        let projectAccessRulesId = buildProjectAccessRules(allAccessRules);

        return projectAccessRulesId;
    } catch (err) {
        commit('setError', {
            type: 'requestProjectAccessRules',
            error: err
        });
    } finally {
        commit('setIsLoadingProjectAccessRules', false);
    }
};
