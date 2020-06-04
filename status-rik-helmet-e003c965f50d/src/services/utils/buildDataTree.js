export default (array, idProp = 'rowId', parentIdProp = 'parentElementId') => {
    let hashTable = Object.create(null);
    array.forEach(el => {
        hashTable[el[idProp]] = { ...el, children: [] };
    });

    let dataTree = [];
    array.forEach(el => {
        if (el[parentIdProp]) hashTable[el[parentIdProp]].children.push(hashTable[el[idProp]]);
        else dataTree.push(hashTable[el[idProp]]);
    });

    return {
        tree: dataTree,
        map: hashTable
    };
};
