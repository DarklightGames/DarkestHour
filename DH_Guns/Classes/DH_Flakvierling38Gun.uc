class DH_Flakvierling38Gun extends DH_ATGun;

#exec OBJ LOAD FILE=..\StaticMeshes\DH_Flakvierling38_stc.usx
#exec OBJ LOAD FILE=..\Animations\DH_Flakvierling38_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_Flakvierling38_tex.utx

var int PrimaryMagazineCount;
var int SecondaryMagazineCount;

simulated function Destroyed()
{
    super(ROVehicle).Destroyed();
}

function DenyEntry(Pawn P, int MessageNum)
{
    P.ReceiveLocalizedMessage(class'DH_AAGunMessage', MessageNum);
}

defaultproperties
{
     VehicleHudTurret=TexRotator'DH_Flakvierling38_tex.flak.flakv38_turret_rot'
     VehicleHudTurretLook=TexRotator'DH_Flakvierling38_tex.flak.flakv38_turret_look'
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Guns.DH_Flakvierling38CannonPawn',WeaponBone="Turret_placement")
     DestroyedVehicleMesh=StaticMesh'DH_Flakvierling38_stc.flakv38.flakv38_destroyed'
     DestructionEffectClass=Class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
     DisintegrationEffectClass=Class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
     DamagedEffectClass=none
     DamagedEffectHealthSmokeFactor=0.000000
     DamagedEffectHealthMediumSmokeFactor=0.000000
     DamagedEffectHealthHeavySmokeFactor=0.000000
     VehicleHudImage=Texture'DH_Flakvierling38_tex.flak.flakv38_base'
     VehicleHudOccupantsX(0)=0.000000
     VehicleHudOccupantsX(1)=0.000000
     VehiclePositionString="using a Flakvierling 38"
     VehicleNameString="Flakvierling 38"
     Mesh=SkeletalMesh'DH_Flakvierling38_anm.flak_base'
}
