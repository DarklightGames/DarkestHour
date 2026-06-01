//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MaximM191030GunConstruction extends DHMountedMachineGunConstruction;

defaultproperties
{
    VehicleClasses(0)=(VariantIndex=0,VehicleClass=Class'DH_MaximM191030Gun')
    VehicleClasses(1)=(VariantIndex=0,VehicleClass=Class'DH_MaximM191030Gun_Winter',SeasonFilters=((Seasons=(SEASON_Winter))))
    VehicleClasses(2)=(VariantIndex=1,VehicleClass=Class'DH_MaximM191030Gun_Standing')
    CollisionQueries(0)=(Type=CQT_Cylinder,Location=(X=-48,Z=24),Radius=38.0,HalfHeight=24)
}
