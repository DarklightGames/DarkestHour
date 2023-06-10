//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_GMCTruckSupport extends DH_GMCTruck;

defaultproperties
{
    VehicleNameString="GMC CCKW (Logistics)"
    PassengerPawns(1)=(AttachBone="body",DriveRot=(Yaw=-40000),DrivePos=(X=-180.0,Y=-40.0,Z=135.0),DriveAnim="crouch_idle_binoc")
    PassengerPawns(2)=(AttachBone="body",DriveRot=(Yaw=40000),DrivePos=(X=-180.0,Y=40.0,Z=135.0),DriveAnim="crouch_idle_binoc")
    ExitPositions(2)=(X=-273.0,Y=-34.0,Z=25.0) // back left rider
    ExitPositions(11)=(X=-271.0,Y=23.0,Z=25.0)  // back right rider
    VehicleHudOccupantsX(2)=0.45
    VehicleHudOccupantsY(2)=0.8
    VehicleHudOccupantsX(3)=0.55
    VehicleHudOccupantsY(3)=0.8
    SupplyAttachmentClass=class'DHConstructionSupplyAttachment_Vehicle'
    SupplyAttachmentBone="cache_attachment"
    ResupplyAttachmentBone="resupply"
    VehHitpoints(7)=(PointRadius=60.0,PointScale=1.0,PointBone="body",PointOffset=(X=-60.0,Y=0.0,Z=100.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DisintegrationHealth=-1000.0 // disintegrates if health falls below this threshold, due to explosive ammo carried
    DisintegrationEffectClass=class'ROEffects.ROVehicleObliteratedEmitter'
    DisintegrationEffectLowClass=class'ROEffects.ROVehicleObliteratedEmitter_simple'
    bRequiresDriverLicense=true
    FriendlyResetDistance=15000.0  // 250 meters
}
