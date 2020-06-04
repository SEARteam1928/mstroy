<template>
    <q-icon
        class="q-icon q-icon-custom"
        :class="{ 'q-icon-custom-dense': dense }"
        :draggable="false"
        :name="src"
        :size="size + 'px'"
        :color="(colors && colors.primary) || defaultPrimary"
    />
</template>

<script>
import svgTemplate from './svg-icon-template.js';
import { colors as qColors } from 'quasar';

export default {
    name: 'QIconCustom',
    props: {
        colors: Object,
        dense: {
            type: Boolean,
            required: false
        },
        name: {
            type: String,
            required: true
        },
        size: {
            type: Number,
            required: false,
            default: 24
        }
    },
    data() {
        return {
            // https://regex101.com/r/YV1wbj/1
            regexTemplate: /{{(\w+\d?)}}/gm,
            // https://regex101.com/r/WvzsTC/2
            regexImgData: /^data:image\/.+/m,
            prefixImg: 'img:',
            prefix: 'img:data:image/svg+xml;charset=utf-8,',
            // defaultPrimary: 'custom-icon-primary',
            defaultPrimary: 'ms_black',
            defaultBg: 'custom-icon-bg',
            currentColors: null
        };
    },
    computed: {
        src() {
            let result = '';

            // Проверка на переданную иконку в data-троке
            let imgDataMatch = this.name.match(this.regexImgData);
            if (imgDataMatch && imgDataMatch[0]) {
                return this.prefixImg + imgDataMatch[0];
            }

            let colors = {};
            for (let name in this.colors) {
                // Если передано имя зарегистрированного цвета, берем значение цвета,
                // если нет - то оставляем как есть, значит передано уже само значение
                colors[name] = qColors.getBrand(this.colors[name])
                    ? qColors.getBrand(this.colors[name])
                    : this.colors[name];
            }

            // Основной сценарий - получение svg по имени и шаблонизация
            this.currentColors = {
                primary: qColors.getBrand(this.defaultPrimary),
                bg: qColors.getBrand(this.defaultBg),
                ...colors
            };

            let template = svgTemplate[this.name];

            if (template) {
                template = template.replace(this.regexTemplate, this.colorReplace);
                result = this.prefix + encodeURIComponent(template);
            } else {
                result = this.name;
            }

            return result;
        }
    },
    methods: {
        // '{{color1}}-ljlkjl-{{color2}}'.replace(/{{(\w+\d?)}}/gm, (...prop) => console.log(prop))

        /*  
            0: "{{color1}}"
            1: "color1"
            2: 0
            3: "{{color1}}-ljlkjl-{{color2}}"
        */
        colorReplace(...match) {
            return this.currentColors[match[1]] ? this.currentColors[match[1]] : '#000';
        }
    }
};
</script>

<style lang="sass" scoped>
.q-icon-custom
    &-dense
        width: 18px
        height: 18px
</style>
