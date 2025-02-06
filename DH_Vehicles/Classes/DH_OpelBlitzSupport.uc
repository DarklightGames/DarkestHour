//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_OpelBlitzSupport extends DH_OpelBlitz;

defaultproperties
{
    VehicleNameString="Opel Blitz (Logistics)"
    PassengerPawns(1)=(AttachBone="passenger_l_3",DrivePos=(X=-1.0,Y=0.0,Z=-4.0),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(2)=(AttachBone="passenger_r_3",DrivePos=(X=-1.0,Y=0.0,Z=-4.0),DriveAnim="VHalftrack_Rider1_idle")
    ExitPositions(2)=(X=-255.0,Y=-30.0,Z=60.0)
    ExitPositions(3)=(X=-255.0,Y=30.0,Z=60.0)
    VehicleHudOccupantsX(2)=0.45
    VehicleHudOccupantsY(2)=0.8
    VehicleHudOccupantsX(3)=0.55
    VehicleHudOccupantsY(3)=0.8
    SupplyAttachmentClass=class'DHConstructionSupplyAttachment_Vehicle'
    SupplyAttachmentBone="body"
    SupplyAttachmentRotation=(Yaw=-16384)
    SupplyAttachmentOffset=(X=0.0,Y=55.0,Z=-10.0)
    SupplyAttachmentStaticMesh=StaticMesh'DH_Construction_stc.Supply_Cache.GER_Supply_cache_full'
    MapIconMaterial=Texture'DH_GUI_tex.GUI.supply_point'
    ResupplyAttachmentBone="supply"
    VehHitpoints(5)=(PointRadius=40.0,PointBone="body",PointOffset=(X=0.0,Y=50.0,Z=15.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DisintegrationHealth=-1000.0 // disintegrates if health falls below this threshold, due to explosive ammo carried
    DisintegrationEffectClass=class'ROEffects.ROVehicleObliteratedEmitter'
    DisintegrationEffectLowClass=class'ROEffects.ROVehicleObliteratedEmitter_simple'
    bRequiresDriverLicense=true
    FriendlyResetDistance=15000.0  // 250 meters
}
