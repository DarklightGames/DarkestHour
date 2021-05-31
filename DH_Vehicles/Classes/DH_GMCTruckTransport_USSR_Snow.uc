//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_GMCTruckTransport_USSR_Snow extends DH_GMCTruckTransport;

defaultproperties
{
    Skins(0)=Texture'DH_GMC_tex.GMC.GMC_Generic'    // TODO: get proper winter tex
    Skins(1)=Texture'DH_GMC_tex.GMC.GMC_Canvas_Snow'
    DestroyedMeshSkins(0)=Combiner'DH_GMC_tex.GMC.GMC_Generic_Destroyed'    // TODO: get proper winter tex
    DestroyedMeshSkins(1)=Shader'DH_GMC_tex.GMC.GMC_Canvas_Destroyed'
}

