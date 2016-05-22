//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHWaterVolume extends PhysicsVolume;

var()   bool    bIsShallowWater; // means we won't get functionality associated with state 'Swimming' in deep water, but will still get splash effects

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
    bWaterVolume=true
    bIsShallowWater=true // leveller can override
    LocationName=""
    FluidFriction=0.3        // 2.4 in WaterVolume
    KExtraLinearDamping=2.5  // same as WaterVolume
    KExtraAngularDamping=0.4 // same as WaterVolume
    bDistanceFog=true
    DistanceFogColor=(R=0,G=0,B=0,A=0) // 32/64/128/64 in WaterVolume
    DistanceFogStart=0.0               // 8 in WaterVolume
    DistanceFogEnd=64.0                // 2000 in WaterVolume
}
