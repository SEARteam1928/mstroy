import { colors as quasarColors } from 'quasar';

export default () => {
    return {
        props: {
            state: {
                type: Object,
                required: false,
                default: () => ({
                    name: 'normal',
                    color: false
                })
            },
            colorizeNormal: {
                type: Boolean,
                required: false,
                default: false
            }
        },
        watch: {
            state: {
                handler(newState) {
                    this.setStateColor(newState.color);
                },
                deep: true
            }
        },
        mounted() {
            this.setStateColor();
        },
        methods: {
            setStateColor(color = this.state.color) {
                if (color && this.state.name !== 'normal') {
                    this.$refs.section && this.$refs.section.style.setProperty('--section-color', color);
                    this.$refs.section && this.$refs.section.style.setProperty('--value-color', color);
                } else if (color && this.state.name === 'normal' && this.colorizeNormal) {
                    this.$refs.section && this.$refs.section.style.setProperty('--section-color', color);
                    this.$refs.section &&
                        this.$refs.section.style.setProperty('--value-color', quasarColors.lighten(color, -20));
                } else {
                    this.$refs.section && this.$refs.section.style.removeProperty('--section-color');
                    this.$refs.section && this.$refs.section.style.setProperty('--value-color', 'inherit');
                }
            }
        }
    };
};
