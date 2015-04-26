//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHPistolWeapon extends DHSemiAutoWeapon
    abstract;

// Overridden so we don't play idle empty anims after a reload
simulated state Reloading
{
    simulated function PlayIdle()
    {
        if (bUsingSights)
        {
            LoopAnim(IronIdleEmptyAnim, IdleAnimRate, 0.2);
        }
        else
        {
            LoopAnim(IdleAnim, IdleAnimRate, 0.2);
        }
    }
}

defaultproperties
{
    Priority=5
    InventoryGroup=3

    // Override unwanted defaults inherited from semi-auto
    BobDamping=0.96
    FreeAimRotationSpeed=8.0
    bCanAttachOnBack=false
    bSniping=false
}
