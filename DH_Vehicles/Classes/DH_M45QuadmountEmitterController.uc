//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M45QuadmountEmitterController extends WeaponAmbientEmitter;

// Modified so this class acts as a master controller for 4 separate BarrelEffectEmitters
// Necessary as appears that AmbientEffectEmitter is only disabled for non-owning net clients by VehicleWeapon's native PostNetReceive() event (from zeroed FlashCount)
// So if we replace the AmbientEffectEmitter with 4 BarrelEffectEmitters, the native code doesn't do this for us
// But if we spawn this actor as a master controller, the native functionality will work on this class & we'll use this to control the real emitters
simulated function SetEmitterStatus(bool bEnabled)
{
    local DH_M45QuadmountMG M45;
    local int               i;

    M45 = DH_M45QuadmountMG(Owner);

    if (M45 != none)
    {
        for (i = 0; i < arraycount(M45.BarrelEffectEmitter); ++i)
        {
            if (M45.BarrelEffectEmitter[i] != none)
            {
                M45.BarrelEffectEmitter[i].SetEmitterStatus(bEnabled);
            }
        }
    }
}

defaultproperties
{
    bNoDelete=false
    Style=STY_None
    DrawType=DT_None
}
