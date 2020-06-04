export default GQLData => {
    let result = [];

    if (!GQLData || !GQLData.data.allPlannedWorks instanceof Array) return result;

    result = GQLData.data.allPlannedWorks.map(({ startDate, endDate, wbsElementId, wbsElement }) => {
        let {
            parentWbsElementId,
            operName,
            isResource,
            factVolume,
            workLoadSum,
            cSum1,
            cSum111,
            cSum112,
            resCentHour,
            measureUnit
        } = wbsElement;

        let resource = {
            factVolume,
            workLoadSum,
            cSum1,
            cSum111,
            cSum112,
            resCentHour,
            measureUnitShortName: measureUnit ? measureUnit.shortName : null
        };

        let data = {
            start_date: new Date(startDate),
            end_date: new Date(endDate),
            id: wbsElementId,
            text: operName,
            parent: parentWbsElementId,
            isResource,
            resource
        };

        // Если у ноды нет родительского задания, значит эта нода - проект
        if (!data.parent) {
            data.type = 'project';
            data.open = true;
        }

        return data;
    });

    return result;
};
