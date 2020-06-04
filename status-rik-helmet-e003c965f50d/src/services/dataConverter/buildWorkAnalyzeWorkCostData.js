import { uid } from 'quasar';

const buildTotalRow = (total, all) => {
    let totalRow = {
        id: uid(),
        name: all ? 'Итого общее' : 'Итого',
        in_zone_hours: 0,
        percentages: 0,
        hours_amount: 0,
        pay_amount: 0,
        rowName: all ? 'total' : 'sub-total'
    };

    if (!total) return totalRow;

    totalRow.in_zone_hours = total.in_zone_hours;
    totalRow.percentages = Math.round(total.percentages) + '%';
    totalRow.hours_amount = total.hours_amount;
    totalRow.pay_amount = total.pay_amount;

    return totalRow;
};

export default tableData => {
    let result = [];
    let tableSubTitlePerformance = 'Производительные:';
    let tableSubTitleNotPerformance = 'Непроизводительные:';

    let workHours = tableData.work_hours.map((work_hours, index) => {
        return {
            id: uid(),
            pp: index + 1,
            ...work_hours,
            percentages: Math.round(work_hours.percentages) + '%'
        };
    });

    let performanceSubTitle = { id: uid(), name: tableSubTitlePerformance, section: 'sub-title' };
    let performance = workHours.filter(({ is_work_area }) => is_work_area);
    let performanceSubTotal = buildTotalRow(tableData.work_in_zone);

    let notPerformanceSubTitle = { id: uid(), name: tableSubTitleNotPerformance, section: 'sub-title' };
    let notPerformance = workHours.filter(({ is_work_area }) => !is_work_area);
    let notPerformanceSubTotal = buildTotalRow(tableData.work_not_in_zone);

    let totalRow = buildTotalRow(tableData.total, true);

    result = [
        performanceSubTitle,
        ...performance,
        performanceSubTotal,
        notPerformanceSubTitle,
        ...notPerformance,
        notPerformanceSubTotal,
        totalRow
    ];

    return result;
};
