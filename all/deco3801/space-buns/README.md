# Space Buns

“Space Buns” is an educational, co-operative multiplayer game designed to teach Health & Safety outcomes to teenagers.
## Technology Used

**Game Engine -** [Godot (4.1.1)](https://godotengine.org/)

**Version Control Software -** [Git](https://git-scm.com/), [GitHub](https://github.com/)

**Asset Creation/Design -** [Adobe Suite](https://www.adobe.com/au/creativecloud.html)

## Running Locally

Precompiled binaries for Space Buns are already available for MacOS and Windows. They can be found in the ``bin`` folder of the project.

### On MacOS (M1 & Intel)

Double-click to open the image at ``bin/space_buns.dmg`` to be greeted with a popup containing two files ``Space Buns.app`` and ``Space Buns.command`` (Note that the filename extensions may not be visible, however the file ending with .app should have a icon resembling the Godot Engine logo, and the shell script ending in .command has an icon resembling the Terminal app on MacOS). Right click the application (the one with the Godot Logo) and then click Run in the dialog menu. A popup may present itself asking if you trust the application, click Run on this popup if it appears and Space Buns should launch.

### On Windows

Double-click the executable at ``bin/Space Buns.exe`` to launch. A popup from Windows SmartScreen may present itself, if so press on the underlined 'More Info' text, and then click on the 'Run' button that appears next to the 'Don't Run' button at the bottom right.

## Running in the Engine

To begin, ensure that the ``4.1.1 - .NET`` version of the Godot Engine has been installed.

Launch the Godot Engine, and press the Import button on the right hand side of the project selection menu, navigate to your extracted copy of Space Buns and select the contained ``project.godot`` file to import the project. Once the project has been imported double click the ``Space Buns`` entry that appears in the project selection menu of Godot.

### Running in Debug Mode

To run the game in Debug mode, simply press the white play button in the top right of the editor. If you wish to run multiple instances of the game at once go to Debug > Run Multiple Instances in the top menu bar of the editor.

### Building from Source

To build Space Buns from source into a target executable, go to the Project > Export... button in the top menu bar of the editor. A popup will appear where you can configure export targets based on the desired platform and architecture. Once a target has been selected, simply press the 'Export Project...' button at the bottom of the export popup.
## Background on the Code

As the language used in the Godot Engine, and subsequently our project, Space Buns, may be very unfamiliar, some background information on builtin methods and behaviors is provided below, along with accompanying justifications on the commenting volume within the project's codebase.

### A Brief Background on Godot

In Godot a game is represented as a hierachy of **Nodes** and **Scenes** in a tree-based structure. 

Scenes are simply reusable, instantiatable collections of Nodes.

Nodes on the otherhand are the backbone of the Godot Engine, Nodes are the engine's smallest building blocks that are arranged into useful abstractions of a game's systems. Many of the engine's functions are related to the lifecycles of Nodes, and the implictly called ones are described in the following section.

### Implicit Lifecycle Methods & Builtin Methods

``_ready()``: The ready function is called when a Node is instantiated and added to the game's 'tree' of nodes at any position. For example it is called when a Node representing a bullet is spawned and placed at the barrel of a gun in the game world

``_physics_process(delta)``: The physics process function is called on every Node every single physics frame. A physics frame occurs when physics is recalculated across the entire game. ``delta`` is an argument that is passed to this function and represents the time (in seconds) since the last time the function was called on the same Node, however it is usually fixed as physics frames normally occur at fixed intervals (in our case the physics engine runs at 60 FPS).

``_process(delta)``: The process function is called on every Node every single rendering frame. A rendering frame occurs whenever the screen is updated and a new rendered image from the game is shown, rendering occurs as frequently as possible after all other calculations, including physics frames, have already occured. The ``delta`` argument represents the same thing here as it does in ``_physics_process``

``@rpc``: The remote procedure call (RPC) decorator for a function, allows a function to be called remotely between peers connected to the server. This forms the backbone of most of our synchronisation logic for multiplayer along with the builtin MultiplayerSynchronizer Node.

### Code Commenting

As much of the functionality within the Godot Engine is encapsulated within the default behavior of the builtin Nodes and scripts merely extend on top of this, the volume of meaningful comments we could provide is more limited than in a conventional programming project. We have tried our best to comment the code where relevant but in some places it is not possible to clearly document the intent of the code without understanding its relation to the nodes and scene structure of the project which does not appear within the code itself but in non human-readable scene files.
## Attributions

The following references are attributions to any use of 3rd party public licensed works and assets within our game that still remain.

- [Kitchen Assets](https://maschiat.itch.io/house-tileset)
- [Industrial Zone Tileset](https://free-game-assets.itch.io/free-industrial-zone-tileset-pixel-art)
- [Super Grotto Escape Pack](https://ansimuz.itch.io/super-grotto-escape-pack)
- [Sci-Fi Platformer Assets](https://opengameart.org/content/px-free-scifi-platformer-assets)
- [Cyberpunk Asset Pack](https://sirnosir.itch.io/pixelwhale-sf)
- [Warped Zone 202](https://ansimuz.itch.io/warped-zone-202)
- [Space Themed Assets](https://gurokitty.itch.io/space-themed-assets)
- [2D Sci-Fi Lab Platform Builder](https://f0x0ne.itch.io/2d-sci-fi-lab-platform-builder)
- [Green Zone Enemies](https://opengameart.org/content/enemies-for-platformer-pixel-art)
- [Villagers Sprite Sheet](https://craftpix.net/freebies/free-villagers-sprite-sheets-pixel-art/)
- [Sci-Fi Tileset HD](https://www.pngitem.com/middle/hRwRhJJ_free-sci-fi-tileset-hd-png-download/)
- [Water Sprite Effects](https://www.gamedeveloperstudio.com/graphics/viewgraphic.php?item=185d0w0x0y4c7a7n36)
- [Fire Animations Pixel Art](https://brullov.itch.io/fire-animation)
- [Smoke Particles](https://opengameart.org/content/smoke-particle-assets)
- [Pixel Guns Pack 2](https://free-game-assets.itch.io/free-guns-pack-2-for-main-characters-pixel-art)
- [Explosion Sprites Pixel Art](https://free-game-assets.itch.io/11-free-pixel-art-explosion-sprites)
- [Hex Shield VFX](https://pipoya.itch.io/pipoya-free-vfx-hex-shield)
- [Basic Gun Assets](https://c1aymor3.itch.io/basic-gun-asset-pack)
- [RPG Pixel Melee Weapons](https://johnmartpixel25.itch.io/32x32-pixel-weapons-for-rpg-free)
- [Gradient Health Bar](https://www.freepik.com/free-vector/gradient-video-game-health-bar-element_42113955.htm)
- [Pixel Art Drones Pack](https://craftpix.net/freebies/free-drones-pack-pixel-art/)
- [Sci-Fi UI Kit](https://wenrexa.itch.io/ui-different01)
- [Sci-Fi Antagonists Pixel Art](https://craftpix.net/freebies/free-sci-fi-antagonists-pixel-character-pack/)
- [Survival Props Pack](https://opengameart.org/content/free-survival-props-pack)
- [Topdown Hospital Pixel Art](https://opengameart.org/content/hospital-topdown-perspective-2d-pixel-art)
- [Modular Space Assets](https://wenrexa.itch.io/space-full-assets-pack)
- [Sci-Fi Platformer Tileset](https://pzuh.itch.io/free-sci-fi-platformer-tileset)
