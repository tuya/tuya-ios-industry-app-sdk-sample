## Login

**Parameter description**

| Parameter | Type | Required | Description |
| ------ | ---- | -------- | ---- |
| params | NSDictionary | Yes | The login parameters. params = ["username": account,"password": password,"projectCode": info.projectCode,"host": info.region] |
| success | block | Yes | The login success callback. |
| failure | block | Yes | The login failure callback, returning the `NSError` object. |

**Example**

```
guard let info = TYIoTSDK.parseProjectQRCode(AppKey.projectQRCode) else {
            return;
}

let params = [
    "username": account,
    "password": password,
    "projectCode": info.projectCode,
    "host": info.region
]

UserService.shared().login(withParams: params) {
    NSLog(@"Login succeeded");
} failure: { error in
    NSLog(@"Login failed, error = %@", error.localizedDescription);
}
```

## Logout

**Parameter description**

| Parameter | Type | Required | Description |
| ------ | ---- | -------- | ---- |
| success | block | Yes | The logout success callback. |
| failure | block | Yes | The logout failure callback, returning the `NSError` object. |

**Example**

```
UserService.shared().logoutSuccess {
    NSLog(@"Logout succeeded");
} failure: { error in
    NSLog(@"Logout failed, error = %@", error.localizedDescription);
}
```
## Get user information

`IndustryUser` is used to get information about the current industry user.

**Parameter description**

| Parameter | Type | Description |
| ------ | ---- | ---- |
| userName | NSString |  |
| userId | NSString |  |
| isLogin | BOOL |  |

**Example**

```
UserService.shared().user()?.username
```

## Register a listener for login session expiration

If users reset the password or have not logged in for a long time, an error message is returned to indicate session expiration. In this case, you must listen for the notifications of `TuyaSmartUserNotificationUserSessionInvalid` and navigate users to the login page.

```
func loadNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(sessionInvalid), name: NSNotification.Name(rawValue: "TuyaSmartUserNotificationUserSessionInvalid"), object: nil)
}

@objc func sessionInvalid() {
    print("sessionInvalid")
    // Navigate to the login page.
        let vc = MyLoginViewController()
        window.rootViewController = vc
        window.makeKeyAndVisible()
}
```
