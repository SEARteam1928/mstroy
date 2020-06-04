// Configuration for your app
// https://quasar.dev/quasar-cli/quasar-conf-js
require('dotenv').config();

const PUBLIC_PATH = process.env.PUBLIC_PATH || '/';

module.exports = function(ctx) {
    const config = {
        // app boot file (/src/boot)
        // --> boot files are part of "main.js"
        boot: ['vuex-router-sync', 'vue-json-viewer', 'portal-vue'],

        css: ['app.sass'],

        extras: [
            // 'ionicons-v4',
            // 'mdi-v3',
            // 'fontawesome-v5',
            // 'eva-icons',
            // 'themify',
            // 'roboto-font-latin-ext', // this or either 'roboto-font', NEVER both!

            'roboto-font', // optional, you are not bound to it
            'material-icons' // optional, you are not bound to it
        ],

        framework: {
            iconSet: 'material-icons',
            lang: 'ru', // Quasar language

            // all: true, // --- includes everything; for dev only!!!

            components: [
                'QLayout',
                'QHeader',
                'QDrawer',
                'QPageContainer',
                'QPage',
                'QToolbar',
                'QToolbarTitle',
                'QBtn',
                'QIcon',
                'QList',
                'QItem',
                'QItemSection',
                'QItemLabel',
                'QDialog',
                'QForm',
                'QInput',
                'QSpinnerPuff',
                'QTooltip',
                'QTable',
                'QTh',
                'QTr',
                'QTd',
                'QSelect',
                'QSpace',
                'QSeparator',
                'QCheckbox',
                'QSlideTransition',
                'QCard',
                'QCardSection',
                'QCardActions',
                'QTabPanels',
                'QTabPanel',
                'QTabs',
                'QTab',
                'QCircularProgress',
                'QDate',
                'QTime',
                'QPopupProxy',
                'QImg',
                'QPullToRefresh',
                'QAvatar',
                'QBtnDropdown',
                'QIntersection',
                'QColor',
                'QBar',
                'QLinearProgress',
                'QBadge',
                'QExpansionItem',
                'QRouteTab',
                'QScrollArea',
                'QTree',
                'QResizeObserver',
                'QPageSticky',
                'QSpinner',
                'QSlider',
                'QField',
                'QToggle',
                'QMenu',
                'QOptionGroup',
                'QInnerLoading',
                'QRadio'
            ],

            directives: ['Ripple', 'ClosePopup'],

            // Quasar plugins
            plugins: ['Notify', 'Meta']
        },

        supportIE: false,

        vueRouterMode: 'history',

        build: {
            env: {
                BIM_API: JSON.stringify(process.env.BIM_API),
                STATUS_FREYA_API: JSON.stringify(process.env.STATUS_FREYA_API),
                GRAPH_QL_API: JSON.stringify(process.env.GRAPH_QL_API),
                BIM_SERVER_URL: JSON.stringify(process.env.BIM_SERVER_URL)
            },

            scopeHoisting: true,

            // Нужен редирект на сервере
            vueRouterMode: 'history',
            publicPath: PUBLIC_PATH,

            // vueCompiler: true,
            gzip: true,
            // analyze: true,
            // extractCSS: false,

            extendWebpack(cfg) {
                const path = require('path');

                if (ctx.prod) {
                    const CopyPlugin = require('copy-webpack-plugin');

                    cfg.plugins.push(
                        new CopyPlugin([
                            {
                                // Копирование в dist\spa файла htaccess для работы роутера в режиме 'history' на хосте не в корне
                                from: path.resolve(cfg.resolve.alias.src, '.htaccess'),
                                to: cfg.output.path
                            }
                        ])
                    );
                }

                cfg.module.rules.push({
                    test: /\.(graphql|gql)$/,
                    exclude: /node_modules/,
                    loader: 'graphql-tag/loader'
                });

                cfg.resolve.alias = {
                    ...cfg.resolve.alias,
                    '@pages': path.resolve(__dirname, './src/pages'),
                    '@layouts': path.resolve(__dirname, './src/layouts'),
                    '@components': path.resolve(__dirname, './src/components'),
                    '@services': path.resolve(__dirname, './src/services'),
                    '@assets': path.resolve(__dirname, './src/assets'),
                    '@statics': path.resolve(__dirname, './src/statics'),
                    '@mixins': path.resolve(__dirname, './src/mixins'),
                    '@router': path.resolve(__dirname, './src/router')
                };

                const BitBarWebpackProgressPlugin = require('bitbar-webpack-progress-plugin');
                cfg.plugins.push(new BitBarWebpackProgressPlugin());
            }
        },

        devServer: {
            // https: true,
            // port: 8080,
            open: true // opens browser window automatically
        },

        // animations: 'all', // --- includes all animations
        animations: [],

        ssr: {
            pwa: false
        },

        pwa: {
            // workboxPluginMode: 'InjectManifest',
            // workboxOptions: {}, // only for NON InjectManifest
            manifest: {
                // name: 'Quasar App',
                // short_name: 'Quasar App',
                // description: 'A Quasar Framework app',
                display: 'standalone',
                orientation: 'portrait',
                background_color: '#ffffff',
                theme_color: '#027be3',
                icons: [
                    {
                        'src': 'statics/icons/icon-128x128.png',
                        'sizes': '128x128',
                        'type': 'image/png'
                    },
                    {
                        'src': 'statics/icons/icon-192x192.png',
                        'sizes': '192x192',
                        'type': 'image/png'
                    },
                    {
                        'src': 'statics/icons/icon-256x256.png',
                        'sizes': '256x256',
                        'type': 'image/png'
                    },
                    {
                        'src': 'statics/icons/icon-384x384.png',
                        'sizes': '384x384',
                        'type': 'image/png'
                    },
                    {
                        'src': 'statics/icons/icon-512x512.png',
                        'sizes': '512x512',
                        'type': 'image/png'
                    }
                ]
            }
        },

        cordova: {
            // id: 'org.cordova.quasar.app',
            // noIosLegacyBuildFlag: true, // uncomment only if you know what you are doing
        },

        electron: {
            // bundler: 'builder', // or 'packager'

            extendWebpack(cfg) {
                // do something with Electron main process Webpack cfg
                // chainWebpack also available besides this extendWebpack
            },

            packager: {
                // https://github.com/electron-userland/electron-packager/blob/master/docs/api.md#options
                // OS X / Mac App Store
                // appBundleId: '',
                // appCategoryType: '',
                // osxSign: '',
                // protocol: 'myapp://path',
                // Windows only
                // win32metadata: { ... }
            },

            builder: {
                // https://www.electron.build/configuration/configuration
                // appId: 'helmet'
            }
        }
    };

    return config;
};
