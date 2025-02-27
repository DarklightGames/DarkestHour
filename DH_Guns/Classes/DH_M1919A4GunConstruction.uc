//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1919A4GunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.mg'
    VehicleClasses(0)=(VariantIndex=0,VehicleClass=class'DH_Guns.DH_M1919A4Gun')
    //VehicleClasses(1)=(VariantIndex=1,VehicleClass=class'DH_Guns.DH_Fiat1435Gun_WC')
    SupplyCost=500
    ProgressMax=5
    bCanOnlyPlaceOnTerrain=false
    bCanPlaceIndoors=true
    ArcLengthTraceIntervalInMeters=0.125
    bSinglePlayerOnly=true
}
