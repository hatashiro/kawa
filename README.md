![logo](resource/png/logo.png)

# Kawa [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/noraesae/kawa/master/LICENSE) [![GitHub release](https://img.shields.io/github/release/noraesae/kawa.svg)](https://github.com/noraesae/kawa/releases) [![travis-ci](https://travis-ci.org/noraesae/kawa.svg)](https://travis-ci.org/noraesae/kawa)

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

The prebuilt binaries can be found in [Releases](https://github.com/noraesae/kawa/releases).

Unzip `Kawa.zip` and move `Kawa.app` to `Applications`.

## Known Issues

There is a known bug in the TIS library of macOS that switching keyboard
layouts doesn't work well when done programmingly, especially between complex
input sources like [CJK](https://en.wikipedia.org/wiki/CJK_characters).
Kawa once tried to resolve this problem using hacky workaround, which caused
more bugs, did more bad than good. The option is removed in v0.1.3, and I
decide to wait for the fix from macOS.

However, if a nice workaround is found, please upload it as an issue or PR. I
would be happy to consider adopting it.

## Preferences

Preferences can be found in a preference window. The window can be opened by
clicking the menubar icon of Kawa or launching Kawa again.

* General Stuff
  * **`Show Menubar Icon`**  
    Show the icon of Kawa in the OS X menubar. When you click the icon, a
    preference window will be opened. If this option is unset, the icon will be
    hidden and the preference window can be opened when launching Kawa again.
  * **`Launch Kawa on startup`**  
    Add Kawa to startup items.

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
$ git clone git@github.com:noraesae/kawa.git
$ carthage bootstrap
```

To open the Xcode project of Kawa:

```
$ open kawa.xcodeproj
```

You can surely open the project from Xcode.

Kawa can be built with the `Product` menu in Xcode as other Xcode projects
are built. If you prefer using command line, just run the build script.

```
$ ./build.sh
```

It will build the project and export `Kawa.app` to the project root.

## Help!

The application is quite simple and this README contains quite most of it. When
you have a problem using Kawa, I would recommend reading this README again,
carefully.

* [Install](#install)
* [Preferences](#preferences)
* [Development](#development)

If there's still a problem, please upload it as an issue on
[Issues](https://github.com/noraesae/kawa/issues).

## License

Kawa is released under the [MIT License](LICENSE).
