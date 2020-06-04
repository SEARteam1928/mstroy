import isFalse from '@services/utils/isFalse';

const buildProjectAccessRules = rules => {
    let rulesId = {
        createId: null,
        readId: null,
        updateId: null,
        deleteId: null
    };

    rules.forEach(({ rowId: id, create, read, update, delete: del }) => {
        rulesId.createId = !isFalse(create) && isFalse(read) && isFalse(update) && isFalse(del) ? id : rulesId.createId;
        rulesId.readId = isFalse(create) && !isFalse(read) && isFalse(update) && isFalse(del) ? id : rulesId.readId;
        rulesId.updateId = isFalse(create) && isFalse(read) && !isFalse(update) && isFalse(del) ? id : rulesId.updateId;
        rulesId.deleteId = isFalse(create) && isFalse(read) && isFalse(update) && !isFalse(del) ? id : rulesId.deleteId;
    });

    return rulesId;
};

export default buildProjectAccessRules;
