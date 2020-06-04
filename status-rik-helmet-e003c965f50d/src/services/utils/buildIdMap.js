const buildIdMap = (array, idKey = 'rowId') => {
    let map = {};
    array.forEach((elem, index) => (map[elem[idKey]] = index));

    return map;
};

export default buildIdMap;
