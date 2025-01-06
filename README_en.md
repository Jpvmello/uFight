# uFight: be a virtual fighter with Computer Vision and Pose Estimation

**uFight** is a Virtual Reality game which uses your PC camera to turn you into the strongest fighter. It uses deep *human pose estimation* with the [Simple Pose](https://github.com/robertklee/COCO-Human-Pose) model to detect your position and pose on the camera frame and create a virtual opponent to fight.

# Installation

## Back-end

`pip install -r requirements.txt`

## Front-end

Download and install [Processing](https://processing.org/download) graphical environment. The project was tested on version 3.5.3.

# Use

Run game's Python back-end:

`python ufight.py`

Open [game front-end code](game/game.pde) using Processing IDE. Click on the `Run` button to open the game's graphical interface. It will connect to the front-end throught the `localhost:8000` address. Get far enough from your PC's camera so that your whole-body pose is recognized. Have fun!