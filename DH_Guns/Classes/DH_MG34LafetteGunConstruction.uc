//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MG34LafetteGunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.mg'
    VehicleClasses(0)=(VariantIndex=0,VehicleClass=Class'DH_MG34LafetteGun')
    VehicleClasses(1)=(VariantIndex=1,VehicleClass=Class'DH_MG34LafetteGun_Low')
    SupplyCost=500
    ProgressMax=5
    bCanOnlyPlaceOnTerrain=false
    bCanPlaceIndoors=true
    ArcLengthTraceIntervalInMeters=0.125
    ProxyTraceDepthMeters=2.0
    //CollisionQueries(0)=(Type=CQT_Cylinder,Location=(X=-48,Z=24),Radius=38.0,HalfHeight=24)
}
