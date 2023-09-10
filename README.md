# docker-wine

See the original readme and project at: [scottyhardy/docker-wine](https://github.com/scottyhardy/docker-wine)

## Getting Started with wine and LTspice

First clone and build [cs224/docker-remote-desktop](https://github.com/cs224/docker-remote-desktop):

    > git clone https://github.com/cs224/docker-remote-desktop.git
    > cd docker-remote-desktop
    > ./build
    > cd ..

Then clone and build this repository:

    > git clone https://github.com/cs224/docker-wine.git
    > cd docker-wine
    > ./build
    > mkdir winehome

Test the installation:

    > ./docker-wine --home-volume="$(readlink -f .)/winehome" wine notepad 
  
Another test: open winecfg:

    > ./docker-wine --home-volume="$(readlink -f .)/winehome" --env="WINEDEBUG=fixme-all" wine winecfg

Download LTspice from: https://www.analog.com/en/design-center/design-tools-and-calculators/ltspice-simulator.html

    > wget https://ltspice.analog.com/software/LTspice64.msi
    > mv LTspice64.msi winehome
    > ./docker-wine --home-volume="$(readlink -f .)/winehome" wine msiexec /i LTspice64.msi
    > ./docker-wine --home-volume="$(readlink -f .)/winehome" wine .wine/drive_c/users/cs/AppData/Local/Programs/ADI/LTspice/LTspice.exe
