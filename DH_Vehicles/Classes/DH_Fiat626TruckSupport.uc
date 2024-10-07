//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Fiat626TruckSupport extends DH_Fiat626Truck;

defaultproperties
{
    VehicleNameString="Fiat 626 (Logistics)"
    MapIconMaterial=Texture'DH_GUI_tex.GUI.supply_point'

    // Passengers
    PassengerPawns(1)=(AttachBone="passenger_06",DriveAnim="fiat626_passenger_bl",DrivePos=(Z=58),DriveRot=(Yaw=-16384))
    PassengerPawns(2)=(AttachBone="passenger_11",DriveAnim="fiat626_passenger_br",DrivePos=(Z=58),DriveRot=(Yaw=-16384))

    VehicleHudOccupantsX(2)=0.425
    VehicleHudOccupantsY(2)=0.825
    VehicleHudOccupantsX(3)=0.575
    VehicleHudOccupantsY(3)=0.825

    // Logistics
    SupplyAttachmentClass=class'DHConstructionSupplyAttachment_Vehicle'
    SupplyAttachmentBone="body"
    SupplyAttachmentOffset=(X=-38.7437,Y=0.0,Z=62.7177)
    SupplyAttachmentStaticMesh=StaticMesh'DH_Construction_stc.Supply_Cache.ITA_Supply_cache_full'
    ResupplyAttachmentBone="body"   // TODO: set these up
    bRequiresDriverLicense=true
    FriendlyResetDistance=15000.0  // 250 meters
    // TODO: add ammo store hitpoint
    //VehHitpoints(1)=(PointRadius=60.0,PointBone="body",PointOffset=(X=-60.0,Y=0.0,Z=100.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
}
