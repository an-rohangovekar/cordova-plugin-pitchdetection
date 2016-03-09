var exec = require('cordova/exec'),
cordova = require('cordova');

exports.registerFrequency = function (frequency, success, fail) {
    //console.log("registerFrequency  " + frequency);
    var freq = frequency.toString();
    exec(success, fail, "CDVPitchDetection", "registerFrequency", [freq]);
};

exports.startListener = function (a) {
    //console.log( "startListener ");
    var success = function(){};
    var error = function(){};
    exec(success, error, "CDVPitchDetection", "startListener", [a]);
};

exports.stopListener = function () {
    var success = function(){};
    var error = function(){};
    exec(success, error, "CDVPitchDetection", "stopListener", []);
};

exports.executeCallback = function (frequency) {
    var event = document.createEvent('Events');
    event.initEvent('audiofrequency', true, true);
    event.data = frequency;
    window.dispatchEvent(event);
};
            
exports.otherfrequency = function (frequency) {
    var event1 = document.createEvent('Events');
    event1.initEvent('unmatchfrequency', true, true);
    event1.data = frequency;
    window.dispatchEvent(event1);
};
