<a href="https://gitlocalize.com/repo/4343"> <img src="https://gitlocalize.com/repo/4343/whole_project/badge.svg" /> </a>
<img src="https://travis-ci.org/bartzaalberg/sudokular.svg?branch=master" />

# Archived
This repository is not maintained anymore and will not be updated to Elementary OS 6.0. You have my blessing to create a fork and update the application to post publish it in Elementary 6.0 under your own name. 

# Sudokular
The number that is alone

<p align="center">
    <a href="https://appcenter.elementary.io/com.github.bartzaalberg.sudokular">
        <img src="https://appcenter.elementary.io/badge.svg" alt="Get it on AppCenter">
    </a>
</p>

<p align="center">
    <img
    src="https://raw.githubusercontent.com/bartzaalberg/sudokular/master/screenshot.png" />
</p>

### Sudoku

The goal of Sudoku is to fill in a 9×9 grid with digits so that each column, row, and 3×3 section contain the numbers between 1 to 9. At the beginning of the game, the 9×9 grid will have some of the squares filled in. Your job is to use logic to fill in the missing digits and complete the grid. A move is incorrect if:

* Any row contains more than one of the same number from 1 to 9
* Any column contains more than one of the same number from 1 to 9
* Any 3×3 grid contains more than one of the same number from 1 to 9

## Installation

First you will need to install elementary SDK

 `sudo apt install elementary-sdk`

### Dependencies

These dependencies must be present before building
 - `valac`
 - `glib-2.0`
 - `gee-0.8`
 - `gtk+-3.0`
 - `granite`
 - `qqwing`

 You can install these on a Ubuntu-based system by executing this command:

 `sudo apt install valac libgtk-3-dev libgranite-dev qqwing`

### Building
```
meson build --prefix=/usr
cd build
ninja
```

### Installing
`sudo ninja install`

### Update .pot file
Call the following command from the build folder:

`ninja com.github.bartzaalberg.sudokular-pot`
