import allRolesQuery from './graphql/roles/allRolesQuery.gql';
import allScenariosQuery from './graphql/roles/allScenariosQuery.gql';
import createRoleMutation from './graphql/roles/createRoleMutation.gql';
import deleteRoleMutation from './graphql/roles/deleteRoleMutation.gql';
import updateRoleMutation from './graphql/roles/updateRoleMutation.gql';

export async function allRoles() {
    let result = await this.apollo.query({
        query: allRolesQuery
    });

    return result;
}

export async function allScenarios() {
    let result = await this.apollo.query({
        query: allScenariosQuery
    });

    return result;
}

export async function createRole({ name, description }) {
    let result = await this.apollo.mutate({
        mutation: createRoleMutation,
        variables: { name, description }
    });

    return result;
}

export async function deleteRole(id) {
    let result = await this.apollo.mutate({
        mutation: deleteRoleMutation,
        variables: { id }
    });

    return result;
}

export async function updateRole({ id, name, description, scenarioIds }) {
    let result = await this.apollo.mutate({
        mutation: updateRoleMutation,
        variables: { id, name, description, scenarioIds }
    });

    return result;
}
