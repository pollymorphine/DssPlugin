// var exec = require('cordova/exec');

// exports.coolMethod = function (arg0, success, error) {
//     exec(success, error, 'DSSPlugin', 'coolMethod', [arg0]);
// };


var exec = require('cordova/exec');
var dssPlugin = function () {
    var successFunc = ((data) => {
        resolve(data);
    });
    // tslint:disable-next-line: typedef
    var errorFunc = ((error) => {
        reject(error);
    });
    exec(successFunc, errorFunc, 'DSSPlugin', 'sayHello', []);
};