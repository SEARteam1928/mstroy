import Api from '@services/api';
import isFalse from '@services/utils/isFalse';
import buildDataTree from '@services/utils/buildDataTree';
import delay from '@services/utils/delay';

export const requestAllProjectElements = async ({ getters, commit }) => {
    let { projectId, actualTransactionId } = getters;
    if (isFalse(projectId) || isFalse(actualTransactionId)) return;

    try {
        commit('clearError', 'requestAllProjectElements');

        let res = await Api.allConstructives({
            projectIdEq: projectId,
            projectTransactionIdEq: actualTransactionId
        });
        let { tree, map } = buildDataTree(res.data.allConstructives);

        commit('setAllProjectElementsMap', map);
        commit('setAllProjectElements', tree);
    } catch (err) {
        commit('setError', {
            type: 'requestAllProjectElements',
            error: err
        });
    }
};

export const requestUpdateConstructiveVersion = async ({ getters, commit }, { id, appId }) => {
    if (isFalse(id) || isFalse(appId)) return;

    try {
        commit('clearError', 'requestUpdateConstructiveVersion');

        let res = await Api.updateConstructiveVersion({ id, appId });

        return res.data.updateConstructiveVersion;
    } catch (err) {
        commit('setError', {
            type: 'requestUpdateConstructiveVersion',
            error: err
        });

        return false;
    }
};

export const requestWorks = async ({ getters, commit, dispatch }) => {
    let { projectId: projectIdEq, selectedCompleteData } = getters;
    let { constructiveId: parentElementIdEq } = selectedCompleteData;
    if (isFalse(projectIdEq) || isFalse(parentElementIdEq)) return;

    try {
        commit('clearError', 'requestWorks');

        let res = await Api.allWorks({ projectIdEq, parentElementIdEq });
        let worksArray = res.data.allWorks;
        let worksIdArray = worksArray.map(({ rowId }) => rowId);

        let resources = await dispatch('requestResources', worksIdArray);

        commit('setSelectedCompleteData', { worksArray, worksIdArray, resources });
    } catch (err) {
        commit('setError', {
            type: 'requestWorks',
            error: err
        });
    }
};

export const requestResources = async ({ getters, commit }, parentElementIdIn) => {
    let { projectId: projectIdEq } = getters;
    if (isFalse(projectIdEq) || parentElementIdIn.length === 0) return [];

    try {
        commit('clearError', 'requestResources');

        let res = await Api.allProjectResources({ projectIdEq, parentElementIdIn });
        let allProjectResources = res.data.allProjectResources;

        return allProjectResources;
    } catch (err) {
        commit('setError', {
            type: 'requestResources',
            error: err
        });

        return [];
    }
};

export const requestConstructiveByAppId = async ({ getters, commit }) => {
    let { selectedCompleteData } = getters;
    let { appId } = selectedCompleteData;
    if (isFalse(appId)) return;

    try {
        commit('clearError', 'requestConstructiveByAppId');

        let res = await Api.allConstructiveVersions({ appId });
        let allConstructiveVersions = res.data.allConstructiveVersions[0];
        if (!allConstructiveVersions) return;

        let { constructiveId, constructive, volume, cost, versionStart, versionFinish } = allConstructiveVersions;
        let constructiveName = null;
        let constructiveCode = null;
        let isComplete = null;
        let measureUnit = null;

        if (constructive) {
            constructiveName = constructive.name;
            constructiveCode = constructive.code;
            isComplete = constructive.isComplete;
            measureUnit = constructive.measureUnit;
        }

        commit('setSelectedCompleteData', {
            constructiveId,
            volume,
            cost,
            versionStart,
            versionFinish,
            constructiveName,
            constructiveCode,
            isComplete,
            measureUnit
        });
    } catch (err) {
        commit('setError', {
            type: 'requestConstructiveByAppId',
            error: err
        });
    }
};
