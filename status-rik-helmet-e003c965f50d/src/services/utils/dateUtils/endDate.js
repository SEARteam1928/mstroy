import { date as quasarDate } from 'quasar';
import toTimestamp from './toTimestamp';

export default (time, unit) => quasarDate.endOfDate(toTimestamp(time), unit);
