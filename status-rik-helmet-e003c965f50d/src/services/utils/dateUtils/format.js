import { date as quasarDate } from 'quasar';
import toTimestamp from './toTimestamp';

export default (time, ...rest) => quasarDate.formatDate(toTimestamp(time), ...rest);
