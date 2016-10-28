//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHPawn extends ROPawn
    config(User);

#exec OBJ LOAD FILE=ProjectileSounds.uax

// Model record variables
var     array<Material>         FaceSkins;
var     array<Material>         BodySkins;

var     int                     FaceSlot;
var     int                     BodySlot;

// General
var     float   SpawnProtEnds;            // is set when a player spawns/teleports for "spawn" protection in selectable spawn maps
var     float   SpawnKillTimeEnds;        // is set when a player spawns
var     float   StanceChangeStaminaDrain; // how much stamina is lost by changing stance
var     float   MinHurtSpeed;             // when a moving player lands, if they're moving faster than this speed they'll take damage
var     vector  LastWhizLocation;         // last whiz sound location on pawn (basically a non-replicated version of Pawn's mWhizSoundLocation, as we no longer want it to replicate)
var     bool    bHatShotOff;
var     bool    bHasBeenPossessed;        // fixes players getting new ammunition when they get out of vehicles
var     bool    bNeedToAttachDriver;      // flags that net client was unable to attach Driver to VehicleWeapon, as hasn't yet received VW actor (tells vehicle to do it instead)
var     bool    bClientSkipDriveAnim;     // set by vehicle replicated to net client that's already played correct initial driver anim, so DriveAnim doesn't override that
var     bool    bClientPlayedDriveAnim;   // flags that net client already played DriveAnim on entering vehicle, so replicated vehicle knows not to set bClientSkipDriveAnim

// Resupply
var     bool    bWeaponNeedsReload;       // whether an AT weapon is loaded or not
var     int     MortarHEAmmo;
var     int     MortarSmokeAmmo;

// Mortars
var     Actor   OwnedMortar;              // mortar vehicle associated with this actor, used to destroy mortar when player dies
var     bool    bIsDeployingMortar;       // whether or not the pawn is deploying his mortar - used for disabling movement
var     bool    bMortarCanBeResupplied;
var     bool    bLockViewRotation;
var     rotator LockViewRotation;

// Obstacle clearing
var     bool    bCanCutWire;
var     bool    bIsCuttingWire;

// Ironsight bob
var     float   IronsightBobTime;
var     vector  IronsightBob;
var     float   IronsightBobAmplitude;
var     float   IronsightBobFrequency;
var     float   IronsightBobDecay;

// Radioman
var     ROArtilleryTrigger  CarriedRadioTrigger; // for storing the trigger on a radioman each spawn, for the purpose of deleting it on death

// Sounds
var(Sounds) class<DHPawnSoundGroup> DHSoundGroupClass;
var() array<sound>                  PlayerHitSounds;
var() array<sound>                  HelmetHitSounds;

// Mantling
var     vector  MantleEndPoint;      // player's final location after mantle
var     bool    bCanMantle;          // used for HUD icon display
var     bool    bSetMantleEyeHeight; // for lowering eye height during mantle
var     bool    bIsMantling;         // fairly straightforward
var     bool    bMantleSetPitch;     // to prevent climbing/bob until view pitch is level
var     bool    bCrouchMantle;       // whether a climb ends in a crouch or not, for tight spaces
var     bool    bMantleAnimRun;      // has the anim been started on the server/remote clients yet?
var     bool    bCancelledMantle;    // whether a mantle has ended naturally or been aborted
var     bool    bMantleDebug;        // show debug output while mantling
var     float   MantleHeight;        // how high we're climbing
var     float   StartMantleTime;     // used for smoothing out pitch at mantle start
var     int     MantleYaw;           // for locking rotation during climb
var     vector  RootLocation;
var     vector  RootDelta;
var     vector  NewAcceleration;     // acceleration which is checked by PlayerMove in the Mantling state within DHPlayer
var     bool    bEndMantleBob;       // initiates the pre mantle head bob up motion
var     sound   MantleSound;

var(ROAnimations)   name        MantleAnim_40C, MantleAnim_44C, MantleAnim_48C, MantleAnim_52C, MantleAnim_56C, MantleAnim_60C, MantleAnim_64C,
                                MantleAnim_68C, MantleAnim_72C, MantleAnim_76C, MantleAnim_80C, MantleAnim_84C, MantleAnim_88C;

var(ROAnimations)   name        MantleAnim_40S, MantleAnim_44S, MantleAnim_48S, MantleAnim_52S, MantleAnim_56S, MantleAnim_60S, MantleAnim_64S,
                                MantleAnim_68S, MantleAnim_72S, MantleAnim_76S, MantleAnim_80S, MantleAnim_84S, MantleAnim_88S;
// Burning
var     bool                bOnFire;                       // whether Pawn is on fire or not
var     bool                bBurnFXOn;                     // whether Fire FX are enabled or not
var     bool                bCharred;                      // for switching in a charred overlay after the fire goes out
var     class<Emitter>      FlameEffect;                   // the fire sprite emitter class
var     Emitter             FlameFX;                       // spawned instance of the above
var     Material            BurningOverlayMaterial;        // overlay for when player is on fire
var     Material            DeadBurningOverlayMaterial;    // overlay for when player is on fire and dead
var     Material            CharredOverlayMaterial;        // overlay for dead, burned players after flame extinguished
var     Material            BurnedHeadgearOverlayMaterial; // overlay for burned hat
var     int                 FireDamage;
var     class<DamageType>   FireDamageClass;               // the damage type that started the fire
var     int                 BurnTimeLeft;                  // number of seconds remaining for a corpse to burn
var     float               LastBurnTime;                  // last time we did fire damage to the Pawn
var     Pawn                FireStarter;                   // who set a player on fire

// Touch messages
var     class<LocalMessage> TouchMessageClass;
var     float               LastNotifyTime;

replication
{
    // Variables the server will replicate to all clients except the one that owns this actor
    reliable if (bNetDirty && !bNetOwner && Role == ROLE_Authority)
        bWeaponNeedsReload;

    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bOnFire, bCrouchMantle, MantleHeight;

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        ClientPawnWhizzed;
}

// Modified to use DH version of bullet whip attachment, & to remove its SavedAuxCollision (deprecated as now we simply enable/disable collision in ToggleAuxCollision function)
// Also removes needlessly setting some variables to what will be default values anyway for a spawning actor
simulated function PostBeginPlay()
{
    super(Pawn).PostBeginPlay();

    SetBodySkin(Rand(default.BodySkins.Length));
    SetFaceSkin(Rand(default.FaceSkins.Length));

    if (Level.bStartup && !bNoDefaultInventory)
    {
        AddDefaultInventory();
    }

    AssignInitialPose();

    UpdateShadow();

    AuxCollisionCylinder = Spawn(class'DHBulletWhipAttachment', self);
    AttachToBone(AuxCollisionCylinder, 'spine');

    LastResupplyTime = Level.TimeSeconds - 1.0;
}

// Matt 2016: modified to fix 'uniform bug' where player on net client would sometimes spawn with wrong player model (most commonly an allied player spawning as a German)
// The functionality is now in a new SetUpPlayerModel() function to avoid code duplication, so see that function for explanatory comments
simulated function PostNetReceive()
{
    local Inventory Inv;
    local bool      bVerifiedPrimary, bVerifiedSecondary, bVerifiedNades;
    local int       i;

    // Flag bRecievedInitialLoadout when all of our role's weapons & equipment have been replicated, then switch to best weapon
    if (!bRecievedInitialLoadout)
    {
        for (Inv = Inventory; Inv != none; Inv = Inv.Inventory)
        {
            if (Weapon(Inv) != none)
            {
                if (VerifyPrimary(Inv))
                {
                    bVerifiedPrimary = true;
                }

                if (VerifySecondary(Inv))
                {
                    bVerifiedSecondary = true;
                }

                if (VerifyNades(Inv))
                {
                    bVerifiedNades = true;
                }
            }

            i++;

            if (i > 500) // prevents possibility of runaway loop
            {
                break;
            }
        }

        if (bVerifiedPrimary && bVerifiedSecondary && bVerifiedNades && VerifyGivenItems()) // minor re-factor so don't check given items unless other tests passed
        {
            bRecievedInitialLoadout = true;

            if (Controller != none)
            {
                Controller.SwitchToBestWeapon();
            }
        }
    }

    // Set up the player model when we have received the PRI & its CharacterName property has been updated
    // Called function includes crucial fix to verify CharacterName property has been updated when player is in a vehicle
    if (!bInitializedPlayer)
    {
        SetUpPlayerModel();
    }

    // Initialise weapon attachment (check if one has been received in our Attached array of attached actors)
    if (!bInitializedWeaponAttachment && WeaponAttachment == none)
    {
        for (i = 0; i < Attached.Length; ++i)
        {
            if (ROWeaponAttachment(Attached[i]) != none)
            {
                SetWeaponAttachment(ROWeaponAttachment(Attached[i]));
                bInitializedWeaponAttachment = true;
                break;
            }
        }
    }

    // Disable PostNetReceive() notifications once we have initialised everything for this pawn
    if (bInitializedPlayer && bInitializedWeaponAttachment && bRecievedInitialLoadout)
    {
        bNetNotify = false;
    }
}

simulated function SetBodySkin(optional int Index)
{
    local int i;

    //return;

    for (i = default.BodySkins.Length - 1; i >= 0; --i)
    {
        if (default.BodySkins[i] == None)
        {
            default.BodySkins.Remove(i, 1);
            i -= 1;
        }
    }

    if (default.BodySkins.Length > 0)
    {
        default.Skins[default.BodySlot] = default.BodySkins[Rand(default.BodySkins.Length)];
    }
}

simulated function SetFaceSkin(optional int Index)
{
    local int i;

    //return;

    for (i = default.FaceSkins.Length - 1; i >= 0; --i)
    {
        if (default.FaceSkins[i] == none)
        {
            default.FaceSkins.Remove(i, 1);
            i -= 1;
        }
    }

    if (default.FaceSkins.Length > 0)
    {
        default.Skins[default.FaceSlot] = default.FaceSkins[Index % default.FaceSkins.Length];
    }
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    // Lets keep the effects client side, the server has enough to deal with
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (bOnFire && !bBurnFXOn)
        {
            BurningDropWeaps(); // if you're on fire, the last thing you'll be doing is continuing to fight!
            StartBurnFX();
        }
        else if (!bOnFire && bBurnFXOn)
        {
            EndBurnFX();
        }

        // Forced client bob values. These variables are global config and are used in native code.
        // There is no way to bypass its use and only way to restrict is by forcing its value in tick
        // Do not set to DHPawn.default.Bob as it'll just use the ini as default
        Bob = 0.01;
        bWeaponBob = true;
    }

    // Forces us to equip a mortar if we have one on us.
    if (Level.NetMode != NM_DedicatedServer && HasMortarInInventory() && DHMortarWeapon(Weapon) == none)
    {
        SwitchWeapon(9); // mortars are inventory group 9, deal with it
    }

    // Would prefer to do this in a Timer but too many states hijack timer and reset it on us
    // I don't want to have to override over a dozen functions just to do damage every half second
    if (bOnFire && (Level.TimeSeconds - LastBurnTime > 1.0) && Health > 0)
    {
        TakeDamage(FireDamage, FireStarter, Location, vect(0.0, 0.0, 0.0), FireDamageClass);

        if (Weapon != none)
        {
            BurningDropWeaps();
        }
    }
}

simulated function bool HasMortarInInventory()
{
    local Inventory I;

    if (!CanUseMortars())
    {
        return false;
    }

    for (I = Inventory; I != none; I = I.Inventory)
    {
        if (DHMortarWeapon(I) != none)
        {
            return true;
        }
    }

    return false;
}

// PossessedBy - figure out what dummy attachments are needed
function PossessedBy(Controller C)
{
    local array<class<ROAmmoPouch> > AmmoClasses;
    local int i, Prim, Sec, Gren;
    local DHRoleInfo DHRI;
    local ROPlayerReplicationInfo PRI;

    super(Pawn).PossessedBy(C);

    // From XPawn
    if (Controller != none)
    {
        OldController = Controller;
    }

    // Handle dummy attachments
    if (Role == ROLE_Authority)
    {
        ClientForceStaminaUpdate(Stamina);

        if (Controller != none)
        {
            if (ROPlayer(Controller) != none)
            {
                Prim = ROPlayer(Controller).PrimaryWeapon;
                Sec = ROPlayer(Controller).SecondaryWeapon;
                Gren = ROPlayer(Controller).GrenadeWeapon;
            }
            else if (ROBot(Controller) != none)
            {
                Prim = ROBot(Controller).PrimaryWeapon;
                Sec = ROBot(Controller).SecondaryWeapon;
                Gren = ROBot(Controller).GrenadeWeapon;
            }
        }

        PRI = ROPlayerReplicationInfo(PlayerReplicationInfo);

        if (PRI != none && PRI.RoleInfo != none)
        {
            HeadgearClass = PRI.RoleInfo.GetHeadgear();
            DetachedArmClass = PRI.RoleInfo.static.GetArmClass();
            DetachedLegClass = PRI.RoleInfo.static.GetLegClass();
            PRI.RoleInfo.GetAmmoPouches(AmmoClasses, Prim, Sec, Gren);
        }
        else
        {
            Warn("Error!!! Possess with no RoleInfo!!!");
        }

        for (i = 0; i < AmmoClasses.Length; ++i)
        {
            AmmoPouchClasses[i] = AmmoClasses[i];
        }

        // These don't need to exist on dedicated servers at the moment, though they might if the ammo holding functionality of the pouch is put in - Erik
        if (Level.NetMode != NM_DedicatedServer)
        {
            if (HeadgearClass != none && Headgear == none && !bHatShotOff)
            {
                Headgear = Spawn(HeadgearClass, self);
            }

            for (i = 0; i < arraycount(AmmoPouchClasses); ++i)
            {
                if (AmmoPouchClasses[i] == none)
                {
                    break;
                }

                AmmoPouches[AmmoPouches.Length] = Spawn(AmmoPouchClasses[i], self);
            }
        }

        // We just check if we've already been possessed once - if not, we run this
        if (!bHasBeenPossessed)
        {
            DHRI = GetRoleInfo();

            // We've now been possessed
            bHasBeenPossessed = true;
            bUsedCarriedMGAmmo = false;

            // Give default mortar ammunition. (TODO: this is horrible!)
            if (DHRI.bCanUseMortars)
            {
                if (C.GetTeamNum() == 0) // axis
                {
                    MortarHEAmmo = 16;
                    MortarSmokeAmmo = 4;
                }
                else // allies
                {
                    MortarHEAmmo = 24;
                    MortarSmokeAmmo = 4;
                }
            }
        }
    }

    // Send the info to the client now to make sure RoleInfo is replicated quickly
    NetUpdateTime = Level.TimeSeconds - 1.0;

    // Slip this in here
    if (Controller != none && DHPlayer(Controller) != none)
    {
        bMantleDebug = DHPlayer(Controller).bMantleDebug;
    }
}

// Modified to remove trying to loop non-existent 'Vehicle_Driving' animation if vehicle doesn't have a DriveAnim (e.g. where driver is hidden)
simulated function AssignInitialPose()
{
    if (DrivenVehicle == none)
    {
        TweenAnim(MovementAnims[0], 0.0);
    }
    else if (HasAnim(DrivenVehicle.DriveAnim))
    {
        LoopAnim(DrivenVehicle.DriveAnim,, 0.1);
    }

    AnimBlendParams(1, 1.0, 0.2, 0.2, 'Bip01_Spine1');
    BoneRefresh();
}

// Modified to stop "accessed none" log errors on trying to play invalid vehicle DriveAnim
simulated event AnimEnd(int Channel)
{
    local name  WeapAnim, PlayerAnim, Anim;
    local float Frame, Rate;
    local bool  bIsMoving;

    bIsMoving = VSizeSquared(Velocity) > 625.0; // equivalent to speed of 25 (VSSquared is more efficient)

    if (DrivenVehicle != none)
    {
        if (HasAnim(DrivenVehicle.DriveAnim))
        {
            PlayAnim(DrivenVehicle.DriveAnim, 1.0,, 1);
        }
    }
    else if (Channel == 1 && WeaponState != GS_IgnoreAnimend)
    {
        if (WeaponState == GS_Ready)
        {
            AnimBlendToAlpha(1, 0.0, 0.12);
            WeaponState = GS_None;
        }
        else if (WeaponState == GS_FireSingle || WeaponState == GS_ReloadSingle)
        {
            AnimStopLooping(1); // stop the rapid fire anim from looping
            AnimBlendToAlpha(1, 0.0, 0.12);
            WeaponState = GS_None;

            if (!bIsMoving)
            {
                IdleTime = Level.TimeSeconds;
            }

            if (WeaponAttachment != none)
            {
                WeaponAttachment.GetAnimParams(0, Anim, Frame, Rate);

                if (WeaponAttachment.bBayonetAttached)
                {
                    if (WeaponAttachment.bOutOfAmmo && WeaponAttachment.WA_BayonetIdleEmpty != '' && Anim != WeaponAttachment.WA_BayonetReloadEmpty)
                    {
                        WeaponAttachment.LoopAnim(WeaponAttachment.WA_BayonetIdleEmpty);
                    }
                    else if (WeaponAttachment.WA_BayonetIdle != '')
                    {
                        WeaponAttachment.LoopAnim(WeaponAttachment.WA_BayonetIdle);
                    }
                }
                else
                {
                    if (WeaponAttachment.bOutOfAmmo && WeaponAttachment.WA_IdleEmpty != '' && Anim != WeaponAttachment.WA_ReloadEmpty)
                    {
                        WeaponAttachment.LoopAnim(WeaponAttachment.WA_IdleEmpty);
                    }
                    else
                    {
                        WeaponAttachment.LoopAnim(WeaponAttachment.WA_Idle);
                    }
                }
            }
        }
        else if (WeaponState == GS_GrenadePullBack)
        {
            if (bIsCrawling)
            {
                LoopAnim('prone_hold_nade',, 0.0, 1);
            }
            else
            {
                LoopAnim('stand_hold_nade',, 0.0, 1);
            }

            WeaponState = GS_GrenadeHoldBack;
            IdleTime = Level.TimeSeconds;
        }
        else if (WeaponState == GS_PreReload && WeaponAttachment != none)
        {
            AnimBlendParams(1, 1.0, 0.0, 0.2, SpineBone1);
            AnimBlendParams(1, 1.0, 0.0, 0.2, SpineBone2);

            if (WeaponAttachment.bOutOfAmmo)
            {
                if (bIsCrawling)
                {
                    PlayerAnim = WeaponAttachment.PA_ProneReloadEmptyAnim;
                }
                else
                {
                    PlayerAnim = WeaponAttachment.PA_ReloadEmptyAnim;
                }
            }
            else
            {
                if (bIsCrawling)
                {
                    PlayerAnim = WeaponAttachment.PA_ProneReloadAnim;
                }
                else
                {
                    PlayerAnim = WeaponAttachment.PA_ReloadAnim;
                }
            }

            LoopAnim(PlayerAnim,, 0.0, 1);
            WeaponState = GS_ReloadLooped;
            IdleTime = Level.TimeSeconds;

            if (WeaponAttachment.bBayonetAttached)
            {
                if (bIsCrawling)
                {
                    if (WeaponAttachment.bOutOfAmmo && WeaponAttachment.WA_BayonetProneReloadEmpty != '')
                    {
                        WeapAnim = WeaponAttachment.WA_BayonetProneReloadEmpty;
                    }
                    else if (WeaponAttachment.WA_BayonetProneReload != '')
                    {
                        WeapAnim = WeaponAttachment.WA_BayonetProneReload;
                    }
                }
                else
                {
                    if (WeaponAttachment.bOutOfAmmo && WeaponAttachment.WA_BayonetReloadEmpty != '')
                    {
                        WeapAnim = WeaponAttachment.WA_BayonetReloadEmpty;
                    }
                    else if (WeaponAttachment.WA_BayonetReload != '')
                    {
                        WeapAnim = WeaponAttachment.WA_BayonetReload;
                    }
                }
            }
            else
            {
                if (bIsCrawling)
                {
                    if (WeaponAttachment.bOutOfAmmo && WeaponAttachment.WA_ProneReloadEmpty != '')
                    {
                        WeapAnim = WeaponAttachment.WA_ProneReloadEmpty;
                    }
                    else if (WeaponAttachment.WA_ProneReload != '')
                    {
                        WeapAnim = WeaponAttachment.WA_ProneReload;
                    }
                }
                else
                {
                    if (WeaponAttachment.bOutOfAmmo && WeaponAttachment.WA_ReloadEmpty != '')
                    {
                        WeapAnim = WeaponAttachment.WA_ReloadEmpty;
                    }
                    else
                    {
                        WeapAnim = WeaponAttachment.WA_Reload;
                    }
                }
            }

            WeaponAttachment.LoopAnim(WeapAnim);
        }
        else if (WeaponState != GS_ReloadLooped && WeaponState != GS_GrenadeHoldBack && WeaponState != GS_FireLooped)
        {
            AnimBlendToAlpha(1, 0.0, 0.12);
        }
    }
    else if (bKeepTaunting && Channel == 0)
    {
        PlayVictoryAnimation();
    }
}

