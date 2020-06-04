import random from './random';

export default array => {
    let arr = [...array];
    let result = [];

    while (arr.length) {
        let rand = random(0, arr.length - 1);
        let elem = arr.splice(rand, 1);
        result.push(elem[0]);
    }

    return result;
};
