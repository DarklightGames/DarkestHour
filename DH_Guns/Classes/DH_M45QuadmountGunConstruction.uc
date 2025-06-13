//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M45QuadmountGunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.aa_light'
    VehicleClasses(0)=(VehicleClass=Class'DH_M45QuadmountGun')
    VehicleClasses(1)=(VehicleClass=Class'DH_M45QuadmountGun_Snow',SeasonFilters=((Seasons=(SEASON_Winter))))
    SupplyCost=1050
    ProgressMax=7
}
