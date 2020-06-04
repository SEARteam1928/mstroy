const buildTotalRow = (total, all) => {
    let totalRow = {
        name: all ? 'Итого общее' : 'Итого',
        in_zone_hours: 0,
        percentages: 0,
        hours_amount: 0,
        pay_amount: 0,
        section: all ? 'total' : 'subTotal'
    };

    if (!total) return totalRow;

    totalRow.in_zone_hours = total.in_zone_hours;
    totalRow.percentages = Math.round(total.percentages) + '%';
    totalRow.hours_amount = total.hours_amount;
    totalRow.pay_amount = total.pay_amount;

    return totalRow;
};

export default apiData => {
    let result = [];
    let subTitlePerformance = 'Производительные:';
    let subTitleNotPerformance = 'Непроизводительные:';

    let workHours = apiData.work_hours.map((work_hours, index) => {
        return {
            pp: index + 1,
            ...work_hours,
            percentages: Math.round(work_hours.percentages) + '%'
        };
    });

    let performanceSubTitle = { name: subTitlePerformance, section: 'subTitle' };
    let performance = workHours.filter(({ is_work_area }) => is_work_area);
    let performanceSubTotal = buildTotalRow(apiData.work_in_zone);

    let notPerformanceSubTitle = { name: subTitleNotPerformance, section: 'subTitle' };
    let notPerformance = workHours.filter(({ is_work_area }) => !is_work_area);
    let notPerformanceSubTotal = buildTotalRow(apiData.work_not_in_zone);

    let total = buildTotalRow(apiData.total, true);

    result = result.concat(
        performanceSubTitle,
        performance,
        performanceSubTotal,
        notPerformanceSubTitle,
        notPerformance,
        notPerformanceSubTotal,
        total
    );

    return result;
};
