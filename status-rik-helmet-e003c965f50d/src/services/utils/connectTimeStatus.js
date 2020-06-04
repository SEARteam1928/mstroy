const connectTimeStatus = diffTime => {
    let connectTimeStatus = 'empty';

    if (!diffTime) return connectTimeStatus;

    switch (true) {
        // 5 - 15 мин
        case diffTime > 6 * 60 * 1000 && diffTime < 16 * 60 * 1000:
            connectTimeStatus = 'warning';
            break;

        // > 15 мин
        case diffTime > 16 * 60 * 1000:
            connectTimeStatus = 'error';
            break;

        // < 5 мин
        default:
            connectTimeStatus = 'normal';
            break;
    }

    return connectTimeStatus;
};

export default connectTimeStatus;
