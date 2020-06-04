import allTimeResourcesQuery from './graphql/time_resource/allTimeResourcesQuery.gql';

export async function allTimeResources(filters) {
    let result = await this.apollo.query({
        query: allTimeResourcesQuery,
        variables: { filters }
    });

    return result;
}

export async function timeResource(projectId, workerId) {
    let url = `${this.statusFreya}/time_resource/?project_id=${projectId}`;
    if (workerId !== undefined) {
        url += `&worker_id=${workerId}`;
    }

    let res = await this.axios(url);

    return res.data;
}
