# xc

`xc` is a small binary written in Swift which helps quickly open package, Xcode projects & workspaces.

Simply invoking `xc` in your current directory will either open a package, file or project.
It does this by giving all three a priority, if a `Package.swift` file is found, the app
assumes that you are inside a Swift package folder. If that doesn't match, then it tries
to either open an Xcode workspace, and finally it falls back to trying to open a regular Xcode project.

It is as simple as that.