simulated function HelmetShotOff(rotator Rotation)
{
    local DroppedHeadGear Hat;

    if (HeadGear == none)
    {
        return;
    }

    Hat = Spawn(class'DroppedHeadGear',,, HeadGear.Location, HeadGear.Rotation);

    if (Hat == none)
    {
        return;
    }

    Hat.LinkMesh(HeadGear.Mesh);
    Hat.Skins[0] = Headgear.Skins[0];

    if (bOnFire)
    {
        Hat.SetOverlayMaterial(BurnedHeadgearOverlayMaterial, 999.0, true);
    }

    HeadGear.Destroy();

    Hat.Velocity = Velocity + vector(Rotation) * (Hat.MaxSpeed + (Hat.MaxSpeed / 2.0) * FRand());
    Hat.LifeSpan = Hat.LifeSpan + 2.0 * FRand() - 1.0;

    bHatShotOff = true;
}

function name GetWeaponBoneFor(Inventory I)
{
    return 'weapon_rhand';
}

function bool IsSpawnProtected()
{
    return SpawnProtEnds > Level.TimeSeconds;
}

function bool IsSpawnKillProtected()
{
    return SpawnKillTimeEnds > Level.TimeSeconds;
}

// Modified to handle new DH SpawnProtEnds variable, & also to avoid occasional "accessed none" log error (re Level.Game) when called on net client
function DeactivateSpawnProtection()
{
    SpawnProtEnds = -10000.0;

    if (!bSpawnDone)
    {
        bSpawnDone = true;

        if (DeathMatch(Level.Game) != none && (Level.TimeSeconds - SpawnTime) < DeathMatch(Level.Game).SpawnProtectionTime)
        {
            SpawnTime = Level.TimeSeconds - DeathMatch(Level.Game).SpawnProtectionTime - 1.0;
        }
    }
}

// Modified to handle bullet 'snaps' for supersonic rounds, as well as whizzes, & also to add suppression effects - all based on passed WhizType
// Also to remove setting replicated variables, as is unnecessary as this event gets called on both server & net clients (by native code in HitPointTrace from bullet collision)
event PawnWhizzed(vector WhizLocation, int WhizType)
{
    // Whiz type 255 is special flag that we don't want to play whiz effects, & is only used by bullet's pre-launch trace to trigger this event so it can grab WhizLocation
    // WhizLocation has been calculated by native code & we save it as a non-replicated variable (instead of using mWhizSoundLocation, which would pointlessly replicate)
    if (WhizType == 255)
    {
        LastWhippedTime = Level.TimeSeconds;
        LastWhizLocation = WhizLocation;
    }
    // Don't play whiz effects if player was very recently whizzed, or for bots, or whizzes for other players
    else if (ShouldBeWhizzed())
    {
        LastWhippedTime = Level.TimeSeconds;

        if (WhizType == 1)
        {
            Spawn(class'DHBulletSnap',,, WhizLocation); // supersonic round
        }
        else
        {
            Spawn(class'DHBulletWhiz',,, WhizLocation); // subsonic round
        }

        // WhizType 3 means a friendly bullet at very close range, so don't suppress
        if (WhizType != 3 && DHPlayer(Controller) != none)
        {
            DHPlayer(Controller).PlayerWhizzed(VSizeSquared(Location - WhizLocation));
        }
    }
}

// New helper function, just to improve readability & to avoid repeating time check literal in other classes (e.g. bullet's pre-launch trace)
// bSkipLocallyControlledCheck option is used by pre-launch trace, as server needs to do special whiz (type 4) to get WhizLocation to make net clients play whiz
simulated function bool ShouldBeWhizzed(optional bool bSkipLocallyControlledCheck)
{
    return (Level.TimeSeconds - LastWhippedTime) > 0.15 && IsHumanControlled() && (bSkipLocallyControlledCheck || IsLocallyControlled());
}

// New server-to-client replicated function, used by DHProjectileFire's pre-launch trace system for the server to play whiz/snap effects on clients
simulated function ClientPawnWhizzed(vector WhizLocation, byte WhizType)
{
    if (WhizType != 0)
    {
        PawnWhizzed(WhizLocation, int(WhizType));
    }
}

// Emptied out to prevent playing old whiz sounds over the top of the new
// Matt: this event is called by native code when net client receives a changed replicated value of SpawnWhizCount,
// but should no longer be called as I've stopped PawnWhizzed from replicating whiz variables
simulated event HandleWhizSound()
{
}

// Modified so player pawn's AuxCollisionCylinder (the bullet whip attachment) only retains its collision if player is entering a VehicleWeaponPawn in an exposed position
// Matt: part of new vehicle occupant hit detection system, which basically keeps normal hit detection as for an infantry player pawn, if the player is exposed
// Also so player's CullDistance isn't set to 5000 (83m) when in vehicle, as caused players to disappear at quite close ranges when often should be highly visible, e.g. AT gunner
// And some fixes where vehicle is replicating to net client, which may not have received all relevant actors yet (e.g. Driver, Gun)
// Flags for vehicle to attach Driver when it receives Gun, & stops DriveAnim overriding a correct driver anim just played by vehicle's SetPlayerPosition()
simulated event StartDriving(Vehicle V)
{
    local VehicleWeaponPawn WP;
    local int               i;

    DrivenVehicle = V;
    NetUpdateTime = Level.TimeSeconds - 1.0;
    AmbientSound = none;
    StopWeaponFiring();
    DeactivateSpawnProtection();

    // Move the driver into position & attach to vehicle
    ShouldCrouch(false);
    ShouldProne(false);
    bIgnoreForces = true;
    Velocity = vect(0.0, 0.0, 0.0);
    Acceleration = vect(0.0, 0.0, 0.0);
    bCanTeleport = false;

    if (!V.bRemoteControlled || V.bHideRemoteDriver)
    {
        SetCollision(false, false);
        bCollideWorld = false;

        // If vehicle just replicated to net client & it doesn't yet have the necessary actor to attach to, tell vehicle it needs to attach Driver when it receives relevant actor
        // VehicleWeapon (Gun) actor is needed by most VehicleWeaponPawns, but rider pawns need the VehicleBase to attach to
        if (Role < ROLE_Authority)
        {
            WP = VehicleWeaponPawn(V);
        }

        if (WP != none && ((WP.Gun == none && WP.GunClass != none) || (WP.GunClass == none && WP.VehicleBase == none)))
        {
            bNeedToAttachDriver = true;
        }
        else
        {
            V.AttachDriver(self);
            bNeedToAttachDriver = false;
        }

        if (V.bDrawDriverinTP)
        {
//          CullDistance = 5000.0;
        }
        else
        {
            bHidden = true;
        }
    }

    // Set animation
    bPhysicsAnimUpdate = false;
    bWaitForAnim = false;

    // Play initial driver animation
    if (V.bDrawDriverinTP && !V.bHideRemoteDriver && HasAnim(V.DriveAnim))
    {
        // If vehicle has just replicated to net client, playing DriveAnim may override a correct driver anim just played by vehicle's SetPlayerPosition() function
        // So if bClientSkipDriveAnim is flagged & we haven't already played DriveAnim, we avoid playing DriveAnim now (but reset the flag so it's only this 1st time)
        if (Role < ROLE_Authority && bClientSkipDriveAnim)
        {
            bClientSkipDriveAnim = false;
        }
        else
        {
            LoopAnim(V.DriveAnim);
            SetAnimFrame(0.5);
            SmoothViewYaw = Rotation.Yaw;
            SetTwistLook(0, 0);

            if (Role < ROLE_Authority && !bClientPlayedDriveAnim)
            {
                bClientPlayedDriveAnim = true;
            }
        }
    }

    if (PlayerShadow != none)
    {
        PlayerShadow.bShadowActive = false;
    }

    if (WeaponAttachment != none)
    {
        WeaponAttachment.Hide(true);
    }

    // Hack for sticky grenades
    for (i = 0; i < Attached.Length; ++i)
    {
        if (Projectile(Attached[i]) != none)
        {
            Attached[i].SetBase(none);
        }
    }

    // Either keep or disable collision for player pawn's AuxCollisionCylinder (the bullet whip attachment)
    // Only keep it if the vehicle is set to bKeepDriverAuxCollision & the player is in an exposed position
    ToggleAuxCollision(V.bKeepDriverAuxCollision && InExposedVehiclePosition(V));

    if (Weapon != none)
    {
        if (ROWeapon(Weapon) != none)
        {
            ROWeapon(Weapon).GotoState('Idle');
        }

        Weapon.NotifyOwnerJumped();
    }
}

// New function to determine whether player occupying a vehicle (including a VehicleWeaponPawn) is exposed & can be hit
simulated function bool InExposedVehiclePosition(Vehicle V)
{
    local ROVehicleWeaponPawn VWP;
    local ROVehicle           Veh;

    VWP = ROVehicleWeaponPawn(V);

    if (VWP != none)
    {
        return VWP.bSinglePositionExposed || (VWP.bMultiPosition && VWP.DriverPositions[VWP.DriverPositionIndex].bExposed);
    }

    Veh = ROVehicle(V);

    return Veh != none && Veh.DriverPositions[Veh.DriverPositionIndex].bExposed;
}

// Modified to avoid restoring collision to players who have exited vehicle because they have been killed (otherwise their collision makes the vehicle jump around)
// Also so exiting into a shallow water volume doesn't send player into swimming state
simulated function StopDriving(Vehicle V)
{
    if (Role == ROLE_Authority && IsHumanControlled() && V != none)
    {
        V.PlayerStartTime = Level.TimeSeconds + 12.0;
    }

    CullDistance = default.CullDistance;
    NetUpdateTime = Level.TimeSeconds - 1.0;

    if (V != none && V.Weapon != none)
    {
        V.Weapon.ImmediateStopFire();
    }

    if (Physics == PHYS_Karma)
    {
        return;
    }

    DrivenVehicle = none;
    bIgnoreForces = false;
    bHardAttach = false;
    bWaitForAnim = false;
    bCanTeleport = true;

    if (Health > 0) // added Health check so we don't restore collision for dead player
    {
        bCollideWorld = true;
    }

    PlayWaiting();

    if (V != none)
    {
        V.DetachDriver(self);
    }

    bPhysicsAnimUpdate = default.bPhysicsAnimUpdate;

    if (Health > 0) // added Health check so we don't restore collision for dead player
    {
        SetCollision(true, true);
    }

    if (Role == ROLE_Authority && Health > 0 && (V == none || !V.bRemoteControlled || V.bHideRemoteDriver))
    {
        Acceleration = vect(0.0, 0.0, 24000.0);

        if (PhysicsVolume != none && PhysicsVolume.bWaterVolume && !(PhysicsVolume.IsA('DHWaterVolume') && DHWaterVolume(PhysicsVolume).bIsShallowWater))
        {
            SetPhysics(PHYS_Swimming); // exiting into shallow water volume doesn't send player into swimming state
        }
        else
        {
            SetPhysics(PHYS_Falling);
        }

        SetBase(none);
        bHidden = false;
    }

    bOwnerNoSee = default.bOwnerNoSee;

    if (Weapon != none)
    {
        PendingWeapon = none;
        Weapon.BringUp();
    }

    if (PlayerShadow != none)
    {
        PlayerShadow.bShadowActive = true;
    }

    if (WeaponAttachment != none)
    {
        WeaponAttachment.Hide(false);
    }

    ToggleAuxCollision(true);
    SetAnimAction('ClearAnims');
}

// Modified to deprecate SavedAuxCollision & simply enable or disable collision based on passed bool
simulated function ToggleAuxCollision(bool bEnabled)
{
    if (AuxCollisionCylinder != none)
    {
        AuxCollisionCylinder.SetCollision(bEnabled, false);
    }
}

// Added bullet impact sounds for helmets and players
// MergeTODO: Replace this with realistic gibbing
simulated function ProcessHitFX()
{
    local Coords BoneCoords;
    local int    j;
    local float  GibPerterbation;

    if (Level.NetMode == NM_DedicatedServer)
    {
        SimHitFxTicker = HitFxTicker;

        return;
    }

    for (SimHitFxTicker = SimHitFxTicker; SimHitFxTicker != HitFxTicker; SimHitFxTicker = (SimHitFxTicker + 1) % arraycount(HitFX))
    {
        j++;

        if (j > 30)
        {
            SimHitFxTicker = HitFxTicker;

            return;
        }

        if (HitFX[SimHitFxTicker].damtype == none || (Level.bDropDetail && (Level.TimeSeconds - LastRenderTime > 3) && !IsHumanControlled()))
        {
            continue;
        }

        if (HitFX[SimHitFxTicker].Bone == 'obliterate' && !class'GameInfo'.static.UseLowGore())
        {
            SpawnGibs(HitFX[SimHitFxTicker].rotDir, 0.0);
            bGibbed = true;
            Destroy();

            return;
        }

        BoneCoords = GetBoneCoords(HitFX[SimHitFxTicker].Bone);

        if (!Level.bDropDetail && !class'GameInfo'.static.NoBlood())
        {
            AttachEffect(BleedingEmitterClass, HitFX[SimHitFxTicker].Bone, BoneCoords.Origin, HitFX[SimHitFxTicker].rotDir);
        }

        if (class'GameInfo'.static.UseLowGore())
        {
            HitFX[SimHitFxTicker].bSever = false;
        }

        if (HitFX[SimHitFxTicker].bSever)
        {
            GibPerterbation = HitFX[SimHitFxTicker].damtype.default.GibPerterbation;

            switch (HitFX[SimHitFxTicker].Bone)
            {
                case 'obliterate':
                    break;

                case 'lthigh':
                case 'lupperthigh':
                    if (!bLeftLegGibbed)
                    {
                        SpawnGiblet(DetachedLegClass, BoneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation);
                        bLeftLegGibbed = true;
                    }
                    break;

                case 'rthigh':
                case 'rupperthigh':
                    if (!bRightLegGibbed)
                    {
                        SpawnGiblet(DetachedLegClass, BoneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation);
                        bRightLegGibbed = true;
                    }
                    break;

                case 'lfarm':
                case 'lupperarm':
                    if (!bLeftArmGibbed)
                    {
                        SpawnGiblet(DetachedArmClass, BoneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation);
                        bLeftArmGibbed = true;
                    }
                    break;

                case 'rfarm':
                case 'rupperarm':
                    if (!bRightArmGibbed)
                    {
                        SpawnGiblet(DetachedArmClass, BoneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation);
                        bRightArmGibbed = true;
                    }
                    break;
            }

            if (HitFX[SimHitFXTicker].Bone != 'Spine' && HitFX[SimHitFXTicker].Bone != 'UpperSpine')
            {
                HideBone(HitFX[SimHitFxTicker].Bone);
            }
        }

        if (HitFX[SimHitFXTicker].Bone == 'head' && Headgear != none)
        {
            if (DHHeadgear(HeadGear).bIsHelmet)
            {
                if (HitDamageType != none && HitDamageType.default.HumanObliterationThreshhold == 1000001)
                {
                    DHHeadgear(HeadGear).PlaySound(HelmetHitSounds[Rand(HelmetHitSounds.Length)], SLOT_None, 2.0,, 8,, true);
                }
                else
                {
                    DHHeadgear(HeadGear).PlaySound(HelmetHitSounds[Rand(HelmetHitSounds.Length)], SLOT_None, RandRange(100.0, 150.0),, 80,, true);
                }
            }

            HelmetShotOff(HitFX[SimHitFxTicker].rotDir);
        }
    }
}

// Modified to add extra effects if certain body parts are hit (chest or head), to play a hit sound, & to remove duplicated calls to TakeDamage()
function ProcessLocationalDamage(int Damage, Pawn InstigatedBy, vector hitlocation, vector Momentum, class<DamageType> DamageType, array<int> PointsHit)
{
    local EPawnHitPointType HitPointType;
    local vector            HitDirection;
    local int               OriginalDamage, BodyPartDamage, CumulativeDamage, HighestDamageAmount, HighestDamagePoint, i;

    // If someone else has killed this player, return
    if (bDeleteMe || Health <= 0 || PointsHit.Length < 1)
    {
        return;
    }

    OriginalDamage = Damage;

    // Loop through array of body parts that have been hit
    for (i = 0; i < PointsHit.Length; ++i)
    {
        // Calculate damage to this body part
        BodyPartDamage = OriginalDamage * Hitpoints[PointsHit[i]].DamageMultiplier;
        BodyPartDamage = Level.Game.ReduceDamage(BodyPartDamage, self, InstigatedBy, HitLocation, Momentum, DamageType);

        if (BodyPartDamage < 1)
        {
            continue;
        }

        // Update the locational damage list & record if damage to this body part is the highest damage yet
        UpdateDamageList(PointsHit[i] - 1);

        if (BodyPartDamage > HighestDamageAmount)
        {
            HighestDamageAmount = BodyPartDamage;
            HighestDamagePoint = PointsHit[i];
        }

        // Update cumulative damage & break out of the for loop if it's enough to kill the player
        CumulativeDamage += BodyPartDamage;

        if (CumulativeDamage >= Health)
        {
            break;
        }

        HitPointType = Hitpoints[PointsHit[i]].HitPointType;

        // If we've been shot in the foot or leg & are sprinting, we fall to the ground & are winded (zero stamina)
        if (HitPointType == PHP_Leg || HitPointType == PHP_Foot)
        {
            if (bIsSprinting && !bIsCrawling && DHPlayer(Controller) != none)
            {
                Stamina = 0.0;
                ClientForceStaminaUpdate(Stamina);
                DHPlayer(Controller).ClientProne();
            }
        }
        // If we've been shot in the hand, we have a chance of dropping our weapon
        else if (HitPointType == PHP_Hand && FRand() > 0.5)
        {
            if (DHPlayer(Controller) != none && ROTeamGame(Level.Game) != none && ROTeamGame(Level.Game).FriendlyFireScale > 0.0 && !InGodMode())
            {
                DHPlayer(Controller).ThrowWeapon();
                ReceiveLocalizedMessage(class'ROWeaponLostMessage');
            }
        }
        // If we've been shot in the head, our vision is jarred
        else if (HitPointType == PHP_Head)
        {
            if (DHPlayer(Controller) != none && ROTeamGame(Level.Game) != none && ROTeamGame(Level.Game).FriendlyFireScale > 0.0 && !InGodMode())
            {
                HitDirection = Location - HitLocation;
                HitDirection.Z = 0.0;
                HitDirection = normal(HitDirection);

                DHPlayer(Controller).PlayerJarred(HitDirection, 15.0);
            }
        }
        // If we've been shot in the chest, we're winded (lose half stamina) - Basnett
        else if (HitPointType == PHP_Torso)
        {
            if (IsHumanControlled() && ROTeamGame(Level.Game) != none && ROTeamGame(Level.Game).FriendlyFireScale > 0.0 && !InGodMode())
            {
                Stamina = 0.0;
                StaminaRecoveryRate /= 2.0;
                ClientForceStaminaUpdate(Stamina);
            }
        }
    }

    // Damage the player & play hit sound (but make sure no one else has killed this player)
    if (CumulativeDamage > 0 && !bDeleteMe && Health > 0)
    {
        if (DamageType.default.HumanObliterationThreshhold != 1000001)
        {
            PlaySound(PlayerHitSounds[Rand(PlayerHitSounds.Length)], SLOT_None, 100.0,, 15.0);
        }

        HitDamageType = DamageType;
        TakeDamage(CumulativeDamage, InstigatedBy, hitlocation, Momentum, DamageType, HighestDamagePoint);
    }
}

