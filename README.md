# Data Structures with VHDL

This is a VHDL introductionary course to learn HDL by developing data structure algorithms: sorting, search, tree, and graphs.

The main goal is to use GHDL as basis for the development.


## Enviroment Setup

Before we start our journey into coding, you may install the development environment.

## Linux

In Ubuntu enviroments you can run the following commands:

```bash
sudo apt-get install ghdl gtkwave
```

Archies may run:

```bash
sudo pacman -S gdhl gtkwave
```

### MacOS (tested on M2)

First insall Rosetta 2:

```bash
softwareupdate --install-rosetta
```

Download the release from ghdl's github for mcode build [link](https://github.com/ghdl/ghdl/releases/download/nightly/ghdl-macos-11-mcode.tgz)

```bash
mkdir .macos
cd .macos
mkdir ghdl
curl -L -o ghdl.tar https://github.com/ghdl/ghdl/releases/download/nightly/ghdl-macos-11-mcode.tgz
tar -xf ghdl.tar
rm ghdl.tar
```

Check the installation:
```bash
cd .macos/ghdl/bin
./ghdl --version
# or may run using rosetta 2
arch -x86_64 ./ghdl --help
```

### GTKWave

You can find the versions for MacOS and Windows at [sourceforge](https://sourceforge.net/projects/gtkwave/files/).


### Python Scripts

For scripting, used to generate data for verificiation and so on you can install:

```bash
python3 -m pip install flake8 pycodestyle black pydantic opencv-python
```

## Course Topics

TODO:

- [x] 00: Introduction
- [ ] 01: Structures
- [x] 02: Sorting Algorithms
- [x] 03: Search Algorithms
- [ ] 04: Graphs
- [ ] 05: Hashing
- [ ] 06: Compression


## License

Feel free to copy, modify, change, commit new examples and finish the course :)

```
MIT License

Copyright (c) 2023 Joed

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
