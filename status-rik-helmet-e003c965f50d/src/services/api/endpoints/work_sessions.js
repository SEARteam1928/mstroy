import allWorkSessionsQuery from './graphql/work_sessions/allWorkSessionsQuery.gql';
import createWorkSessionMutation from './graphql/work_sessions/createWorkSessionMutation.gql';
import updateWorkSessionMutation from './graphql/work_sessions/updateWorkSessionMutation.gql';
import deleteWorkSessionMutation from './graphql/work_sessions/deleteWorkSessionMutation.gql';

export async function allWorkSessions(filters = {}, pagination = {}, orderBy = {}) {
    let result = await this.apollo.query({
        query: allWorkSessionsQuery,
        variables: { filters, pagination, orderBy }
    });

    return result;
}

export async function createWorkSession({ startDate, finishDate, deviceId, timeResourceId }) {
    let result = await this.apollo.mutate({
        mutation: createWorkSessionMutation,
        variables: { startDate, finishDate, deviceId, timeResourceId }
    });

    return result;
}

export async function updateWorkSession({ id, startDate, finishDate, deviceId, timeResourceId }) {
    let result = await this.apollo.mutate({
        mutation: updateWorkSessionMutation,
        variables: { id, startDate, finishDate, deviceId, timeResourceId }
    });

    return result;
}

export async function deleteWorkSession({ id }) {
    let result = await this.apollo.mutate({
        mutation: deleteWorkSessionMutation,
        variables: { id }
    });

    return result;
}

export async function workSessions(project_id, device_id) {
    let url = `${this.statusFreya}/work_sessions/?`;
    url += `project_id=${project_id}`;

    if (device_id !== undefined) {
        url += `&device_id=${device_id}`;
    }
    let res = await this.axios(url);

    return res.data;
}

export async function createSession(newSessionData) {
    let url = `${this.statusFreya}/work_sessions/`;

    // Если поле с датой окончания сессии пустое - удаляем его
    if (!newSessionData.finish_date) {
        delete newSessionData.finish_date;
    }

    let res = await this.axios.post(url, newSessionData);

    return res.data;
}

export async function updateSession(workSessionId, newSessionData) {
    let url = `${this.statusFreya}/work_sessions/${workSessionId}`;

    // Если поле с датой окончания сессии пустое - удаляем его
    if (!newSessionData.finish_date) {
        delete newSessionData.finish_date;
    }

    let res = await this.axios.put(url, newSessionData);

    return res.data;
}

export async function deleteSession(workSessionId) {
    let url = `${this.statusFreya}/work_sessions/${workSessionId}`;
    let res = await this.axios.delete(url);

    return res.data;
}
