//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHWaterVolume extends PhysicsVolume;

var()   bool    bIsShallowWater; // means we won't get functionality associated with state 'Swimming' in deep water, but will still get splash effects

// Modified to nullify any splash effects, as they are now handled better by projectiles & we don't want any duplication
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    PawnEntryActor = none;
    EntryActor = none;
    EntrySound = none;
    ExitActor = none;
    ExitSound = none;
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
