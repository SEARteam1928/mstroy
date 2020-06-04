import { buildDevicesQuery, buildPeriodQuery, buildActiveQuery } from '../utils';

// Получить массив координат
export async function getDevicesCoordinates(devices, period, active) {
    // Собирает строку параметров с перечислением нужных устройств
    let devicesQuery = buildDevicesQuery(devices);
    if (!devicesQuery) {
        return false;
    }

    // Собирает строку параметров для выбора временнОго периода
    let periodQuery = buildPeriodQuery(period);
    // Получать активные/не активные/любые координаты
    let activeQuery = buildActiveQuery(active);

    // Вся строка параметров в сборе
    let queryParamsString = `${devicesQuery}&${periodQuery}&_limit=1000000${activeQuery}`;

    let res = await this.axiosBimApi(`${this.bimApi}/devicecoordinates?${queryParamsString}`, {
        headers: {}
    });

    return res;
}

export async function getCoordinatesByWorker(workerId, from, to, onlyActive = true, withoutNulls = true) {
    let url = this.statusFreya;
    url += `/device_coordinates/coords_by_worker/${workerId}`;
    url += `?from_date=${from}&to_date=${to}`;
    url += `&without_nulls=${withoutNulls}&only_active=${onlyActive}`;
    url += `&orderby=TimeStamp&limit=1000000`;

    let res = await this.axios(url);

    return res.data;
}

export async function getCoordinatesExcel(deviceId, from, to) {
    let url = this.statusFreya;
    url += `/device_coordinates/device_coordinate_excel/${deviceId}`;
    url += `?from_date=${from}&to_date=${to}`;

    let res = await this.axios(url);

    return res.data;
}
