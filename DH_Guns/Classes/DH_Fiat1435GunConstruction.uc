//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Fiat1435GunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.mg'
    VehicleClasses(0)=(VariantIndex=0,VehicleClass=Class'DH_Fiat1435Gun_AC')
    VehicleClasses(1)=(VariantIndex=1,VehicleClass=Class'DH_Fiat1435Gun_WC')
    SupplyCost=500
    ProgressMax=5
    bCanOnlyPlaceOnTerrain=false
    bCanPlaceIndoors=true
    ArcLengthTraceIntervalInMeters=0.125
    bSinglePlayerOnly=true
}
