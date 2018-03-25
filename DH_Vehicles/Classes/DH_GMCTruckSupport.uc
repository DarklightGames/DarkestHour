//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_GMCTruckSupport extends DH_GMCTruck;

defaultproperties
{
    bSquadOwned=true
    VehicleNameString="GMC CCKW (Logistics)"
    PassengerPawns(1)=(AttachBone="passenger_l_5",DrivePos=(X=8.0,Y=0.0,Z=5.0),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(2)=(AttachBone="passenger_r_5",DrivePos=(X=8.0,Y=0.0,Z=5.0),DriveAnim="VHalftrack_Rider1_idle")
    ExitPositions(2)=(X=-273.0,Y=-34.0,Z=25.0) // back left rider
    ExitPositions(3)=(X=-271.0,Y=23.0,Z=25.0)  // back right rider
    VehicleHudOccupantsX(2)=0.45
    VehicleHudOccupantsY(2)=0.75
    VehicleHudOccupantsX(3)=0.55
    VehicleHudOccupantsY(3)=0.75
    SupplyAttachmentClass=class'DHConstructionSupplyAttachment_Vehicle'
    SupplyAttachmentBone="Deco"
    SupplyAttachmentOffset=(X=-2.0,Y=0.0,Z=2.0)
    ResupplyAttachmentBone="supply"
    VehHitpoints(3)=(PointRadius=40.0,PointScale=1.0,PointBone="body",PointOffset=(X=-80.0,Y=0.0,Z=90.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DisintegrationHealth=-1000.0 // disintegrates if health falls below this threshold, due to explosive ammo carried
    DisintegrationEffectClass=class'ROEffects.ROVehicleObliteratedEmitter'
    DisintegrationEffectLowClass=class'ROEffects.ROVehicleObliteratedEmitter_simple'
    bMustBeInSquadToSpawn=true
    FriendlyResetDistance=15000.0  // 250 meters
}
