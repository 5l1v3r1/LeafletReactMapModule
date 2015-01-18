var gulp = require('gulp');
var browserify = require('browserify');
var browsersync = require('browser-sync');
var source = require('vinyl-source-stream');
var $ = require('./gulp/gulpfile_function.js');
var config = require('./gulp/gulpfile_config.js');

//sass      //rename        //gutil      //mainBowerFiles   //if            //copy
//jade      //streamify     //uglify     //wiredep          //bowerCopy
//notify    //filter        //concat     //usemin           //swallowError

var base = config.base;
var path = config.path;
var bower_overrides = config.bower_overrides;


//
////fire up browsersync server
gulp.task('browsersync',function(){
    browsersync({
        open: false,
        server : {
            baseDir: base.dst
        }
    });
});

//
//
////compile apps
gulp.task('app', function() {
    return browserify([path.coffeescript.src + '/main.coffee'])
        .transform("coffee-reactify")
        .require(base.bower + "/reflux/dist/reflux.js", {
            expose: 'reflux'
        })
        .bundle()
        .on("error", $.swallowError)
        .pipe(source('app.js'))
        .pipe($.streamify($.concat('app.js')))
        .pipe(gulp.dest(path.js.dst))
        .pipe($.streamify($.uglify()))
        .pipe($.rename("app.min.js"))
        .pipe(gulp.dest(path.coffeescript.dst))
        .pipe(browsersync.reload({
            stream: true
        }));
});
//
//
//
//
gulp.task('jade', function() {
    var wiredep_exclude =
        [
            "bootstrap-sass-official",
            "reflux.js", 
            "jquery",
            "bootstrap.js",
        ];
    var wiredep_config = {
        overrides: bower_overrides,
        exclude: wiredep_exclude
    };
    var wiredep = require('wiredep');
    $.wiredep = wiredep.stream;
    //var assets = $.useref.assets();
    //console.log(wiredep(path.jade.src));
    var src = path.jade.src;

    console.log(wiredep(wiredep_config).js);
    console.log(wiredep(wiredep_config).css);

    return gulp.src(src)
            .pipe($.wiredep(wiredep_config))
            .pipe($.jade({
                pretty: true
            }))
            .pipe($.usemin({
                js: [$.uglify()],
                css: [$.minifyCss(), 'concat']
            }))
            .on("error", $.swallowError)
            .pipe(gulp.dest(path.jade.dst))
            .pipe(browsersync.reload({
                stream: true
            }));
});
//
//
gulp.task('copy-vendor-files', function() {
    gulp.src($.bowerCopy("boot/dist/fonts/"))
    .pipe(gulp.dest(base.dst + "/fonts"));
    gulp.src($.bowerCopy("leaflet/dist/images/"))
    .pipe(gulp.dest(base.dst + "/images"));

});
//
//
gulp.task('watch', function() {
    gulp.watch(path.jade.src, ['jade']);
    gulp.watch(path.coffeescript.src + '/**/**/*.coffee', ['app']);
});
//
//
//
gulp.task('default', ['watch', 'browsersync']);
gulp.task('build-vendor', ['jade', 'copy-vendor-files']);
//
//