export default timeStr => {
    // https://regex101.com/r/mjd4XW/3
    const regex = /[\-\+]\d{2}:\d{2}$/;

    // Отрезает от строкового представления даты часть, в которой указывается часовой пояс
    return timeStr.replace(regex, '');
};
