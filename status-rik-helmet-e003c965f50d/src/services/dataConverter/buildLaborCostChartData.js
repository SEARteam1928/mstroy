export default (nearObjectsData, defaultColor) => {
    let data = [];
    let colors = {};
    // Карта id зоны: Имя зоны
    let map = {};

    // Карта число: его индекс в массиве data
    let daysMap = {};

    nearObjectsData.forEach(({ created_at, id, name, count, color }) => {
        map[id] = name;

        let dayIndex = daysMap[created_at];

        // Если этого дня еще нет в массиве data
        if (dayIndex === undefined) {
            daysMap[created_at] = data.length;
            dayIndex = data.length;

            data.push({ day: created_at });
        }

        let day = data[dayIndex];

        // Берем количество часов в этот день по зоне `id`
        let idCount = day[id] || 0;
        idCount += Number(count);
        day[id] = idCount;

        color = color || defaultColor;
        colors[id] = color;
    });

    let ids = {};
    for (let id in colors) {
        ids[id] = 0;
    }

    data = data.map(day => ({ ...ids, ...day }));

    return {
        data,
        colors,
        map
    };
};
