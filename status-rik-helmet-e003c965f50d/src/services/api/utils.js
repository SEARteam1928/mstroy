const buildDevicesQuery = devices => {
    let keyParam = 'dev_in';
    let keyInDevice = 'lora_key';

    if (typeof devices === 'string' || typeof devices === 'number') {
        devices = [
            {
                [keyInDevice]: devices
            }
        ];
    } else if (devices instanceof Array && !devices.length) {
        return false;
    }

    let queryString = devices.reduce((acc, device) => `${acc}${keyParam}=${device[keyInDevice]}&`, '');

    return queryString.slice(0, -1);
};

const buildPeriodQuery = ({ from, to }) => {
    let fromKeyParam = 'TimeStamp_gte';
    let toKeyParam = 'TimeStamp_lte';

    return `${fromKeyParam}=${from}&${toKeyParam}=${to}`;
};

const buildActiveQuery = active => {
    let activeParam = 'Activity';
    let activeQuery = '';
    if (active !== undefined && active !== null) {
        activeQuery = `&${activeParam}=${active}`;
    }

    return activeQuery;
};

const buildDirentsQuery = dirents => {
    dirents = dirents instanceof Array ? dirents : [dirents];
    let queryString = dirents.reduce((acc, item) => `${acc}&dirents=${item}`, '');

    return queryString.substr(1);
};

export { buildDevicesQuery, buildPeriodQuery, buildActiveQuery, buildDirentsQuery };
