var $ = require("gulp-load-plugins")({
    pattern: ['gulp-*', 'gulp.*', 'main-bower-files'],
    replaceString: /\bgulp[\-.]/
});



$.bowerCopy = function(filterFile){
    var callback = function(file)
    {
        return (file.indexOf(filterFile) > -1);
    };
    return $.mainBowerFiles({filter: callback});
};

$.swallowError = function(error) {
    console.log(error.toString());
    //$.gutil.beep();
    this.emit('end');
};


$.copy = function(src, dest) {
    return gulp.src(src, {
            base: "."
        })
        .pipe(gulp.dest(dest));
};

module.exports = $;