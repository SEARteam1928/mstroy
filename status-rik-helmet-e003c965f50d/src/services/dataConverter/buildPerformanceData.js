import { toPercent } from '../utils';

export default apiData => {
    let result = [];
    let hourSalary = 200;
    let totalRow = {
        date: 'Итого',
        performance: 0,
        performanceNot: 0,
        performancePercent: 0,
        salaryPerformance: 0,
        salaryNotPerformance: 0,
        reportManHours: 0,
        reportFOT: 0,
        reportFOTPerformance: 0,
        reportReserve: 0,
        reportReservePercent: 0
    };

    apiData.forEach(({ day, device_hours_in_zone, device_hours_not_in_zone, percentage_in_zone, excel_hours }) => {
        let performance = Number(device_hours_in_zone);
        let performanceNot = Number(device_hours_not_in_zone);
        let performancePercent = Number(percentage_in_zone);

        let salaryPerformance = performance * hourSalary;
        let salaryNotPerformance = performanceNot * hourSalary;

        let reportManHours = Number(excel_hours);
        let reportFOT = reportManHours * hourSalary;
        let reportFOTPerformance = reportFOT * (performancePercent / 100);
        let reportReserve = reportFOT - reportFOTPerformance;
        let reportReservePercent = toPercent(reportFOTPerformance, reportReserve);

        result.push({
            date: day,
            // Трудозатраты
            performance,
            performanceNot,
            performancePercent: Number(performancePercent.toFixed(2)),

            // Зарплата
            salaryPerformance: Number(salaryPerformance.toFixed(2)),
            salaryNotPerformance,

            // Табель
            reportManHours,
            reportFOT,
            reportFOTPerformance: Number(reportFOTPerformance.toFixed(2)),
            reportReserve: Number(reportReserve.toFixed(2)),
            reportReservePercent: Number(reportReservePercent.toFixed(2))
        });

        totalRow.performance += performance;
        totalRow.performanceNot += performanceNot;
        totalRow.salaryPerformance += salaryPerformance;
        totalRow.salaryNotPerformance += salaryNotPerformance;
        totalRow.reportManHours += reportManHours;
        totalRow.reportFOT += reportFOT;
        totalRow.reportReserve += reportReserve;
    });

    totalRow.performancePercent = Number(
        toPercent(totalRow.performance, totalRow.performance + totalRow.performanceNot).toFixed(2)
    );

    totalRow.reportFOTPerformance = Number(totalRow.reportFOT * (totalRow.performancePercent / 100).toFixed(2));
    totalRow.reportReserve = Number(totalRow.reportReserve.toFixed(2));
    totalRow.reportReservePercent = Number(toPercent(totalRow.reportFOTPerformance, totalRow.reportReserve).toFixed(2));

    result.push(totalRow);

    return result;
};
