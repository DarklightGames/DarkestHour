//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_VehicleMGMultiBarrelEmitterController extends WeaponAmbientEmitter;

// Modified so this class acts as a master controller for 4 separate BarrelEffectEmitters
// Necessary as appears that AmbientEffectEmitter is only disabled for non-owning net clients by VehicleWeapon's native PostNetReceive() event (from zeroed FlashCount)
// So if we replace the AmbientEffectEmitter with 4 BarrelEffectEmitters, the native code doesn't do this for us
// But if we spawn this actor as a master controller, the native functionality will work on this class & we'll use this to control the real emitters
simulated function SetEmitterStatus(bool bEnabled)
{
    local DHVehicleMG   MG;
    local int           i;

    MG = DHVehicleMG(Owner);

    if (MG != none)
    {
        for (i = 0; i < MG.Barrels.Length; ++i)
        {
            if (MG.Barrels[i].EffectEmitter != none)
            {
                MG.Barrels[i].EffectEmitter.SetEmitterStatus(bEnabled);
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
