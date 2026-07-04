# opencur

Opens the current Finder directory in your terminal.

Supports Terminal.app, iTerm2, and Ghostty.

## Build

```bash
xcodebuild -project opencur.xcodeproj -scheme opencur -configuration Release
```

The app is output to `Build/Products/Release/opencur.app`.

## Trust

macOS blocks unsigned apps from running. To allow opencur:

```bash
spctl --assess --type execute opencur.app
# or
xattr -dr com.apple.quarantine /path/to/opencur.app
```

If Gatekeeper still blocks it, go to **System Settings → Privacy & Security** and click **Open Anyway**.

## Config

Set your default terminal:

```bash
defaults write io.github.joshaken.opencur opencur-terminal-bundle-id com.apple.Terminal        # Terminal.app
defaults write io.github.joshaken.opencur opencur-terminal-bundle-id com.googlecode.iterm2     # iTerm2
defaults write io.github.joshaken.opencur opencur-terminal-bundle-id com.mitchellh.ghostty     # Ghostty
```

Default is Ghostty. Remove the key to reset:

```bash
defaults delete io.github.joshaken.opencur opencur-terminal-bundle-id
```

## Use

Click the app in Finder (or run it anywhere). It reads the frontmost Finder window or selected item and opens that directory in your terminal.
