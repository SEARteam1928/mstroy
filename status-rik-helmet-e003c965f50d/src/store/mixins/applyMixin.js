const applyMixin = (mixinData, moduleData, namespaced = true) => {
    let result = { namespaced };
    let keyNames = [].concat(Object.keys(mixinData), Object.keys(moduleData));

    keyNames.forEach(key => (result[key] = { ...mixinData[key], ...moduleData[key] }));

    return result;
};

export default applyMixin;
