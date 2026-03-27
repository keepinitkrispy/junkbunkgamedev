# The Junk Bunch Adventures — Game Design Document

**Version:** 0.1
**Genre:** Roguelite Squad Defender
**Platform:** TBD (Godot 4 recommended)
**Visual Style:** 2.5D Pixel Art
**Target Audience:** Kids 6–12, families

---

## 1. Concept Overview

The Junk Bunch Adventures is a roguelite squad defense game inspired by Plants vs. Zombies and Poppy Playtime. Players build a squad of misfit characters made from discarded junk and defend against waves of living household objects across 11 unique worlds.

Each run is different. Players choose from their unlocked roster, fight through waves, spend Scrap to upgrade between rounds, and unlock new Bunch members by defeating bosses.

---

## 2. Core Loop

```
Start Run
  → Pick 3 Bunch members from unlocked roster
  → Fight wave of room enemies (lanes-based defense)
  → Earn Scrap during wave
  → Between waves: spend Scrap on upgrades/new members
  → Defeat Boss → unlock new Bunch member
  → Next room or game over
```

- Runs are self-contained (roguelite — you keep unlocks, not upgrades)
- Harder rooms = rarer Bunch unlocks
- Losing a run returns you to the hub with any newly unlocked members saved

---

## 3. Currency: Scrap

Scrap is the in-run resource earned by defeating enemies.

Used for:
- Deploying Bunch members to lanes
- Upgrading a Bunch member mid-run
- Buying a one-time power-up between waves
- Re-rolling your upgrade choices

Scrap does NOT carry between runs.

---

## 4. Bunch Member System

### Deployment
- Lanes-based grid (3–5 lanes depending on world)
- Each Bunch member costs Scrap to place
- Members have cooldowns before re-deploying

### Stats per Member
- **HP** — health pool
- **Attack** — damage per hit
- **Speed** — attack rate
- **Range** — melee / mid / ranged
- **Skill** — unique active or passive ability
- **Weakness** — environmental condition that debuffs them

### Unlock Tiers
| Tier | How to Unlock | Rarity |
|---|---|---|
| Common | Clear any boss | Easy |
| Uncommon | Clear boss without losing a member | Medium |
| Rare | Clear boss on hard mode | Hard |
| Legendary | Secret conditions | Very Hard |

---

## 5. Sample Bunch Members

| Name | Made From | Skill | Weakness |
|---|---|---|---|
| Boltz | Old robot toy parts | Magnetizes metal enemies — pulls them forward | Short circuits in water |
| Patchy | Sewn-together stuffed animals | Stretches to hit 2 lanes at once | Gets heavy when wet — half speed |
| Crinkle | Aluminum foil & cans | Reflects projectiles back at enemies | Loud — triggers noise-sensitive enemies |
| Cordy | Tangled cables & wires | Grapples and stuns an enemy | Gets tangled — briefly immobilized |
| Glubbs | Broken rubber duck + tubes | Attacks ignore water/slippery tile debuffs | Pops on sharp enemies — takes double damage |
| Scrapz | Cardboard & duct tape | Builds a temporary wall to block a lane | Burns — takes damage from fire enemies |

*Full roster to be expanded with player-drawn characters.*

---

## 6. Worlds & Enemy Rosters

### World 1 — Classroom: "Chalk & Chaos"

| Enemy | Attack |
|---|---|
| Eraser Chunk | Lobs itself, leaves dust cloud (blind) |
| Ruler Slapper | Melee line attack |
| Scissor Crawler | Snips — cuts Bunch member HP in half |
| Glue Glob | Immobilizes on contact |
| Pencil Jabber | Fast stab, low HP |
| Backpack Basher | Slow tank, high HP |
| **Boss: The Substitute** | Giant chalkboard — writes commands that change enemy behavior mid-wave |

---

### World 2 — Yard: "The Last Stand" (PvZ Homage)

