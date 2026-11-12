================================================================
  DEAR STRANGER PIXEL ART PACK
  A cozy Y2K Frutiger Aqua asset kit
  by Coda, 2026
================================================================


CONTENTS
--------

This pack contains pixel art assets from the game Dear Stranger,
organized into four folders:

icons/   37 beach decoration sprites, 18x18 px each
               (pearls, flags, shells, starfish, fish, treasure
               chest, lifebuoy, and color variants)

cursors/   5 cursor sprites (default, mound, carve)
               authored small for in-engine pixel cursors

ui/            TextureButton states (idle, pressed),
               progress bar track and fill tiles, HUD frames,
               selection ring

animations/    Animated bubble effect, provided as both
               a sprite sheet AND individual frames so you
               can use whichever your engine prefers

Every file is a transparent PNG. No anti-aliasing, no padding,
no embedded color profiles.


INTENDED USE
------------

All assets were authored at native pixel resolution for a base
render size of 320 by 180. They will scale cleanly to any
integer multiple (2x, 3x, 4x, 6x, etc.) using nearest-neighbor
filtering.

In your engine, set the texture filter to NEAREST (not Linear /
Bilinear) for crisp rendering. The common name varies:

  Godot:        Texture Filter -> Nearest
  Unity:        Filter Mode -> Point (no filter)
  GameMaker:    Image Settings -> Disable AA
  Unreal:       Texture sampler -> Nearest

If your game runs at a non-integer scale (e.g. 1080p from a
320x180 base = 6x), the assets will still look correct as long
as the texture filter is nearest.


ANIMATIONS
----------

The bubble animation is provided in two formats inside
animations/bubble/:

  bubble_blue.png     Horizontal sprite sheet, [N] frames
                       Frame width: [X] px, frame height: [Y] px
                       Suggested playback: 8 FPS, looping

  bubbles-1.png        Individual frames numbered in sequence.
  bubble-2.png        Use these if your engine prefers
  ...                  per-frame imports (e.g. Godot's
                       SpriteFrames resource).

Both formats are identical content. Use whichever fits your
workflow.


LICENSE
-------

You ARE allowed to:
  Use these assets in commercial and non-commercial projects
  Use them in game jams without restriction
  Modify, repaint, recolor, and rearrange the sprites
  Use them in tutorials and educational materials

You are NOT allowed to:
  Resell the assets as a standalone art pack or asset bundle
  Claim authorship of the original artwork
  Train AI models on these assets

Attribution is appreciated but not required. If you credit the
pack in your project, "Pixel art by Coda" or a link back to
the itch.io page is plenty.


CONTACT
-------

If you ship something using these assets, I would love to know.
Reach out on itch.io or social media and I will happily share
your work.

If you are a pixel artist interested in collaborating on
future projects, my DMs are open.

  Itch.io:  https://coda-game.itch.io/


CHANGELOG
---------

v1.0  Initial release (2026)


SOURCE
------

These assets are part of a larger set made for Dear Stranger,
a cozy sandcastle-building game released for the Uplifting Game
Jam. You can play it free in your browser at:

https://coda-game.itch.io/dear-stranger


================================================================
  Thank you for downloading. Build something nice.
================================================================