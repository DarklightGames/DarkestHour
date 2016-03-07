//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Sdkfz105TransportArmored extends DH_Sdkfz105Transport;

// Modified to unhide the collision mesh attachment used for the armoured shielding on the front
simulated function PostBeginPlay()
{
    super(DHApcVehicle).PostBeginPlay(); // skip over the Super in DH_Sdkfz105Transport, so we don't spawn a windscreen attachment

    if (Level.NetMode != NM_DedicatedServer && VisorColMeshActor != none)
    {
        VisorColMeshActor.SetRelativeLocation(VisorColMeshActor.RelativeLocation + (vect(0.0, 0.0, -45.0) >> Rotation)); // TEMP // TODO: Peter to adjust static meshes to lower by 45 units in Z axis
        VisorColMeshActor.Skins[0] = Skins[1]; // match camo to vehicle's 'cabin' texture
        VisorColMeshActor.bHidden = false;
    }
}

defaultproperties
{
    VisorColStaticMesh=StaticMesh'DH_German_vehicles_stc4.Sdkfz10_5.SdKfz10_5_armor' // not actually a moving driver's visor, but using this to spawn the armour shielding to front
    VisorColAttachBone="Body"
    DriverPositions(0)=(TransitionUpAnim="Driver_out")  // to lean forward for a better view through vision slot in armoured shield
    DriverPositions(1)=(TransitionDownAnim="Driver_in") // for reference: camera moves X+25, Z-1
}
