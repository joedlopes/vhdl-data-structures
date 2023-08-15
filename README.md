# Data Structures with VHDL

This is a VHDL introductionary course to learn VHDL by developing data structure algorithms: sorting, search, tree, and graphs.

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

## Course

- 00: Introduction
- 01: Structures
- 02: Sorting Algorithms
- 03: Search Algorithms
- 04: Graphs
- 05: Hashing
- 06: Compression

