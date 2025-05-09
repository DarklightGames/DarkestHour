//=============================================================================
// BulletHoleDev
//=============================================================================
// Projector for bullet impacts on Dev Material (visibility of where shots landed)
//=============================================================================

class DHBulletHoleDev extends ROBulletHole;

//=============================================================================
// defaultproperties
//=============================================================================

defaultproperties
{
    ProjTexture=Texture'DH_FX_Tex.Effects.DevImpact' //Purple Square impact to show off where a bullet landed
    LifeSpan=30.0
}
