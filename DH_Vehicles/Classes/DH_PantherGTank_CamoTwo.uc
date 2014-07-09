//===================================================================
// DH_PantherG_Camo2Tank
//===================================================================
class DH_PantherGTank_CamoTwo extends DH_PantherGTank;

/*
// Stuff for deco meshes - Shurek
var 	class<DH_VehicleDecoAttachment>     	DecoAttachmentClass;
var 	DH_VehicleDecoAttachment            	HullDecoAttachment;
var     name                                    DecoAttachBone;
var     vector                                  DecoAttachOffset;


replication
{

	reliable if (bNetDirty && Role == ROLE_Authority)
		DecoAttachmentClass;

}


simulated function PostBeginPlay()
{

    super.PostBeginPlay();

    if( HullDecoAttachment != none )
    {

                HullDecoAttachment=Spawn(DecoAttachmentClass, self,, Location + (DecoAttachOffset >> Rotation));
                AttachToBone(HullDecoAttachment, DecoAttachBone);
                HullDecoAttachment.SetRelativeRotation(rot(0,0,0));

    }

}
*/
static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.PantherG_body_camo2');

}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.PantherG_body_camo2');
	Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_PantherGCannonPawn_CamoTwo')
     DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherG_Destroyed2'
     Skins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_body_camo2'
}
