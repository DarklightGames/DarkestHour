//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MaximM191030GunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.mg'
    VehicleClasses(0)=(VariantIndex=0,VehicleClass=Class'DH_MaximM191030Gun')
    SupplyCost=500
    ProgressMax=5
    bCanOnlyPlaceOnTerrain=false
    bCanPlaceIndoors=true
    ArcLengthTraceIntervalInMeters=0.125
}
