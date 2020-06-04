import { date as quasarDate } from 'quasar';
import toTimestamp from './toTimestamp';

export default (dateTarget, dateFrom, dateTo) =>
    quasarDate.isBetweenDates(toTimestamp(dateTarget), toTimestamp(dateFrom), toTimestamp(dateTo), {
        inclusiveFrom: true,
        inclusiveTo: true
    });
