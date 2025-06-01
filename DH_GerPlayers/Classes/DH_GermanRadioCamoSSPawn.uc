//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_GermanRadioCamoSSPawn extends DH_GermanPawn; // not extending the obvious DH_GermanRadioSSPawn as would inherit 3 extra unwanted BodySkins

defaultproperties
{
    Skins(1)=Texture'DHGermanCharactersTex.WSS.SS_Autumn'

    BodySkins(0)=Texture'DHGermanCharactersTex.WSS.SS_Autumn'
    BodySkins(1)=Texture'DHGermanCharactersTex.WSS.SS_Autumn'

    Mesh=SkeletalMesh'DHCharactersGER_anm.Ger_Heer_Radioman'
}
