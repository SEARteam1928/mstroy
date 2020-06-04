export default time => {
    if (time instanceof Date) {
        return !isNaN(time);
    } else {
        throw new TypeError(toString.call(time) + ' is not an instance of Date');
    }
};
