import Foundation

@objcMembers
public class RemoteSettings: NSObject {
    private static let keyCache = "RemoteSettingsCache"
    private let settingsRequest: URLRequest
    private let userDefaults: UserDefaults
    
    /// Initialise with the URLRequest used to fetch the settings.
    /// In you want to use it with the suite you can optionally provide your UserDefaults that will be used for caching.
    public init(settingsURLRequest: URLRequest, userDefaults: UserDefaults = .standard) {
        self.settingsRequest = settingsURLRequest
        self.userDefaults = userDefaults
        
        super.init()
    }
    
    public convenience init(settingsJsonURL: URL, basicAuth: BasicAuthCredentials? = nil, userDefaults: UserDefaults = .standard) throws {
        var request = URLRequest(url: settingsJsonURL)
        
        if let basicAuth = basicAuth {
            let loginString = String(format: "%@:%@", basicAuth.login, basicAuth.password)
            guard let loginData = loginString.data(using: String.Encoding.utf8) else {
                throw RemoteSettingsError.runtime("Basic auth credentials string encoding error")
            }
            let base64LoginString = loginData.base64EncodedString()
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        }
        
        self.init(settingsURLRequest: request)
    }
    
    public convenience init(settingsJsonURLString: String, basicAuth: BasicAuthCredentials? = nil, userDefaults: UserDefaults = .standard) throws {
        guard let url = URL(string: settingsJsonURLString) else {
            throw RemoteSettingsError.runtime("Error: Unable to parse URL: \(settingsJsonURLString)")
        }
        
        try self.init(settingsJsonURL: url, basicAuth: basicAuth, userDefaults: userDefaults)
    }
    
    /// Syncroniously reads data from the internal cache. Use the `refreshSettings`before this call to get the latest remote data is needed.
    public func getValue<T>(forKey key: String) throws -> T? {
        assert(T.self is String.Type || T.self is Int.Type || T.self is Double.Type || T.self is Bool.Type)
        
        let settings = try readCachedSettings()
        return settings?[key] as? T
    }
    
    /// Refreshes the config with the latest remote data.
    /// Writes the new data to the internal cache that is used by the `getValue` function to read the data.
    public func refreshSettings(completion: ((Error?) -> Void)?) {
        fetchSettings { [weak self] (result) in
            if case .success(let data) = result {
                do {
                    try self?.storeSettingsCache(json: data)
                    completion?(nil)
                } catch {
                    completion?(error)
                }
            } else if case .failure(let error) = result {
                completion?(error)
            } else {
                fatalError("Unexpected flow")
            }
        }
    }
    
    private func readCachedSettings() throws -> Dictionary<String, Any>? {
        guard let rawSettings = userDefaults.data(forKey: RemoteSettings.keyCache) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: rawSettings, options: []) as? [String: Any] else {
            throw RemoteSettingsError.runtime("Unable to parse json, data length: \(rawSettings.count)")
        }
        
        return json
    }
    
    private func storeSettingsCache(json: Dictionary<String, Any>) throws {
        guard JSONSerialization.isValidJSONObject(json) else {
            throw RemoteSettingsError.runtime("Invaid JSON object: \(json)")
        }
        
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        userDefaults.setValue(data, forKey: RemoteSettings.keyCache)
    }
    
    /// Fetches the settings from the remote
    private func fetchSettings(completion: @escaping (Result<Dictionary<String, Any>, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: settingsRequest) { (data, response, error) in
            DispatchQueue.main.async {
                completion(Result {
                    if (response as? HTTPURLResponse)?.statusCode == 401 {
                        throw RemoteSettingsError.runtime("Authentication failed with code 401")
                    }
                    guard let data = data else {
                        let statusCode = (response as? HTTPURLResponse)?.statusCode
                        throw RemoteSettingsError.runtime("Fetch failed with the status code: \(String(describing: statusCode)) and error: \(String(describing: error))")
                    }
                    guard let parsedData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        throw RemoteSettingsError.runtime("Unable to parse json, data length: \(data.count)")
                    }
                    
                    return parsedData
                })
            }
        }
        
        task.resume()
    }
}

@objcMembers
public class BasicAuthCredentials: NSObject {
    let login: String
    let password: String
    
    public init(login: String, password: String) {
        self.login = login
        self.password = password
    }
}

public enum RemoteSettingsError: Error {
    case runtime(String)
}
