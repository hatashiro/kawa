![logo](resource/png/logo.png)

# Kawa [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/utatti/kawa/master/LICENSE) [![GitHub release](https://img.shields.io/github/release/utatti/kawa.svg)](https://github.com/utatti/kawa/releases) [![travis-ci](https://travis-ci.org/utatti/kawa.svg)](https://travis-ci.org/utatti/kawa)

###### A better input source switcher for OS X

## TL;DR
Kawa helps users to switch between keyboard input sources by user-defined
shortcuts.

## A little background

I use 3 input sources in my Mac, `U.S.`, `2-Set Korean` and `Hiragana`. When
I used to use only 2 sources, it was just fine. I needed to just stroke `Command+Space`
to switch between them. However, when the other was added, it became a mess.

In order to switch an input source to another, `Command+Space` should be
stroked several times. It's mainly because it switches a source to a
previously-selected source, and usually we don't always remember what it was.
There's another built-in shortcut, `Alt+Command+Space`, which switch the input
to a next language in system order. However, the order should be memorised to
avoid always checking which language is current. Although we've memorised the
order perfectly, we need to stroke the keys more than twice if the sources
are not adjecent. In short, it's a hell.

I'd always thought I needed an app like Kawa before I accidently became into
Swift and decided to implement this by myself. I hope others can be helped
by Kawa and escape from the input switching hell.

Cheers!

## Demo

[![demo](https://cloud.githubusercontent.com/assets/1013641/9109734/d73505e4-3c72-11e5-9c71-49cdf4a484da.gif)](http://vimeo.com/135542587)

For better quality, there is a
[video version of this demo](http://vimeo.com/135542587) on Vimeo.

## Install

### Using [Homebrew](https://brew.sh/)

```shell
brew update
brew cask install kawa
```

### Manually

The prebuilt binaries can be found in [Releases](https://github.com/utatti/kawa/releases).

Unzip `Kawa.zip` and move `Kawa.app` to `Applications`.

## For CJKV input sources

There is a known bug in the TIS library of macOS that switching keyboard
layouts doesn't work well when done programmatically, especially between complex
input sources like [CJKV](https://en.wikipedia.org/wiki/CJK_characters).

Kawa workarounded this bug by programmatically doing the followings:

- Select a target input source
- If the source is CJKV
    - Switch to the first non-CJKV input source
    - Return to the target input source by sending `Select the previous input source` shortcut

Thus, to activate the workaround above, the following restrictions should meet.

1. There is at least one non-CJKV input source in the input source list
2. The `Select the previous input source` shortcut should be enabled and set to something
    - It can be set in **System Preferences** > **Keyboard** > **Shortcuts** > **Input Sources**

## Preferences

Preferences can be found in a preference window. The window can be opened by
clicking the menubar icon of Kawa or launching Kawa again.

### Show menubar icon

Show the icon of Kawa in the OS X menubar. When you click the icon, a
preference window will be opened. If this option is unset, the icon will be
hidden and the preference window can be opened when launching Kawa again.

### Launch Kawa on startup

Add Kawa to startup items.

### Show notification on input source change

Show macOS notification on input source change.

## Development

We use [Carthage](https://github.com/Carthage/Carthage) as a dependency manager.
You can find the latest releases of Carthage [here](https://github.com/Carthage/Carthage/releases),
or just install it with [Homebrew](http://brew.sh).

```bash
$ brew update
$ brew install carthage
```

To clone the Git repository of Kawa and install dependencies:

```bash
$ git clone git@github.com:utatti/kawa.git
$ carthage bootstrap
```

After dependency installation, you can open and build the project with Xcode.

## Help!

The application is quite simple and this README contains quite most of it. When
you have a problem using Kawa, I would recommend reading this README again,
carefully.

* [Install](#install)
* [Preferences](#preferences)
* [Development](#development)

If there's still a problem, please upload it as an issue on
[Issues](https://github.com/utatti/kawa/issues).

## License

Kawa is released under the [MIT License](LICENSE).
