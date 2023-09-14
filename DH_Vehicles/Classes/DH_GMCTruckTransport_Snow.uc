//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_GMCTruckTransport_Snow extends DH_GMCTruckTransport;

defaultproperties
{
    bIsWinterVariant=true
    Skins(0)=Texture'DH_GMC_tex.GMC.GMC_USOD_Snow'
    Skins(1)=Texture'DH_GMC_tex.GMC.GMC_Canvas_Snow'
    DestroyedMeshSkins(0)=Combiner'DH_GMC_tex.GMC.GMC_USOD_Snow_Destroyed'
    DestroyedMeshSkins(1)=Shader'DH_GMC_tex.GMC.GMC_Canvas_Destroyed'
}
