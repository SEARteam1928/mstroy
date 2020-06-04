import allAccessRulesQuery from './graphql/access_rules/allAccessRulesQuery.gql';
import createAccessRuleForNewProjectMutation from './graphql/access_rules/createAccessRuleForNewProjectMutation.gql';

export async function allAccessRules({ filters = {}, forceFetch = false } = {}) {
    let result = await this.apollo.query({
        query: allAccessRulesQuery,
        variables: { filters },
        fetchPolicy: forceFetch ? 'network-only' : 'cache-first'
    });

    return result;
}

export async function createAccessRuleForNewProject({
    projectEntityId,
    projectId,
    projectName,
    withRead,
    withUpdate,
    withDelete
}) {
    let readName = `Доступ на чтение для проекта "${projectName}"`;
    let updateName = `Доступ на изменение для проекта "${projectName}"`;
    let deleteName = `Доступ на удаление для проекта "${projectName}"`;

    let result = await this.apollo.mutate({
        mutation: createAccessRuleForNewProjectMutation,
        variables: { projectEntityId, projectId, withRead, readName, withUpdate, updateName, withDelete, deleteName },
        refetchQueries: [{ query: allAccessRulesQuery }],
        awaitRefetchQueries: true
    });

    return result;
}
