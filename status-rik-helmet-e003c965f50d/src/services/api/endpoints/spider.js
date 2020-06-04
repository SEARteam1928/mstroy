import allPlannedWorksQuery from './graphql/spider/allPlannedWorksQuery.gql';

export async function allPlannedWorks() {
    let result = await this.apollo.query({
        query: allPlannedWorksQuery
    });

    return result;
}
