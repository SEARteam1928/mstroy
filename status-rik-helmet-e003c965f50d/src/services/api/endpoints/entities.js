import allEntitiesQuery from './graphql/entities/allEntitiesQuery.gql';

export async function allEntities() {
    let result = await this.apollo.query({
        query: allEntitiesQuery
    });

    return result;
}