// Handle locational damage
// MergeTODO: this function needs some work
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    local int        ActualDamage;
    local Controller Killer;
    local DarkestHourGame G;
    local DHGameReplicationInfo GRI;
    local int RoundTime;

    if (DamageType == none)
    {
        if (InstigatedBy != none)
        {
            Warn("No DamageType for damage by" @ Instigatedby @ "with weapon" @ InstigatedBy.Weapon);
        }

        DamageType = class'DamageType';
    }

    if (Role < ROLE_Authority || Health <= 0)
    {
        return;
    }

    if ((InstigatedBy == none || InstigatedBy.Controller == none) && DamageType.default.bDelayedDamage && DelayedDamageInstigatorController != none)
    {
        InstigatedBy = DelayedDamageInstigatorController.Pawn;
    }

    if (Physics == PHYS_None && DrivenVehicle == none)
    {
        SetMovementPhysics();
    }

    if (Physics == PHYS_Walking && DamageType.default.bExtraMomentumZ)
    {
        Momentum.Z = FMax(Momentum.Z, 0.4 * VSize(Momentum));
    }

    if (InstigatedBy == self)
    {
        Momentum *= 0.6;
    }

    Momentum = Momentum / Mass;

    if (Weapon != none)
    {
        Weapon.AdjustPlayerDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
    }

    if (DrivenVehicle != none)
    {
        DrivenVehicle.AdjustDriverDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
    }

    ActualDamage = Level.Game.ReduceDamage(Damage, self, InstigatedBy, HitLocation, Momentum, DamageType);

    if (ActualDamage > 0 && DamageType.Name == 'Fell' || DamageType.Name == 'DHExitMovingVehicleDamageType')
    {
        if (!bIsCrawling && !bIsCrouched && DHPlayer(Controller) != none)
        {
            Stamina = 0.0;
            ClientForceStaminaUpdate(Stamina);
            DHPlayer(Controller).ClientProne();
        }

        SetLimping(FMin(ActualDamage / 5.0, 10.0));
    }
    else if (DamageType.Name == 'DHBurningDamageType') // || (DamageType.Name == 'DH_Whatever') // This is for later - Ch!cken
    {
        if (ActualDamage <= 0 && bOnFire)
        {
            bOnFire = false;
        }
        else
        {
            bOnFire = true;

            FireDamage = Damage;
            FireDamageClass = DamageType;
            FireStarter = InstigatedBy;
            LastBurnTime = Level.TimeSeconds;
        }
    }
    else if (DamageType.Name == 'DamTypeVehicleExplosion')
    {
        if (ActualDamage <= 0 && bOnFire)
        {
            bOnFire = false;
        }
        else
        {
            bOnFire = true;

            FireDamage = Damage;
            FireDamageClass = DamageType;
            FireStarter = InstigatedBy;
            LastBurnTime = Level.TimeSeconds;
        }
    }

    Health -= ActualDamage;

    if (HitLocation == vect(0.0, 0.0, 0.0))
    {
        HitLocation = Location;
    }

    LastHitIndex = HitIndex;

    PlayHit(ActualDamage, InstigatedBy, HitLocation, DamageType, Momentum, HitIndex);

    if (Health <= 0)
    {
        if (bOnFire)
        {
            BurnTimeLeft = 10;
            SetTimer(1.0, false);

            if (DHBurningPlayerFlame(FlameFX) != none)
            {
                DHBurningPlayerFlame(FlameFX).PlayerDied();
            }
        }

        // Pawn died
        if (DamageType.default.bCausedByWorld && (InstigatedBy == none || InstigatedBy == self) && LastHitBy != none)
        {
            Killer = LastHitBy;
        }
        else if (InstigatedBy != none)
        {
            Killer = InstigatedBy.GetKillerController();
        }

        if (Killer == none && DamageType.default.bDelayedDamage)
        {
            Killer = DelayedDamageInstigatorController;
        }

        if (bPhysicsAnimUpdate && !DamageType.default.bRagdollBullet)
        {
            SetTearOffMomemtum(Momentum);
        }

        G = DarkestHourGame(Level.Game);

        if (G != none && G.Metrics != none)
        {
            GRI = DHGameReplicationInfo(G.GameReplicationInfo);

            if (GRI != none)
            {
                RoundTime = GRI.ElapsedTime - GRI.RoundStartTime;
            }

            G.Metrics.OnPlayerFragged(PlayerController(Killer), PlayerController(Controller), DamageType, HitLocation, HitIndex, RoundTime);
        }

        Died(Killer, DamageType, HitLocation);
    }
    else
    {
        AddVelocity(Momentum);

        if (Controller != none)
        {
            Controller.NotifyTakeHit(InstigatedBy, HitLocation, ActualDamage, DamageType, Momentum);
        }

        if (InstigatedBy != none && InstigatedBy != self)
        {
            LastHitBy = InstigatedBy.Controller;
        }
    }

    MakeNoise(1.0);

    // Force cancellation of mantling
    if (bIsMantling)
    {
        CancelMantle();
        DHPlayer(Controller).GotoState('PlayerWalking');
        DHPlayer(Controller).SetTimer(0.0, false);
    }
}

// Handle ammo resupply
function TossAmmo(Pawn Gunner)
{
    local DarkestHourGame G;
    local DHGameReplicationInfo GRI;
    local DHWeapon W;

    if (bUsedCarriedMGAmmo || Gunner == none || GetTeamNum() != Gunner.GetTeamNum())
    {
        return;
    }

    G = DarkestHourGame(Level.Game);
    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);
    W = DHWeapon(Gunner.Weapon);

    if (W == none || !W.ResupplyAmmo())
    {
        return;
    }

    bUsedCarriedMGAmmo = true;

    if (DarkestHourGame(Level.Game) != none && Controller != none && Gunner.Controller != none)
    {
        Gunner.ReceiveLocalizedMessage(class'DHResupplyMessage', 1, Controller.PlayerReplicationInfo); // notification message to gunner
        ReceiveLocalizedMessage(class'DHResupplyMessage', 0, Gunner.Controller.PlayerReplicationInfo); // notification message to supplier

        if (GRI != none &&
            Gunner.Controller != none &&
            Gunner.Controller.PlayerReplicationInfo != none)
        {
            GRI.RemoveMGResupplyRequestFor(Gunner.Controller.PlayerReplicationInfo);
        }

        if (G != none)
        {
            G.ScoreMGResupply(Controller, Gunner.Controller);
        }
    }

    PlayOwnedSound(sound'Inf_Weapons_Foley.ammogive', SLOT_Interact, 1.75,, 10.0);
}

function TossMortarAmmo(DHPawn P)
{
    local DarkestHourGame G;
    local DHGameReplicationInfo GRI;

    if (bUsedCarriedMGAmmo || P == none || !P.ResupplyMortarAmmunition())
    {
        return;
    }

    bUsedCarriedMGAmmo = true;

    G = DarkestHourGame(Level.Game);
    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (Controller != none && P.Controller != none)
    {
        // notification message to gunner
        P.ReceiveLocalizedMessage(class'DHResupplyMessage', 1, Controller.PlayerReplicationInfo);

        // notification message to supplier
        ReceiveLocalizedMessage(class'DHResupplyMessage', 0, P.Controller.PlayerReplicationInfo);

        if (GRI != none) // remove any resupply request
        {
            GRI.RemoveMGResupplyRequestFor(P.Controller.PlayerReplicationInfo);
        }

        G.ScoreMortarResupply(Controller, P.Controller);
    }

    PlayOwnedSound(sound'Inf_Weapons_Foley.ammogive', SLOT_Interact, 1.75,, 10.0);
}

function TossMortarVehicleAmmo(DHMortarVehicle V)
{
    local DarkestHourGame  G;
    local DHGameReplicationInfo GRI;
    local PlayerController Recipient;

    if (V == none || Controller == none || bUsedCarriedMGAmmo || !ResupplyMortarVehicleWeapon(V))
    {
        return;
    }

    bUsedCarriedMGAmmo = true;

    G = DarkestHourGame(Level.Game);
    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (V.WeaponPawns.Length > 0 && V.WeaponPawns[0] != none)
    {
        Recipient = PlayerController(V.WeaponPawns[0].Controller);
    }

    if (Recipient != none)
    {
        // "You have resupplied {0}"
        ReceiveLocalizedMessage(class'DHResupplyMessage', 0, Recipient.PlayerReplicationInfo);

        // "You have been resupplied by {0}"
        Recipient.ReceiveLocalizedMessage(class'DHResupplyMessage', 1, Controller.PlayerReplicationInfo);

        if (GRI != none)
        {
            // Remove any resupply request
            GRI.RemoveMGResupplyRequestFor(Recipient.PlayerReplicationInfo);
        }
    }
    else
    {
        // "You have resupplied a friendly mortar"
        ReceiveLocalizedMessage(class'DHResupplyMessage', 2);
    }

    if (G != none)
    {
        G.ScoreMortarResupply(Controller, Recipient);
    }

    PlayOwnedSound(sound'Inf_Weapons_Foley.ammogive', SLOT_Interact, 1.75,, 10.0);
}

function bool ResupplyMortarVehicleWeapon(DHMortarVehicle V)
{
    if (V != none || DHMortarVehicleWeaponPawn(V.WeaponPawns[0]) != none)
    {
        return V.WeaponPawns[0].ResupplyAmmo();
    }

    return false;
}

// Handle assisted reload
function LoadWeapon(Pawn Gunner)
{
    local DHWeapon W;
    local DarkestHourGame G;

    if (Gunner == none)
    {
        return;
    }

    W = DHWeapon(Gunner.Weapon);
    G = DarkestHourGame(Level.Game);

    // Can reload the other player (AssistedReload returns true if was successful)
    if (W != none && W.AssistedReload())
    {
        if (Controller != none && Gunner.Controller != none)
        {
            Gunner.ReceiveLocalizedMessage(class'DHATLoadMessage', 1, Controller.PlayerReplicationInfo); // notification message to recipient (been reloaded by [player])
            ReceiveLocalizedMessage(class'DHATLoadMessage', 0, Gunner.Controller.PlayerReplicationInfo); // notification message to loader (you loaded [player])

            if (G != none)
            {
                G.ScoreATReload(Controller, Gunner.Controller);
            }
        }

        PlayOwnedSound(sound'Inf_Weapons_Foley.ammogive', SLOT_Interact, 1.75,, 10.0);
    }
    // Notify loader of failed attempt
    else
    {
        ReceiveLocalizedMessage(class'DHATLoadFailMessage', 0, Gunner.Controller.PlayerReplicationInfo);
    }
}

// Modified to avoid cast to deprecated ROProjectileWeapon (base class DHWeapon extends ROWeapon & bypasses ROProjectileWeapon)
// Also re-factored slightly to optimise
simulated function SetWeaponAttachment(ROWeaponAttachment NewAtt)
{
    WeaponAttachment = NewAtt;

    if (WeaponAttachment != none)
    {
        if (!bInitializedWeaponAttachment)
        {
            bInitializedWeaponAttachment = true;
        }

        if (Weapon != none) // cast is unnecessary as bBayonetMounted is in the base Weapon class
        {
            WeaponAttachment.bBayonetAttached = Weapon.bBayonetMounted;
        }

        WeaponAttachment.AnimEnd(0);
    }
}

// Handles the stamina calculations and sprinting functionality
// Modified to prevent stamina recharging during a mantle - Ch!cKeN
function HandleStamina(float DeltaTime)
{
    local byte NewBreathSound;

    // Prone
    if (bIsCrawling)
    {
        if (Stamina < default.Stamina && Acceleration == vect(0.0, 0.0, 0.0))
        {
            Stamina = FMin(default.Stamina, Stamina + (DeltaTime * ProneStaminaRecoveryRate));
        }
        else
        {
            Stamina = FMin(default.Stamina, Stamina + (DeltaTime * SlowStaminaRecoveryRate));
        }
    }
    else
    {
        if (bIsSprinting || bIsMantling)
        {
            if (bIsCrouched)
            {
                Stamina = FMax(0.0, Stamina - (DeltaTime * 1.25));
            }
            else
            {
                Stamina = FMax(0.0, Stamina - DeltaTime);
            }
        }
        else if (bIsMantling && (Physics == PHYS_RootMotion || Physics == PHYS_Flying))
        {
            Stamina = FMax(0.0, Stamina - DeltaTime * 1.15);
        }
        else
        {
            if (Stamina < default.Stamina && !bIsWalking && !bIsCrouched && VSizeSquared(Velocity) > 0.0)
            {
                Stamina = FMin(default.Stamina, Stamina + (DeltaTime * SlowStaminaRecoveryRate));
            }
            else
            {
                if (bIsCrouched)
                {
                    Stamina = FMin(default.Stamina, Stamina + (DeltaTime * CrouchStaminaRecoveryRate));
                }
                else
                {
                    Stamina = FMin(default.Stamina, Stamina + (DeltaTime * StaminaRecoveryRate));
                }
             }
        }
    }

    // Only set this flag on the server
    if (Level.NetMode != NM_Client)
    {
        bCanStartSprint = Stamina > 2.0;
    }

    if (Stamina == 0.0 || Acceleration == vect(0.0, 0.0, 0.0))
    {
        SetSprinting(false);
    }

    // Stamina sound handling. Sets the ambient breathing sound based on stamina level
    if (Level.NetMode != NM_Client)
    {
        if (Health > 0 && Stamina < 10.0)
        {
            if (Stamina <= 2.0)
            {
                NewBreathSound = 1;
            }
            else if (Stamina < 5.0)
            {
                NewBreathSound = 2;
            }
            else if (Stamina < 7.5)
            {
                NewBreathSound = 3;
            }
            else
            {
                NewBreathSound = 4;
            }
        }
        else
        {
            NewBreathSound = 5;
        }

        if (SavedBreathSound != NewBreathSound)
        {
            SetBreathingSound(NewBreathSound);
        }
    }
}

state Dying
{
    simulated function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
    {
        local vector SelfToHit, SelfToInstigator, CrossPlaneNormal, HitNormal, ShotDir, PushLinVel, PushAngVel;
        local float  W, YawDir, HitBoneDist;
        local int    MaxCorpseYawRate;
        local name   HitBone;

        if (DamageType == none)
        {
            return;
        }

        if (Physics == PHYS_KarmaRagdoll)
        {
            // Can't shoot corpses during de-res
            if (bDeRes)
            {
                return;
            }

            // Throw the body if its a rocket explosion or shock combo
            if (DamageType.Name == 'ROSMineDamType' || DamageType.Name == 'DH_StielGranateDamType' || DamageType.Name == 'ROMineDamType' || DamageType.Name == 'DH_M1GrenadeDamType')
            {
                ShotDir = Normal(Momentum);
                PushLinVel = (RagDeathVel * ShotDir) +  vect(0.0, 0.0, 250.0);
                PushAngVel = Normal(ShotDir cross vect(0.0, 0.0, 1.0)) * -18000.0;
                KSetSkelVel(PushLinVel, PushAngVel);
            }
            else if (DamageType.default.bRagdollBullet)
            {
                if (Momentum == vect(0.0, 0.0, 0.0))
                {
                    Momentum = HitLocation - InstigatedBy.Location;
                }

                if (FRand() < 0.65)
                {
                    if (Velocity.Z <= 0.0)
                    {
                        PushLinVel = vect(0.0, 0.0, 40.0);
                    }

                    PushAngVel = Normal(Normal(Momentum) cross vect(0.0, 0.0, 1.0)) * -8000.0;
                    PushAngVel.X *= 0.5;
                    PushAngVel.Y *= 0.5;
                    PushAngVel.Z *= 4;

                    KSetSkelVel(PushLinVel, PushAngVel);
                }

                PushLinVel = RagShootStrength*Normal(Momentum);
                KAddImpulse(PushLinVel, HitLocation);

                if (LifeSpan > 0.0 && LifeSpan < (DeResTime + 2.0))
                {
                    LifeSpan += 0.2;
                }
            }
            else if (DamageType.Name == 'DHBurningDamageType')
            {
                if (!bOnFire)
                {
                    bOnFire = true;
                }

                BurnTimeLeft = 10;

                SetTimer(1.0, false);
            }
            else
            {
                PushLinVel = RagShootStrength * Normal(Momentum);
                KAddImpulse(PushLinVel, HitLocation);
            }

            if (DamageType.default.DamageOverlayMaterial != none && Level.DetailMode != DM_Low && !Level.bDropDetail && !bOnFire)
            {
                SetOverlayMaterial(DamageType.default.DamageOverlayMaterial, DamageType.default.DamageOverlayTime, true);
            }

            return;
        }

        if (Damage > 0)
        {
            if (InstigatedBy != none)
            {
                // Figure out which direction to spin
                if (InstigatedBy.Location != Location)
                {
                    SelfToInstigator = InstigatedBy.Location - Location;
                    SelfToHit = HitLocation - Location;

                    CrossPlaneNormal = Normal(SelfToInstigator cross vect(0.0, 0.0, 1.0));
                    W = CrossPlaneNormal dot Location;

                    if (HitLocation dot CrossPlaneNormal < W)
                    {
                        YawDir = -1.0;
                    }
                    else
                    {
                        YawDir = 1.0;
                    }
                }
            }

            if (VSizeSquared(Momentum) < 100.0) // Matt: was (VSize(Momentum) < 10.0) but it's more efficient to use VSizeSquared < 100
            {
                Momentum = - Normal(SelfToInstigator) * Damage * 1000.0;
                Momentum.Z = Abs(Momentum.Z);
            }

            SetPhysics(PHYS_Falling);

            Momentum = Momentum / Mass;
            AddVelocity(Momentum);
            bBounce = true;

            RotationRate.Pitch = 0;
            RotationRate.Yaw += VSize(Momentum) * YawDir;

            MaxCorpseYawRate = 150000;
            RotationRate.Yaw = Clamp(RotationRate.Yaw, -MaxCorpseYawRate, MaxCorpseYawRate);
            RotationRate.Roll = 0;

            bFixedRotationDir = true;
            bRotateToDesired = false;

            Health -= Damage;
            CalcHitLoc(HitLocation, vect(0.0, 0.0, 0.0), HitBone, HitBoneDist);

            if (InstigatedBy != none)
            {
                HitNormal = Normal(Normal(InstigatedBy.Location - HitLocation) + VRand() * 0.2 + vect(0.0, 0.0, 2.8));
            }
            else
            {
                HitNormal = Normal(vect(0.0, 0.0, 1.0) + VRand() * 0.2 + vect(0.0, 0.0, 2.8));
            }

            DoDamageFX(HitBone, Damage, DamageType, rotator(HitNormal));
        }
    }

    function Timer()
    {
        local int i;

        if (BurnTimeLeft > 5)
        {
            BurnTimeLeft--;

            SetTimer(1.0, false);
        }
        else if (BurnTimeLeft > 0)
        {
            if (OverlayMaterial != DeadBurningOverlayMaterial)
            {
                SetOverlayMaterial(DeadBurningOverlayMaterial, 999.0, true);

                for (i = 0; i < AmmoPouches.Length; ++i)
                {
                    AmmoPouches[i].SetOverlayMaterial(DeadBurningOverlayMaterial, 999.0, true);
                }
            }

            if (DHBurningPlayerFlame(FlameFX) != none)
            {
                DHBurningPlayerFlame(FlameFX).DouseFlames();
            }

            BurnTimeLeft--;

            SetTimer(1.0, false);
        }
        else if (bOnFire)
        {
            bOnFire = false;
        }

        super.Timer();
    }

Begin:
    Sleep(0.2);
    bInvulnerableBody = false;

    if (Level.Game != none && !Level.Game.bGameEnded) // needs != none check to avoid "accessed none" error on client (actor has been torn off so usual role authority check doesn't work)
    {
        PlayDyingSound();
    }
}

