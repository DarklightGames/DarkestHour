//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_30Cal_VehHUDOverlay extends VehicleHUDOverlay;

// To put the overlay mesh in the correct position, with a full belt of bullets fed into the gun
simulated function PostBeginPlay()
{
    // TODO: do the bullets here as well! this really should be componentized or something
    // sinfce we are duplicating code!

    PlayAnim('bipod_idle');
}

defaultproperties
{
    Mesh=SkeletalMesh'DH_M1919_anm.M1919A4_vehicle'
    Skins(0)=Texture'Weapons1st_tex.Arms.hands'
    Skins(1)=Texture'DHUSCharactersTex.Sleeves.USAB_sleeves'
    Skins(2)=Texture'DH_M1919_tex.1st.M1919_1st'
    Skins(3)=Texture'DH_M1919_tex.1st.M1919_A6_1st'
    Skins(4)=Texture'DH_M1919_tex.1st.M1919_A6_Shroud_1st'
}
