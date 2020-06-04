module.exports = {
    default: {
        localRoot: './dist/spa/',
    },
    fast: {
        exclude: [
            'img/**/*.*',
            'statics/**/*.*',
            'fonts/**/*.*',
            '**/*.map',
        ],
    }
}
