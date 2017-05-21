//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHPistolWeapon extends DHSemiAutoWeapon
    abstract;

// Overridden so we don't play idle empty anims after a reload
simulated state Reloading
{
    simulated function PlayIdle()
    {
        if (bUsingSights && HasAnim(IronIdleEmptyAnim))
        {
            LoopAnim(IronIdleEmptyAnim, IdleAnimRate, 0.2);
        }
        else if (HasAnim(IdleAnim))
        {
            LoopAnim(IdleAnim, IdleAnimRate, 0.2);
        }
    }
}

defaultproperties
{
    bCanAttachOnBack=false
    InventoryGroup=3
    Priority=5
    FreeAimRotationSpeed=8.0
    AIRating=0.35
    CurrentRating=0.35
    bSniping=false
}
