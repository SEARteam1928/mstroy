import isFalse from './isFalse';

export default (date, withTime = false) => {
    let result = '';
    let time = '';
    if (isFalse(date)) return '';

    let splittedDate = date.split(' ');
    let datePart = splittedDate[0];
    let timePart = splittedDate[1];
    if (isFalse(datePart)) return '';

    if (withTime && !isFalse(timePart)) {
        let clearedTime = timePart.split(/[\.+]/)[0];
        time = clearedTime ? ` ${clearedTime}` : '';
    }

    result = datePart
        .split('-')
        .reverse()
        .join('.');

    return result + time;
};