| Enemy | Attack |
|---|---|
| Garden Gnome | Throws pebbles in arcs |
| Rake Face | Steps on itself — stuns nearby |
| Sprinkler Spinner | Rotating water knockback |
| Flowerpot Roller | Rolls full lane |
| Lawn Ornament | Summons duplicates of itself |
| Leaf Blower | Pushes entire Bunch back |
| **Boss: The Lawnmower** | Charges lanes — classic PvZ style |

---

### World 3 — Playground: "The Rusty Lot"

| Enemy | Attack |
|---|---|
| Swing Chain | Whips back and forth, damages lane |
| Slide Slick | Launches enemies down fast |
| Seesaw Stomper | Launches partner enemies airborne |
| Sandbox Crab | Burrows, surprise attack |
| Jungle Gym Spider | Clings to top, drops on Bunch |
| Dodgeball | Bounces rapidly between lanes |
| **Boss: The Merry-Go-Round** | Spins and flings minions outward |

---

### World 4 — Backyard Pool: "The Deep End"

| Enemy | Attack |
|---|---|
| Pool Noodle Whip | Long range swipe |
| Water Gun Gunner | Ranged water shots (slows) |
| Inflatable Floatie | Bouncy tank, hard to pin down |
| Diving Board | Launches heavy enemies as projectiles |
| Sunscreen Blob | Slippery + slows |
| Goggles Ghost | Invisible until close |
| **Boss: The Pool Drain** | Giant suction pulls everyone in — waves get faster |

---

### World 5 — Kitchen: "The Messy Kitchen"

| Enemy | Attack |
|---|---|
| Fork Knight | Stabs rapidly in a line |
| Spoon Slinger | Launches soup blobs in an arc |
| Spatula Slap | Wide knockback swipe |
| Rolling Pin | Rolls across the lane, crushes |
| Broccoli Creep | Slow, lots of them, regenerates |
| Hot Dog Roller | Rolls back and forth |
| Egg Cracker | Breaks open, yolk slows on impact |
| Meatball | Bounces unpredictably between lanes |
| Butter Pat | Sits still, makes lane slippery |
| Cheese Blob | Slow, sticky — glues Bunch members in place |
| **Boss: Chef Ladle** | Giant ladle slams lanes and splashes soup AoE |

---

### World 6 — Office: "Cubicle Carnage"

| Enemy | Attack |
|---|---|
| Stapler Shooter | Rapid-fire staples |
| Paperclip Chain | Links enemies together — must break chain |
| Sticky Note Swarm | Covers Bunch member — blinds + slows |
| Coffee Mug | Splashes hot coffee (burn DoT) |
| Keyboard Stomper | Slams down AoE |
| Spinning Chair | Charges and spins wildly |
| **Boss: The Printer** | Paper jam rage — fires paper cuts, jams lanes with paper walls |

---

### World 7 — Bedroom: "The Nightmare Room"

| Enemy | Attack |
|---|---|
| Alarm Clock | Stun burst on death |
| Sock Puppet | Grabs and holds a Bunch member |
| Blanket Crawler | Wraps and immobilizes |
| Lego Minefield | Spawns traps on the lane |
| Crayon Scribbler | Draws walls to block |
| Toy Soldier | Marches in formation, hard to break |
| **Boss: The Closet Monster** | Summons enemies from darkness |

---

### World 8 — Stairway: "The Gauntlet" (vertical level)

*Enemies roll/fall downward. Bunch must hold the bottom.*

| Enemy | Attack |
|---|---|
| Loose Shoe | Rolls downhill, knocks back |
| Laundry Pile | Smothers, slows movement |
| Handrail Snake | Slides down fast, full lane |
| Bouncy Ball | Unpredictable bounce path |
| Backpack Tumbler | Rolls and explodes contents |
| Carpet Static | Shocks anything it touches |
| **Boss: The Banister Beast** | Rides the rail, sweeps entire staircase |

---

### World 9 — Bathroom: "The Drain Dungeon"

| Enemy | Attack |
|---|---|
| Soap Bar | Slides across lane, causes slipping |
| Toothbrush Bristle | Rapid poke combo |
| Shampoo Blob | Splits into two on hit |
| Toilet Paper Mummy | Wraps and slows |
| Drain Sucker | Pulls Bunch members toward it |
| Rubber Ducky | Squeaks to call reinforcements |
| **Boss: The Plunger King** | Suction pulls, slam attacks |

