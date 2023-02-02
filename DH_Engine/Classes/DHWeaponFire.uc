//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHWeaponFire extends ROWeaponFire;

var bool bIgnoresWeaponLock;

var vector MuzzleOffset;

simulated function InitEffects()
{
    if (Level.NetMode == NM_DedicatedServer || AIController(Instigator.Controller) != none)
    {
        return;
    }

    if (FlashEmitterClass != none && (FlashEmitter == none || FlashEmitter.bDeleteMe))
    {
        FlashEmitter = Weapon.Spawn(FlashEmitterClass);

        if (FlashEmitter != none && MuzzleBone != '')
        {
            Weapon.AttachToBone(FlashEmitter, MuzzleBone);
            FlashEmitter.SetRelativeLocation(MuzzleOffset);
        }
    }

    if (SmokeEmitterClass != none && (SmokeEmitter == none || SmokeEmitter.bDeleteMe))
    {
        SmokeEmitter = Weapon.Spawn(SmokeEmitterClass, Instigator);

        if (SmokeEmitter != None && MuzzleBone != '')
        {
            Weapon.AttachToBone(SmokeEmitter, MuzzleBone);
            SmokeEmitter.SetRelativeLocation(MuzzleOffset);
        }
    }
}

defaultproperties
{
    SpreadStyle=SS_Random // this is actually assumed & hard-coded into spread functionality
}
