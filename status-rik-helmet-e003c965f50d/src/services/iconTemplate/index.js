class IconTemplate {
    constructor() {
        if (typeof IconTemplate.instance === 'object') {
            return IconTemplate.instance;
        }

        IconTemplate.instance = this;

        this.base64prefix = 'data:image/svg+xml;base64,';
        this.replaceStrategy = {
            attrValue: (rule, value) => `${rule}="${value}"`,
            styleValue: (rule, value, { styleValuePostfix }) => `${rule}:${value}${styleValuePostfix}`
        };
    }

    decodeSVG(base64Content) {
        return atob(base64Content.replace(this.base64prefix, ''));
    }

    camelToKebab(string) {
        return string.replace(/([a-z])([A-Z])/g, '$1-$2').toLowerCase();
    }

    attrReplace(content, rules) {
        for (let rule in rules) {
            rule = this.camelToKebab(rule);
            // https://regex101.com/r/z4L3av/3
            let regex = new RegExp(
                `${rule}="(?<attrValue>.+?)"|${rule}\s*?:\s*?(?<styleValue>.+?)(?<styleValuePostfix>[;"\s])`,
                'gi'
            );

            let value = rules[rule];
            content = content.replace(regex, (...match) => {
                let matchGroups = match.pop();
                let strategyName = Object.keys(this.replaceStrategy)
                    .filter(key => matchGroups[key] !== undefined)
                    .shift();
                let strategy = this.replaceStrategy[strategyName];

                return strategy(rule, value, matchGroups);
            });
        }

        return content;
    }

    templateReplace(content, rules) {
        let restRules = { ...rules };

        // https://regex101.com/r/YV1wbj/2
        let regex = /{{(?<rule>\w+\d*?)}}/gi;

        let match;
        while ((match = regex.exec(content)) !== null) {
            if (match.index === regex.lastIndex) {
                regex.lastIndex++;
            }

            let rule = match.groups.rule;
            let value = rules[rule];
            if (value !== undefined) {
                content = content.replace(match[0], value);

                delete restRules[rule];
            }
        }

        return this.attrReplace(content, restRules);
    }

    toBase64(content) {
        return this.base64prefix + btoa(content);
    }

    template = (icon, rules, base64 = true) => {
        let iconContent = require(`./icons/${icon}.svg`);
        let pureContent = this.decodeSVG(iconContent);
        let result = this.templateReplace(pureContent, rules);
        result = base64 ? this.toBase64(result) : result;

        return result;
    };
}

export default new IconTemplate().template;
