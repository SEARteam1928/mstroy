import { date as quasarDate } from 'quasar';
import toTimestamp from './toTimestamp';

export default (time, unit) => quasarDate.startOfDate(toTimestamp(time), unit);
