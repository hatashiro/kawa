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

Dependencies are fetched with Swift Package Manager. Open `kawa.xcodeproj` in
Xcode and it will resolve packages automatically, or resolve/build from the
command line:

```bash
xcodebuild -resolvePackageDependencies
xcodebuild -scheme kawa -configuration Debug
```

## License

Kawa is released under the [MIT License](LICENSE).
