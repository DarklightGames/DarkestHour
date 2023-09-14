//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_Sandbags extends DHConstruction
    abstract;

defaultproperties
{
    GroupClass=class'DHConstructionGroup_Defenses'
    BrokenEmitterClass=class'DHConstruction_Sandbags_BrokenEmitter'
    StartRotationMin=(Yaw=16384)
    StartRotationMax=(Yaw=16384)
    bShouldAlignToGround=false
    bCanTakeImpactDamage=true
    bIsNeutral=true
    bAcceptsProjectors=false

    // Damage
    DamageTypeScales(0)=(DamageType=class'DHShellAPImpactDamageType',Scale=0.33)            // AP Impact
    DamageTypeScales(1)=(DamageType=class'DHRocketImpactDamage',Scale=0.33)                 // AT Rocket Impact
    DamageTypeScales(2)=(DamageType=class'DHThrowableExplosiveDamageType',Scale=1.25)       // Satchel/Grenades
}
