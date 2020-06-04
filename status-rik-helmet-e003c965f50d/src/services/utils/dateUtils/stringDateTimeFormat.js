import parse from './parse';
import { date as quasarDate } from 'quasar';

export default date => {
    date = parse(date);

    return quasarDate.formatDate(date, 'DD.MM.YYYY HH:mm:ss');
};
