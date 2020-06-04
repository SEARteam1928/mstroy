import { date } from 'quasar';

export default work_hours => {
    let result = [];

    work_hours.forEach(({ day, spider_hours, excel_hours, total_hours, effective_percentage }, index) => {
        let dateTS = date.extractDate(day, 'YYYY-MM-DD');
        result.push({
            day: date.formatDate(dateTS, 'DD.MM.YYYY'),
            spider_hours,
            excel_hours,
            total_hours,
            effective_percentage: effective_percentage + '%'
        });
    });

    return result;
};
