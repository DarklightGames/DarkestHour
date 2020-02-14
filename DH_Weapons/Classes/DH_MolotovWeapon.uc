//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_MolotovWeapon extends DHExplosiveWeapon;

var     class<Actor>    FlameEffect;
var     Actor           FlameInstance;

var     sound           IgnitionSound;
var     sound           ThrowSound;

simulated function Fire ( float F )
{
    super.Fire(F);

    if( Level.NetMode!=NM_DedicatedServer )
    {
        if( FlameInstance==none )
        {
            FlameInstance = Spawn( FlameEffect ,,, Location + vect(0,0,-10) );
            FlameInstance.bOnlyDrawIfAttached = true;
            AttachToBone( FlameInstance , 'Bip01 R Hand' );
            FlameInstance.SetRelativeLocation( vect(4,0,20) );

            if( IgnitionSound!=none )
            {
                PlaySound( IgnitionSound ,,,, 100 );
            }
        }
    }
}

simulated function PostFire ()
{
    super.PostFire();

    if( ThrowSound!=none )
    {
        PlaySound( ThrowSound ,,,, 100 );
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

    // fx
    FlameEffect = class'DH_Effects.DHMolotovCoctailFlame'

    // sound
    IgnitionSound = Sound'DH_MolotovCocktail.ignite'
    ThrowSound = Sound'DH_MolotovCocktail.throw'
    
    // mesh
    Mesh = SkeletalMesh'DH_Molotov_1st.Soviet'
    //HighDetailOverlay = shader'shader goes here'
}