// Prevented damage overlay from overriding burning overlay
function PlayHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> DamageType, vector Momentum, optional int HitIndex)
{
    local PlayerController     PC;
    local ProjectileBloodSplat BloodHit;
    local vector  HitNormal;
    local name    HitBone;
    local float   HitBoneDist;
    local rotator SplatRot;
    local bool    bShowEffects, bRecentHit;

    bRecentHit = Level.TimeSeconds - LastPainTime < 0.2;

    // Call the modified version of the original Pawn playhit
    OldPlayHit(Damage, InstigatedBy, HitLocation, DamageType, Momentum);

    if (Damage <= 0)
    {
        return;
    }

    PC = PlayerController(Controller);

    bShowEffects = Level.NetMode != NM_Standalone || (Level.TimeSeconds - LastRenderTime) < 2.5 || (InstigatedBy != none && PlayerController(InstigatedBy.Controller) != none) || PC != none;

    if (!bShowEffects)
    {
        return;
    }

    if (DamageType.default.bLocationalHit)
    {
        HitBone = GetHitBoneFromIndex(HitIndex);
        HitBoneDist = 0.0;
    }
    else
    {
        HitLocation = Location;
        HitBone = 'none';
        HitBoneDist = 0.0;
    }

    if (DamageType.default.bAlwaysSevers && DamageType.default.bSpecial)
    {
        HitBone = 'head';
    }

    if (InstigatedBy != none)
    {
        HitNormal = Normal(Normal(InstigatedBy.Location-HitLocation) + VRand() * 0.2 + vect(0.0, 0.0, 2.8));
    }
    else
    {
        HitNormal = Normal(vect(0.0, 0.0, 1.0) + VRand() * 0.2 + vect(0.0, 0.0, 2.8));
    }

    if (DamageType.default.bCausesBlood && (!bRecentHit || (bRecentHit && (FRand() > 0.8))))
    {
        if (!class'GameInfo'.static.NoBlood())
        {
            if (Momentum != vect(0.0, 0.0, 0.0))
            {
                SplatRot = rotator(Normal(Momentum));
            }
            else
            {
                if (InstigatedBy != none)
                {
                    SplatRot = rotator(Normal(Location - InstigatedBy.Location));
                }
                else
                {
                    SplatRot = rotator(Normal(Location - HitLocation));
                }
            }

            BloodHit = Spawn(ProjectileBloodSplatClass, InstigatedBy,, HitLocation, SplatRot);
        }
    }

    DoDamageFX(HitBone, Damage, DamageType, rotator(HitNormal));

    if (DamageType.default.DamageOverlayMaterial != none && Damage > 0 && !bOnFire)
    {
        SetOverlayMaterial(DamageType.default.DamageOverlayMaterial, DamageType.default.DamageOverlayTime, false);
    }
}

// Modified to fix UT2004 bug affecting non-owning net players in any vehicle with bPCRelativeFPRotation (nearly all), often causing effects to be skipped
// Vehicle's rotation was not being factored into calcs using the PlayerController's rotation, which effectively randomised the result of this function
// Also re-factored to make it a little more optimised, direct & easy to follow (without repeated use of bResult)
simulated function bool EffectIsRelevant(vector SpawnLocation, bool bForceDedicated)
{
    local PlayerController PC;

    // Only relevant on a dedicated server if the bForceDedicated option has been passed
    if (Level.NetMode == NM_DedicatedServer)
    {
        return bForceDedicated;
    }

    if (Role < ROLE_Authority)
    {
        // Always relevant for the owning net player
        if (Instigator != none && Instigator.IsHumanControlled())
        {
            return true;
        }

        // Not relevant to other net clients if the hit player has not been drawn on their screen recently (within last 3 seconds)
        if ((Level.TimeSeconds - LastRenderTime) >= 3.0)
        {
            return false;
        }
    }

    PC = Level.GetLocalPlayerController();

    if (PC == none || PC.ViewTarget == none)
    {
        return false;
    }

    // Check to see whether effect would spawn off to the side or behind where player is facing, & if so then only spawn if within quite close distance
    // Using PC's CalcViewRotation, which is the last recorded camera rotation, so a simple way of getting player's non-relative view rotation, even in vehicles
    // (doesn't apply to the hit player)
    if (PC.Pawn != Instigator && vector(PC.CalcViewRotation) dot (SpawnLocation - PC.ViewTarget.Location) < 0.0)
    {
        return VSizeSquared(PC.ViewTarget.Location - SpawnLocation) < 2560000.0; // equivalent to 1600 UU or 26.5m (changed to VSizeSquared as more efficient)
    }

    // Effect relevance is based on normal distance check
    return CheckMaxEffectDistance(PC, SpawnLocation);
}

// Overridden for our limited burning screams group
function PlayTakeHit(vector HitLocation, int Damage, class<DamageType> DamageType)
{
    local vector  Direction;
    local rotator InvRotation;
    local float   JarScale;

    if (Level.TimeSeconds - LastPainSound < MinTimeBetweenPainSounds)
    {
        return;
    }

    LastPainSound = Level.TimeSeconds;

    if (HeadVolume.bWaterVolume)
    {
        if (DamageType.IsA('Drowned'))
        {
            PlaySound(GetSound(EST_Drown), SLOT_Pain, 1.5 * TransientSoundVolume,, 10.0);
        }
        else
        {
            PlaySound(GetSound(EST_HitUnderwater), SLOT_Pain, 1.5 * TransientSoundVolume,, 10.0);
        }

        return;
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (class<ROWeaponDamageType>(DamageType) != none && class<ROWeaponDamageType>(DamageType).default.bCauseViewJarring && ROPlayer(Controller) != none)
        {
            // Get the approximate direction that the hit went into the body
            Direction = self.Location - HitLocation;

            // No up-down jarring effects since I don't have the barrel velocity
            Direction.Z = 0.0;
            Direction = Normal(Direction);

            // We need to rotate the jarring direction in screen space so basically the exact opposite of the player's pawn's rotation
            InvRotation.Yaw = -Rotation.Yaw;
            InvRotation.Roll = -Rotation.Roll;
            InvRotation.Pitch = -Rotation.Pitch;
            Direction = Direction >> InvRotation;

            JarScale = FMin(0.1 + (Damage / 50.0), 1.0);

            ROPlayer(Controller).PlayerJarred(Direction, JarScale);
       }
    }

    PlayOwnedSound(DHSoundGroupClass.static.GetHitSound(DamageType), SLOT_Pain, 3.0 * TransientSoundVolume,, RandRange(30, 90),, true);
}

// A few minor additions
// DH added removal of radioman arty triggers on death - PsYcH0_Ch!cKeN
function Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
    local vector          HitDirection;
    local Trigger         T;
    local NavigationPoint N;
    local float           DamageBeyondZero;
    local bool            bShouldGib;

    if (bDeleteMe || Level.bLevelChange || Level.Game == none)
    {
        return; // already destroyed, or level is being cleaned up
    }

    if (DamageType.default.bCausedByWorld && (Killer == none || Killer == Controller) && LastHitBy != none)
    {
        Killer = LastHitBy;
    }
    else if (bOnFire) // person who starts the fire always gets the credit
    {
        if (FireStarter != none)
        {
            Killer = FireStarter.Controller;
        }

        DamageType = FireDamageClass;
    }

    // Mutator hook to prevent deaths
    // WARNING - don't prevent bot suicides - they suicide when really needed
    if (Level.Game.PreventDeath(self, Killer, DamageType, HitLocation))
    {
        Health = Max(Health, 1); // mutator should set this higher

        return;
    }

    // Reset root bone if mantling when killed
    if (bIsMantling)
    {
        ResetRootBone();
    }

    // Turn off the auxiliary collision when the player dies
    if (AuxCollisionCylinder != none)
    {
        AuxCollisionCylinder.SetCollision(false, false);
    }

    DamageBeyondZero = Health;

    Health = Min(0, Health);

    // Fix for suicide death messages
    if (DamageType == class'Suicided')
    {
        DamageType = class'ROSuicided';
    }

    bShouldGib = DamageType != none && (DamageType.default.bAlwaysGibs || ((Abs(DamageBeyondZero) + default.Health) > DamageType.default.HumanObliterationThreshhold));

    // If the pawn has not been gibbed, is not in a vehicle, and has not been spawn killed
    if (!bShouldGib && DrivenVehicle == none && !IsSpawnKillProtected())
    {
        // Then drop weapons
        BurningDropWeaps();
    }

    DestroyRadioTrigger();

    if (OwnedMortar != none)
    {
        OwnedMortar.GotoState('PendingDestroy');
    }

    if (DrivenVehicle != none)
    {
        Velocity = DrivenVehicle.Velocity;
        DrivenVehicle.DriverDied();
    }

    if (Controller != none)
    {
        Controller.WasKilledBy(Killer);
        Level.Game.Killed(Killer, Controller, self, DamageType);
    }
    else
    {
        Level.Game.Killed(Killer, Controller(Owner), self, DamageType);
    }

    DrivenVehicle = none;

    if (Killer != none)
    {
        TriggerEvent(Event, self, Killer.Pawn);
    }
    else
    {
        TriggerEvent(Event, self, none);
    }

    // Make sure to untrigger any triggers requiring player touch
    if (IsPlayerPawn() || WasPlayerPawn())
    {
        PhysicsVolume.PlayerPawnDiedInVolume(self);

        foreach TouchingActors(class'Trigger', T)
        {
            T.PlayerToucherDied(self);
        }

        // Event for HoldObjectives
        foreach TouchingActors(class'NavigationPoint', N)
        {
            if (N.bReceivePlayerToucherDiedNotify)
            {
                N.PlayerToucherDied(self);
            }
        }
    }

    // Remove powerup effects, etc.
    RemovePowerups();

    Velocity.Z *= 1.3;

    if (IsHumanControlled())
    {
        PlayerController(Controller).ForceDeathUpdate();
    }

    if (DHPlayer(Controller) != none &&
        class<ROWeaponDamageType>(DamageType) != none &&
        class<ROWeaponDamageType>(DamageType).default.bCauseViewJarring)
    {
        HitDirection = Location - HitLocation;
        HitDirection.Z = 0.0;
        HitDirection = normal(HitDirection);

        DHPlayer(Controller).PlayerJarred(HitDirection, 3.0);
    }

    if (DamageType != none && DamageType.default.bAlwaysGibs && !class'GameInfo'.static.UseLowGore())
    {
        if (Level.NetMode == NM_DedicatedServer)
        {
           DoDamageFX('obliterate', 1010, class'RODiedInTankDamType', Rotation);
        }

        ChunkUp(Rotation, DamageType.default.GibPerterbation);
    }
    else if (DamageType != none && (Abs(DamageBeyondZero) + default.Health) > DamageType.default.HumanObliterationThreshhold && !class'GameInfo'.static.UseLowGore())
    {
        if (Level.NetMode == NM_DedicatedServer)
        {
           DoDamageFX('obliterate', 1010, class'RODiedInTankDamType', Rotation);
        }

        ChunkUp(rotator(GetTearOffMomemtum()), DamageType.default.GibPerterbation);
    }
    else
    {
        NetUpdateFrequency = default.NetUpdateFrequency;
        PlayDying(DamageType, HitLocation);

        if (Level.Game.bGameEnded)
        {
            return;
        }

        if (!bPhysicsAnimUpdate && !IsLocallyControlled())
        {
            ClientDying(DamageType, HitLocation);
        }
    }
}

// Stop damage overlay from overriding burning overlay if necessary
simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
    WeaponState = GS_None;

    if (IsHumanControlled())
    {
        PlayerController(Controller).bFreeCamera = false;
    }

    AmbientSound = none;
    bCanTeleport = false; // sjs - fix karma going crazy when corpses land on teleporters
    bReplicateMovement = false;
    bTearOff = true;
    bPlayedDeath = true;
    HitDamageType = DamageType; // these are replicated to other clients
    TakeHitLocation = HitLoc;

    if (DamageType != none && !bOnFire)
    {
        if (DamageType.default.DeathOverlayMaterial != none && !class'GameInfo'.static.UseLowGore())
        {
            SetOverlayMaterial(DamageType.default.DeathOverlayMaterial, DamageType.default.DeathOverlayTime, true);
        }
        else if ((DamageType.default.DamageOverlayMaterial != none) && (Level.DetailMode != DM_Low) && !Level.bDropDetail)
        {
            SetOverlayMaterial(DamageType.default.DamageOverlayMaterial, 2 * DamageType.default.DamageOverlayTime, true);
        }
    }

    // Stop shooting
    AnimBlendParams(1, 0.0);
    LifeSpan = RagdollLifeSpan;

    GotoState('Dying');

    PlayDyingAnimation(DamageType, HitLoc);
}

// Prevent damage overlay from overriding burnt overlay
simulated function DeadExplosionKarma(class<DamageType> DamageType, vector Momentum, float Strength)
{
    local vector ShotDir;
    local vector PushLinVel, PushAngVel;

    if ((RagdollLifeSpan - LifeSpan) < 1.0)
    {
        return;
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (class'GameInfo'.static.UseLowGore())
        {
            return;
        }

        if (DamageType != none && DamageType.default.bKUseOwnDeathVel)
        {
            RagDeathVel = DamageType.default.KDeathVel;
            RagDeathUpKick = DamageType.default.KDeathUpKick;
            RagShootStrength = DamageType.default.KDamageImpulse;
        }

        ShotDir = Normal(Momentum);
        PushLinVel = (RagDeathVel * ShotDir);
        PushLinVel.Z += RagDeathUpKick * (RagShootStrength * DamageType.default.KDeadLinZVelScale);

        PushAngVel = Normal(ShotDir cross vect(0.0, 0.0, 1.0)) * -18000.0;
        PushAngVel *= RagShootStrength * DamageType.default.KDeadAngVelScale;
        PushLinVel *= Strength;
        PushAngVel *= Strength;

        KSetSkelVel(PushLinVel, PushAngVel);

        if (DamageType.default.DeathOverlayMaterial != none && !bOnFire)
        {
            SetOverlayMaterial(DamageType.default.DeathOverlayMaterial, DamageType.default.DeathOverlayTime, true);
        }
    }
}

// The two functions below overridden to include specific fire kill commands
// Without these, premature Pawn DeRes can cause emitter to not destroy and results in a GPF crash
simulated function SpawnGibs(rotator HitRotation, float ChunkPerterbation)
{
    if (FlameFX != none)
    {
        FlameFX.Emitters[0].SkeletalMeshActor = none;
        FlameFX.Emitters[1].SkeletalMeshActor = none;
        FlameFX.Emitters[2].SkeletalMeshActor = none;
        FlameFX.Kill();
    }

    super.SpawnGibs(HitRotation, ChunkPerterbation);
}

simulated event Destroyed()
{
    if (FlameFX != none)
    {
        FlameFX.Emitters[0].SkeletalMeshActor = none;
        FlameFX.Emitters[1].SkeletalMeshActor = none;
        FlameFX.Emitters[2].SkeletalMeshActor = none;
        FlameFX.Kill();
    }

    super.Destroyed();
}

// Called by DH_GiveChuteTrigger, adds parachute items to player's inventory
singular function GiveChute()
{
    local RORoleInfo RI;
    local int        i;
    local string     ItemString;
    local bool       bHasPSL, bHasPI;

    if (DHPlayer(Controller) != none)
    {
        RI = DHPlayer(Controller).GetRoleInfo();
    }

    // Make sure player doesn't already have a parachute
    if (RI != none)
    {
        for (i = RI.GivenItems.Length - 1; i >= 0; --i)
        {
            ItemString = RI.GivenItems[i];

            if (ItemString == "DH_Equipment.DH_ParachuteStaticLine")
            {
                bHasPSL = true;
            }
            else if (ItemString == "DH_Equipment.DH_ParachuteItem")
            {
                bHasPI = true;
            }
        }
    }

    if (!bHasPSL)
    {
        GiveWeapon("DH_Equipment.DH_ParachuteStaticLine");
    }

    if (!bHasPI)
    {
        GiveWeapon("DH_Equipment.DH_ParachuteItem");
    }
}

// Destroys carried radio triggers and removes them from the minimap
function DestroyRadioTrigger()
{
    local DHGameReplicationInfo GRI;

    if (CarriedRadioTrigger == none)
    {
        return;
    }

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    GRI.RemoveCarriedRadioTrigger(CarriedRadioTrigger);

    CarriedRadioTrigger.Destroy();
}

// Modified to allow player to carry more than 1 type of grenade
// Also to add != "none" (string) checks before calling CreateInventory yo avoid calling GetInventoryClass("none") on base mutator & the log errors created each time a player spawns
function AddDefaultInventory()
{
    local DHPlayer   P;
    local DHBot      B;
    local RORoleInfo RI;
    local string     S;
    local int        i;

    if (Controller == none)
    {
        return;
    }

    P = DHPlayer(Controller);

    if (IsLocallyControlled())
    {
        if (P != none)
        {
            S = P.GetPrimaryWeapon();

            if (S != "None" && S != "")
            {
                CreateInventory(S);
            }

            S = P.GetSecondaryWeapon();

            if (S != "None" && S != "")
            {
                CreateInventory(S);
            }

            RI = P.GetRoleInfo();

            if (RI != none)
            {
                for (i = 0; i < arraycount(RI.Grenades); ++i)
                {
                    S = string(RI.Grenades[i].Item);

                    if (S != "None" && S != "")
                    {
                        CreateInventory(S);
                    }
                }

                for (i = 0; i < RI.GivenItems.Length; ++i)
                {
                    if (RI.GivenItems[i] != "")
                    {
                        CreateInventory(RI.GivenItems[i]);
                    }
                }
            }
        }
        else
        {
            B = DHBot(Controller);

            if (B != none)
            {
                S = B.GetPrimaryWeapon();

                if (S != "None" && S != "")
                {
                    CreateInventory(S);
                }

                S = B.GetSecondaryWeapon();

                if (S != "None" && S != "")
                {
                    CreateInventory(S);
                }

                RI = B.GetRoleInfo();

                if (RI != none)
                {
                    for (i = 0; i < RI.GivenItems.Length; ++i)
                    {
                        if (RI.GivenItems[i] != "")
                        {
                            CreateInventory(RI.GivenItems[i]);
                        }
                    }
                }
            }
        }

        Level.Game.AddGameSpecificInventory(self);
    }
    else
    {
        Level.Game.AddGameSpecificInventory(self);

        if (P != none)
        {
            RI = P.GetRoleInfo();

            if (RI != none)
            {
                for (i = RI.GivenItems.Length - 1; i >= 0; --i)
                {
                    if (RI.GivenItems[i] != "")
                    {
                        CreateInventory(RI.GivenItems[i]);
                    }
                }
            }

            for (i = 0; i < arraycount(RI.Grenades); ++i)
            {
                S = string(RI.Grenades[i].Item);

                if (S != "None" && S != "")
                {
                    CreateInventory(S);
                }
            }

            S = P.GetSecondaryWeapon();

            if (S != "None" && S != "")
            {
                CreateInventory(S);
            }

            S = P.GetPrimaryWeapon();

            if (S != "None" && S != "")
            {
                CreateInventory(S);
            }
        }
    }

    NetUpdateTime = Level.TimeSeconds - 1.0;

    if (Inventory != none)
    {
        Inventory.OwnerEvent('LoadOut');
    }

    if (Level.NetMode == NM_Standalone || (Level.NetMode == NM_ListenServer && IsLocallyControlled()))
    {
        bRecievedInitialLoadout = true;
        Controller.ClientSwitchToBestWeapon();
    }
}

// Modified to add != "none" check (in string format), which avoids calling GetInventoryClass("none") on the base mutator & the log errors that creates each time a player spawns
function CreateInventory(string InventoryClassName)
{
    if (InventoryClassName != "None" && InventoryClassName != "")
    {
        super.CreateInventory(InventoryClassName);
    }
}

