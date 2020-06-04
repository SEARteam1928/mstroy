export default apiData => {
    // console.log('apiData: ', apiData);
    let result = [];
    let nameIndexMap = {};

    apiData.forEach(({ hours_amount, in_zone_hours, name, pay_amount, percentages, is_work_area }) => {
        let index = nameIndexMap[name];

        if (index === undefined) {
            index = result.length;
            nameIndexMap[name] = index;

            result.push({
                pp: index + 1,
                name,
                inZoneHours: 0,
                percentages: 0,
                hoursAmount: 0,
                payAmount: 0,
                is_work_area
            });
        }

        let objectItem = result[index];

        let inZoneHours = Number(in_zone_hours);
        let _percentages = Number(percentages) * 100;
        let hoursAmount = Number(hours_amount);
        let payAmount = Number(pay_amount);

        objectItem.inZoneHours += inZoneHours;
        objectItem.percentages += _percentages;
        objectItem.hoursAmount += hoursAmount;
        objectItem.payAmount += payAmount;
    });

    result = result.map(({ pp, name, inZoneHours, percentages, hoursAmount, payAmount, is_work_area }) => {
        return {
            pp,
            name,
            inZoneHours: inZoneHours.toFixed(2),
            percentages: percentages.toFixed(2) + '%',
            hoursAmount: hoursAmount.toFixed(2),
            payAmount: payAmount.toFixed(2),
            is_work_area
        };
    });

    return result;
};
