import allProjectsQuery from './graphql/projects/allProjectsQuery.gql';
import createProjectMutation from './graphql/projects/createProjectMutation.gql';
import updateProjectMutation from './graphql/projects/updateProjectMutation.gql';
import deleteProjectMutation from './graphql/projects/deleteProjectMutation.gql';

export async function allProjects() {
    let result = await this.apollo.query({
        query: allProjectsQuery
    });

    return result;
}

export async function createProject(input = {}) {
    let result = await this.apollo.mutate({
        mutation: createProjectMutation,
        variables: { ...input },
        refetchQueries: [{ query: allProjectsQuery }],
        awaitRefetchQueries: true
    });

    return result;
}

export async function updateProject(input = {}) {
    let result = await this.apollo.mutate({
        mutation: updateProjectMutation,
        variables: { ...input },
        refetchQueries: [{ query: allProjectsQuery }],
        awaitRefetchQueries: true
    });

    return result;
}

export async function deleteProject(id) {
    let result = await this.apollo.mutate({
        mutation: deleteProjectMutation,
        variables: { id },
        refetchQueries: [{ query: allProjectsQuery }],
        awaitRefetchQueries: true
    });

    return result;
}
