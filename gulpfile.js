const gulp = require('gulp');
const elm = require('gulp-elm');
const sass = require('gulp-sass');
const cssmin = require('gulp-cssmin');
const concat = require('gulp-concat');
const nodemon = require('gulp-nodemon');
const runSequence = require('run-sequence');
const browserSync = require('browser-sync').create();

/// VARS

const appPort = 7100;
const cssFile = 'style.build.css';
const elmFile = 'elm.build.js';
const staticJs = './static/js';
const staticCss = './static/css';

let elmDebug = false;
let serverStarted = false;
let streamOpts =
    { script: 'index.js'
    , env: { 'NODE_ENV': 'production' }
    };


/// SASS

gulp.task('sass', () => {
    return gulp
        .src('./scss/index.scss')
        .pipe(sass({outputStyle:'compressed'})).on('error', sass.logError)
        .pipe(concat(cssFile))
        .pipe(cssmin())
        .pipe(gulp.dest(staticCss))
        .pipe(browserSync.stream());
});


/// ELM

gulp.task('elm-init', elm.init);
gulp.task('elm-watch', ['elm'], () => browserSync.reload)
gulp.task('elm', ['elm-init'], () => {
    return gulp
        .src(['src/**/*.elm'])
        .pipe(elm.bundle(elmFile, {debug: elmDebug})).on('error', console.log)
        .pipe(gulp.dest(staticJs));
});


/// START

gulp.task('start', cb => {
    return nodemon(streamOpts)
        .on('start', () => {
            if (!serverStarted) {
                console.log('Server started...');
                serverStarted = true;
                cb();
            }
        })
        .on('restart', () => {
            console.log('Server restarted...');
        });
});


/// WATCH

gulp.task('watch', () => {
    gulp.watch(['scss/**/*.scss'], ['sass']);
    gulp.watch(['src/**/*.elm'], ['elm-watch']);
    gulp.watch('index.js', ['start']);
});


/// BROWSERSYNC

gulp.task('browsersync', () => {
    // Serve files from the root of this project
    browserSync.init({
        open: false
        , port: appPort + 1
        , browser: 'google chrome'
        , files: 'views/**/*.pug'
        , proxy: {
            target: `localhost:${appPort}`
        }
        , ui: {
            port: appPort + 2
        }
    });

    runSequence(
        'elm'
        , 'sass'
        , 'watch'
        , 'start'
    );
});


/// DEFAULT

gulp.task('default', () => gulp.start('browsersync'));
gulp.task('debug', () => {
    elmDebug = true;
    streamOpts.env.NODE_ENV = 'development';
    gulp.start('browsersync');
});
