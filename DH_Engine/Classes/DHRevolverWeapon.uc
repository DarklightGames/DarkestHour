//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// WARNING: THIS WHOLE CLASS IS A HACK, REMOVE IT WHEN WE MOVE SINGLEs RELOADS
// TO THE MAIN PROJECTILE WEAPON CLASS!
//==============================================================================

class DHRevolverWeapon extends DHBoltActionWeapon
    abstract;

defaultproperties
{
    SwayModifyFactor=1.1 // More sway for pistols
    BobModifyFactor=0.2  // Less weapon bob for pistols

    bCanAttachOnBack=false
    InventoryGroup=3
    Priority=5
    FreeAimRotationSpeed=8.0
    AIRating=0.35
    CurrentRating=0.35
    bSniping=false
    bUsesIronsightFOV=false

    bShouldSkipBolt=true
    bCanUseUnfiredRounds=false
}
