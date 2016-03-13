//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Sdkfz105TransportArmored extends DH_Sdkfz105Transport;

// Modified to unhide collision mesh attachment used for armoured shielding on the front, to match its camo to the vehicle, & to set it to resist bullets
simulated function PostBeginPlay()
{
    super(DHWheeledVehicle).PostBeginPlay(); // skip over the Super in DH_Sdkfz105Transport, so we don't spawn a windscreen attachment

    if (CollisionMeshActor != none)
    {
        CollisionMeshActor.bIsBulletProof = true;

        if (Level.NetMode != NM_DedicatedServer)
        {
            CollisionMeshActor.Skins[0] = Skins[1]; // match camo to vehicle's 'cabin' texture
            CollisionMeshActor.bHidden = false;
        }
    }
}

defaultproperties
{
    ColMeshStaticMesh=StaticMesh'DH_German_vehicles_stc4.Sdkfz10_5.SdKfz10_5_armor' // collision mesh for the armour shielding to the front
    ColMeshAttachBone="Body"
    DriverPositions(0)=(TransitionUpAnim="Driver_out")  // to lean forward for a better view through vision slot in armoured shield
    DriverPositions(1)=(TransitionDownAnim="Driver_in") // for reference: camera moves X+25, Z-1
}
