import { date } from 'quasar';
import { clearTimeZone, dateISONormalize } from '../utils';

const correctToZeroTimezone = timestamp => {
    let offset = timestamp.getTimezoneOffset();
    offset = offset * 60 * 1000;

    timestamp = +timestamp + offset;

    return new Date(timestamp);
};

export default workAnalyzeTotalData => {
    let result = [];
    let currentMonth = date.formatDate(new Date(), 'MMMM YYYY');

    result = workAnalyzeTotalData.map(({ day, spider_hours, excel_hours, total_hours, effective_percentage }) => {
        // FIXME: Временная заглушка. В ответе с апи приходит часовой пояс +5,
        // если такой формат отдавать в конструктор даты, смещается число,
        // поэтому просто от строки отрезается часовой пояс
        let clearedFromDate = clearTimeZone(day);
        let timestamp = correctToZeroTimezone(new Date(clearedFromDate));
        let totalDay = date.formatDate(timestamp, 'MMMM YYYY');
        let from_date = dateISONormalize(timestamp);
        let to_date;

        if (totalDay !== currentMonth) {
            to_date = dateISONormalize(date.endOfDate(timestamp, 'month'));
        } else {
            to_date = dateISONormalize(new Date());
        }

        return {
            from_date,
            to_date,
            day: totalDay,
            spider_hours,
            excel_hours,
            total_hours,
            effective_percentage: effective_percentage + '%',
            rowName: 'total',
            daysData: []
        };
    });

    return result;
};
