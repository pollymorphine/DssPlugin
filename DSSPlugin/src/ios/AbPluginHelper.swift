import Foundation

func decodeDto<T: Decodable>(command: CDVInvokedUrlCommand, at: UInt) throws -> T {
    let dtoAsString = command.argument(at: at) as? String ?? ""
    Log.d("DTO: " + dtoAsString)
    
    let dtoData = dtoAsString.data(using: .utf8)!
    
    do {
        let dto = try JSONDecoder().decode(T.self, from: dtoData)
        return dto;
    } catch {
        throw "Pasring DTO error"
    }
}

func encodeObjectToJson<T: Encodable>(object: T) throws -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    
    let data = try encoder.encode(object)
    let result = String(data: data, encoding: .utf8)!
    return result
}

/**
 Класс, отвечающий за отправку коллбэков плагина
 */
class PluginCallbackSender {
    private let commandDelegate: CDVCommandDelegate
    private let callbackId: String
      
    init(commandDelegate: CDVCommandDelegate, callbackId: String) {
        self.commandDelegate = commandDelegate
        self.callbackId = callbackId
    }
    
    func sendError(_ message: String? = nil) {
        var errorText = "Unknown PayControlPlugin error"
        if (message != nil) {
            errorText = message!
        }
        
        Log.e(errorText)
        let operationResult = OperationResult(errorText: errorText)
        var operationResultStringified: String
        do {
            operationResultStringified = try encodeObjectToJson(object: operationResult)
        } catch {
            Log.e("EncodeError!")
            operationResultStringified = errorText
        }
        
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: operationResultStringified)
        self.commandDelegate.send(pluginResult, callbackId: self.callbackId)
    }

    func sendSuccess(_ message: String? = nil, _ data: String? = nil) {
        if (message != nil){
            Log.succ(message!)
        }
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: data)
        self.commandDelegate.send(pluginResult, callbackId: self.callbackId)
    }
}


/// Класс используется для обработки сообщений об ошибках плагина в приложении, возможно расширение функционала при необходимости
class OperationResult: Encodable {
    public let error: ErrorModel
    public let isSuccess: Bool
    
    public init(errorText: String) {
        error = ErrorModel(errorText: errorText)
        isSuccess = false
    }
}

class ErrorModel: Encodable {
    public let errorText: String
    public let errorCode: Int
    public let exception: String
    
    public init(errorText: String) {
        self.errorText = errorText
        self.errorCode = 0
        self.exception = ""
    }
}

/**
 Логгирование внутри плагина
 */
class Log {
    private static var TAG: String = "[PayControlPlugin] "
    private static var enableLogging: Bool = true
    
    static func v(_ msg: String) {
        if enableLogging {
            print(TAG + "[🔖 verbose] " + msg)
        }
    }
    static func d(_ msg: String) {
        if enableLogging {
            print(TAG + "[🐞 debug] " + msg)
        }
    }
    static func i(_ msg: String) {
        if enableLogging {
            print(TAG + "[ℹ️ info] " + msg)
        }
    }
    static func succ(_ msg: String) {
        if enableLogging {
            print(TAG + "[✅ success] " + msg)
        }
    }
    static func w(_ msg: String) {
        if enableLogging {
            print(TAG + "[⚠️ warning] " + msg)
        }
    }
    static func e(_ msg: String) {
        if enableLogging {
            print(TAG + "[❌ error] " + msg)
        }
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
