// Форматирует денежные суммы, разделяя каждые 3 разряда числа пробелом

export default value => {
    if (!value) return value;
    // https://regex101.com/r/GsQygl/2
    const regex = /(\d)(?=(\d{3})+(?!\d))/g;

    return value.toString().replace(regex, '$1 ');
};
