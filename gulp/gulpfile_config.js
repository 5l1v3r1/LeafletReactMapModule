var base = {
    src: "./src",
    dst: "./build",
    bower: "./bower_components"
};


var path = {
    jade: {
        src: base.src + '/jade/*.jade',
        dst: base.dst
    },
    bootstrapcss: {
        src: base.bower + "/boot/dist/css",
        dst: base.dst + "/asset/css"
    },
    styles: {
        dst: base.dst + "/styles"
    },
    vendor: {
        dst: base.dst + "/js/vendor"
    },
    js: {
        src: base.src + "/js",
        dst: base.dst + "/scripts"
    },
    coffeescript: {
        src: base.src + "/coffeescript",
        dst: base.dst + "/scripts"
    },
    html: {
        src: "",
        dst: ""
    },
};

var bower_overrides = {
    "PruneCluster": {
        "main": [
            "dist/PruneCluster.min.js",
            "dist/LeafletStyleSheet.css"
        ]
    },
    "leaflet": {
        "main": [
            "dist/leaflet.js",
            "dist/leaflet.css",
        ],
        "ignore": ["*src.js"]
    }
};

module.exports = {
    base: base,
    path: path,
    bower_overrides: bower_overrides
};