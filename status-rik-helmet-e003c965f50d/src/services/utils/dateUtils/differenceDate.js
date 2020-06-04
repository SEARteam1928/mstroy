import { date as quasarDate } from 'quasar';
import toTimestamp from './toTimestamp';

export default (date1, date2, unit) => quasarDate.getDateDiff(toTimestamp(date1), toTimestamp(date2), unit);
