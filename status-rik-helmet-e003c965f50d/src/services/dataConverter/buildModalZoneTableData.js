const buildFullName = worker => {
    let fullName = `${worker.last_name} ${worker.first_name} ${worker.surname}`;

    return fullName;
};

export default (data, workers, object_id) => {
    console.log('buildModalZoneTableData', data, workers);
    let result = [];
    let indexMap = {};
    let filteredData = data.filter(item => item.object_id === object_id);

    filteredData.forEach(({ worker_id, total_hours, activity_hours }) => {
        let index = indexMap[worker_id];

        if (index === undefined) {
            index = result.length;
            indexMap[worker_id] = index;
            result.push({
                worker_id,
                name: buildFullName(workers[worker_id]),
                total_hours: 0,
                activity_hours: 0
            });
        }

        result[index].total_hours += Number(total_hours);
        result[index].activity_hours += Number(activity_hours);
    });

    console.log('result: ', result);

    return result;
};
