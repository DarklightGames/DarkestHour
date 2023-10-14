//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_USVestPawn extends DH_AmericanPawn;

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersUS_anm.US_GI_vest'
    Skins(1)=Texture'DHUSCharactersTex.GI.GI_AssualtVest'

    BodySkins(0)=Texture'DHUSCharactersTex.GI.GI_AssualtVest'
    BodySkins(1)=Texture'DHUSCharactersTex.GI.GI_AssualtVest' //Dumb skin duplication here appears to be required as skin inhereted from AmericanPawn is not compatible with vest models.
}
