const isUndefined = value => value === undefined;

const evaluateGuards = (guards, to, from, next, store) => {
    const guardsLeft = [...guards];
    const nextGuard = guardsLeft.shift();

    if (isUndefined(nextGuard)) {
        next();
        return;
    }

    const nextFn = nextArg => {
        if (isUndefined(nextArg)) {
            evaluateGuards(guardsLeft, to, from, next, store);
            return;
        }

        next(nextArg);
    };

    nextGuard(to, from, nextFn, store);
};

export default guards => {
    if (!(guards instanceof Array)) guards = [guards];

    return (to, from, next, store) => evaluateGuards(guards, to, from, next, store);
};
