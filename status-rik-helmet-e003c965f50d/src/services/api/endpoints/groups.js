import allAccessGroupsQuery from './graphql/groups/allAccessGroupsQuery.gql';
import updateAccessGroupMutation from './graphql/groups/updateAccessGroupMutation.gql';
import createAccessGroupMutation from './graphql/groups/createAccessGroupMutation.gql';
import deleteAccessGroupMutation from './graphql/groups/deleteAccessGroupMutation.gql';

export async function allAccessGroups() {
    let result = await this.apollo.query({
        query: allAccessGroupsQuery
    });

    return result;
}

export async function createAccessGroup(input) {
    let result = await this.apollo.mutate({
        mutation: createAccessGroupMutation,
        variables: { input }
    });

    return result;
}

export async function updateAccessGroup(input) {
    let result = await this.apollo.mutate({
        mutation: updateAccessGroupMutation,
        variables: { input }
    });

    return result;
}

export async function deleteAccessGroup(id) {
    let result = await this.apollo.mutate({
        mutation: deleteAccessGroupMutation,
        variables: { id }
    });

    return result;
}
