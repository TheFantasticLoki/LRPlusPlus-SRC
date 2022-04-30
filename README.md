# LRZPlusPlus
 Loki's Ragnarok ++ Is a Zombies QOL Script Developed by The Fantastic Loki.

This script features a LOT so please bear with me on this. Any features with an asterisk* will have explanations below! So far this script includes:
- Console Toggles for script features (Host Only)*
- New Progressive Perks System *
- New Harder Zombies Mode*
- 9 Perk Limit (Will be console var controlled later)
- Loki's Blessings (Round Reward System)
- Zombie & Health counters
- Match & Round Timers
- Zone Display Hud*
- Removed Fog on Trazit maps & Extended model load distance for best quality.
- Doubled Revive Trigger radius
- Slightly Faster Sprinting & Increased Jump Height
- 64 placed claymore limit (hehehehehe hf)
- A WIP Mod menu that is disabled by DEFAULT but will be used as an aid later on.
- And more!!!
Feature explanation time:
Most of the script features can be toggled or changed by typing a specific dvar into the console using ~ AFTER loading into a map at least once.
Most of these dvars can be found by typing LRZ_ into the console but the only one that isn't in that section is start_round which will let you choose a specific round to start at. This was used for debugging but I left it in for those that want it.

Zone Display HUD:
This is a fairly simple script that confuses some people but all this does is show where you are on the map.
So if your playing town and your by jugg your in west town. Or if your playing origins and your at the second song trigger your in dead mans land. This will show on the left side of your screen. This attributes around 2 thousand lines of code for all the locations and triggers tho.

Harder Zombies Mode:
Console Toggle: LRZ_Harder_Zombies 0
This is something I made in order to make the early rounds more fun and make the game a bit more challenging in general as I always found zombies a bit too easy.
This feature decreases the default time it takes in between every zombie spawn on round 1 to 1.5 seconds and continues down to 0.5 seconds after round 21. This makes the zombies show up a lot faster and can have hordes on the map within seconds of round start providing a much faster paced experience.
It also increases the speed multiplier from 8 to 12 meaning zombies will be 1.5x faster every round than they normally would as well as setting zombies to move at round 4 speed from round 1-4.
I also increased the max zombies from 24 to 32
Lastly I increased the zombie health increase multiplier from 0.1 to 0.15 as well as increased their static health increase from 100 to 150 but static health increase doesn't seem to be working atm.
Now the big one... Progressive Perks
This is a system I decided to make as a sort of homage to an old WAW Mod Menu feature but implemented in a Tasteful way.
What this system does is increase the Double Tap & Speed Cola rate, Deadshot Effectiveness (Hipfire Size), ClipSizeMultiplier and Bleedout time as you get to higher rounds. This actually turned out really nicely and makes the game a lot more fun to play.
The triggers for these changes start at round 11 and end at round 81 and 101 exclusively for bleedout time.
The increase in perk effectiveness is gradual at the start but will get up to 3x as much as normal in the much later rounds.
You will be notified of the increase in perk tier when they occur.
