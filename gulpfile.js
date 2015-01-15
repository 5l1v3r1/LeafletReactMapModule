
var gulp            = require('gulp');

var sass            = require('gulp-sass');
var jade            = require('gulp-jade');
var notify          = require('gulp-notify');
var gutil           = require('gulp-util');
var uglify          = require('gulp-uglify');  
var concat          = require('gulp-concat');
var rename          = require('gulp-rename');  
var streamify       = require('gulp-streamify');
var filter          = require('gulp-filter');

var browserify      = require('browserify');
var source          = require('vinyl-source-stream');
var mainBowerFiles  = require('main-bower-files');
var browsersync     = require('browser-sync');
var reload          = browsersync.reload;


var scriptFilter = filter(['*.js', '*.coffee']);
var notScriptFilter = filter(['!*.js', '!*.coffee', '*']);

function swallowError(error) {
    console.log(error.toString());
    gutil.beep();
    this.emit('end');
}

gulp.copy=function(src,dest){
    return gulp.src(src, {base:"."})
        .pipe(gulp.dest(dest));
};


var vendors = 
{
 //   jquery:                         "./bower_components/jquery/dist/jquery.js",    
 //   underscore:                     "./bower_components/underscore/underscore.js",
 //   backbone:                       "./bower_components/backbone/backbone.js",
 //   backbone_babysitter:            "./bower_components/backbone.babysitter/lib/backbone.babysitter.js",
 //   backbone_wreqr:                 "./bower_components/backbone.wreqr/lib/backbone.wreqr.js",    
 //   marionette:                     "./bower_components/marionette/lib/backbone.marionette.min.js",
    underscore:                     "./bower_components/underscore/underscore.js",
    reactjs:                        "./bower_components/react/react-with-addons.js",
 //   reflux:                         "./bower_components/reflux/dist/reflux.js"
};

var vendor_files = [];
for (var vendor in vendors) {
    vendor_files.push(vendors[vendor]);
}


var base = {
    src : "./src",
    dst : "./build"
};

var path = {
    jade : {
        src: base.src + '/jade/*.jade',
        dst: base.dst
    },
    template : {
        src: "",
        dst: ""
    },
    vendor : {
        dst : base.dst + "/js/vendor"
    },
    js : {
        src: base.src + "/js",
        dst: base.dst + "/js"
    },
    coffeescript : {
        src: base.src + "/coffeescript",
        dst: base.dst + "/js"
    },    
    html : {
        src: "",
        dst: ""
    },
};

//fire up browsersync server
gulp.task('browsersync',function(){
    browsersync({
        open: false,
        server : {
            baseDir: base.dst
        }
    });
});


//bundle vendor js
gulp.task('vendor', function(){ 
    var vendorFiles = gulp.src(vendor_files)
        //.pipe(scriptFilter)
        .pipe(concat('vendor.js'))
        .pipe(gulp.dest(path.vendor.dst))                
        .pipe(uglify())
        .pipe(rename("vendor.min.js"))
        .pipe(gulp.dest(path.vendor.dst));
});



//vendor leaflet
gulp.task('vendor-leaflet', function(){
    
    var basedir = './bower_components/leaflet/dist';
    var vendordir = '/leaflet'

    return gulp.src([ basedir + '/**/*', '!**/leaflet-src.js'], {base: basedir})
            .pipe(gulp.dest(path.vendor.dst + vendordir));
});

//vendor prunecluster
gulp.task('vendor-prunecluster', function(){
    
    var basedir = './bower_components/PruneCluster/dist';
    var vendordir = '/prunecluster'

    return gulp.src([ basedir + '/**/*.css', basedir + '/**/*.min.js', basedir + '/**/*.js.map' ], {base: basedir})
            .pipe(gulp.dest(path.vendor.dst + vendordir));
});

gulp.task('vendor-jsonlayer', function(){
    
    var basedir = './bower_components/leaflet-layerJSON/dist';
    var vendordir = '/leaflet-layerJSON';

    return gulp.src([ basedir + '/**/*.js'], {base: basedir})
            .pipe(gulp.dest(path.vendor.dst + vendordir)).pipe(reload({stream : true}));

});

//compile apps
gulp.task('app', function() {
    return browserify(path.coffeescript.src + '/main.coffee')
        .transform("coffee-reactify")
        .require("./bower_components/reflux/dist/reflux.js", { expose: 'reflux'})
        //.transform("debowerify")
        //.transform("hbsfy")
        .bundle()
        .on("error", swallowError)
        .pipe(source('app.js'))
        .pipe(streamify(concat('app.js')))
        .pipe(gulp.dest(path.js.dst))        
        .pipe(streamify(uglify()))
        .pipe(rename("app.min.js"))        
        .pipe(gulp.dest(path.js.dst))
        .pipe(reload({stream : true}));
 });


gulp.task('jade-index', function() {
    return gulp.src(path.jade.src)
        .pipe(jade({
            pretty: true
        }))
        .on("error", swallowError)
        .pipe(gulp.dest(path.jade.dst))
        .pipe(reload({stream : true}));
});


gulp.task('jade', function() {
    return gulp.src(path.src.jade)
        .pipe(jade())
        .pipe(gulp.dest(path.dst.html))
});



gulp.task('watch', function() {
    gulp.watch("/Applications/AMPPS/www/biodesign/biodesign-frontend/bower_components/leaflet-layerJSON/dist/leaflet-layerjson.src.js" , ['vendor-jsonlayer']);
    gulp.watch(path.jade.src, ['jade-index']);
    gulp.watch(path.coffeescript.src + '/**/**/*.coffee', ['app']);
});



gulp.task('default', ['watch', 'browsersync']);
gulp.task('build-vendor', ['vendor','vendor-jsonlayer', 'vendor-prunecluster', 'vendor-leaflet']);

