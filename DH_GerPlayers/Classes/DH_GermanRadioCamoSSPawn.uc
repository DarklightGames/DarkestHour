//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_GermanRadioCamoSSPawn extends DH_GermanPawn; // not extending the obvious DH_GermanRadioSSPawn as would inherit 3 extra unwanted BodySkins

defaultproperties
{
    Mesh=SkeletalMesh'DHCharacters_anm.Ger_SS_Radioman'
    Skins(1)=texture'DHGermanCharactersTex.WSS.ger_camo'
}
