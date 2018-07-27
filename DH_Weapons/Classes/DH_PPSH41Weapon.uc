//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

// This class has a hack that allows the PPSH41 to have other fire modes, it is not ideal, but otherwise a significant rewrite is required to support it

class DH_PPSh41Weapon extends DHFastAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\Allies_Ppsh_1st.ukx

var class<WeaponFire> SingleFireModeClass; // Fire class for the single fire mode

var WeaponFire DefaultFireMode; // Backup of the default fire mode
var WeaponFire SingleFireMode;  // Firemode used for single fire mode

// Hack to create firemodes that we store so we can toggle between them with the active firemode
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (SingleFireModeClass != none)
    {
        SingleFireMode = new(self) SingleFireModeClass;

        if (SingleFireMode != none)
        {
            // Is this being run on the client?
            Log("Hey we should see this on the client too");

            SingleFireMode.ThisModeNum = 0;
            SingleFireMode.Weapon = self;
            SingleFireMode.Instigator = FireMode[0].Instigator;
            SingleFireMode.Level = Level;
            SingleFireMode.Owner = self;
            SingleFireMode.PreBeginPlay();
            SingleFireMode.BeginPlay();
            SingleFireMode.PostBeginPlay();
            SingleFireMode.SetInitialState();
            SingleFireMode.PostNetBeginPlay();
        }
    }

    DefaultFireMode = FireMode[0];
}

// Modified to play the click sound as there is no anim AND a hack to allow for another firemode for a DHFastAutoWeapon
simulated function ToggleFireMode()
{
    PlaySound(Sound'Inf_Weapons_Foley.stg44.stg44_firemodeswitch01',, 2.0);

    // Toggles the fire mode between single and auto
    if (FireMode[0].bWaitForRelease)
    {
        FireMode[0] = DefaultFireMode;
        FireMode[0].InitEffects(); // this is needed for swapping smoke and flash emitters
    }
    else
    {
        FireMode[0] = SingleFireMode;
        FireMode[0].Instigator = Instigator; // Have to set the Instigator for some reason
        FireMode[0].InitEffects(); // this is needed for swapping smoke and flash emitters
    }
}

defaultproperties
{
    ItemName="PPSh-41"

    SingleFireModeClass=class'DH_Weapons.DH_PPSH41FireSingle'
    FireModeClass(0)=class'DH_Weapons.DH_PPSH41Fire'
    FireModeClass(1)=class'DH_Weapons.DH_PPSH41MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_PPSH41Attachment'
    PickupClass=class'DH_Weapons.DH_PPSH41Pickup'

    Mesh=SkeletalMesh'Allies_Ppsh_1st.PPSH-41-mesh'
    HighDetailOverlay=shader'Weapons1st_tex.SMG.PPSH41_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=30.0

    bHasSelectFire=true
    MaxNumPrimaryMags=3
    InitialNumPrimaryMags=3
}
