import Foundation

/// Obj-C Wrappers
extension RemoteSettings {
    @objc
    public func getBool(forKey key: String) -> RemoteSettingsValue {
        let value = try? getValue(forKey: key) as Bool?
        return RemoteSettingsValue(success: value != nil, value: value as Any)
    }
    
    @objc
    public func getString(forKey key: String) -> RemoteSettingsValue {
        let value = try? getValue(forKey: key) as String?
        return RemoteSettingsValue(success: value != nil, value: value as Any)
    }
    
    @objc
    public func getDouble(forKey key: String) -> RemoteSettingsValue {
        let value = try? getValue(forKey: key) as Double?
        return RemoteSettingsValue(success: value != nil, value: value as Any)
    }
    
    @objc
    public func getInt(forKey key: String) -> RemoteSettingsValue {
        let value = try? getValue(forKey: key) as Int?
        return RemoteSettingsValue(success: value != nil, value: value as Any)
    }
}

/// Used to represent the value in Obj-C code
@objcMembers
public class RemoteSettingsValue: NSObject {
    public let success: Bool
    public let value: Any
    
    init(success: Bool, value: Any) {
        self.success = success
        self.value = value
    }
    
    public override var description: String {
        return "RemoteSettingsValue success: \(success) value: \(value)"
    }
}