// Modified to use DH weapon classes to determine the correct put away & draw animations (also to prevent "accessed none" errors on parachute landing)
state PutWeaponAway
{
    simulated function BeginState()
    {
        local name Anim;

        bPreventWeaponFire = true;

        // Put the weapon down on the server as well as the client
        if (Level.NetMode == NM_DedicatedServer && Weapon != none)
        {
            Weapon.PutDown();
        }

        // Select the proper animation to play based on what the player is holding
        // Weapon could be none because it might have been destroyed before getting here (nades, faust, etc)
        if (Weapon != none)
        {
            // Putting away a grenade or binoculars
            if (Weapon.IsA('DHExplosiveWeapon') || Weapon.IsA('DHBinocularsItem'))
            {
                if (bIsCrawling)
                {
                    Anim = 'prone_putaway_nade';
                }
                else
                {
                    Anim = 'stand_putaway_nade';
                }
            }
            // Putting away a pistol
            else if (Weapon.IsA('DHPistolWeapon'))
            {
                if (bIsCrawling)
                {
                    Anim = 'prone_putaway_pistol';
                }
                else
                {
                    Anim = 'stand_putaway_pistol';
                }
            }
        }

        // If no specific animation has been set, we'll use a generic anim for putting away the old weapon on the player's back
        if (Anim == '')
        {
            if (bIsCrawling)
            {
                Anim = 'prone_putaway_kar';
            }
            else
            {
                Anim = 'stand_putaway_kar';
            }
        }

        // Handle the inventory side of swapping the weapon, not the visual side
        SwapWeapon = Weapon;

        if (Weapon != none)
        {
            Weapon.GotoState('Hidden');

            if (Weapon != none) // necessary to prevent "accessed none" errors, as Weapon can become 'none' during GotoState above, e.g. when parachute landing
            {
                Weapon.NetUpdateFrequency = 2.0;
            }
        }

        Weapon = PendingWeapon;

        if (Controller != none)
        {
            Controller.ChangedWeapon();
        }

        PendingWeapon = none;

        if (Weapon != none)
        {
            Weapon.NetUpdateFrequency = 100.0;
            Weapon.AttachToPawnHidden(self);
            Weapon.BringUp(SwapWeapon);
        }

        if (DHExplosiveWeapon(Weapon) == none)
        {
            bPreventWeaponFire = false;
        }

        if (Inventory != none)
        {
            Inventory.OwnerEvent('ChangedWeapon'); // tell inventory that weapon changed (in case any effect was being applied)
        }

        SetTimer(GetAnimDuration(Anim, 1.0) + 0.1, false);

        SetAnimAction(Anim);
    }

    simulated function EndState()
    {
        local name Anim;

        if (SwapWeapon != none)
        {
            if (SwapWeapon.bCanAttachOnBack)
            {
                if (AttachedBackItem != none)
                {
                    AttachedBackItem.Destroy();
                    AttachedBackItem = none;
                }

                AttachedBackItem = Spawn(class 'BackAttachment', self);
                AttachedBackItem.InitFor(SwapWeapon);
                AttachToBone(AttachedBackItem, AttachedBackItem.AttachmentBone);
            }

            SwapWeapon.SetDefaultDisplayProperties();
            SwapWeapon.DetachFromPawn(self);
        }

        // Select the proper animation to play based on what the player is holding & what weapon they are switching to
        if (Weapon == none)
        {
            if (bIsCrawling)
            {
                Anim = 'prone_nadefromrifle';
            }
            else
            {
                Anim = 'stand_nadefromrifle';
            }
        }
        else if (SwapWeapon != none)
        {
            if (SwapWeapon.IsA('DHExplosiveWeapon') || SwapWeapon.IsA('DHBinocularsItem'))
            {
                // From grenade or binocs to pistol
                if (Weapon.IsA('DHPistolWeapon'))
                {
                    if (bIsCrawling)
                    {
                        Anim = 'prone_pistolfromnade';
                    }
                    else
                    {
                        Anim = 'stand_pistolfromnade';
                    }
                }
                // From grenade or binocs, to grenade or binocs
                else if (Weapon.IsA('DHExplosiveWeapon') || Weapon.IsA('DHBinocularsItem'))
                {
                    if (bIsCrawling)
                    {
                        Anim = 'prone_draw_nade';
                    }
                    else
                    {
                        Anim = 'stand_draw_nade';
                    }
                }
                // From grenade or binocs to any other weapon (generic anim to draw new weapon from player's back)
                else
                {
                    if (bIsCrawling)
                    {
                        Anim = 'prone_riflefromnade';
                    }
                    else
                    {
                        Anim = 'stand_riflefromnade';
                    }
                }
            }
            else if (SwapWeapon.IsA('DHPistolWeapon'))
            {
                // From pistol to grenade or binocs
                if (Weapon.IsA('DHExplosiveWeapon') || Weapon.IsA('DHBinocularsItem'))
                {
                    if (bIsCrawling)
                    {
                        Anim = 'prone_nadefrompistol';
                    }
                    else
                    {
                        Anim = 'stand_nadefrompistol';
                    }
                }
                // From pistol to any other weapon (generic anim to draw new weapon from player's back)
                else
                {
                    if (bIsCrawling)
                    {
                        Anim = 'prone_riflefrompistol';
                    }
                    else
                    {
                        Anim = 'stand_riflefrompistol';
                    }
                }
            }
            else
            {
                // From any other weapon to grenade or binocs (generic anim having put away old weapon on player's back)
                if (Weapon.IsA('DHExplosiveWeapon') || Weapon.IsA('DHBinocularsItem')) // also used if Weapon is none
                {
                    if (bIsCrawling)
                    {
                        Anim = 'prone_nadefromrifle';
                    }
                    else
                    {
                        Anim = 'stand_nadefromrifle';
                    }
                }
                // From any other weapon to pistol
                else if (Weapon.IsA('DHPistolWeapon'))
                {
                    if (bIsCrawling)
                    {
                        Anim = 'prone_pistolfromrifle';
                    }
                    else
                    {
                        Anim = 'stand_pistolfromrifle';
                    }
                }
            }
        }

        // If no specific animation has been set, we'll use a generic anim for drawing the new weapon from the player's back
        if (Anim == '')
        {
            if (bIsCrawling)
            {
                Anim = 'prone_draw_kar';
            }
            else
            {
                Anim = 'stand_draw_kar';
            }
        }

        SetAnimAction(Anim);

        if (Weapon != none)
        {
            if (AttachedBackItem != none && AttachedBackItem.InventoryClass == Weapon.Class)
            {
                AttachedBackItem.Destroy();
                AttachedBackItem = none;
            }

            // Unhide the weapon now
            if (Weapon.ThirdPersonActor != none)
            {
                if (DrivenVehicle == none) // Matt: added 'if' so we don't make the 3rd person weapon attachment visible again if player just got into a vehicle
                {
                    Weapon.ThirdPersonActor.bHidden = false;
                }
            }
            else
            {
                Weapon.AttachToPawn(self);
            }
        }

        SwapWeapon = none;

        bPreventWeaponFire = false;
    }
}

// Increased damage once over safe fall threshold
// Hacked in code to hurt players who are moving too fast in any direction when they land
function TakeFallingDamage()
{
    local float Shake, EffectiveSpeed, TotalSpeed;

    if (Velocity.Z < -0.5 * MaxFallSpeed)
    {
        if (Role == ROLE_Authority)
        {
            MakeNoise(1.0);

            if (Velocity.Z < -1.0 * MaxFallSpeed)
            {
                EffectiveSpeed = Velocity.Z;

                if (TouchingWaterVolume())
                {
                    EffectiveSpeed = FMin(0.0, EffectiveSpeed + 100.0);
                }

                if (EffectiveSpeed < -1 * MaxFallSpeed)
                {
                    TakeDamage(-100 * (1.5 * EffectiveSpeed + MaxFallSpeed) / MaxFallSpeed, none, Location, vect(0.0, 0.0, 0.0), class'Fell');
                    // Damaged the legs
                    UpdateDamageList(254);
                }
            }
        }

        if (Controller != none)
        {
            Shake = FMin(1.0, -1.0 * Velocity.Z / MaxFallSpeed);
            Controller.DamageShake(Shake);
        }
    }
    else
    {
        TotalSpeed = VSize(Velocity);

        if (TotalSpeed > 0.75 * MinHurtSpeed)
        {
            if (Role == ROLE_Authority)
            {
                MakeNoise(1.0);

                if (TotalSpeed > MinHurtSpeed)
                {
                    if (TouchingWaterVolume())
                    {
                        TotalSpeed = FMin(0.0, TotalSpeed + 100.0);
                    }

                    if (TotalSpeed > MinHurtSpeed)
                    {
                        TakeDamage((TotalSpeed - MinHurtSpeed) * 0.4, none, Location, vect(0.0, 0.0, 0.0), class'DHExitMovingVehicleDamageType');
                        UpdateDamageList(254); // damaged the legs
                    }
                }
            }

            if (Controller != none)
            {
                Shake = FMin(1.0, TotalSpeed / MinHurtSpeed);
                Controller.DamageShake(Shake);
            }
        }
        else if (Velocity.Z < -1.4 * JumpZ)
        {
            MakeNoise(0.5);
        }
    }
}

// Called on the server. Sends a message to the client to let them know to play a the reload
function HandleAssistedReload()
{
    local name PlayerAnim;

    // Set the anim blend time so the server will make this player relevant for third person reload sounds to be heard
    if (Level.NetMode != NM_StandAlone && DHWeaponAttachment(WeaponAttachment) != none)
    {
        PlayerAnim = DHWeaponAttachment(WeaponAttachment).PA_AssistedReloadAnim;

        AnimBlendTime = GetAnimDuration(PlayerAnim, 1.0) + 0.1;
    }

    SetAnimAction('DoAssistedReload');
}

// Play an assisted reload on the client
simulated function PlayAssistedReload()
{
    local name PlayerAnim;
    local name WeaponAnim;

    if (DHWeaponAttachment(WeaponAttachment) != none)
    {
        PlayerAnim = DHWeaponAttachment(WeaponAttachment).PA_AssistedReloadAnim;
        WeaponAnim = WeaponAttachment.WA_ReloadEmpty;

        AnimBlendParams(1, 1.0, 0.0, 0.2, SpineBone1);
        AnimBlendParams(1, 1.0, 0.0, 0.2, SpineBone2);

        PlayAnim(PlayerAnim,, 0.1, 1);
        WeaponAttachment.PlayAnim(WeaponAnim,, 0.1);

        AnimBlendTime = GetAnimDuration(PlayerAnim, 1.0) + 0.1;

        WeaponState = GS_ReloadSingle;
    }
}

// Called on the server. Sends a message to the client to let them know to play the Mantle animation
function HandleMantle()
{
    SetAnimAction('StartMantle');
}

function HandleEndMantle()
{
    SetAnimAction('EndMantle');
}

function HandleResetRoot()
{
    SetAnimAction('ResetRoot');
}

function HandleMortarDeploy()
{
    SetAnimAction('MortarDeploy');
}

function HandleMortarFire()
{
    SetAnimAction('MortarFire');
}

function HandleMortarUnflinch()
{
    SetAnimAction('MortarUnflinch');
}

// Mantle anims
simulated function PlayMantle()
{
    local name  Anim;
    local float AnimTimer;
    local bool  bLocallyControlled;

    const MANTLE_ANIM_RATE = 1.25;

    bPhysicsAnimUpdate = false;
    LockRootMotion(1); // lock the rendering of the root bone to where it is (it will still translate for calculation purposes)
    bLocallyControlled = IsLocallyControlled();

    // Matt: was PlayOwnedSound but that's only relevant to server & this plays on client - same below & in PlayEndMantle
    if (bLocallyControlled)
    {
        PlaySound(MantleSound, SLOT_Interact, 1.0,, 10.0);
    }

    Anim = SetMantleAnim();
    AnimTimer = GetAnimDuration(Anim, MANTLE_ANIM_RATE) + 0.1;

    if (Level.NetMode == NM_DedicatedServer || (Level.NetMode == NM_ListenServer && !bLocallyControlled))
    {
        SetTimer(AnimTimer, false);
    }
    else
    {
        // Instigator gets a slightly longer blend time to allow other clients to better sync animation with movement
        if (Role < ROLE_Authority && bLocallyControlled)
        {
            SetTimer(AnimTimer + 0.05, false);
            PlayAnim(Anim, MANTLE_ANIM_RATE, 0.15, 0);
        }
        else
        {
            SetTimer(AnimTimer, false);
            PlayAnim(Anim, MANTLE_ANIM_RATE, 0.1, 0);
        }
    }

    if (bMantleDebug)
    {
        if (Role == ROLE_Authority)
        {
            ClientMessage("SERVER playing anim:" @ Anim);
            Log("SERVER playing anim:" @ Anim);
        }
        else
        {
            ClientMessage("CLIENT playing anim:" @ Anim);
            Log("CLIENT playing anim:" @ Anim);
        }
    }
}

simulated function PlayEndMantle()
{
    if (Weapon != none && WeaponAttachment != none)
    {
        if (bCrouchMantle)
        {
            if (Level.NetMode != NM_DedicatedServer)
            {
                PlayAnim(WeaponAttachment.PA_IdleCrouchAnim, 1.0, 0, 0);
            }

            SetCollisionSize(CollisionRadius, CrouchHeight);
        }
        else
        {
            if (Level.NetMode != NM_DedicatedServer)
            {
                PlayAnim(WeaponAttachment.PA_IdleWeaponAnim, 1.0, 0.1, 0);
            }

            if (IsLocallyControlled())
            {
                PlaySound(StandToCrouchSound, SLOT_Misc, 1.0,, 10);
            }
        }
    }
    else
    {
        if (bCrouchMantle)
        {
            if (Level.NetMode != NM_DedicatedServer)
            {
                PlayAnim(IdleCrouchAnim, 1.0, 0, 0);
            }

            SetCollisionSize(CollisionRadius, CrouchHeight);
        }
        else
        {
            if (Level.NetMode != NM_DedicatedServer)
            {
                PlayAnim(IdleWeaponAnim, 1.0, 0.1, 0);
            }

            if (IsLocallyControlled())
            {
                PlaySound(StandToCrouchSound, SLOT_Misc, 1.0,, 10);
            }
        }
    }

    SetTimer(0.1, false);
}

// Run this here, after the new animation has had a chance to change the root position before we lock it
simulated function ResetRootBone()
{
    if (bCrouchMantle)
    {
        SetCollisionSize(CollisionRadius, default.CollisionHeight);
        CrouchMantleAdjust();
    }

    bPhysicsAnimUpdate = true;
    LockRootMotion(0);

    if (bCrouchMantle && Physics == PHYS_Walking)
    {
        ShouldCrouch(true);
    }
}

// Checks WeaponState (new enum for added anim capabilities) instead of FiringState
// Overridden to add AT assisted reload animations & again for mantling animations & again for mortar animations
simulated event SetAnimAction(name NewAction)
{
    local name UsedAction;

    if (!bWaitForAnim)
    {
        // Since you can't call SetAnimAction for the same action twice in a row (it won't get replicated)
        // For animations that need to happen twice in a row (such as working the bolt of a rifle) we alternate animaction names for these actions so they replicate properly
        if (Level.NetMode == NM_Client)
        {
            UsedAction = GetAnimActionName(NewAction);
        }
        else
        {
            UsedAction = NewAction;

            if (AnimAction == NewAction)
            {
                NewAction = GetAltName(NewAction);
            }
        }

        AnimAction = NewAction;

        // Weapon switching actions
        if (IsDrawAnim(UsedAction))
        {
            AnimBlendParams(1, 1.0, 0.0, 0.2, SpineBone1);
            AnimBlendParams(1, 1.0, 0.0, 0.2, SpineBone2);
            PlayUpperBodyAnim(UsedAction, 1.0, 0.0);
        }
        else if (IsPutAwayAnim(UsedAction))
        {
            AnimBlendParams(1, 1.0, 0.0, 0.2, SpineBone1);
            AnimBlendParams(1, 1.0, 0.0, 0.2, SpineBone2);
            WeaponState = GS_IgnoreAnimend;
            PlayUpperBodyAnim(UsedAction, 1.0, 0.1, GetAnimDuration(AnimAction, 1.0) * 2.0);

        }
        else if (UsedAction == 'ClearAnims')
        {
            AnimBlendToAlpha(1, 0.0, 0.12);
        }
        else if (UsedAction == 'TossedWeapon')
        {
            SetWeaponAttachment(none);
        }
        else if (UsedAction == 'DoStandardReload')
        {
            if (Level.NetMode != NM_DedicatedServer)
            {
                PlayStandardReload();
            }
        }
        else if (UsedAction == 'DoAssistedReload')
        {
            if (Level.NetMode != NM_DedicatedServer)
            {
                PlayAssistedReload();
            }
        }
        else if (UsedAction == 'DoBayoAttach')
        {
            if (Level.NetMode != NM_DedicatedServer)
            {
                PlayBayonetAttach();
            }
        }
        else if (UsedAction == 'DoBayoDetach')
        {
            if (Level.NetMode != NM_DedicatedServer)
            {
                PlayBayonetDetach();
            }
        }
        else if (UsedAction == 'DoBipodDeploy')
        {
            if (Level.NetMode != NM_DedicatedServer)
            {
                PlayBipodDeploy();
            }
        }
        else if (UsedAction == 'DoBipodUnDeploy')
        {
            if (Level.NetMode != NM_DedicatedServer)
            {
                PlayBipodUnDeploy();
            }
        }
        else if (UsedAction == 'DoBoltAction')
        {
            if (Level.NetMode != NM_DedicatedServer)
            {
                PlayBoltAction();
            }
        }
        else if (UsedAction == 'DoLoopingReload')
        {
            if (Level.NetMode != NM_DedicatedServer)
            {
                PlayStartReloading();
            }
        }
        else if (UsedAction == 'DoReloadEnd')
        {
            if (Level.NetMode != NM_DedicatedServer)
            {
                PlayStopReloading();
            }
        }
        else if (UsedAction == 'StartCrawling')
        {
            bWaitForAnim = true;
            GotoState('StartProning');
        }
        else if (UsedAction == 'EndCrawling')
        {
            bWaitForAnim = true;
            GotoState('EndProning');
        }
        else if (UsedAction == 'DiveToProne')
        {
            bWaitForAnim = true;
            GotoState('DivingToProne');
        }
        else if (UsedAction == 'ProneToCrouch')
        {
            bWaitForAnim = true;
            GotoState('CrouchingFromProne');
        }
        else if (UsedAction == 'CrouchToProne')
        {
            bWaitForAnim = true;
            GotoState('ProningFromCrouch');
        }
        // MANTLING
        else if (UsedAction == 'StartMantle')
        {
            if (Role == ROLE_Authority || !IsLocallyControlled())
            {
                PlayMantle();
            }

            GotoState('Mantling');
        }
        else if (UsedAction == 'EndMantle')
        {
            if (Role == ROLE_Authority || !IsLocallyControlled())
            {
                PostMantle();
                PlayEndMantle();
            }
        }
        else if (UsedAction == 'ResetRoot')
        {
            ResetRootBone();
            GotoState('');
        }
        else if (Physics == PHYS_None || (Level.Game != none && Level.Game.IsInState('MatchOver')))
        {
            PlayAnim(UsedAction,, 0.1);
            AnimBlendToAlpha(1, 0.0, 0.05);
        }
        else if (Physics == PHYS_Falling || (Physics == PHYS_Walking && Velocity.Z != 0.0))
        {
            if (CheckTauntValid(UsedAction))
            {
                if (WeaponState == GS_None || WeaponState == GS_Ready)
                {
                    AnimBlendParams(1, 1.0, 0.0, 0.2, FireRootBone);
                    PlayAnim(UsedAction,, 0.1, 1.0);
                    WeaponState = GS_Ready;
                }
            }
            else if (PlayAnim(UsedAction))
            {
                if (Physics != PHYS_None)
                {
                    bWaitForAnim = true;
                }
            }
            else
            {
                AnimAction = '';
            }
        }
        else if (bIsIdle && !bIsCrouched && Bot(Controller) == none) // standing taunt
        {
            PlayAnim(UsedAction,, 0.1);
            AnimBlendToAlpha(1, 0.0, 0.05);
        }
        else // running taunt
        {
            if (WeaponState == GS_None || WeaponState == GS_Ready)
            {
                AnimBlendParams(1, 1.0, 0.0, 0.2, FireRootBone);
                PlayAnim(UsedAction,, 0.1, 1.0);
                WeaponState = GS_Ready;
            }
        }
    }
}

//------------------------
// Mantling Functions
//------------------------

simulated function HUDCheckMantle()
{
    // Only run this on the client, otherwise we'll bring servers to their knees
    if (IsLocallyControlled())
    {
        bCanMantle = CanMantle();
    }
}

simulated function bool CanMantleActor(Actor A)
{
    local DHObstacleInstance O;

    if (A != none)
    {
        if (A.bStatic)
        {
            return true;
        }

        O = DHObstacleInstance(A);

        if (O != none && O.Info.CanBeMantled())
        {
            return true;
        }
    }

    return false;
}

