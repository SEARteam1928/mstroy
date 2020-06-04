// Получить список работников
export async function workers(id) {
    let url = `${this.statusFreya}/workers/`;
    if (typeof id === 'number') {
        url += id;
    }

    let res = await this.axios(url);

    return res.data;
}
