//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHPistolWeapon extends DHProjectileWeapon
    abstract;

defaultproperties
{
    SwayModifyFactor=1.1 // More sway for pistols

    BobModifyFactor=0.2 // Less weapon bob for pistols

    bPlusOneLoading=true
    bCanAttachOnBack=false
    InventoryGroup=3
    Priority=5
    FreeAimRotationSpeed=8.0
    AIRating=0.35
    CurrentRating=0.35
    bSniping=false
    bUsesIronsightFOV=false
}
