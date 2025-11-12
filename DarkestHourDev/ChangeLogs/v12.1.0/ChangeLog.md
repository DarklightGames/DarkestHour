# Counter-Battery!
In this update, we are adding an new (somewhat experimental) mechanic that we think will add some depth and complexity to the current artillery gameplay. We call this system "counter-battery"!

## How it Works
When you fire an artillery piece, enemy players will be able to see a short temporary marker approximating the location of your gun.

The accuracy of this mark is dependent on the size of the gun, where larger guns (e.g., 10.5cm howitzers) have more accurate marks than smaller ones (e.g., 8cm mortars).

<< show a gif of this >>

As the gun is continually fired, keen-eyed observers can estimate a position of the enemy gun and mark it for counter-battery fire. To aid in this, there is a new "Enemy Artillery" spotting type that can be marked on the map.

## Motivation & Goals
In the current meta, long-range artillery pieces are virtually immune from attack unless the enemy can get a direct sight on them. This is at odds with the battlefield reality of the time, where sophisticated artillery ranging equipment was deployed to locate enemy guns with acoustic listening posts, a technology birthed out of necessity in the Great War, and significantly improved during World War 2.

We hope that this change will have the following effects:

* Create a meaningful advantage to wise placement of artillery pieces (i.e., dissuading players from creating tightly packed batteries that are easy to locate and destroy).
* Create a major advantage for mobile artillery (e.g., Wespe, Priest) since they are able to avoid incoming counter-battery fire.
* Create another objective for artillery operators other than responding to fire request markers.

## Trivia
* This system was inspired by the Blitzkrieg series of games by Nival Interactive.
* We toyed with the idea of adding physical constructions for the listening posts that would be more accurate depending on different triangulation characteristics, but we did not want to further burden logistics players.

This is obviously an experimental feature, so we will make adjustments if the outcomes don't align with the goals of the system. We look forward to seeing how this changes the artillery game!

# Mortar Pit Construction
This new system makes unprotected 8cm mortars uniquely vulnerable to enemy fire since they are currently unable to be moved (we plan on adding the ability to move these later). To provide some protection from counter-battery fire, we have added a new Mortar Pit construction.

<< screenshot >>

This is the first construction that uses the new "sockets" system that let's constructions slot into places where the placement rules would otherwise forbid it.

<< gif for this >>

Sockets were developed for the upcoming mounted MGs, but it works perfectly for this new construction too!

# 🇫🇷 French Localization

Sacrebleu! At long last, DH is now fully localized to French! This was brought to you by long-time historical contributor "Frenchy" (what a fitting name)!

<< show french UI screenshots >>

A reminder that if you want to use the French translation, you must have your Steam Interface Language set to French! For a guide on how to do this, [click here](https://wiki.darklightgames.com/localization#change-the-game-language).

Looking ahead, We also have a nearly complete Japanese (人本語) localization that should be ready to release in the next couple weeks.

If you want to help get DH translated to your native tongue, please let us know in the Discord! We are currently looking for translators for Portuguese, Italian and Chinese!

# Changes & Fixes
* Squad leaders can now only place constructions when squadmates are near. However, they can now also use their shovel to build. This should eliminate the annoyance of suddenly not being able to build if a teammate runs off.
* Added a minimum hold time for following grenades:
  * F1 Grenade
  * L-Type Grenade
  * SCRM mod. 35 Grenade
* Fixed M4A3E2 Sherman "Jumbo" armor values to be more historically accurate. This increases the armor thickness by about ~15%.
* Fixed a bug where rallies would be overrun by friendly vehicles (this was a regression since v12.0.9).
* Fixed missing vertical tilt on Gundlach periscopes for a number of vehicles (e.g., T34, IS-2, Cromwell, Churchill).
* Fixed one of the ISU-152 periscope overlays to be more historically accurate.

Rendez-vous sur le champ de bataille,
Darklight Games