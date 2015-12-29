# Karma configuration
# Generated on Fri Dec 25 2015 22:41:07 GMT+0900 (JST)

module.exports = (config) ->
  config.set {
    # base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: '../..'
    # frameworks to use
    # available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['jasmine']

    # list of files / patterns to load in the browser
    files: [
        'js/lib/angular/angular.js'
        'js/lib/angular-mocks/angular-mocks.js'
        'js/lib/ngmap/build/scripts/ng-map.js'
        'https://cdnjs.cloudflare.com/ajax/libs/angular-material-icons/0.6.0/angular-material-icons.min.js'
        'https://cdnjs.cloudflare.com/ajax/libs/angular-touch/1.4.8/angular-touch.min.js'
        'js/*.js'
        'js/spec/*.js'
    ]


    # list of files to exclude
    exclude: []

    # preprocess matching files before serving them to the browser
    # available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
        'js/*.js': 'coverage'
    }

    # test results reporter to use
    # possible values: 'dots', 'progress'
    # available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['progress', 'coverage']
    coverageReporter : {
        reporters: [
            {
                type: 'lcov'
                dir : 'coverage/'
            }
            {
                type : 'html'
                dir : 'coverage/'
            }
        ]
    }


    # web server port
    port: 9876

    # enable / disable colors in the output (reporters and logs)
    colors: true

    # level of logging
    # possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_INFO

    # enable / disable watching file and executing tests whenever any file changes
    autoWatch: false

    # start these browsers
    # available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: ['Chrome']

    # Continuous Integration mode
    # if true, Karma captures browsers, runs the tests and exits
    singleRun: true

    # Concurrency level
    # how many browser should be started simultaneous
    concurrency: Infinity
  }
