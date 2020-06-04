export default (current, total) => {
    if (total === 0) return 0;

    return (current * 100) / total;
};
