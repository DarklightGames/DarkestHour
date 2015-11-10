//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ShermanTank_DDay extends DH_ShermanTank;

var     DHVehicleDecoAttachment     DuctsAttachment;

// Modified to attach a static mesh the intake/exhaust ducts on the back of the tank
// Also to void the PassengerPawns array, as we inherit unwanted rider positions that can't be used due to the large ducts on the engine deck
simulated function PostBeginPlay()
{
    PassengerPawns.Length = 0; // remove the inherited riders (needs to go before the Super)

    super.PostBeginPlay();

    DuctsAttachment = Spawn(class'DHVehicleDecoAttachment');

    if (DuctsAttachment != none)
    {
        DuctsAttachment.SetStaticMesh(StaticMesh'DH_allies_vehicles_stc.Sherman.Dday_Sherman_DuctsAttachment');
        DuctsAttachment.SetCollision(true, true); // bCollideActors & bBlockActors both true, so ducts block players walking through & stop projectiles
        DuctsAttachment.bWorldGeometry = true;    // means we get appropriate bullet impact effects, as if we'd hit a normal static mesh actor
        DuctsAttachment.bHardAttach = true;
        DuctsAttachment.SetBase(self);
    }
}

// Modified to include DuctsAttachment
simulated function DestroyAttachments()
{
    super.DestroyAttachments();

    if (DuctsAttachment != none)
    {
        DuctsAttachment.Destroy();
    }
}

defaultproperties
{
    bAllowRiders=false // blocked by the large ducts on the engine deck
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanCannonPawn_DDay')
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Sherman.DDay_Sherman_Dest'
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.shermandd_body'
    VehicleNameString="M4A1 Sherman DD"
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.sherman_dd'
}
