export default measureUnit => {
    let result = {
        name: null,
        shortName: null
    };

    // Если есть и полное имя величины измерения и короткое
    if (measureUnit && measureUnit.name && measureUnit.shortName) {
        let { name, shortName } = measureUnit;
        // Если имена совпадают
        if (name === shortName) {
            result.shortName = measureUnit.shortName;
        } else {
            result.name = measureUnit.name;
            result.shortName = measureUnit.shortName;
        }

        // Если есть только полное имя величины измерения
    } else if (measureUnit && measureUnit.name && !measureUnit.shortName) {
        result.shortName = measureUnit.name;

        // Если есть только короткое имя величины измерения
    } else if (measureUnit && !measureUnit.name && measureUnit.shortName) {
        result.shortName = measureUnit.shortName;
    }

    return result;
};
