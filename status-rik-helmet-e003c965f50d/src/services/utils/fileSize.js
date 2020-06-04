export default (size = 0, extend = false) => {
    size = +size;
    if (isNaN(size)) return false;
    let level_counter = 0;
    let levels = ['Б', 'КБ', 'МБ', 'ГБ', 'ТБ'];

    const check = size => {
        if (size > 1024 && level_counter < 4) {
            level_counter++;
            return check(size / 1024);
        } else {
            return size;
        }
    };

    if (extend) {
        return {
            size: check(size),
            level: level_counter,
            unit: levels[level_counter]
        };
    } else {
        return `${check(size).toFixed(1)} ${levels[level_counter]}`;
    }
};
