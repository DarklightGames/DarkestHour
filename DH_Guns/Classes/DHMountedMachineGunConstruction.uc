//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMountedMachineGunConstruction extends DHConstruction_Vehicle
    abstract;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.mg'
    ProxyTraceDepthMeters=2.0
    SupplyCost=500
    ProgressMax=5
    bCanOnlyPlaceOnTerrain=false
    bCanPlaceIndoors=true
    ArcLengthTraceIntervalInMeters=0.125
}
