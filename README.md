A simple library for fetching your self-hosted remote config with caching capabilities.

### Usage

Before being able to read the data you must create the `RemoteSettings` object and fetch the data. If the data was fetched and cached before you can read it right away.

```swift
/// Create the object
guard let settings = try? RemoteSettings(settingsJsonURLString: "https://api.github.com/users/github") else {
	return
}

/// Fetch the latest data
settings.refreshSettings(completion: { (error) in
	if let error = error {
		print(error)
	}

	/// Read the data
	let value: String? = try? settings.getValue(forKey: "login")
})
```

##### Reading a value in Swift:
```swift
/// Read the appropriate type via type interpolation
let value: String? = try? settings.getValue(forKey: "login")
```

##### Reading a value in Obj-C:
```obj-c
/// Use a specific getter
NSString *value = [settings getStringForKey:@"login"];
```

##### Basic access authentication:
```swift
let basicAuth = BasicAuthCredentials(login: "myLogin", password: "myPassword")

let settingsWithAuth = try? RemoteSettings(settingsJsonURLString: endpointWithAuth, basicAuth: basicAuth)
```

### Installation

##### SPM
Repository: `https://github.com/numen31337/remote_settings.git`, Branch: `main`

##### CocoaPods
`pod 'RemoteSettings', :git => 'https://github.com/numen31337/remote_settings.git'`

### Facts

- The cached data is persistent and available after the app relaunch. It uses UserDefaults to store the cached data.

- The URL's hash is used as the cache identifier, therefore the object with the same URL will override the existing key whereas the object with a different key can act independently.

- After initialisation, you must fetch the data is it is not happening automatically.
