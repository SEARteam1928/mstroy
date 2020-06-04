import allProjectElementsQuery from './graphql/bim/allProjectElementsQuery.gql';
import allConstructivesQuery from './graphql/bim/allConstructivesQuery.gql';
import updateConstructiveVersionMutation from './graphql/bim/updateConstructiveVersionMutation.gql';
import allWorksQuery from './graphql/bim/allWorksQuery.gql';
import allProjectResourcesQuery from './graphql/bim/allProjectResourcesQuery.gql';
import allConstructiveVersionsQuery from './graphql/bim/allConstructiveVersionsQuery.gql';

export async function allProjectElements(filters) {
    let result = await this.apollo.query({
        query: allProjectElementsQuery,
        variables: { filters }
    });

    return result;
}

export async function allConstructives({ projectIdEq, projectTransactionIdEq }) {
    let result = await this.apollo.query({
        query: allConstructivesQuery,
        variables: { projectIdEq, projectTransactionIdEq }
    });

    return result;
}

export async function updateConstructiveVersion({ id, appId }) {
    let result = await this.apollo.mutate({
        mutation: updateConstructiveVersionMutation,
        variables: { id, appId }
    });

    return result;
}

export async function allWorks({ projectIdEq, parentElementIdEq }) {
    let result = await this.apollo.query({
        query: allWorksQuery,
        variables: { projectIdEq, parentElementIdEq }
    });

    return result;
}

export async function allProjectResources({ projectIdEq, parentElementIdIn }) {
    let result = await this.apollo.query({
        query: allProjectResourcesQuery,
        variables: { projectIdEq, parentElementIdIn }
    });

    return result;
}

export async function allConstructiveVersions({ appId }) {
    let result = await this.apollo.query({
        query: allConstructiveVersionsQuery,
        variables: { appId }
    });

    return result;
}
