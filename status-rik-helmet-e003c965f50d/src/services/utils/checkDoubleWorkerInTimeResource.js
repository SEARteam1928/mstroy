const checkDoubleWorkerInTimeResource = allTimeResources => {
    let doubleWorkers = {};
    let workerMap = {};

    allTimeResources.forEach(({ rowId, worker }) => {
        let { rowId: WorkerRowId } = worker;
        if (!workerMap[WorkerRowId]) {
            workerMap[WorkerRowId] = [];
        }

        workerMap[WorkerRowId].push(rowId);
    });

    for (const key in workerMap) {
        const resourceIds = workerMap[key];
        if (resourceIds.length > 1) {
            doubleWorkers[key] = resourceIds.length;
        }
    }

    console.log('doubleWorkers: ', doubleWorkers);
};

export default checkDoubleWorkerInTimeResource;
