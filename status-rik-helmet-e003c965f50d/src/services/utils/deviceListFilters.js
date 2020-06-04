import isFalse from './isFalse';
import computeDiffTime from './computeDiffTime';
import connectTimeStatus from './connectTimeStatus';

const filterWithSessions = devices => devices.filter(({ owner }) => !isFalse(owner) && !isFalse(owner.id));
const filterWithoutSessions = devices => devices.filter(({ owner }) => isFalse(owner) || isFalse(owner.id));
const filterWithActivityLevel = devices =>
    devices.filter(
        ({ activityLevel }) =>
            activityLevel instanceof Array && !isFalse(activityLevel[0]) && activityLevel[0].value > 0
    );
const filterWithoutActivityLevel = devices =>
    devices.filter(
        ({ activityLevel }) =>
            activityLevel instanceof Array && !isFalse(activityLevel[0]) && activityLevel[0].value === 0
    );

const filterWithConnectionError = devices =>
    devices.filter(({ connectTime, requestTimestamp }) => {
        let diffTime = computeDiffTime(connectTime).number;

        return connectTimeStatus(diffTime) === 'error';
    });
const filterWithConnectionWarning = devices =>
    devices.filter(({ connectTime, requestTimestamp }) => {
        let diffTime = computeDiffTime(connectTime).number;

        return connectTimeStatus(diffTime) === 'warning';
    });
const filterWithConnectionNormal = devices =>
    devices.filter(({ connectTime, requestTimestamp }) => {
        let diffTime = computeDiffTime(connectTime).number;

        return connectTimeStatus(diffTime) === 'normal';
    });

export default [
    {
        label: 'Устройства с сессиями',
        value: 'filterWithSessions',
        filter: filterWithSessions
    },
    {
        label: 'Устройства без сессий',
        value: 'filterWithoutSessions',
        filter: filterWithoutSessions
    },
    {
        label: 'Устройства c активностью',
        value: 'filterWithActivityLevel',
        filter: filterWithActivityLevel
    },
    {
        label: 'Устройства без активности',
        value: 'filterWithoutActivityLevel',
        filter: filterWithoutActivityLevel
    },
    {
        label: 'Связь > 15мин.',
        value: 'filterWithConnectionError',
        filter: filterWithConnectionError
    },
    {
        label: 'Связь > 5мин. и < 15мин.',
        value: 'filterWithConnectionWarning',
        filter: filterWithConnectionWarning
    },
    {
        label: 'Связь < 5мин.',
        value: 'filterWithConnectionNormal',
        filter: filterWithConnectionNormal
    }
];