// Check whether there's anything in front of the player that can be climbed
simulated function bool CanMantle(optional bool bActualMantle, optional bool bForceTest)
{
    local DHWeapon DHW;
    local vector   Extent, HitLoc, HitNorm, StartLoc, EndLoc, Direction;
    local int      i;
    local DHPlayer Player;

    DHW = DHWeapon(Weapon);

    if (bOnFire || !bForceTest && (Velocity != vect(0.0, 0.0, 0.0) || bIsCrouched || bWantsToCrouch || bIsCrawling || IsInState('EndProning') || IsInState('CrouchingFromProne') ||
        (Level.TimeSeconds + 1.0 < NextJumpTime) || Stamina < 2.0 || bIsMantling || Physics != PHYS_Walking || bBipodDeployed ||
        (Weapon != none && (Weapon.bUsingSights || !Weapon.IsInState('Idle') || (DHW != none && !DHW.WeaponAllowMantle())))))
    {
        return false;
    }

    if (bMantleDebug && bForceTest)
    {
        ClientMessage("Client mantle test is being forced");
        Log("Client mantle test is being forced");
    }

    // The extent size and trace height are set to detect anything above MAXSTEPHEIGHT (35uu) and below shoulder height (94uu)
    // A player's "location" is 57.45 uu above "ground"
    Extent.X = CollisionRadius;
    Extent.Y = CollisionRadius;
    Extent.Z = 28.0; // half the height of the actual trace

    Direction = vector(Rotation);

    StartLoc = Location;
    StartLoc.Z += 5.0; // necessary to make the bottom of the extent just clip the MINFLOORZ height and the top hit shoulder height
    EndLoc = StartLoc + (15.0 * Direction);

    // This is the initial trace to see if there's anything in front of the pawn
    if (!CanMantleActor(Trace(HitLoc, HitNorm, EndLoc, StartLoc, true, Extent))) // * 50.0
    {
        return false;
    }

    /* Sloped walls pose a problem. BSP are ok, but meshes seem to play havoc with traces that start inside them.
    To get around this, we'll do a flat trace (i.e. with no height) at 0.5uu above the max climb height (the extra
    0.5 dist represents space required for the player to occupy). If we hit something then the object is obviously
    too high and therefore we can't climb it. If we don't hit anything, then do an extent trace downward to find
    the top of the object. This saves us from starting a trace inside an object and the problems that can result
    if that object is a mesh. The extra 15uu is to take into account the player stepping onto the object. */

    Extent.Z = 0.5;

    StartLoc.Z = Location.Z + 31.1; // ~89 uu above ground, roughly shoulder height - 0.55 higher than max climb height
    EndLoc = StartLoc + (30.0 * Direction);

    if (CanMantleActor(Trace(HitLoc, HitNorm, EndLoc, StartLoc, true, Extent)))
    {
        //Spawn(class'DHDebugTracer', self,, HitLoc, rotator(HitNorm));
        //ClientMessage("Object is too high to mantle");
        return false;
    }

    EndLoc += (7.0 * Direction); // brings us to a total of 60uu out from our starting location, which is how far our animations go
    StartLoc = EndLoc;
    EndLoc.Z = Location.Z - 22.0; // 36 UU above ground, which is just above MAXSTEPHEIGHT // NOTE: testing shows you can actually step higher than MAXSTEPHEIGHT - nevermind, this is staying as-is

    // Trace downward to find the top of the object - coming from above to prevent false positives from uneven surfaces
    if (!CanMantleActor(Trace(HitLoc, HitNorm, EndLoc, StartLoc, true, Extent)))
    {
        //ClientMessage("Downward trace failed to find the top of the object");
        return false;
    }

    // Check whether the object is sloped too steeply to stand on
    if (HitNorm.Z < MINFLOORZ)
    {
        //ClientMessage("Surface is too steep to stand on");
        return false;
    }

    // Save this for later!
    MantleEndPoint = HitLoc;

    StartLoc = HitLoc;
    EndLoc = StartLoc;
    EndLoc.Z += CollisionHeight * 2.0;

    // Trace back up to ensure that there's enough room to stand on the object
    if (CanMantleActor(Trace(HitLoc, HitNorm, EndLoc, StartLoc, false, Extent)))
    {
        //ClientMessage("Upward trace was obstructed - we can't stand!");
        EndLoc = StartLoc;
        EndLoc.Z += CrouchHeight * 2.0;

        // If we can't stand, see if there's room to crouch on it instead
        if (CanMantleActor(Trace(HitLoc, HitNorm, EndLoc, StartLoc, false, Extent)))
        {
            //ClientMessage("Upward trace was obstructed - we can't fit by crouching!");
            return false;
        }
        else
        {
            bCrouchMantle = true;
        }
    }
    else
    {
        bCrouchMantle = false;
    }

    // Calculations for the actual mantle action - only run when server initiates an actual mantle
    if (bActualMantle)
    {
        if (bMantleDebug && IsLocallyControlled())
        {
            ClientMessage("------------- Start Mantle Debug -------------");
            Log("------------- Start Mantle Debug -------------");
        }

        // Stop any movement before the climb to prevent any overshoot
        Velocity = vect(0.0, 0.0, 0.0);
        Acceleration = vect(0.0, 0.0, 0.0);

        // Our original downward trace isn't accurate enough, so lets find the ACTUAL top of the object
        Extent.Z = 0.5;
        StartLoc = Location;
        StartLoc.Z = MantleEndPoint.Z - 1.0;
        EndLoc = StartLoc + (30.0 * Direction);

        for (i = 0; i < 5; ++i)
        {
            if (CanMantleActor(Trace(HitLoc, HitNorm, EndLoc, StartLoc, true, Extent)))
            {
                break;
            }
            else
            {
                StartLoc.Z -= 1.0;
                EndLoc.Z -= 1.0;
            }
        }

        MantleHeight = (HitLoc.Z + 58.0) - Location.Z;

        if (bMantleDebug)
        {
            if (Role == ROLE_Authority)
            {
                ClientMessage("SERVER MantleHeight (approx): " @ MantleHeight);
                Log("SERVER MantleHeight (approx): " @ MantleHeight);
            }
            else
            {
                ClientMessage("CLIENT MantleHeight (approx): " @ MantleHeight);
                Log("CLIENT MantleHeight (approx): " @ MantleHeight);
            }
        }

        bIsMantling = true;
        StartMantleTime = Level.TimeSeconds;
        bCanMantle = false; // removes icon while mantling
        MantleYaw = Rotation.Yaw;

        if (IsLocallyControlled())
        {
            MantleLowerWeapon();
        }

        bSetMantleEyeHeight = true;

        if (Role == ROLE_Authority)
        {
            if ((Level.Game != none) && (Level.Game.GameDifficulty > 2.0))
            {
                MakeNoise(0.1 * Level.Game.GameDifficulty);
            }

            if (bCountJumps && Inventory != none)
            {
                Inventory.OwnerEvent('Jumped');
            }

            if (Weapon != none)
            {
                Weapon.NotifyOwnerJumped();
            }
        }

        SetTimer(1.0, false); // In case client or server fail to get here for any reason, this will abort the one that did
    }

    Player = DHPlayer(Controller);

    if (Player != none)
    {
        Player.QueueHint(1, true);
    }

    return true;
}

function PreMantle()
{
    SetSprinting(false);
    SetPhysics(PHYS_Flying);

    bCollideWorld = false;

    if (WeaponAttachment != none)
    {
        WeaponAttachment.SetDrawType(DT_None);
    }

    AirSpeed = default.GroundSpeed;
    AccelRate = 50000.0;

    if (Role < ROLE_Authority)
    {
        PlayMantle();
    }

    if (Role == ROLE_Authority && IsLocallyControlled())
    {
        HandleMantle();
        bMantleAnimRun = true;
    }

    RootDelta = GetRootLocationDelta(); // this acts as a "reset" before we try to call it for real
}

function DoMantle(float DeltaTime)
{
    local vector FinalVelocity, DeltaVelocity;

    RootDelta = GetRootLocationDelta();

    // This prevents us from starting the anim on other clients until the movement has started replicating, to maintain anim sync
    if (Role == ROLE_Authority && !bMantleAnimRun && Physics == PHYS_Flying && Velocity != vect(0.0, 0.0, 0.0))
    {
        HandleMantle();
        bMantleAnimRun = true;
    }

    if (Physics == PHYS_RootMotion)
    {
        MoveSmooth(RootDelta);
    }

    if (IsLocallyControlled() && Physics == PHYS_Flying)
    {
        if (RootDelta == vect(0.0, 0.0, 0.0))
        {
            NewAcceleration = vect(0.0, 0.0, 0.0);
        }
        else
        {
            FinalVelocity = RootDelta / DeltaTime;
            DeltaVelocity = FinalVelocity - Velocity;
            NewAcceleration = DeltaVelocity / DeltaTime;
            NewAcceleration -= Acceleration; // the engine seems to treat new acceleration values as cumulative, not absolute, so this anticipates that
        }

        if (NewAcceleration.Z > 0.0 && (MantleHeight >= 80.0 || bCrouchMantle))
        {
            NewAcceleration.Z += 500.0; // try to compensate for the slight errors caused by varying DeltaTime
        }
    }
}

function PostMantle()
{
    if (bCrouchMantle)
    {
        SetCollisionSize(CollisionRadius, CrouchHeight);
    }

    bIsMantling = false;
    bCollideWorld = true;

    SetPhysics(PHYS_Falling);

    if (IsLocallyControlled())
    {
        MantleRaiseWeapon();
    }

    if (!bCancelledMantle)
    {
        Velocity = vect(0.0, 0.0, 0.0);
    }

    NewAcceleration = vect(0.0, 0.0, 0.0);
    AccelRate = default.AccelRate;
    Airspeed = default.AirSpeed;
    ClientForceStaminaUpdate(Stamina);
    NextJumpTime = Level.TimeSeconds + 2.0;
    bSetMantleEyeHeight = false;
    BaseEyeHeight = default.BaseEyeHeight;

    if (WeaponAttachment != none)
    {
        WeaponAttachment.SetDrawType(DT_Mesh);
    }

    bMantleAnimRun = false;

    if (bMantleDebug)
    {
        if (Role == ROLE_Authority)
        {
            ClientMessage("SERVER Running PostMantle");
            Log("SERVER Running PostMantle");
        }
        else
        {
            ClientMessage("CLIENT Running PostMantle");
            Log("CLIENT Running PostMantle");
        }
    }
}

// Make sure we ended up vaguely near where we were supposed to
// This should catch instances of packet loss or screenshots that cause iffy behaviour
function TestMantleSuccess()
{
    if (bCrouchMantle)
    {
        MantleEndPoint += CrouchHeight * vect(0.0, 0.0, 1.0);
    }
    else
    {
        MantleEndPoint += CollisionHeight * vect(0.0, 0.0, 1.0);
    }

    if (Location.Z < MantleEndPoint.Z - 10.0 || Location.Z > MantleEndPoint.Z + 15.0 || VSize(Location - MantleEndPoint) > CollisionRadius * 2.5)
    {
        if (bMantleDebug)
        {
            if (Location.Z < MantleEndPoint.Z - 10.0)
            {
                ClientMessage("We've finished too low");
                Log("We've finished too low");
            }
            else if (Location.Z > MantleEndPoint.Z + 15.0)
            {
                ClientMessage("We've finished too high");
                Log("We've finished too high");
            }
            else if (VSize(Location - MantleEndPoint) > CollisionRadius * 2.5)
            {
                ClientMessage("We've finished too far away");
                Log("We've finished too far away");
            }
        }

        SetLocation(MantleEndPoint);
        Velocity = vect(0.0, 0.0, 0.0);
        NewAcceleration = vect(0.0, 0.0, 0.0);
    }
}

simulated function CancelMantle()
{
    local vector TempVel;

    SetTimer(0.0, false);

    // Make sure our feet haven't clipped through the ground, else we'll fall through the world
    if (!FastTrace((Location - (vect(0.0, 0.0, 1.0) * CollisionHeight)), Location))
    {
        MoveSmooth(vect(0.0, 0.0, 20.0));
    }

    // To prevent people from falling through scenery, give them a shove backwards
    if (bCrouchMantle)
    {
        TempVel = Normal(vector(Rotation)) * -150.0;
    }
    else
    {
        TempVel = Normal(vector(Rotation)) * -100.0;
    }

    TempVel.Z = 150.0;

    Velocity = TempVel;
    SetPhysics(PHYS_Falling);
    bCancelledMantle = true;

    if (Role == ROLE_Authority)
    {
        HandleEndMantle();
    }
    else if (IsLocallyControlled())
    {
        PostMantle();
        PlayEndMantle();
    }

    if (bMantleDebug)
    {
        ClientMessage("Mantle was cancelled");
        Log("Mantle was cancelled");
    }
}

// Called only when we have desync between client and server
simulated function ClientMantleFail()
{
    bIsMantling = false;
    MantleRaiseWeapon();
    ResetRootBone();
}

simulated function name SetMantleAnim()
{
    local name MantleAnim;

    if (bCrouchMantle)
    {
        if (MantleHeight > 84.0)
        {
            MantleAnim = MantleAnim_88C;
        }
        else if (MantleHeight > 80.0)
        {
            MantleAnim = MantleAnim_84C;
        }
        else if (MantleHeight > 76.0)
        {
            MantleAnim = MantleAnim_80C;
        }
        else if (MantleHeight > 72.0)
        {
            MantleAnim = MantleAnim_76C;
        }
        else if (MantleHeight > 68.0)
        {
            MantleAnim = MantleAnim_72C;
        }
        else if (MantleHeight > 64.0)
        {
            MantleAnim = MantleAnim_68C;
        }
        else if (MantleHeight > 60.0)
        {
            MantleAnim = MantleAnim_64C;
        }
        else if (MantleHeight > 56.0)
        {
            MantleAnim = MantleAnim_60C;
        }
        else if (MantleHeight > 52.0)
        {
            MantleAnim = MantleAnim_56C;
        }
        else if (MantleHeight > 48.0)
        {
            MantleAnim = MantleAnim_52C;
        }
        else if (MantleHeight > 44.0)
        {
            MantleAnim = MantleAnim_48C;
        }
        else if (MantleHeight > 40.0)
        {
            MantleAnim = MantleAnim_44C;
        }
        else
        {
            MantleAnim = MantleAnim_40C;
        }
    }
    else
    {
        if (MantleHeight > 84.0)
        {
            MantleAnim = MantleAnim_88S;
        }
        else if (MantleHeight > 80.0)
        {
            MantleAnim = MantleAnim_84S;
        }
        else if (MantleHeight > 76.0)
        {
            MantleAnim = MantleAnim_80S;
        }
        else if (MantleHeight > 72.0)
        {
            MantleAnim = MantleAnim_76S;
        }
        else if (MantleHeight > 68.0)
        {
            MantleAnim = MantleAnim_72S;
        }
        else if (MantleHeight > 64.0)
        {
            MantleAnim = MantleAnim_68S;
        }
        else if (MantleHeight > 60.0)
        {
            MantleAnim = MantleAnim_64S;
        }
        else if (MantleHeight > 56.0)
        {
            MantleAnim = MantleAnim_60S;
        }
        else if (MantleHeight > 52.0)
        {
            MantleAnim = MantleAnim_56S;
        }
        else if (MantleHeight > 48.0)
        {
            MantleAnim = MantleAnim_52S;
        }
        else if (MantleHeight > 44.0)
        {
            MantleAnim = MantleAnim_48S;
        }
        else if (MantleHeight > 40.0)
        {
            MantleAnim = MantleAnim_44S;
        }
        else
        {
            MantleAnim = MantleAnim_40S;
        }
    }

    return MantleAnim;
}

simulated state Mantling
{
    simulated function Timer()
    {
        if (bMantleDebug)
        {
            if (Role == ROLE_Authority)
            {
                ClientMessage("SERVER Running Timer");
                Log("SERVER Running Timer");
            }
            else
            {
                ClientMessage("CLIENT Running Timer");
                Log("CLIENT Running Timer");
            }
        }

        if (Physics == PHYS_Flying || Physics == PHYS_RootMotion)
        {
            if (Role == ROLE_Authority)
            {
                TestMantleSuccess();
            }

            bCancelledMantle = false;

            if (Role == ROLE_Authority)
            {
                HandleEndMantle();
            }
            else if (IsLocallyControlled())
            {
                PostMantle();
                PlayEndMantle();
            }

            DHPlayer(Controller).SetTimer(0.1, false);
            DHPlayer(Controller).bDidMantle = true;
        }
        else
        {
            if (Role == ROLE_Authority)
            {
                HandleResetRoot();
            }
            else if (IsLocallyControlled())
            {
                ResetRootBone();
            }
        }
    }

    simulated function BeginState()
    {
        SetSprinting(false);
    }

    simulated function EndState()
    {
        // Just in case the server/client get out of sync for any reason
        if (bIsMantling)
        {
            if (Role == ROLE_Authority)
            {
                HandleEndMantle();
                HandleResetRoot();
            }
            else if (IsLocallyControlled())
            {
                PostMantle();
                PlayEndMantle();
                ResetRootBone();
            }
        }
    }

    simulated function bool WeaponAllowSprint()
    {
        return false;
    }
}

simulated function MantleLowerWeapon()
{
    if (DHWeapon(Weapon) != none)
    {
        DHWeapon(Weapon).bIsMantling = true;
        DHWeapon(Weapon).GotoState('StartMantle');
    }
}

simulated function MantleRaiseWeapon()
{
    if (DHWeapon(Weapon) != none)
    {
        DHWeapon(Weapon).bIsMantling = false;
    }
}

simulated function CrouchMantleAdjust()
{
    local float HeightAdjust;

    HeightAdjust = default.CollisionHeight - CrouchHeight;
    SetLocation(Location + (HeightAdjust * vect(0.0, 0.0, 1.0)));
}

simulated function DoMantleCrouch()
{
    if (!bIsCrouched && !bWantsToCrouch)
    {
        ShouldCrouch(true);
    }
}

// Added a pre-mantle bob
event UpdateEyeHeight(float DeltaTime)
{
    local float  Smooth, MaxEyeHeight, OldEyeHeight;
    local Actor  HitActor;
    local vector HitLocation, HitNormal;

    if (Controller == none)
    {
        EyeHeight = 0.0;

        return;
    }

    // START DH

    // Lower eye height here to hide crouch transition at end of mantle
    if (bSetMantleEyeHeight)
    {
        if (bCrouchMantle)
        {
            Smooth = FMin(0.65, 10.0 * DeltaTime);
            EyeHeight = EyeHeight * (1.0 - 0.1 * Smooth);

            if (EyeHeight < CrouchEyeHeightMod * CrouchHeight + 1.0)
            {
                BaseEyeHeight = CrouchEyeHeightMod * CrouchHeight;
                bSetMantleEyeHeight = false;

                // Sneak these in here, just to prevent a second bob if we start climbing just as we land
                bJustLanded = false;
                bLandRecovery = false;
            }
        }
        else if (bEndMantleBob)
        {
            Smooth = FMin(0.9, 10.0 * DeltaTime);
            OldEyeHeight = EyeHeight;
            EyeHeight = FMin(EyeHeight * (1.0 - 0.6 * Smooth) + BaseEyeHeight * 0.6 * Smooth, BaseEyeHeight);
            LandBob *= (1 - Smooth);

            if (EyeHeight >= BaseEyeHeight - 1.0)
            {
                bSetMantleEyeHeight = false;
                bEndMantleBob = false;
                EyeHeight = BaseEyeHeight;

                // sneak these in here, just to prevent a second bob if we start climbing just as we land
                bJustLanded = false;
                bLandRecovery = false;
            }
        }
        else
        {
            Smooth = FMin(0.65, 10.0 * DeltaTime);
            OldEyeHeight = EyeHeight;
            EyeHeight = EyeHeight * (1.0 - 0.1 * Smooth);
            LandBob += 0.03 * (OldEyeHeight - EyeHeight);

            if (EyeHeight < (0.5 * default.BaseEyeHeight + 1.0) || LandBob > 3.0)
            {
                bEndMantleBob = true;
                EyeHeight = 0.5 * BaseEyeHeight + 1.0;
            }
        }

        Controller.AdjustView(DeltaTime);

        return;
    }

    if (bTearOff)
    {
        EyeHeight = default.BaseEyeHeight;
        bUpdateEyeHeight = false;

        return;
    }

    HitActor = Trace(HitLocation, HitNormal, Location + (CollisionHeight + MAXSTEPHEIGHT + 14.0) * vect(0.0, 0.0, 1.0), Location + CollisionHeight * vect(0.0, 0.0, 1.0), true);

    if (HitActor == none)
    {
        MaxEyeHeight = CollisionHeight + MAXSTEPHEIGHT;
    }
    else
    {
        MaxEyeHeight = HitLocation.Z - Location.Z - 14.0;
    }

    if (Abs(Location.Z - OldZ) > 15.0)
    {
        bJustLanded = false;
        bLandRecovery = false;
    }

    // Smooth up/down stairs
    if (!bJustLanded)
    {
        Smooth = FMin(0.9, 10.0 * DeltaTime / Level.TimeDilation);
        LandBob *= (1.0 - Smooth);

        if (Controller.WantsSmoothedView())
        {
            OldEyeHeight = EyeHeight;
            EyeHeight = FClamp((EyeHeight - Location.Z + OldZ) * (1.0 - Smooth) + BaseEyeHeight * Smooth, -0.5 * CollisionHeight, MaxEyeHeight);
        }
        else
        {
            EyeHeight = FMin(EyeHeight * (1.0 - Smooth) + BaseEyeHeight * Smooth, MaxEyeHeight);
        }
    }
    else if (bLandRecovery)
    {
        Smooth = FMin(0.9, 10.0 * DeltaTime);
        OldEyeHeight = EyeHeight;
        EyeHeight = FMin(EyeHeight * (1.0 - 0.6 * Smooth) + BaseEyeHeight * 0.6 * Smooth, BaseEyeHeight);
        LandBob *= (1.0 - Smooth);

        if (EyeHeight >= BaseEyeHeight - 1.0)
        {
            bJustLanded = false;
            bLandRecovery = false;
            EyeHeight = BaseEyeHeight;
        }
    }
    else
    {
        Smooth = FMin(0.65, 10.0 * DeltaTime);
        OldEyeHeight = EyeHeight;
        EyeHeight = FMin(EyeHeight * (1.0 - 1.5*Smooth), MaxEyeHeight);
        LandBob += 0.03 * (OldEyeHeight - EyeHeight);

        if ((EyeHeight < 0.25 * BaseEyeHeight + 1.0) || LandBob > 3.0)
        {
            bLandRecovery = true;
            EyeHeight = 0.25 * BaseEyeHeight + 1.0;
        }
    }

    Controller.AdjustView(DeltaTime);
}

