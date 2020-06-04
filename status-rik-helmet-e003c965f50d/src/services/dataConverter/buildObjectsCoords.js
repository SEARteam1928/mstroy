export default (objects, objectsCoords) => {
    // Итоговый массив объектов с координатами и информацией о них
    let coordsArr = [];
    // Карта для сопоставления object_id и индекса в итоговом массиве
    let objectIdMap = {};

    let objectMap = {};

    objects.forEach(object => {
        objectMap[object.id] = object;
    });

    let unusedIds = {};

    objectsCoords.forEach(({ object_id, latitude, longitude }) => {
        let object = objectMap[object_id];
        if (object === undefined) {
            let num = unusedIds[object_id];
            num = num !== undefined ? num : 0;
            unusedIds[object_id] = ++num;

            return;
        }
        let { name, color, is_work_area, radius, project_id } = object;

        let idIndex = objectIdMap[object_id];
        let latLng = [Number(latitude), Number(longitude)];

        // Если объекта с object_id еще нет итоговом массиве
        if (idIndex === undefined) {
            idIndex = coordsArr.length;
            objectIdMap[object_id] = idIndex;

            // Добавим шаблон объекта в итоговый массив
            coordsArr.push({
                name,
                color,
                radius,
                is_work_area,
                object_id,
                project_id,
                zone: [latLng]
            });

            // Если объекта с object_id уже есть в итоговом массиве, добавим ему только координаты
        } else {
            coordsArr[idIndex].zone.push(latLng);
        }
    });

    // console.log('-----------');
    // console.log('coordsArr: ', coordsArr);
    // console.log('objectIdMap: ', objectIdMap);
    // console.log('nameIdMap: ', nameIdMap);
    // console.log('colorIdMap: ', colorIdMap);
    // console.log('-----------');

    // console.log('unusedIds: ', unusedIds);
    let unusedIdsAmount = Object.keys(unusedIds).reduce((acc, id) => acc + unusedIds[id], 0);
    console.log(
        '%c%s%c %d',
        'background-color: #f06292',
        'Количество мусорных координат рабочих зон: ',
        'background-color: transparent; color: rgb(153, 128, 255)',
        unusedIdsAmount
    );

    return coordsArr;
};
