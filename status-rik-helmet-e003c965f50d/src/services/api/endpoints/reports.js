// Данные о трудозатратах за месяц
export async function reportsHoursMonthComparing(fromDate) {
    let url = `${this.statusFreya}/reports/hours/month/comparing?from_date=${fromDate}&orderby=day`;
    let res = await this.axios(url);

    return res;
}

//
export async function getNearObjects(fromDate, toDate) {
    let url = `${this.statusFreya}/reports/get_near_objects?orderby=created_at&from_date=${fromDate}&to_date=${toDate}`;
    let res = await this.axios(url);

    return res;
}

// Получает активность работников во всех зонах за период времени
export async function reportsHoursObjectsWorkers(from, to) {
    let url = `${this.statusFreya}/reports/hours/objects/workers?from_date=${from}&to_date=${to}`;
    let res = await this.axios(url);

    return res.data;
}

// Данные о трудозатратах для страницы табеля
export async function reportsHoursComparing(projectId, fromDate, toDate) {
    let url = `${this.statusFreya}/reports/hours/comparing/${projectId}?from_date=${fromDate}&to_date=${toDate}`;
    let res = await this.axios(url);

    return res.data;
}
