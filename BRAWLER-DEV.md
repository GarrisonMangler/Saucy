# Keybound Brawler development build

Based on PunishXIV/Saucy default branch commit
`c874dbc23dc297329eff253c2e4fb62fbb45ae0f` (October 28, 2026).
That source already includes Brawler gameplay and auto-queue. The public
2.1.2.5 package installed on this machine predates that module.

## Changes

- Uses upstream's direct, process-local word action. No simulated letters,
  Escape, Enter, window messages, or foreground-window lookup in Brawler.
  This replaces the typing implementation in the previously configured
  Le-Vagabond-gh/Saucy development build, commit d2634e0.
- Requires this client's active Brawler HUD and input agents, with their
  expected association, before performing actions or resetting inactivity.
- Stops actions during loading/logout and clears pending gameplay state.
- Auto-queue accepts an already-open Brawler entry dialog, including one
  opened manually, before checking duty/director state.
- Throttles result/entry clicks to one per second and waits briefly after
  closing results before interacting with the entry NPC again.
- Turning auto-queue off also leaves the result screen for manual exit.
- Stops owned navigation when interaction becomes unavailable. Existing
  vnavmesh support can move to the entry NPC; without it, stand nearby.

## Build and load

Requires .NET SDK 10, installed Dalamud API 15 development files, and initialized
PunishLib submodule (`git submodule update --init --recursive`).

Run `./tools/build-dev.ps1` in PowerShell from this
checkout. The complete plugin is copied to `bin/Release`; retain all accompanying
DLLs, JSON, images, and Sounds. Version 2.1.2.6 identifies this development build.

1. Disable regular Saucy and remove/disable the old Saucy dev location.
2. Add this checkout's `bin/Release/Saucy.dll` in Dalamud Settings > Experimental >
   Dev Plugin Locations, then enable the development plugin.
3. Open `/saucy`, select **Keybound Brawler**, and enable the module.
4. Enable **Enable auto-queue** to accept rewards/exit and enter another game.
   Disable it for manual result exit and entry.

This retains the Saucy plugin identity and shares its configuration/statistics.
Enable just one Saucy copy in each client. Old fork-specific typing settings
are not used by upstream; configure the current module's delay controls anew.

## Verification

Release compilation and inspection of the compiled Brawler implementation are
performed locally. No live multi-client game run has been performed.
Native signatures, agent layouts, NPC IDs, and button node IDs depend on the
current game build; successful compilation alone does not validate those.

In-game acceptance checks:

1. Run Brawler on a background client; focus an idle second client, open chat,
   and check that no letters, Enter/Escape, or UI shortcuts are generated.
2. Run Brawler on both clients and alternate focus. Confirm both continue
   performing word actions without corrupting each other's input or scores.
3. With auto-queue enabled, complete at least two rounds. Confirm rewards are
   recorded, results close, the NPC is used, entry is accepted, and play resumes.
4. Open the entry dialog manually while auto-queue is enabled; confirm acceptance.
5. Disable auto-queue on the result screen; confirm it stays open. Disable the
   module while navigating; confirm owned navigation stops.
6. Change areas or log out with a pending word; confirm no delayed action fires.

To revert, disable the development copy, remove its dev location, and enable
regular Saucy. This does not roll back saved configuration or statistics.