// LimitYaw - limits player's Yaw or turning amount
function LimitYaw(out int Yaw)
{
    local int MaxBipodYaw, MinBipodYaw;

    if (bBipodDeployed)
    {
        MaxBipodYaw = InitialDeployedRotation.Yaw + DeployedPositiveYawLimit;
        MinBipodYaw = InitialDeployedRotation.Yaw + DeployedNegativeYawLimit;

        Yaw = FClamp(Yaw, MinBipodYaw, MaxBipodYaw);
    }
    else if (bIsMantling)
    {
        Yaw = MantleYaw;
    }
    else if (bLockViewRotation)
    {
        Yaw = LockViewRotation.Yaw;
    }
}

function int LimitPitch(int Pitch, optional float DeltaTime)
{
    local int MaxBipodPitch;
    local int MinBipodPitch;

    Pitch = Pitch & 65535;

    if (bBipodDeployed)
    {
        MaxBipodPitch = InitialDeployedRotation.Pitch + DeployedPitchUpLimit;
        MinBipodPitch = InitialDeployedRotation.Pitch + DeployedPitchDownLimit;

        if (MaxBipodPitch > 65535)
        {
            MaxBipodPitch -= 65535;
        }

        if (MinBipodPitch < 0)
        {
            MinBipodPitch += 65535;
        }

        if (MaxBipodPitch > PitchUpLimit && MaxBipodPitch < PitchDownLimit)
        {
            MaxBipodPitch = PitchUpLimit;
        }

        if (MinBipodPitch < PitchDownLimit && MinBipodPitch > PitchUpLimit)
        {
            MinBipodPitch = PitchDownLimit;
        }

        // Handles areas where newPitchUpLimit is less than newPitchDownLimit
        if (Pitch > MaxBipodPitch && Pitch < MinBipodPitch)
        {
            if ((Pitch - MaxBipodPitch) < (MinBipodPitch - Pitch))
            {
                Pitch = MaxBipodPitch;
            }
            else
            {
                Pitch = MinBipodPitch;
            }
        }
        // Following 2 ifs, handle when newPitchUpLimit is greater than newPitchDownLimit
        else if (Pitch > MaxBipodPitch && MaxBipodPitch > MinBipodPitch)
        {
            Pitch = MaxBipodPitch;
        }
        else if (Pitch < MinBipodPitch && MaxBipodPitch > MinBipodPitch)
        {
            Pitch = MinBipodPitch;
        }
    }
    else
    {
        if (bIsCrawling)
        {
            // Smoothly rotate the player to the pitch limit when you start crawling
            // This prevents the jarring "pop" when the pitch limit kicks in to prevent you from looking through your arms
            if (Weapon != none && Weapon.IsCrawling())
            {
                if (Pitch > CrawlingPitchUpLimit && Pitch < CrawlingPitchDownLimit)
                {
                    if (Pitch - CrawlingPitchUpLimit < CrawlingPitchDownLimit - Pitch)
                    {
                        if (Level.TimeSeconds - Weapon.LastStartCrawlingTime < 0.15)
                        {
                            Pitch -= CrawlPitchTweenRate * DeltaTime;
                        }
                        else
                        {
                            Pitch = CrawlingPitchUpLimit;
                        }
                    }
                    else
                    {
                        if (Level.TimeSeconds - Weapon.LastStartCrawlingTime < 0.15)
                        {
                            Pitch += CrawlPitchTweenRate * DeltaTime;
                        }
                        else
                        {
                            Pitch = CrawlingPitchDownLimit;
                        }
                    }
                }
            }
            else
            {
                if (Pitch > PronePitchUpLimit && Pitch < PronePitchDownLimit)
                {
                    if (Pitch - PronePitchUpLimit < PronePitchDownLimit - Pitch)
                    {
                        Pitch = PronePitchUpLimit;
                    }
                    else
                    {
                        Pitch = PronePitchDownLimit;
                    }
                }
            }
        }
        else if (bIsMantling)
        {
            // As above, but for mantling
            if (Pitch != 0)
            {
                if (Pitch > 100 && Pitch < 65435)
                {
                    if (Pitch < 65435 - Pitch) // 65536
                    {
                        if (Level.TimeSeconds - StartMantleTime < 0.15)
                        {
                            Pitch -= 50000 * DeltaTime;
                        }
                        else
                        {
                            Pitch = 0;
                        }
                    }
                    else
                    {
                        if (Level.TimeSeconds - StartMantleTime < 0.15)
                        {
                            Pitch += 50000 * DeltaTime;
                        }
                        else
                        {
                            Pitch = 0;
                        }
                    }
                }
                else
                {
                    Pitch = 0;
                }
            }
        }
        else if (Pitch > PitchUpLimit && Pitch < PitchDownLimit)
        {
            if (Pitch - PitchUpLimit < PitchDownLimit - Pitch)
            {
                Pitch = PitchUpLimit;
            }
            else
            {
                Pitch = PitchDownLimit;
            }
        }
    }

    if (bLockViewRotation)
    {
        Pitch = LockViewRotation.Pitch;
    }

    return Pitch;
}

// Returns true if the player can switch the prone state - only valid on the client
simulated function bool CanProneTransition()
{
    //TODO: Remove PHYS_Falling.
    return (Physics == PHYS_Walking || Physics == PHYS_Falling) && !bIsMantling && (Weapon == none || Weapon.WeaponAllowProneChange());
}

// Returns true if the player can switch the crouch state
simulated function bool CanCrouchTransition()
{
    if (IsTransitioningToProne() || bIsMantling)
    {
        return false;
    }

    if (Weapon == none || Weapon.WeaponAllowCrouchChange())
    {
        return true;
    }

    return false;
}

simulated function LeanRight()
{
    if (TraceWall(16384, 64.0) || bLeaningLeft || bIsSprinting || bIsMantling || bIsDeployingMortar || bIsCuttingWire)
    {
        bLeanRight = false;
    }
    else if (!bLeanLeft)
    {
        bLeanRight = true;
    }
}

simulated function LeanLeft()
{
    if (TraceWall(-16384, 64.0) || bLeaningRight || bIsSprinting || bIsMantling || bIsDeployingMortar || bIsCuttingWire)
    {
        bLeanLeft = false;
    }
    else if (!bLeanRight)
    {
        bLeanLeft = true;
    }
}

//------------------------------
//
// Functions for Burning Players
//
//------------------------------

simulated function StartBurnFX()
{
    local int i;

    if (FlameFX == none)
    {
        FlameFX = Spawn(FlameEffect);
        FlameFX.SetBase(self);
        FlameFX.Emitters[0].SkeletalMeshActor = self;
        FlameFX.Emitters[0].UseSkeletalLocationAs = PTSU_SpawnOffset;
        FlameFX.Emitters[1].SkeletalMeshActor = self;
        FlameFX.Emitters[1].UseSkeletalLocationAs = PTSU_SpawnOffset;
        FlameFX.Emitters[2].SkeletalMeshActor = self;
        FlameFX.Emitters[2].UseSkeletalLocationAs = PTSU_SpawnOffset;
    }

    SetOverlayMaterial(BurningOverlayMaterial, 999.0, true);

    if (HeadGear != none)
    {
        HeadGear.SetOverlayMaterial(BurnedHeadgearOverlayMaterial, 999.0, true);
    }

    for (i = 0; i < AmmoPouches.Length; ++i)
    {
        AmmoPouches[i].SetOverlayMaterial(BurningOverlayMaterial, 999.0, true);
    }

    bBurnFXOn = true;
}

simulated function EndBurnFX()
{
    local int i;

    if (FlameFX != none)
    {
        FlameFX.Kill();
    }

    SetOverlayMaterial(CharredOverlayMaterial, 999.0, true);

    for (i = 0; i < AmmoPouches.Length; ++i)
    {
        AmmoPouches[i].SetOverlayMaterial(CharredOverlayMaterial, 999.0, true);
    }

    bBurnFXOn = false;
}

// Burning players drop everything they have - they're on fire after all!
function BurningDropWeaps()
{
    local vector TossVel;

    if (Weapon != none && (DrivenVehicle == none || DrivenVehicle.bAllowWeaponToss))
    {
        if (Controller != none)
        {
            Controller.LastPawnWeapon = Weapon.Class;
        }

        Weapon.HolderDied();
        TossVel = vector(GetViewRotation());
        TossVel = TossVel * ((Velocity dot TossVel) + 50.0) + vect(0.0, 0.0, 200.0);
        TossWeapon(TossVel);
    }

    DropWeaponInventory(TossVel);
}

// Modified to also destroy inventory items, necessary for burning players
function DropWeaponInventory(vector TossVel)
{
    local Inventory Inv;
    local Weapon    W;
    local DHWeapon  DHW;
    local vector    X, Y, Z;
    local int       i;
    local array<Inventory> InventoryList;

    GetAxes(Rotation, X, Y, Z);

    Inv = Inventory;

    while (Inv != none)
    {
        InventoryList[InventoryList.Length] = Inv;

        Inv = Inv.Inventory;
    }

    for (i = 0; i < InventoryList.Length; ++i)
    {
        W = Weapon(InventoryList[i]);

        if (W == none)
        {
            continue;
        }

        DHW = DHWeapon(W);

        if ((DHW != none && DHW.CanDeadThrow()) || (DHW == none && W.bCanThrow))
        {
            W.DropFrom(Location + (0.8 * CollisionRadius * X) - (0.5 * CollisionRadius * Y));
        }
        else
        {
            W.Destroy();
        }
    }
}

// Implemented to douse the flames of a player who is on fire, if he enters water
simulated event PhysicsVolumeChange(PhysicsVolume NewVolume)
{
    if (bOnFire && NewVolume != none && NewVolume.bWaterVolume)
    {
        bOnFire = false;

        if (FlameFX != none)
        {
            FlameFX.Kill();
        }
    }
}

function bool ResupplyMortarAmmunition()
{
    local int i;
    local DHRoleInfo RI;
    local class<DHMortarWeapon> W;

    RI = GetRoleInfo();

    if (!bMortarCanBeResupplied || RI == none || !RI.bCanUseMortars)
    {
        return false;
    }

    for (i = 0; i < RI.GivenItems.Length; ++i)
    {
        if (RI.GivenItems[i] != "")
        {
            W = class<DHMortarWeapon>(DynamicLoadObject(RI.GivenItems[i], class'Class'));
        }

        if (W == none)
        {
            continue;
        }

        MortarHEAmmo = Clamp(MortarHEAmmo + W.default.HighExplosiveResupplyCount, 0, W.default.HighExplosiveMaximum);
        MortarSmokeAmmo = Clamp(MortarSmokeAmmo + W.default.SmokeResupplyCount, 0, W.default.SmokeMaximum);

        CheckIfMortarCanBeResupplied();

        return true;
    }

    return false;
}

function CheckIfMortarCanBeResupplied()
{
    local int i;
    local DHRoleInfo RI;
    local class<DHMortarWeapon> W;

    RI = GetRoleInfo();

    bMortarCanBeResupplied = false;

    if (RI == none || !RI.bCanUseMortars)
    {
        return;
    }

    for (i = 0; i < RI.GivenItems.Length; ++i)
    {
        if (RI.GivenItems[i] != "")
        {
            W = class<DHMortarWeapon>(DynamicLoadObject(RI.GivenItems[i], class'Class'));
        }

        if (W == none)
        {
            continue;
        }

        bMortarCanBeResupplied = MortarHEAmmo < W.default.HighExplosiveMaximum || MortarSmokeAmmo < W.default.SmokeMaximum;
    }
}

simulated function bool CanUseMortars()
{
    local DHRoleInfo RI;

    RI = GetRoleInfo();

    return RI != none && RI.bCanUseMortars;
}

simulated function DHRoleInfo GetRoleInfo()
{
    local DHRoleInfo              RI;
    local DHPlayerReplicationInfo PRI;

    if (PlayerReplicationInfo == none)
    {
        return none;
    }

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    if (PRI == none || PRI.RoleInfo == none)
    {
        return none;
    }

    RI = DHRoleInfo(PRI.RoleInfo);

    return RI;
}

simulated function bool AllowSprint()
{
    if (bIsWalking && !Weapon.bUsingSights)
    {
        return false;
    }

    if (!bIsCrawling && ((Weapon == none || Weapon.WeaponAllowSprint()) && Acceleration != vect(0.0, 0.0, 0.0)))
    {
        return true;
    }

    return false;
}

function SetWalking(bool bNewIsWalking)
{
    if (bNewIsWalking && bIsSprinting)
    {
        return;
    }

    if (bNewIsWalking != bIsWalking) // fixed bug where players could sprint backwards are ridiculous speeds
    {
        bIsWalking = bNewIsWalking;
    }
}

simulated function SetLockViewRotation(bool bShouldLockViewRotation, optional rotator LockViewRotation)
{
    self.bLockViewRotation = bShouldLockViewRotation;
    self.LockViewRotation = LockViewRotation;
}

simulated function SetIsCuttingWire(bool bIsCuttingWire)
{
    self.bIsCuttingWire = bIsCuttingWire;

    if (Controller != none)
    {
        SetLockViewRotation(bIsCuttingWire, Controller.Rotation);
    }
}

simulated function float BobFunction(float T, float Amplitude, float Frequency, float Decay)
{
    return Amplitude * ((Sin(Frequency * T)) / (Frequency ** ((Decay / Frequency) * T)));
}

simulated exec function BobAmplitude(optional float F)
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        if (F == 0)
        {
            Level.Game.Broadcast(self, "IronsightBobAmplitude" @ IronsightBobAmplitude);

            return;
        }

        IronsightBobAmplitude = F;
    }
}

simulated exec function BobFrequency(optional float F)
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        if (F == 0)
        {
            Level.Game.Broadcast(self, "IronsightBobFrequency" @ IronsightBobFrequency);

            return;
        }

        IronsightBobFrequency = F;
    }
}

simulated exec function BobDecay(optional float F)
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        if (F == 0)
        {
            Level.Game.Broadcast(self, "IronsightBobDecay" @ IronsightBobDecay);

            return;
        }

        IronsightBobDecay = F;
    }
}

// Overridden to add some initial weapon bobbing when first iron sighting
function CheckBob(float DeltaTime, vector Y)
{
    local float OldBobTime, BobModifier, Speed2D, IronsightBobAmplitudeModifier, IronsightBobDecayModifier;
    local int   m, n;

    OldBobTime = BobTime;

    Bob = FClamp(Bob, -0.01, 0.01);

    // Modify the amount of bob based on the movement state
    if (bIsSprinting)
    {
        BobModifier = 1.75;
    }
    else if (bIsCrawling && !bIronSights)
    {
        BobModifier = 2.5;
    }
    else if (bIsCrouched && !bIronSights)
    {
        BobModifier = 2.5;
    }
    else if (bIronSights)
    {
        BobModifier = 0.5;
    }
    else
    {
        BobModifier = 1.0;
    }

    if (Physics == PHYS_Walking)
    {
        Speed2D = VSize(Velocity);

        if (bIronSights)
        {
            if (bIsCrawling)
            {
                IronsightBobAmplitudeModifier = 0.5;
                IronsightBobDecayModifier = 1.5;
            }
            else if (bIsCrouched)
            {
                IronsightBobAmplitudeModifier = 0.75;
                IronsightBobDecayModifier = 1.25;
            }
            else
            {
                IronsightBobAmplitudeModifier = 1.0;
                IronsightBobDecayModifier = 1.0;
            }

            IronsightBobTime += DeltaTime;

            IronsightBob.Y = BobFunction(IronsightBobTime, IronsightBobAmplitude * IronsightBobAmplitudeModifier, IronsightBobFrequency, IronsightBobDecay * IronsightBobDecayModifier);
            IronsightBob.Z = BobFunction(IronsightBobTime, IronsightBobAmplitude * IronsightBobAmplitudeModifier, IronsightBobFrequency, IronsightBobDecay * IronsightBobDecayModifier);
        }
        else
        {
            IronsightBobTime = 0.0;
            IronsightBob = vect(0.0, 0.0, 0.0);
        }

        if (bIsCrawling && !bIronSights)
        {
            BobTime += DeltaTime * ((0.3 + 0.7 * Speed2D / (GroundSpeed * PronePct)) / 2.0);
        }
        else if (bIsSprinting)
        {
            if (Speed2D < 10.0)
            {
                BobTime += 0.2 * DeltaTime;
            }
            else
            {
                if (bIsCrouched)
                {
                    BobTime += DeltaTime * (0.3 + 0.7 * Speed2D / ((GroundSpeed * CrouchedSprintPct) / 1.25));
                }
                else
                {
                    BobTime += DeltaTime * (0.3 + 0.7 * Speed2D / ((GroundSpeed * SprintPct) / 1.25));
                }
            }
        }
        else
        {
            if (Speed2D < 10.0)
            {
                BobTime += 0.2 * DeltaTime;
            }
            else
            {
                BobTime += DeltaTime * (0.3 + 0.7 * Speed2D / GroundSpeed);
            }
        }

        WalkBob = Y * (Bob * BobModifier) * Speed2D * Sin(8.0 * BobTime);
        AppliedBob = AppliedBob * (1.0 - FMin(1.0, 16.0 * DeltaTime));
        WalkBob.Z = AppliedBob;

        if (Speed2D > 10.0)
        {
            WalkBob.Z = WalkBob.Z + 0.75 * (Bob * BobModifier) * Speed2D * Sin(16.0 * BobTime);
        }

        if (LandBob > 0.01)
        {
            AppliedBob += FMin(1.0, 16.0 * DeltaTime) * LandBob;
            LandBob *= (1.0 - 8.0 * Deltatime);
        }
    }
    else if (Physics == PHYS_Swimming)
    {
        Speed2D = Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
        WalkBob = Y * Bob * 0.5 * Speed2D * Sin(4.0 * Level.TimeSeconds);
        WalkBob.Z = Bob * 1.5 * Speed2D * Sin(8.0 * Level.TimeSeconds);
    }
    else
    {
        BobTime = 0.0;
        WalkBob = WalkBob * (1.0 - FMin(1.0, 8.0 * DeltaTime));
    }

    if (Physics != PHYS_Walking || VSize(Velocity) < 10.0 || (PlayerController(Controller) != none && PlayerController(Controller).bBehindView))
    {
        return;
    }

    m = int(0.5 * Pi + 9.0 * OldBobTime / Pi);
    n = int(0.5 * Pi + 9.0 * BobTime / Pi);

    if (m != n && !bIsCrawling)
    {
        FootStepping(0);
    }
}

// Modified to cause some stamina loss for prone diving
simulated state DivingToProne
{
    // Copied function from ROPawn as I think calling the super is risky
    simulated function EndState()
    {
        local float NewHeight;
        local name Anim;

        NewHeight = default.CollisionHeight - ProneHeight;

        if (WeaponAttachment != none)
        {
            Anim = WeaponAttachment.PA_DiveToProneEndAnim;
        }
        else
        {
            Anim = DiveToProneEndAnim;
        }

        PlayAnim(DiveToProneEndAnim, 0.0, 0.0, 0);
        PrePivot = default.PrePivot + (NewHeight * vect(0.0, 0.0, 1.0));

        // Take stamina away with each dive prone
        Stamina = FMax(Stamina - JumpStaminaDrain, 0.0);
    }
}

