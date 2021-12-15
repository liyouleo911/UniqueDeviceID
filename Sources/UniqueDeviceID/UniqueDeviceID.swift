import Foundation
import SwiftKeychainWrapper

public class UniqueDeviceID {
    
    private static let udidKey = "UniqueDeviceID_UDID_Key"
    
    /// Retrieve the device's identifier
    /// - Returns: Self generated UDID
    public static func udid() -> String {
        uuid(for: udidKey, isCachedToLocal: true)
    }

    // MARK: private
    private static func uuid(for key: String, isCachedToLocal: Bool = true) -> String {
        let resultUUID: String
        if let uuidFromKeyChain = uuidFromKeyChain(for: key) {
            resultUUID = uuidFromKeyChain
        } else {
            if isCachedToLocal, let uuidFromLocalCache = uuidFromLocalCache(for: key) {
                resultUUID = uuidFromLocalCache
            } else {
                resultUUID = UUID().uuidString
            }
            KeychainWrapper.standard.set(resultUUID, forKey: key)
        }
        if isCachedToLocal {
            UserDefaults.standard.set(resultUUID, forKey: key)
        }
        return resultUUID
    }
    
    private static func uuidFromKeyChain(for key: String) -> String? {
        if let uuidString = KeychainWrapper.standard.string(forKey: key), let _ = UUID(uuidString: uuidString) {
            return uuidString
        }
        return nil
    }
    
    private static func uuidFromLocalCache(for key: String) -> String? {
        if let uuidString = UserDefaults.standard.string(forKey: key), let _ = UUID(uuidString: uuidString) {
            return uuidString
        }
        return nil
    }
}
