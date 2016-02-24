var exec = require('cordova/exec');

exports.registerFrequency = function (frequency, success, fail) {
    console.log("registerFrequency  " + frequency);
    var freq = frequency.toString();
    exec(success, fail, "CDVPitchDetection", "registerFrequency", [freq]);
};

exports.startListener = function () {
    console.log( "startListener ");
    var success = function(){console.log('start listener success');};
    var error = function(){console.log('start listener error');};
    exec(success, error, "CDVPitchDetection", "startListener", []);
};

exports.stopListener = function () {
    var success = function(){console.log('stop listener success');};
    var error = function(){console.log('stop listener error');};
    exec(success, error, "CDVPitchDetection", "stopListener", []);
};

exports.executeCallback = function (frequency) {
    console.log("frequency: ",frequency);
    var event = document.createEvent('Events');
    event.initEvent('audiofrequency', true, true);
    event.data = frequency;
    window.dispatchEvent(event);
};
