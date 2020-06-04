export async function recalculateAll(from, to) {
    let params = `from_date=${from}&to_date=${to}`;
    let res = await this.axios(`${this.statusFreya}/database_procedure/recalculate_all?${params}`);

    return res;
}