---

### World 10 — Library: "The Silent Killer"

| Enemy | Attack |
|---|---|
| Bookworm | Burrows through lane, pops up under Bunch |
| Encyclopedia Golem | Massive slow tank |
| Bookmark Blade | Thrown like a shuriken |
| Card Catalog | Opens drawers — shoots cards in bursts |
| Reading Lamp | Blinds + attracts swarms |
| Overdue Notice | Debuff — drains Scrap over time |
| **Boss: The Head Librarian** | Shushes to silence abilities, summons book walls |

---

### World 11 — Trampoline Park: "Bounce or Die" (Final World)

| Enemy | Attack |
|---|---|
| Foam Pit Lurker | Drags Bunch into pit (removes from lane) |
| Dodgeball Launcher | Rapid fire, bounce off walls |
| Bungee Cord | Snaps and pulls back |
| Air Cannon | Blasts enemies skyward — lands on Bunch |
| Grip Sock Creep | Sticky — slows any lane it enters |
| Trampoline Bouncer | Launches self high, crashes down AoE |
| **Boss: The Inflatable Obstacle Course** | Shape-shifting arena — walls appear/disappear |

---

## 7. Status Effects

| Effect | Description | Caused By |
|---|---|---|
| **Slow** | Reduced movement speed | Wax, Mud, Butter, Cheese |
| **Burn** | Damage over time | Candles, Coffee, Fire enemies |
| **Stun** | Cannot act briefly | Alarm Clock, Remote, Carpet Static |
| **Blind** | Can't target correctly | Dust, Sawdust, Eraser, Lamp |
| **Glued** | Cannot move | Glue Glob, Cheese Blob |
| **Silenced** | Skills disabled | Head Librarian |
| **Pulled** | Dragged toward enemy | Drain Sucker, Pool Drain |
| **Slipped** | Random lane movement | Soap, Butter, Oil |

---

## 8. Progression & Meta

### Hub World
Between runs, players return to **The Junk Yard** — home base of the Bunch.
- New unlocked Bunch members appear here
- Character bios and art viewable
- Upgrade permanent passive bonuses (very light meta-progression)

### Permanent Upgrades (Junk Tokens — earned per run)
- Start each run with +1 Scrap
- Unlock a 4th squad slot
- Reduce all deploy costs by 1
- Start with a random rare Bunch member

### Difficulty
- **Casual** — fewer enemies, more Scrap drops
- **Normal** — standard experience
- **Junk Mode** — extra enemy HP, less Scrap, boss modifiers active

---

## 9. Visual Style

- **2.5D pixel art** — layered parallax backgrounds, pixel-art characters
- **Hand-drawn feel** — characters based on real drawings, slightly wobbly animation
- **Per-world palette** — each world has its own color scheme and tile set
- **Bunch members** — designed from player/kid artwork, scanned and pixel-traced

---

## 10. Audio Direction

- Crunchy, satisfying SFX for each attack type
- Per-world ambient music (classroom = school bell jingles, bathroom = dripping echo, etc.)
- Each Bunch member has a unique sound signature
- Boss music escalates in intensity per phase

---

## 11. Engine & Tech

**Recommended Engine:** Godot 4
**Language:** GDScript
**Resolution:** 320x180 (upscaled to 1920x1080)
**Lanes:** 3 on early worlds, up to 5 on later worlds
**Wave System:** JSON-defined wave files per world

---

## 12. Roadmap

| Phase | Goal |
|---|---|
| 0 | GDD complete, art direction locked |
| 1 | Core lane defense prototype (1 world, 3 Bunch members) |
| 2 | Roguelite loop (Scrap, upgrades, unlock system) |
| 3 | All 11 worlds + bosses |
| 4 | Full Bunch roster from player artwork |
| 5 | Polish, audio, meta-progression |
| 6 | Playtesting with target audience |

---

*Characters and artwork to be added as real drawings are scanned and incorporated.*
