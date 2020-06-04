var MILLISECONDS_IN_MINUTE = 60000;

export default dirtyDate => {
    let date = new Date(dirtyDate.getTime());
    let baseTimezoneOffset = date.getTimezoneOffset();
    date.setSeconds(0, 0);
    let millisecondsPartOfTimezoneOffset = date.getTime() % MILLISECONDS_IN_MINUTE;

    return baseTimezoneOffset * MILLISECONDS_IN_MINUTE + millisecondsPartOfTimezoneOffset;
};
