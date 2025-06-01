//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M116GunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.artillery'
    VehicleClasses(0)=(VehicleClass=class'DH_Guns.DH_M116Gun')
    VehicleClasses(1)=(VehicleClass=class'DH_Guns.DH_M116Gun_Winter',SeasonFilters=((Seasons=(SEASON_Winter))))
    SupplyCost=1500
    ProgressMax=9
    ConstructionBaseMesh=Mesh'DH_M116_anm.m116_base'
}
