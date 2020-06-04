import { date } from 'quasar';

export default _date => {
    // Модифицирует дату, компенсируя смещение по клиентской таймзоне
    // let result = date.addToDate(_date, { minutes: -_date.getTimezoneOffset() });
    // На выходе будет 2019-12-01T00:00:00.000Z
    // result = result.toISOString();

    let result = _date.toISOString();

    return result;
};
