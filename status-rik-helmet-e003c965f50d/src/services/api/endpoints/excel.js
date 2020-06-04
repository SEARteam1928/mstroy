// Данные из Excel табеля
export async function excelReportsHoursDays(toDate) {
    let url = `${this.statusFreya}/excel/reports/hours/days?to_date=${toDate}`;
    let res = await this.axios(url);

    return res;
}
