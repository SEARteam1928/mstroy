import { date as quasarDate } from 'quasar';
import toTimestamp from './toTimestamp';
import addDate from './addDate';
import endDate from './endDate';

export default time => {
    time = toTimestamp(time);
    let dow = quasarDate.getDayOfWeek(time);
    let endDiff = 7 - dow;
    let endDay = addDate(time, 'days', endDiff);

    return endDate(endDay, 'day');
};
