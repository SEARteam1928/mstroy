export default (val, fixed = 0) => {
    let result;

    if (typeof val === 'number') {
        result = val.toFixed(fixed);
    } else if (typeof val === 'string') {
        result = parseFloat(val).toFixed(fixed);
    }

    return result;
};
