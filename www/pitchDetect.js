var exec = require('cordova/exec');
var frequencyMap;
var lastFrequency = "";
           
exports.registerFrequency = function ( frequency, callback, success, fail) {
    console.log("registerFrequency  " + frequency);
    var freq = frequency.toString();
    this.frequencyMap = callback;
    exec(success, fail, "CDVPitchDetection", "registerFrequency", [freq]);
},

exports.startListener = function (success, fail, loop) {
    console.log( "startListener ");
    exec(success, fail, "CDVPitchDetection", "startListener", [loop]);
},

exports.stopListener = function (success, fail) {
    exec(success, fail, "CDVPitchDetection", "stopListener", [""]);
},

exports.executeCallback = function (frequency) {
//    var freq = parseInt(frequency).toString();
//    if ( freq != this.lastFrequency ) {
//        this.lastFrequency = freq;
//        var callback = this.frequencyMap;
//        if ( callback != undefined ) {
//            callback( freq );
//        }
//    }
    console.log("frequency: ",frequency);
    var event = document.createEvent('Events');
    event.initEvent('audiofrequency', true, true);
    event.data = frequency;
    //var event = new CustomEvent('audiofrequency', frequency);
    window.dispatchEvent(event);
    //cordova.fireWindowEvent('audiofrequency', frequency);
}
