import Foundation

@objc(DSSPlugin) class DSSPlugin : CDVPlugin {
   
  @objc(sayHello:)
  func sayHello(command: CDVInvokedUrlCommand) {
    let message = "Hello !";
    
    Log.d("HiHiHi")

    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message);
    commandDelegate.sendPluginResult(pluginResult, callbackId:command.callbackId);
  }
}
