var exec = require('cordova/exec');
var frequencyMap;
var lastFrequency = "";
           
exports.registerFrequency = function ( frequency, callback, success, fail) {
    console.log("registerFrequency  " + frequency);
    var freq = frequency.toString();
    this.frequencyMap = callback;
    exec(success, fail, "CDVPitchDetection", "registerFrequency", [freq]);
},

exports.startListener = function () {
    console.log( "startListener ");
    var success = function(){console.log('start listener success');};
    var error = function(){console.log('start listener error');};
    exec(success, error, "CDVPitchDetection", "startListener", []);
},

exports.stopListener = function () {
    var success = function(){console.log('stop listener success');};
    var error = function(){console.log('stop listener error');};
    exec(success, error, "CDVPitchDetection", "stopListener", []);
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