// From prone to crouch
event ProneToCrouch(float HeightAdjust)
{
    super.ProneToCrouch(HeightAdjust);

    // Take stamina away with each stance change
    Stamina = FMax(Stamina - StanceChangeStaminaDrain, 0.0);
}

// From prone to stand
event EndProne(float HeightAdjust)
{
    super.EndProne(HeightAdjust);

    // Take stamina away with each stance change
    Stamina = FMax(Stamina - StanceChangeStaminaDrain, 0.0);
}

// From crouch to stand
event EndCrouch(float HeightAdjust)
{
    super.EndCrouch(HeightAdjust);

    // Take stamina away with each stance change
    Stamina = FMax(Stamina - (StanceChangeStaminaDrain / 2.0), 0.0);
}

// From crouch to prone
event CrouchToProne(float HeightAdjust)
{
    super.CrouchToProne(HeightAdjust);

    // Take stamina away with each stance change
    Stamina = FMax(Stamina - StanceChangeStaminaDrain, 0.0);
}

// From stand to prone
event StartProne(float HeightAdjust)
{
    super.StartProne(HeightAdjust);

    // Take stamina away with each stance change
    Stamina = FMax(Stamina - StanceChangeStaminaDrain, 0.0);
}

// From stand to crouch
event StartCrouch(float HeightAdjust)
{
    super.StartCrouch(HeightAdjust);

    // Take stamina away with each stance change
    Stamina = FMax(Stamina - (StanceChangeStaminaDrain / 2.0), 0.0);
}

// Modified to increase volume & radius of sound if sprinting, & to reduce sound radius if moving slowly
simulated function FootStepping(int Side)
{
    local Actor    A;
    local vector   HitLocation, HitNormal, Start;
    local material FloorMaterial;
    local int      SurfaceTypeID, i;
    local float    SoundVolumeModifier, SoundRadiusModifier;

    // Play water effects if touching water
    for (i = 0; i < Touching.Length; ++i)
    {
        if ((PhysicsVolume(Touching[i]) != none && PhysicsVolume(Touching[i]).bWaterVolume) || FluidSurfaceInfo(Touching[i]) != none)
        {
            PlaySound(sound'Inf_Player.FootStepWaterDeep', SLOT_Interact, FootstepVolume * 2.0,, FootStepSoundRadius);

            // Play a water ring effect as you walk through the water
            if (Level.NetMode != NM_DedicatedServer && !Level.bDropDetail && Level.DetailMode != DM_Low
                && !Touching[i].TraceThisActor(HitLocation, HitNormal, Location - (CollisionHeight * vect(0.0, 0.0, 1.1)), Location))
            {
                Spawn(class'WaterRingEmitter',,, HitLocation, rot(16384, 0, 0));
            }

            return;
        }
    }

    // No footstep sound if crawling
    if (bIsCrawling)
    {
        return;
    }

    // 20 % increase in footstep sound if sprinting
    if (bIsSprinting)
    {
        SoundVolumeModifier = 1.2;
        SoundRadiusModifier = 1.2;
    }
    // Reduce footstep sound if moving slower (crouching or walking)
    else if (bIsCrouched || bIsWalking)
    {
        SoundVolumeModifier = QuietFootStepVolume;
        SoundRadiusModifier = 0.33; // 1/3 the range of default jog sound, as crouching/walking should be sneaky (but not complete stealth like crawling)
    }
    // Default jogging movement - no sound modifiers
    else
    {
        SoundVolumeModifier = 1.0;
        SoundRadiusModifier = 1.0;
    }

    // Get surface type we are walking on, so we know what kind of sound to play
    if (Base != none && !Base.IsA('LevelInfo') && Base.SurfaceType != EST_Default)
    {
        SurfaceTypeID = Base.SurfaceType;
    }
    else
    {
        Start = Location - (vect(0.0, 0.0, 1.0) * CollisionHeight);
        A = Trace(HitLocation, HitNormal, Start - vect(0.0, 0.0, 16.0), Start, false,, FloorMaterial);

        if (FloorMaterial != none)
        {
            SurfaceTypeID = FloorMaterial.SurfaceType;
        }
    }

    // Play footstep sound, based on surface type & volume/radius modifiers
    PlaySound(SoundFootsteps[SurfaceTypeID], SLOT_Interact, FootstepVolume * SoundVolumeModifier,, FootStepSoundRadius * SoundRadiusModifier);
}

simulated function vector CalcZoomedDrawOffset(Inventory Inv)
{
    local vector DrawOffset;

    if (Controller == none)
    {
        return (Inv.PlayerViewOffset >> Rotation) + BaseEyeHeight * vect(0.0, 0.0, 1.0);
    }

    DrawOffset = 0.9 / Weapon.DisplayFOV * 100.0 * ZoomedModifiedPlayerViewOffset(Inv);

    if (IsLocallyControlled())
    {
        DrawOffset += IronsightBob;
        DrawOffset += ZoomedWeaponBob(Inv.BobDamping);
        DrawOffset += ZoomedCameraShake();
    }

    return DrawOffset;
}

// Modified to have radius on ragdoll sounds
event KImpact(Actor Other, vector Pos, vector ImpactVel, vector ImpactNorm)
{
    local float VelocitySquared, RagHitVolume;

    if (Level.TimeSeconds > (RagLastSoundTime + RagImpactSoundInterval))
    {
        VelocitySquared = VSizeSquared(ImpactVel);
        RagHitVolume = FMin(4.0, (VelocitySquared / 40000.0));
        PlaySound(RagImpactSound, SLOT_None, RagHitVolume,, 10.0,, true);
        RagLastSoundTime = Level.TimeSeconds;
    }
}

// Modified to have radius (so deaths can't be heard like gunshots)
function PlayDyingSound()
{
    if (Level.NetMode == NM_Client || bGibbed)
    {
        return;
    }

    if (HeadVolume.bWaterVolume)
    {
        PlaySound(GetSound(EST_Drown), SLOT_Pain, 2.5 * TransientSoundVolume, true, 80.0);

        return;
    }

    PlaySound(SoundGroupClass.static.GetDeathSound(LastHitIndex), SLOT_Pain, RandRange(20.0, 200.0), true, 80.0,, true);
}

// Modified to remove all DefaultCharacter stuff as just returns nonsense value that can never work & only cause log errors
// Will still work with original PlayerRecord info (from nation's .upl file), but causes no errors when using new RolePawns array in DHRoleInfo classes
// If no PlayerRecord is passed in (i.e. not using .upl file) it only results in setting Species to default Species
simulated function Setup(xUtil.PlayerRecord Rec, optional bool bLoadNow)
{
    if (Rec.Species != none)
    {
        Species = Rec.Species;
    }
    else
    {
        Species = default.Species;
    }

    RagdollOverride = Rec.Ragdoll; // allows PlayerRecord to specify a different ragdoll skeleton (null in new DH pawn model setup system)

    if (Species != none && Species.static.Setup(self, Rec))
    {
        ResetPhysicsBasedAnim();
    }
}

// Modified to fix serious net client bugs introduced in ROPawn override because it can undesirably disable our PostNetReceive (PNR) event
// This function can be called from the PRI's PNR event & that may happen before other crucial set up gets done in our own PNR
// This functionality basically does the same thing as the part of PNR that handled player set up (now moved to SetUpPlayerModel() function)
// In bypassed UT2004 'XPawn' class this function just called its own PNR, which was ok because XPawn's PNR only handled player initialisation, which is what we want
// But ROPawn extended PNR & someone way back realised that impacts on this function & so copied the XPawn's PNR functionality here, without modification
// However, they didn't consider either the changes made to player initialisation in ROPawn's PNR or the impact of setting bNetNotify=false here
// That created 2 major potential problems:
// (1) Before calling Setup() the XPawn functionality didn't have a crucial check added in ROPawn that PRI's CharacterName had been updated & is valid for player's role
// That could cause the 'enemy uniform bug', as described in comments in SetUpPlayerModel()
// (2) It disabled our PNR (bNetNotify=false) even though in ROPawn there are 2 other separate initialisation elements in PNR, which may still be pending
// Those are the bRecievedInitialLoadout & bInitializedWeaponAttachment sections, which would cause major bugs if not executed
// In this override we just do exactly what PNR does in its player initialisation section
simulated function NotifyTeamChanged()
{
    SetUpPlayerModel();
}

// New function for net client to handle setting up the player model when we have received the PRI & its CharacterName property has been updated
// A separate function just to save code duplication in PostNetReceive() & NotifyTeamChanged()
// Original functionality was in ROPawn.PostNetReceive(), but now with crucial fixes for 'uniform bug' where player on net client would sometimes spawn with wrong player model
// Bug was caused because PRI initially has default character model from DarkestHourUser.ini file, which by default is RO's German 'G_Heer1' model, which is obsolete in DH
// When DHPawn is possessed on server, PRI's correct CharacterName gets set & replicates to net clients, natively triggering PRI's UpdateCharacter() event, setting correct model
// But network timing issues, especially in a bad network environment, could result in Setup() being called here BEFORE the PRI's CharacterName gets updated to the client
// Original function included a check for this, but only if player is controlling the DHPawn & it has a PRI, NOT if player is in a vehicle when the DHPawn spawns on client
simulated function SetUpPlayerModel()
{
    local ROPlayerReplicationInfo PRI;

    if (!bInitializedPlayer)
    {
        // Get PRI - but DHPawn may have been replicated to us with player in a vehicle, in which case we need to get the PRI from our controlled DrivenVehicle actor
        if (DrivenVehicle != none && DrivenVehicle.PlayerReplicationInfo != none)
        {
            PRI = ROPlayerReplicationInfo(DrivenVehicle.PlayerReplicationInfo);
        }
        else
        {
            PRI = ROPlayerReplicationInfo(PlayerReplicationInfo);
        }

        // Crucial check that PRI's CharacterName has been updated from default value, but now also checked for a player in a vehicle, which original functionality did not
        // Note than in the new DH pawn set up system, which deprecates PlayerRecords & .upl files, the CharacterName will be null but that is handled fine
        // Using new IsValidCharacterName() function instead of GetModel() as was randomly selecting one role from Models array, which is incorrect for a client validity check
        if (PRI != none && DHRoleInfo(PRI.RoleInfo) != none && DHRoleInfo(PRI.RoleInfo).IsValidCharacterName(PRI.CharacterName))
        {
            Setup(class'xUtil'.static.FindPlayerRecord(PRI.CharacterName));
            bInitializedPlayer = true;
        }
        else if (DrivenVehicle != none && PRI != none && DHRoleInfo(PRI.RoleInfo) != none && !DHRoleInfo(PRI.RoleInfo).IsValidCharacterName(PRI.CharacterName))
            log(PRI.PlayerName @ "SetUpPlayerModel: AVERTED UNIFORM BUG due to PRI.CharacterName" @ PRI.CharacterName @ "being invalid for role" @ PRI.RoleInfo); // TEMPDEBUG (Matt)
    }
}

// Modified so a shallow water volume doesn't send player into swimming state
function SetMovementPhysics()
{
    if (Physics != PHYS_Falling)
    {
        if (PhysicsVolume != none && PhysicsVolume.bWaterVolume && !(PhysicsVolume.IsA('DHWaterVolume') && DHWaterVolume(PhysicsVolume).bIsShallowWater))
        {
            SetPhysics(PHYS_Swimming);
        }
        else
        {
            SetPhysics(PHYS_Walking);
        }
    }
}

// Colin: This is a bit of a half-measure, since we need to retain support for
// "using" the radio trigger normally. Unfortunately, the Pawns is consuming the
// use requests when players are looking directly at the player and trying to
// use the radio. This override simply passes the UsedBy call to the radio
// trigger, if it exists. All error handling and sanity checks are performed
// by the artillery trigger.
function UsedBy(Pawn User)
{
    if (CarriedRadioTrigger != none)
    {
        CarriedRadioTrigger.UsedBy(user);
    }

    super.UsedBy(User);
}

simulated function NotifySelected(Pawn User)
{
    local DHPawn P;
    local DHRoleInfo RI;

    P = DHPawn(User);

    if (P == none ||
        P.GetTeamNum() != GetTeamNum() ||
        Level.NetMode == NM_DedicatedServer ||
        !User.IsHumanControlled() ||
        (Level.TimeSeconds - LastNotifyTime) < TouchMessageClass.default.LifeTime ||
        Health <= 0)
    {
        return;
    }

    if (!P.bUsedCarriedMGAmmo && bWeaponNeedsResupply)
    {
        P.ReceiveLocalizedMessage(TouchMessageClass, 0, self.PlayerReplicationInfo,, User.Controller);
        LastNotifyTime = Level.TimeSeconds;
    }
    else if (bWeaponNeedsReload)
    {
        P.ReceiveLocalizedMessage(TouchMessageClass, 1, self.PlayerReplicationInfo,, User.Controller);
        LastNotifyTime = Level.TimeSeconds;
    }
    else if (CarriedRadioTrigger != none)
    {
        RI = P.GetRoleInfo();

        if (RI != none && RI.bIsArtilleryOfficer)
        {
            P.ReceiveLocalizedMessage(TouchMessageClass, 2, self.PlayerReplicationInfo,, User.Controller);
            LastNotifyTime = Level.TimeSeconds;
        }
    }
}

// DEBUG exec to check whether bInitializedPlayer has been set to true on a net client - run if player spawns with wrong skin
exec function DebugInitPlayer()
{
    Log("DHPawn.bInitializedPlayer =" @ bInitializedPlayer @ " bNetNotify =" @ bNetNotify);
}

// Debug exec to set own player on fire
exec function BurnPlayer()
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        bOnFire = true;
        FireDamage = 1;
    }
}

// Debug exec to increase fly speed
exec function SetFlySpeed(float NewSpeed)
{
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        if (NewSpeed != -1.0)
        {
            AirSpeed = NewSpeed;
        }
        else
        {
            AirSpeed = default.AirSpeed;
        }
    }
}

defaultproperties
{
    // Player model
    Mesh=SkeletalMesh'DHCharacters_anm.Ger_Soldat' // mesh gets set by .upl file but seems to be initial delay until takes effect & pawn spawns with Mesh from defaultproperties
    FaceSlot=0                                     // so unless Mesh is overridden in subclass, pawn spawns with inherited 'Characters_anm.ger_rifleman_tunic' (many German roles do)
    BodySlot=1                                     // that can cause a rash of log errors, as the RO Characters_anm file doesn't have any DH-specific anims

    // General class & interaction stuff
    Species=class'DH_Engine.DHSPECIES_Human'
    ControllerClass=class'DH_Engine.DHBot'
    TouchMessageClass=class'DHPawnTouchMessage'
    bAutoTraceNotify=true
    bCanAutoTraceSelect=true

    // Movement & impacts
    WalkingPct=0.45
    MinHurtSpeed=475.0
    MaxFallSpeed=700.0

    // Stamina
    Stamina=40.0
    StanceChangeStaminaDrain=1.5
    StaminaRecoveryRate=1.15
    CrouchStaminaRecoveryRate=1.3
    ProneStaminaRecoveryRate=1.5
    SlowStaminaRecoveryRate=0.5

    // Weapon aim
    IronsightBobAmplitude=4.0
    IronsightBobFrequency=4.0
    IronsightBobDecay=6.0
    DeployedPitchUpLimit=7300 // bipod
    DeployedPitchDownLimit=-7300

    // Sound
    FootStepSoundRadius=64
    FootstepVolume=0.5
    QuietFootStepVolume=0.66
    DHSoundGroupClass=class'DH_Engine.DHPawnSoundGroup'
    MantleSound=SoundGroup'DH_Inf_Player.Mantling.Mantle'
    HelmetHitSounds(0)=SoundGroup'DH_ProjectileSounds.Bullets.Helmet_Hit'
    PlayerHitSounds(0)=SoundGroup'ProjectileSounds.Bullets.Impact_Player'

    // Burning player
    FireDamage=10
    FireDamageClass=class'DH_Engine.DHBurningDamageType'
    FlameEffect=class'DH_Effects.DHBurningPlayerFlame'
    BurningOverlayMaterial=Combiner'DH_FX_Tex.Fire.PlayerBurningOverlay_ALT'
    DeadBurningOverlayMaterial=Combiner'DH_FX_Tex.Fire.PlayerBurningOverlay'
    CharredOverlayMaterial=Combiner'DH_FX_Tex.Fire.PlayerCharredOverlay'
    BurnedHeadgearOverlayMaterial=Combiner'DH_FX_Tex.Fire.HeadgearBurnedOverlay'

    // Third person player animations
    DodgeAnims(0)="jumpF_mid_nade"
    DodgeAnims(1)="jumpB_mid_nade"
    DodgeAnims(2)="jumpL_mid_nade"
    DodgeAnims(3)="jumpR_mid_nade"

    TakeoffStillAnim="jump_takeoff_nade"
    TakeoffAnims(0)="jumpF_takeoff_nade"
    TakeoffAnims(1)="jumpB_takeoff_nade"
    TakeoffAnims(2)="jumpL_takeoff_nade"
    TakeoffAnims(3)="jumpR_takeoff_nade"

    AirStillAnim="jump_mid_nade"
    AirAnims(0)="jumpF_mid_nade"
    AirAnims(1)="jumpB_mid_nade"
    AirAnims(2)="jumpL_mid_nade"
    AirAnims(3)="jumpR_mid_nade"

    LandAnims(0)="jumpF_land_nade"
    LandAnims(1)="jumpB_land_nade"
    LandAnims(2)="jumpL_land_nade"
    LandAnims(3)="jumpR_land_nade"

    MantleAnim_40C="mantle_crouch_40"
    MantleAnim_44C="mantle_crouch_44"
    MantleAnim_48C="mantle_crouch_48"
    MantleAnim_52C="mantle_crouch_52"
    MantleAnim_56C="mantle_crouch_56"
    MantleAnim_60C="mantle_crouch_60"
    MantleAnim_64C="mantle_crouch_64"
    MantleAnim_68C="mantle_crouch_68"
    MantleAnim_72C="mantle_crouch_72"
    MantleAnim_76C="mantle_crouch_76"
    MantleAnim_80C="mantle_crouch_80"
    MantleAnim_84C="mantle_crouch_84"
    MantleAnim_88C="mantle_crouch_88"
    MantleAnim_40S="mantle_stand_40"
    MantleAnim_44S="mantle_stand_44"
    MantleAnim_48S="mantle_stand_48"
    MantleAnim_52S="mantle_stand_52"
    MantleAnim_56S="mantle_stand_56"
    MantleAnim_60S="mantle_stand_60"
    MantleAnim_64S="mantle_stand_64"
    MantleAnim_68S="mantle_stand_68"
    MantleAnim_72S="mantle_stand_72"
    MantleAnim_76S="mantle_stand_76"
    MantleAnim_80S="mantle_stand_80"
    MantleAnim_84S="mantle_stand_84"
    MantleAnim_88S="mantle_stand_88"

    // Override binoculars WalkAnims from ROPawn that don't exist
    // Normally these are overridden by weapon-specific anims in the weapon attachment class (PA_WalkAnims), so the problem was masked in RO
    // But DH now allows player to drop their weapon without bringing up another & this means it falls back to these WalkAnims
    // When the player walks without a weapon the missing anims caused the player to 'slide' walk,  without animation, with spammed log errors
    WalkAnims(0)="stand_walkFhip_nade"
    WalkAnims(1)="stand_walkBhip_nade"
    WalkAnims(2)="stand_walkLhip_nade"
    WalkAnims(3)="stand_walkRhip_nade"
    WalkAnims(4)="stand_walkFLhip_nade"
    WalkAnims(5)="stand_walkFRhip_nade"
    WalkAnims(6)="stand_walkBLhip_nade"
    WalkAnims(7)="stand_walkBRhip_nade"

    // Override LimpAnims from ROPawn that don't exist & don't appear to be used anyway
    // Possible they're used in native code (as with some other movement anims), but even if so that code must be doing HasAnim() checks as we get no log errors
    LimpAnims(0)=""
    LimpAnims(1)=""
    LimpAnims(2)=""
    LimpAnims(3)=""
    LimpAnims(4)=""
    LimpAnims(5)=""
    LimpAnims(6)=""
    LimpAnims(7)=""
}
