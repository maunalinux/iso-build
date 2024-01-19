## ISO Build

Script para construção das ISO's do Mauna Linux 

### Arquivos

Este script contém todos os arquivos e comandos necessários para a correta construção das devidas ISO's do Mauna que atualmente são: Cinnamon, LXQt e MATE.

### Como construir as ISO's

Primeiramente, instale o live-build para poder fazer todo o processo:

```bash
sudo apt update
wget https://apt.maunalinux.top/mauna/pool/main/l/live-build/live-build_20230502mauna2_all.deb && sudo apt install ./live-build_20230502mauna2_all.deb && sudo rm -r live-build_20230502mauna2_all.deb
```
Caso você esteja utilizando o Mauna Linux, então simplesmente utilize o seguinte comando:

```bash
sudo apt update
sudo apt install -y live-build
```

Baixe o repositório e siga as instruções abaixo:

```bash
git clone https://github.com/maunalinux/iso-build.git
cd iso-build/
```

Dentro da pasta iso-build, escolha o desktop do qual você deseja construir:

Exemplo:

```bash
cd mate/
```

Agora já dentro da pasta com o referido desktop, basta digitar os seguintes comandos, sabendo-se que deverá ter acesso root (administrador( para pode estar executando esta tarefa:

```bash
sudo su
sh build-mate.sh
```

Agora basta esperar até o término da construção da ISO. O tempo pode variar conforme as especificações do seu computador.

Depois de completado, entre na pasta "build" e encontrará a ISO já construida.

## English                 

Script to build Mauna Linux ISO's

### Files

This script contains all the files and commands necessary for the correct construction of the appropriate Mauna ISO's, which are currently: Cinnamon, LXQt and MATE.

### How to build ISO's

First, install the live-build to be able to complete the entire process:

```bash
sudo apt update
wget https://apt.maunalinux.top/mauna/pool/main/l/live-build/live-build_20230502mauna2_all.deb && sudo apt install ./live-build_20230502mauna2_all.deb && sudo rm -r live-build_20230502mauna2_all.deb
```
If you are using Mauna Linux, then simply use the following command:

```bash
sudo apt update
sudo apt install -y live-build
```

Download the repository and follow the instructions below:

```bash
git clone https://github.com/maunalinux/iso-build.git
cd iso-build/
```

Inside the iso-build folder, choose the desktop you want to build from:

Example:

```bash
cd mate/
```

Now inside the folder with the aforementioned desktop, simply type the following commands, knowing that you must have root access (administrator) to be able to perform this task:

```bash
sudo su
sh build-mate.sh
```

Now just wait until the ISO construction is finished. The time may vary depending on your computer's specifications.

Once completed, go to the "build" folder and you will find the already built ISO.
