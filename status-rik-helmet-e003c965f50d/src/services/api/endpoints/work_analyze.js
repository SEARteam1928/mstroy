// Данные для таблицы "Трудозатраты по различным источникам"
export async function workAnalyzeComparing(projectId, from, to) {
    let url = `${this.statusFreya}/work_analyze/comparing/${projectId}?from_date=${from}&to_date=${to}&orderby=day`;
    let res = await this.axios(url);

    return res.data;
}

// Данные для таблицы "Анализ трудозатрат по зонам производства работ"
export async function workAnalyzeWorkCost(projectId, from, to) {
    let url = `${this.statusFreya}/work_analyze/work_cost/${projectId}?from_date=${from}&to_date=${to}`;
    let res = await this.axios(url);

    return res.data;
}

// Получает часы работников, проведенные возле конкретного объекта за период времени
export async function workAnalyzeWorkCostObject(projectId, objectId, from, to) {
    let url = `${this.statusFreya}/work_analyze/work_cost/${projectId}/${objectId}?from_date=${from}&to_date=${to}`;
    let res = await this.axios(url);

    return res.data;
}

// Получает распределение часов работника по зонам объектов за период времени
export async function workAnalyzeWorkCostWorker(projectId, workerId, from, to) {
    let url = `${this.statusFreya}/work_analyze/work_cost_by_worker/${projectId}/${workerId}?from_date=${from}&to_date=${to}`;
    let res = await this.axios(url);

    return res.data;
}

// Получает список из строк "Итого" по месяцам для таблицы "Трудозатраты по различным источникам"
export async function workAnalyzeTotal(projectId) {
    let url = `${this.statusFreya}/work_analyze/total/${projectId}`;
    let res = await this.axios(url);

    return res.data;
}
