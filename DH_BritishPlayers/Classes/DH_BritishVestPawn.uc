//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_BritishVestPawn extends DH_BritishPawn;

// Modified to fix player's head being too big in the assault vest mesh!
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    SetHeadScale(default.HeadScale);
}

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersBRIT_anm.Brit_Infantry_Vest'
    Skins(0)=Texture'DHBritishCharactersTex.Faces.BritParaFace1'
    Skins(1)=Texture'DHBritishCharactersTex.PBI.British_Infantry_Vest'

    HeadScale=0.9

    bReversedSkinsSlots=true
}
