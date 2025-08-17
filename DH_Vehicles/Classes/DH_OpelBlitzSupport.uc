//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_OpelBlitzSupport extends DH_OpelBlitz;

defaultproperties
{
    VehicleNameString="Opel Blitz (Logistics)"
    PassengerPawns(1)=(AttachBone="BODY",DriveRot=(Yaw=-49151),DrivePos=(X=-165.40,Y=-41.93,Z=131.75),DriveAnim="opelblitz_passenger_bl")
    PassengerPawns(2)=(AttachBone="BODY",DriveRot=(Yaw=-16384),DrivePos=(X=-168.31,Y=46.43,Z=132.21),DriveAnim="opelblitz_passenger_br")
    ExitPositions(2)=(X=-267,Y=-41,Z=60)
    ExitPositions(3)=(X=-267,Y=41,Z=60)
    VehicleHudOccupantsX(2)=0.43
    VehicleHudOccupantsY(2)=0.825
    VehicleHudOccupantsX(3)=0.57
    VehicleHudOccupantsY(3)=0.825
    SupplyAttachmentClass=class'DHConstructionSupplyAttachment_Vehicle'
    SupplyAttachmentBone="body"
    SupplyAttachmentRotation=(Yaw=32768,Pitch=273)
    SupplyAttachmentOffset=(X=-64.35,Y=0.0,Z=71.46)
    SupplyAttachmentStaticMesh=StaticMesh'DH_Construction_stc.Supply_Cache.GER_Supply_cache_full'   // TODO: get a real one made
    MapIconMaterial=Texture'DH_GUI_tex.GUI.supply_point'
    ResupplyAttachmentBone="body"
    VehHitpoints(5)=(PointRadius=40.0,PointBone="body",PointOffset=(X=0.0,Y=50.0,Z=15.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DisintegrationHealth=-1000.0 // disintegrates if health falls below this threshold, due to explosive ammo carried
    DisintegrationEffectClass=Class'ROVehicleObliteratedEmitter'
    DisintegrationEffectLowClass=Class'ROVehicleObliteratedEmitter_simple'
    bRequiresDriverLicense=true
    FriendlyResetDistance=15000.0  // 250 meters
    RandomAttachmentGroups(4)=(Options=((Probability=1.0,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_OpelBlitz_stc.OPELBLITZ_ATTACHMENT_TRAILER',SkinIndexMap=((VehicleSkinIndex=4,AttachmentSkinIndex=0))))))
}
