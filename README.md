# macOS Setup!

> A shell script to set up a macOS machine for design and development.

Safe to run multiple times on the same machine. It installs, upgrades, or skips
packages based on what is already installed on the machine.


## Install

You can clone the repository wherever you want. (I like to keep it in ~/dev/setup),
the mac script will automate the process with prompts.

`git clone git@github.com/adsric/macos-setup.git && cd macos-setup`

**Run the script:**

`sh macos.sh`

<sub>Just follow the prompts and you’ll be fine. Once the script is done, quit and relaunch Terminal 👌</sub>

**Run the script with a log:**

`sh macos.sh 2>&1 | tee ~/setup.log`

:warning: **warning:** I advise against running [this macos script](macos.sh) unless you understand what it’s doing to your computer.

:warning: **warning:** It is highly recommended to run the script regularly to keep your computer up to date.

## The setup

The process will install:

<details>
<summary>macOS tools:</summary>

* [XCode Command Line Tools](https://developer.apple.com/xcode/downloads/) for developer essentials.
* [Homebrew](http://brew.sh/) for managing operating system libraries.
</details>

<details>
<summary>Unix tools:</summary>

* [Git](https://git-scm.com/) for version control.
</details>

<details>
<summary>Package Managers:</summary>

* [NVM](https://github.com/creationix/nvm/) for managing and installing multiple versions of [Node.js](http://nodejs.org/) and [npm](https://www.npmjs.org/)
</details>

<details>
<summary>CLI Tools & Utilities:</summary>

* [mackup](https://github.com/lra/mackup) Keep your application settings in sync (OS X/Linux)
* [mas](https://github.com/mas-cli/mas) Mac App Store command line interface
</details>

<details>
<summary>Development</summary>

* [Hyper](https://hyper.is/) for an alternative terminal.
* [Visual Studio Code](https://code.visualstudio.com/) IDE
</details>

<details>
<summary>Design</summary>

* [Sketch](https://www.sketchapp.com/) for design.
</details>

<details>
<summary>Communication</summary>

* [Slack](https://slack.com/) where work happens.
</details>

<details>
<summary>Browsers</summary>

* [Blisk](https://blisk.io/) for cross-device web development.
* [Firefox Developer](https://www.mozilla.org/en-GB/firefox/developer/) fast performance, and the development tools you need to build for the open web.
* [Chrome](https://www.google.com/chrome/browser/desktop/) for fast and free web browsing.
* [Chrome Canary](https://www.google.com/chrome/canary/) nightly builds of chrome for developers.
</details>

And set custom [macOS](preferences.sh) preferences.

<sub>See [`install`](install) for the full list of apps that will be installed. Adjust it to your personal taste.</sub>

It should take less than 20 minutes to install (depends on your machine).


## Known Issues

Cask does not recognize applications installed outside of Homebrew Cask – in the case that the script fails, you can either remove the application from the install list or uninstall the application causing the failure and try again.


## Debugging

Your last setup run will be saved to ~/setup.log (if you chose to run the script with a log). Read through it to see if you can debug the issue yourself. If not, copy the lines where the script failed into a new GitHub Issue. Or, attach the whole log file as an attachment.
