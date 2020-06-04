import detectDiffTimeUnit from './detectDiffTimeUnit';
import dateParse from './dateUtils/parse';
import isFalse from './isFalse';
import { date as quasarDate } from 'quasar';

export default (pastTime, futureTime) => {
    let resultString = '';
    let resultNumber = '';

    // Если нет первой даты - выходим
    if (isFalse(pastTime))
        return {
            string: null,
            number: null,
            diff: null,
            unit: null,
            displayUnit: null
        };

    // Если первая дата - строка, парсим ее
    if (typeof pastTime === 'string') pastTime = dateParse(pastTime);

    // Если второй даты нет, получаем текущую
    if (isFalse(futureTime)) {
        futureTime = new Date();

        // Если вторая дата - строка, парсим ее
    } else if (typeof pastTime === 'string') {
        futureTime = dateParse(futureTime);
    }

    resultNumber = futureTime - pastTime;
    let { unit, displayUnit } = detectDiffTimeUnit(futureTime, pastTime);
    let diff = quasarDate.getDateDiff(futureTime, pastTime, unit);

    resultString = diff + displayUnit;

    return {
        string: resultString,
        number: resultNumber,
        diff,
        unit,
        displayUnit
    };
};
