# uFight

* [English](#ufight-be-a-virtual-fighter-with-computer-vision-and-pose-estimation)
* [Português](#ufight-seja-um-lutador-virtual-com-visão-computacional-e-estimativa-de-pose)
  
___
___
  
# uFight: be a virtual fighter with Computer Vision and Pose Estimation

**uFight** is a Virtual Reality game which uses your PC camera to turn you into the strongest fighter. It uses deep *human pose estimation* with the [Simple Pose](https://github.com/robertklee/COCO-Human-Pose) model to detect your position and pose on the camera frame and create a virtual opponent to fight.

![Animation](video/animation.gif)

# Installation

## Back-end

`pip install -r requirements.txt`

## Front-end

Download and install [Processing](https://processing.org/download) graphical environment. The project was tested on version 3.5.3.

# Use

Run game's Python back-end:

`python ufight.py`

Open the [game front-end code](game/game.pde) using Processing IDE. Click on the `Run` button to open the game's graphical interface. It will connect to the back-end throught the `localhost:8000` address. Get far enough from your PC's camera so that your whole-body pose is recognized. Have fun!

___
___

# uFight: seja um lutador virtual com Visão Computacional e Estimativa de Pose

**uFight** é um jogo de Realidade Virtual que usa a câmera do seu computador para transformar você no lutador mais forte. O jogo aplica o conceito de *estimativa de pose humana* através do modelo profundo [Simple Pose](https://github.com/robertklee/COCO-Human-Pose) para detectar sua posição e pose diante da câmera, e então cria um lutador oponente virtual.

![Animation](video/animation.gif)

# Instalação

## Back-end

`pip install -r requirements.txt`

## Front-end

Baixe e instale o ambiente gráfico [Processing](https://processing.org/download). O projeto foi testado na versão 3.5.3.

# Uso

Execute o *back-end* Python do jogo:

`python ufight.py`

Abra o [código *front-end* do jogo](game/game.pde) usando a IDE do Processing. Clique no botão `Executar` (ou *`Run`*) para abrir a interface gráfica do jogo. Ela se conectará ao *back-end* através do endereço `localhost:8000`. Se distancie da câmera do seu PC o suficiente para que a pose do seu corpo inteiro seja reconhecida. Divirta-se!