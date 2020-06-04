export const allEntities = state => state.allEntities;
export const getEntityIdByName = state => name => {
    let _entity = state.allEntities.find(
        entity => entity.tableName === name || entity.graphqlName === name || entity.restApiName === name
    );

    return _entity?.rowId;
};
