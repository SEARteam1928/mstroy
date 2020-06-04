const checkIntersectionArrays = (arr1, arr2) => {
    // Если один или оба аргумента не массивы
    if (!(arr1 instanceof Array) || !(arr2 instanceof Array)) return false;
    // Если хотя бы один массив пустой
    if (arr1.length === 0 || arr2.length === 0) return false;

    let equalLength = arr1.length === arr2.length;
    let wasIntersection = false;
    let set1 = new Set(arr1);

    for (let index = 0; index < arr2.length; index++) {
        const element = arr2[index];

        // Если элемент из set1 удален, значит он есть в обоих массивах и как минимум, есть их пересечение
        if (set1.delete(element)) {
            wasIntersection = true;
        }
    }

    // Если длина массивов была одинаковая, были пересечения и в set1 не осталось элементов, значит массивы совпадают
    if (equalLength && wasIntersection && set1.size === 0) return true;

    // Если был хотя бы один общий элемент в обоих массивах
    if (wasIntersection) return null;

    // Если не было общих элементов
    if (!wasIntersection) return false;
};

export default checkIntersectionArrays;
