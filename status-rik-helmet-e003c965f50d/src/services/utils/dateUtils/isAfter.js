import { date as quasarDate } from 'quasar';
import toTimestamp from './toTimestamp';

export default (date1, date2) => {
    date1 = toTimestamp(date1);
    date2 = toTimestamp(date2);

    if (quasarDate.isSameDate(date1, date2)) return false;

    let max = quasarDate.getMaxDate(date1, date2);

    return quasarDate.isSameDate(max, date1);
};
