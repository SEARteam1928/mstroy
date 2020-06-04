const rand = (min, max) => Math.floor(min + Math.random() * (max + 1 - min));

const sessinsDataGenerate = () => {
    let data = [];
    let currentDate = +new Date().setHours(8, 0, 0, 0);
    // 1 мин
    let min = 60000;
    // Сутки
    let day = 86400000;

    for (let i = 0; i < 30; i++) {
        let startTime = currentDate + (day * i);
        let workTime = rand(4 * 60, 8 * 60) * min;

        data.push({
            StartTime: startTime,
            EndTime: startTime + workTime,
            // 480 - это 8 часов в минутах
            Accepted: rand(0, workTime / min),
            Total: workTime / min,
        })
    }

    return data;
}

export default sessinsDataGenerate;
