import { date as quasarDate } from 'quasar';
import toTimestamp from './toTimestamp';
import subDate from './subDate';
import startDate from './startDate';

export default time => {
    time = toTimestamp(time);
    let dow = quasarDate.getDayOfWeek(time);
    let startDiff = (1 - dow) * -1;
    let startDay = subDate(time, 'days', startDiff);

    return startDate(startDay, 'day');
};
