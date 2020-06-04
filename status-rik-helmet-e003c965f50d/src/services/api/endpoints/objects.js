// Получить массив гео-объектов
export async function getObjects() {
    let res = await this.axios(`${this.statusFreya}/objects/`);

    return res;
}

// Получить записи координат для гео-объектов
export async function getObjectsCoords() {
    let res = await this.axios(`${this.statusFreya}/objects_coords/`);

    return res;
}

export async function addNewObject(objectData) {
    delete objectData.coordinates;

    let res = await this.axios.post(`${this.statusFreya}/objects`, objectData);
    console.log('addNewObject res: ', res);

    return res;
}

// Добавить или изменить гео-объект
export async function addObject(objectData) {
    // let newObjectRes = await this.addNewObject(objectData);

    let res = await this.axios.post(`${this.statusFreya}/objects/with_borders`, objectData);
    console.log('addObject res: ', res);

    return res;
}

// Удаление объекта
export async function deleteObject(objectId) {
    let res = await this.axios.delete(`${this.statusFreya}/objects/${objectId}`);
    console.log('deleteObject res: ', res);

    return res;
}
