import allUsersQuery from './graphql/users/allUsersQuery.gql';
import createUserMutation from './graphql/users/createUserMutation.gql';
import updateUserMutation from './graphql/users/updateUserMutation.gql';
import deleteUserMutation from './graphql/users/deleteUserMutation.gql';
import getUserQuery from './graphql/users/getUserQuery.gql';

export async function allUsers() {
    let result = await this.apollo.query({
        query: allUsersQuery
    });

    return result;
}

export async function createUser({ email, username, password, workerId }) {
    let result = await this.apollo.mutate({
        mutation: createUserMutation,
        variables: { email, username, password, workerId }
    });

    return result;
}

export async function updateUser({ id, email, username, password, roleIds }) {
    let result = await this.apollo.mutate({
        mutation: updateUserMutation,
        variables: { id, email, username, password, roleIds }
    });

    return result;
}

export async function deleteUser(id) {
    let result = await this.apollo.mutate({
        mutation: deleteUserMutation,
        variables: { id }
    });

    return result;
}

export async function getUser(id) {
    let result = await this.apollo.query({
        query: getUserQuery,
        variables: { id }
    });

    return result;
}
