import { date as quasarDate } from 'quasar';
import toTimestamp from './toTimestamp';

export default (time, unit, add) => quasarDate.addToDate(toTimestamp(time), { [unit]: add });
