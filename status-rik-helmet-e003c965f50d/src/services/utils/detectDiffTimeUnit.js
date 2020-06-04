export default (time1, time2) => {
    let unit = '';
    let displayUnit = '';
    let diff = time1 - time2;

    switch (true) {
        case diff > 0 && diff < 60 * 1000:
            unit = 'seconds';
            displayUnit = 'сек.';
            break;

        case diff >= 60000 && diff < 60 * 60 * 1000:
            unit = 'minutes';
            displayUnit = 'мин.';
            break;

        case diff >= 60 * 60 * 1000 && diff < 24 * 60 * 60 * 1000:
            unit = 'hours';
            displayUnit = 'ч.';
            break;

        default:
            unit = 'days';
            displayUnit = 'д.';
            break;
    }

    return {
        unit,
        displayUnit
    };
};
