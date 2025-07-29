//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstruction_Sandbags extends DHConstruction
    abstract;

defaultproperties
{
    GroupClass=Class'DHConstructionGroup_Defenses'
    BrokenEmitterClass=Class'DHConstruction_Sandbags_BrokenEmitter'
    StartRotationMin=(Yaw=16384)
    StartRotationMax=(Yaw=16384)
    bShouldAlignToGround=false
    bCanTakeImpactDamage=true
    bCanDieOfStagnation=false
    bIsNeutral=true
    bAcceptsProjectors=false

    // Damage
    DamageTypeScales(0)=(DamageType=Class'DHShellAPImpactDamageType',Scale=0.33)            // AP Impact
    DamageTypeScales(1)=(DamageType=Class'DHRocketImpactDamage',Scale=0.33)                 // AT Rocket Impact
    DamageTypeScales(2)=(DamageType=Class'DHThrowableExplosiveDamageType',Scale=1.25)       // Satchel/Grenades
}
