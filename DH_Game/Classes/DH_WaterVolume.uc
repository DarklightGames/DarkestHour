//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WaterVolume extends WaterVolume;

// Modified to douse a player who is on fire
// TODO Matt Dec 2015: removing charred effect doesn't work, as other players don't see it removed (EndBurnFX function gets triggered, which sets charred effect for them)
// Suggest remove that part of the functionality & leave the 'charred' effect on, as it arguably just looks like the player is smoke blackened
// Or remove all douse flames functionality & just let player die a couple of seconds later, as he's been on fire & probably shouldn't survive (& this is usually shallow water anyway)
simulated event Touch(Actor Other)
{
    local DHPawn P;
    local int    i;

    super.Touch(Other);

    P = DHPawn(Other);

    if (P != none && P.bOnFire)
    {
        P.bOnFire = false;

        if (Level.NetMode != NM_DedicatedServer)
        {
            // Stop flame effects on the pawn
            if (P.FlameFX != none)
            {
                P.FlameFX.Kill();
            }

            // Leaving charred looks dumb & anyone with that much burn degree wouldn't be able to fight, so remove charred & turn off all overlay materials
            P.bBurnFXOn = false;
            P.bCharred = false;
            P.SetOverlayMaterial(none, 20.0, true);

            if (P.HeadGear != none)
            {
                P.HeadGear.SetOverlayMaterial(none, 0.0, true);
            }

            // Gotta do it to ammo pouches as well
            for (i = 0; i < P.AmmoPouches.Length; ++i)
            {
                P.AmmoPouches[i].SetOverlayMaterial(none, 0.0, true);
            }
        }
    }
}

defaultproperties
{
    // Seems strange, but this is generally intended as a shallow water volume, so don't want typical water volume things like swimming, drowning, 'jump out of water', etc
    bWaterVolume=false

    // For projectile splash effects, when projectile hits a volume it now checks whether volume either has bWaterVolume=true or it's a 'WaterVolume' (or subclass)
    // We don't want this doing its own splash effects, which would duplicate the projectile's effects, which are more specific to the projectile type
    PawnEntryActorName=""
    EntryActorName=""
    EntrySoundName=""
    ExitSoundName=""

    LocationName=""
    DistanceFogColor=(R=0,G=0,B=0,A=0) // 32/64/128/64 in WaterVolume
    DistanceFogStart=0.0 // 8 in WaterVolume
    DistanceFogEnd=64.0  // 2000 in WaterVolume
    FluidFriction=0.3    // 2.4 in WaterVolume (don't think has any effect here as bWaterVolume=false)
}
