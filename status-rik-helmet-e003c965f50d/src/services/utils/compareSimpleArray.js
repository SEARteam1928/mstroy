const compareSimpleArray = (arr1, arr2) => {
    let wasBreak = false;

    // Если один или оба аргумента не массивы
    if (!(arr1 instanceof Array) || !(arr2 instanceof Array)) return false;

    // Если разное количество элементов
    if (arr1.length !== arr2.length) return false;

    // let set1 = new Set(arr1);
    let set2 = new Set(arr2);

    for (let index = 0; index < arr1.length; index++) {
        const element = arr1[index];

        // Если элемент из set2 не удален, значит он есть в arr1, но его нет в arr2
        if (!set2.delete(element)) {
            wasBreak = true;
            break;
        }
    }

    // Если цикл был прерван из-за не соответствия
    // или в set2 остались элементы после полного прохода по элементам arr1, то массивы не равны
    if (wasBreak || set2.size !== 0) return false;

    // Если дошло до сюда, то массивы равны
    return true;
};

export default compareSimpleArray;
