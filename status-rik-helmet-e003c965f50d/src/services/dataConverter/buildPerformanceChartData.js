export default performanceAnalyzeZonesData => {
    let result = [];
    if (!(performanceAnalyzeZonesData instanceof Array) || !performanceAnalyzeZonesData.length) return [];

    performanceAnalyzeZonesData.forEach(({ name, in_zone_hours }) => {
        result.push({
            name,
            value: in_zone_hours
        });
    });

    return result;
};
