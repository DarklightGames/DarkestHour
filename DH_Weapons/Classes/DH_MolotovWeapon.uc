//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_MolotovWeapon extends DHExplosiveWeapon;

var     class<Actor>    FlameEffect;
var     Actor           FlameInstance;

simulated function PostBeginPlay ()
{
    super.PostBeginPlay();

    // if( Level.NetMode!=NM_DedicatedServer )
    // {
    //     if( FlameInstance==none )
    //     {
    //         FlameInstance = Spawn( FlameEffect ,,, Location + vect(0,0,-10) );
    //         AttachToBone( FlameInstance , 'Bip01 R Hand' );
    //         FlameInstance.SetRelativeLocation( vect(4,0,10) );
    //         FlameInstance.SetRelativeRotation( rot(0,0,0) );
    //     }
    // }
}

simulated function Fire ( float F )
{
    super.Fire(F);

    if( Level.NetMode!=NM_DedicatedServer )
    {
        if( FlameInstance==none )
        {
            FlameInstance = Spawn( FlameEffect ,,, Location + vect(0,0,-10) );
            AttachToBone( FlameInstance , 'Bip01 R Hand' );
            FlameInstance.SetRelativeLocation( vect(4,0,10) );
            FlameInstance.SetRelativeRotation( rot(0,0,0) );
        }
    }
}

simulated function Destroyed ()
{
    super.Destroyed();

    if( FlameInstance!=none )
        FlameInstance.Destroy();
}

// exec function SetFlameOffset ( string x , string y , string z )
// {
//     local vector vec;
//     vec.x = float(x); vec.y = float(y); vec.z = float(z);
//     FlameInstance.SetRelativeLocation( vec );
// }

defaultproperties
{
    ItemName = "Molotov"
    DisplayFOV = 70.0
    bUseHighDetailOverlayIndex = true
    HighDetailOverlayIndex = 2
    GroupOffset = 3

    AttachmentClass = class'DH_Weapons.DH_MolotovAttachment'
    PickupClass = class'DH_Weapons.DH_MolotovPickup'
    FireModeClass(0) = class'DH_Weapons.DH_MolotovFire'
    FireModeClass(1) = class'DH_Weapons.DH_MolotovTossFire'

    FlameEffect = class'DH_Effects.DHMolotovCoctailFlame'
    
    // Mesh = SkeletalMesh'DH_Molotov_1st.soviet'
    // HighDetailOverlay = shader'DH_Weapon_tex.AlliedSmallArms.MolotovCocktail_s'
    Mesh=SkeletalMesh'Axis_Granate_1st.German-Grenade-Mesh'
    HighDetailOverlay=shader'Weapons1st_tex.Grenades.stiel_s'
}
