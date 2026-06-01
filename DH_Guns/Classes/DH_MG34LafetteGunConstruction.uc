//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MG34LafetteGunConstruction extends DHMountedMachineGunConstruction;

defaultproperties
{
    VehicleClasses(0)=(VariantIndex=0,VehicleClass=Class'DH_MG34LafetteGun')
    VehicleClasses(1)=(VariantIndex=0,VehicleClass=Class'DH_MG34LafetteGun_Camo',SeasonFilters=((Operation=SFO_None,Seasons=(SEASON_Winter))))
    VehicleClasses(2)=(VariantIndex=0,VehicleClass=Class'DH_MG34LafetteGun_Desert',SeasonFilters=((Operation=SFO_Any,Seasons=(SEASON_Summer,SEASON_Autumn))))
    VehicleClasses(3)=(VariantIndex=1,VehicleClass=Class'DH_MG34LafetteGun_Low')
    //CollisionQueries(0)=(Type=CQT_Cylinder,Location=(X=-48,Z=24),Radius=38.0,HalfHeight=24)
}
