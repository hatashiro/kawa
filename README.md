![logo](resource/png/logo.png)

# Kawa [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/utatti/kawa/master/LICENSE) [![GitHub release](https://img.shields.io/github/release/utatti/kawa.svg)](https://github.com/utatti/kawa/releases)

A macOS input source switcher with user-defined shortcuts.

## Demo

[![demo](https://cloud.githubusercontent.com/assets/1013641/9109734/d73505e4-3c72-11e5-9c71-49cdf4a484da.gif)](http://vimeo.com/135542587)

## Install

### Using [Homebrew](https://brew.sh/)

```shell
brew update
brew install --cask kawa
```

### Manually

The prebuilt binaries can be found in [Releases](https://github.com/utatti/kawa/releases).

Unzip `Kawa.zip` and move `Kawa.app` to `Applications`.

## Caveats

### CJKV input sources

There is a known bug in the macOS's Carbon library that switching keyboard
layouts using `TISSelectInputSource` doesn't work well with complex input
sources like [CJKV](https://en.wikipedia.org/wiki/CJK_characters).

## Development

Install full Xcode and a recent version of [Carthage](https://github.com/Carthage/Carthage)
that supports XCFrameworks (0.37 or later). The Xcode command line tools alone
are not sufficient.

```bash
$ brew update
$ brew install carthage
```

To clone the Git repository of Kawa and install dependencies:

```bash
$ git clone git@github.com:utatti/kawa.git
$ cd kawa
$ XCODE_XCCONFIG_FILE="$PWD/Carthage.xcconfig" carthage bootstrap --platform macOS --use-xcframeworks --no-use-binaries
```

After dependency installation, open `kawa.xcodeproj` with Xcode. For a release
build, use the standard architectures to include Intel and Apple Silicon. Kawa
requires macOS 12 or later. Verify that both the app and its embedded
MASShortcut framework contain `x86_64` and `arm64`:

```bash
lipo -archs path/to/Kawa.app/Contents/MacOS/Kawa
lipo -archs path/to/Kawa.app/Contents/Frameworks/MASShortcut.framework/MASShortcut
```

If Git is configured with `safe.bareRepository=explicit`, Carthage's dependency
checkout may fail. To allow its bare repository cache only for this command,
run the bootstrap command with:

```bash
GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=safe.bareRepository GIT_CONFIG_VALUE_0=all \
  XCODE_XCCONFIG_FILE="$PWD/Carthage.xcconfig" \
  carthage bootstrap --platform macOS --use-xcframeworks --no-use-binaries
```

## License

Kawa is released under the [MIT License](LICENSE).
