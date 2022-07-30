//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHPawn extends ROPawn
    dependson(DHConstructionSupplyAttachment)
    config(User);

// General
// TODO: I'm sure we can just use existing OldController ref instead of adding SwitchingController, but want to make certain 1st (Matt)
var     Controller          SwitchingController; // needed by KDriverEnter() when switched vehicle position, as player no longer briefly re-possesses DHPawn before entering new position
var     DHRadio Radio; // for storing the trigger on a radioman each spawn, for the purpose of deleting it on death
var     bool    bWeaponNeedsReload;       // whether an AT weapon is loaded or not
var     bool    bCarriesExtraAmmo;        // used to determine if this pawn can carry extra ammo
var     float   StanceChangeStaminaDrain; // how much stamina is lost by changing stance
var     float   MinHurtSpeed;             // when a moving player lands, if they're moving faster than this speed they'll take damage
var     vector  LastWhizLocation;         // last whiz sound location on pawn (basically a non-replicated version of Pawn's mWhizSoundLocation, as we no longer want it to replicate)
var     bool    bHasBeenPossessed;        // fixes players getting new ammunition when they get out of vehicles
var     bool    bNeedToAttachDriver;      // flags that net client was unable to attach Driver to VehicleWeapon, as hasn't yet received VW actor (tells vehicle to do it instead)
var     bool    bClientSkipDriveAnim;     // set by vehicle replicated to net client that's already played correct initial driver anim, so DriveAnim doesn't override that
var     bool    bClientPlayedDriveAnim;   // flags that net client already played DriveAnim on entering vehicle, so replicated vehicle knows not to set bClientSkipDriveAnim
var     bool    bCanPickupWeapons;

// Common Sounds
// ** We are overwriting ROPawn here to expand for our custom surface types **
var(Sounds) sound   DHSoundFootsteps[50]; // Indexed by ESurfaceTypes (sorry about the literal).

// Player model
var     array<material> FaceSkins;        // list of body & face skins to be randomly selected for pawn
var     array<material> BodySkins;
var     byte    PackedSkinIndexes;        // server packs selected index numbers for body & face skins into a single byte for most efficient replication to net clients
var     bool    bReversedSkinsSlots;      // some player meshes have the typical body & face skin slots reversed, so this allows it to be assigned per pawn class
                                          // TODO: fix the reversed skins indexing in player meshes to standardise with body is 0 & face is 1 (as in RO), then delete this
var     string  ShovelClassName;          // name of shovel class, so can be set for different nations (string name not class, due to build order)
var     bool    bShovelHangsOnLeftHip;    // shovel hangs on player's left hip, which is the default position - otherwise it goes on player's backpack (e.g. US shovel)

var     string  BinocsClassName;

// Mortars
var     Actor   OwnedMortar;              // mortar vehicle associated with this actor, used to destroy mortar when player dies
var     bool    bIsDeployingMortar;       // whether or not the pawn is deploying his mortar - used for disabling movement
var     bool    bMortarCanBeResupplied;
var     int     MortarHEAmmo;
var     int     MortarSmokeAmmo;
var     bool    bLockViewRotation;
var     rotator LockViewRotation;

// Obstacle clearing
var     bool    bCanCutWire;
var     bool    bIsCuttingWire;

// Spawning
var     DHSpawnPointBase    SpawnPoint;        // the spawn point that was used to spawn this pawn
var     float               SpawnProtEnds;     // is set when a player spawns/teleports for "spawn" protection in selectable spawn maps
var     float               SpawnKillTimeEnds; // is set when a player spawns
var     bool                bCombatSpawned;    // indicates the pawn was spawned in combat

// Supply
var     array<DHConstructionSupplyAttachment> TouchingSupplyAttachments;
var     int                 TouchingSupplyCount;

// Armored vehicle locking
var     DHArmoredVehicle    CrewedLockedVehicle; // a locked armored vehicle that this player is allowed to enter
var     bool                bInLockedVehicle;    // player is in a locked vehicle (only to replicate to net client to display locked icon on vehicle HUD)

// Touch messages
var     class<LocalMessage> TouchMessageClass;
var     float               LastNotifyTime;

// Ironsight bob
var     float   IronsightBobTime;
var     vector  IronsightBob;
var     float   IronsightBobAmplitude;
var     float   IronsightBobFrequencyY;
var     float   IronsightBobFrequencyZ;
var     float   IronsightBobDecay;

// Hit sounds
var     array<sound>    PlayerHitSounds;
var     array<sound>    HelmetHitSounds;

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

// Diggin
var     bool    bCanDig;

var(ROAnimations)   name        MantleAnim_40C, MantleAnim_44C, MantleAnim_48C, MantleAnim_52C, MantleAnim_56C, MantleAnim_60C, MantleAnim_64C,
                                MantleAnim_68C, MantleAnim_72C, MantleAnim_76C, MantleAnim_80C, MantleAnim_84C, MantleAnim_88C;

var(ROAnimations)   name        MantleAnim_40S, MantleAnim_44S, MantleAnim_48S, MantleAnim_52S, MantleAnim_56S, MantleAnim_60S, MantleAnim_64S,
                                MantleAnim_68S, MantleAnim_72S, MantleAnim_76S, MantleAnim_80S, MantleAnim_84S, MantleAnim_88S;

// Burning player
var     bool                bOnFire;                       // whether Pawn is on fire or not
var     bool                bBurnFXOn;                     // whether Fire FX are enabled or not
var     bool                bCharred;                      // for switching in a charred overlay after the fire goes out
var     class<Emitter>      FlameEffect;                   // the fire sprite emitter class
var     Emitter             FlameFX;                       // spawned instance of the above
var     material            BurningOverlayMaterial;        // overlay for when player is on fire
var     material            DeadBurningOverlayMaterial;    // overlay for when player is on fire and dead
var     material            CharredOverlayMaterial;        // overlay for dead, burned players after flame extinguished
var     material            BurnedHeadgearOverlayMaterial; // overlay for burned hat
var     int                 FireDamage;
var     class<DamageType>   FireDamageClass;               // the damage type that started the fire
var     int                 BurnTimeLeft;                  // number of seconds remaining for a corpse to burn
var     float               LastBurnTime;                  // last time we did fire damage to the Pawn
var     Pawn                FireStarter;                   // who set a player on fire

// Gore
var     bool                bHeadSevered; //we want heads to be able to be blown off if large enough caliber locational hit

// Smoke grenades for squad leaders
var DH_LevelInfo.SNationString SmokeGrenadeClassName;
var DH_LevelInfo.SNationString ColoredSmokeGrenadeClassName;
var int RequiredSquadMembersToReceiveSmoke;
var int RequiredSquadMembersToReceiveColoredSmoke;

// (not) DUMB SHIT
var     DHATGun             GunToRotate;

var     DHBackpack          Backpack;
var     class<DHBackpack>   BackpackClass;

replication
{
    // Variables the server will replicate to clients when this actor is 1st replicated
    reliable if (bNetInitial && bNetDirty && Role == ROLE_Authority)
        PackedSkinIndexes;

    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        TouchingSupplyCount, bInLockedVehicle, bCarriesExtraAmmo;

    // Variables the server will replicate to all clients except the one that owns this actor
    reliable if (!bNetOwner && bNetDirty && Role == ROLE_Authority)
        bWeaponNeedsReload;

    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bOnFire, bCrouchMantle, MantleHeight, Radio;

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerGiveWeapon;

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        ClientPawnWhizzed, ClientExitATRotation;
}

// Modified to use DH version of bullet whip attachment, & to remove its SavedAuxCollision (deprecated as now we simply enable/disable collision in ToggleAuxCollision function)
// Also removes needlessly setting some variables to what will be default values anyway for a spawning actor
simulated function PostBeginPlay()
{
    super(Pawn).PostBeginPlay();

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

// Modified to set up any random selection of body & face skins for the player mesh
// Also to skip over the Super in ROPawn, so net client doesn't spawn a headgear or ammo pouch attachments, which instead is done in PostNetReceive()
// That solves network timing problems as for player's own pawn this gets called before server has time to possess pawn & set & replicate its attachment classes
// Also the bot squad/roster stuff (originally from UnrealPawn) is irrelevant in RO/DH, as Level.bStartup is never true (only applies to pawns placed in the level)
simulated function PostNetBeginPlay()
{
    super(Pawn).PostNetBeginPlay();

    SetBodyAndFaceSkins();
}

// Modified to fix 'uniform bug' where player on net client would sometimes spawn with wrong player model (most commonly an allied player spawning as a German)
// The functionality is now in a new SetUpPlayerModel() function to avoid code duplication, so see that function for explanatory comments
// Also so we don't pointlessly try to check for the inventory of other players, as it won't get replicated to us anyway & the check is only relevant to player's own pawn
// That resulted in all the other pawns doing this inventory loop check constantly throughout the round & so never setting bNetNotify false to disable PostNetReceive!
// Also to spawn decorative attachments for any headgear or ammo pouches, instead of doing this in PostNetBeginPlay()
// That solves network timing problems where PostNetBeginPlay() is called before server has time to possess pawn & set & replicate its attachment classes
simulated function PostNetReceive()
{
    local PlayerController PC;
    local Inventory        Inv;
    local bool             bVerifiedPrimary, bVerifiedSecondary, bVerifiedGrenades;
    local int              i;

    // If this is the local player's pawn, flag bRecievedInitialLoadout when all our role's weapons & equipment have been replicated, then switch to best weapon
    // But now if it's another player's pawn, we just flag bRecievedInitialLoadout so these checks are skipped
    // Re-factored to avoid repeating checks when already confirmed, or carrying out checks if we now other checks have failed
    if (!bRecievedInitialLoadout)
    {
        PC = Level.GetLocalPlayerController();

        if (PC != none)
        {
            // If this is our own pawn, check whether we've now received our full inventory
            if (PC == Controller)
            {
                for (Inv = Inventory; Inv != none; Inv = Inv.Inventory)
                {
                    if (Weapon(Inv) != none && Inv.Instigator != none)
                    {
                        if (!bVerifiedPrimary && VerifyPrimary(Inv))
                        {
                            bVerifiedPrimary = true;
                        }

                        if (!bVerifiedSecondary && VerifySecondary(Inv))
                        {
                            bVerifiedSecondary = true;
                        }

                        // TODO: unlike primary & secondary weapons, role can have > 1 grenade, so think this needs to include an item count, similar to GivenItems
                        if (!bVerifiedGrenades && VerifyNades(Inv))
                        {
                            bVerifiedGrenades = true;
                        }
                    }

                    if (++i > 500) // runaway loop safeguard
                    {
                        break;
                    }
                }

                // If we have our inventory then switch to best weapon
                if (bVerifiedPrimary && bVerifiedSecondary && bVerifiedGrenades && VerifyGivenItems())
                {
                    bRecievedInitialLoadout = true;

                    if (Controller != none)
                    {
                        Controller.SwitchToBestWeapon();
                    }
                }
            }
            // Or if we can confirm this must be another player's pawn, just flag bRecievedInitialLoadout so we don't check again
            else if ((PC.Pawn != self && PC.Pawn != none) || (PC.PlayerReplicationInfo != none && PC.PlayerReplicationInfo.bIsSpectator))
            {
                bRecievedInitialLoadout = true;
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

    // Spawn decorative attachments for any headgear or ammo pouches when we receive the server's choice
    if (Headgear == none && HeadgearClass != default.HeadgearClass && HeadgearClass != none)
    {
        Headgear = Spawn(HeadgearClass, self);
    }

    // Backpack
    if (Backpack == none &&
        BackpackClass != default.BackpackClass &&
        BackpackClass != none)
    {
        Backpack = Spawn(BackpackClass, self);
    }

    if (AmmoPouches.Length == 0 && AmmoPouchClasses[0] != default.AmmoPouchClasses[0] && AmmoPouchClasses[0] != none)
    {
        for (i = 0; i < ArrayCount(AmmoPouchClasses); i++)
        {
            if (AmmoPouchClasses[i] == none)
            {
                break;
            }

            AmmoPouches[AmmoPouches.Length] = Spawn(AmmoPouchClasses[i], self);
        }
    }

    // Disable PostNetReceive() notifications once we have initialised everything for this pawn
    if (bInitializedPlayer && bInitializedWeaponAttachment && bRecievedInitialLoadout
        && HeadgearClass != default.HeadgearClass && AmmoPouchClasses[0] != default.AmmoPouchClasses[0])
    {
        bNetNotify = false;
    }
}

simulated event SetHeadScale(float NewScale)
{
    HeadScale = NewScale;
    SetBoneScale(4,HeadScale,'head');

    if (Headgear != none)
    {
        Headgear.SetDrawScale(HeadScale);
    }

    // Increase scale of main collision hitbox (whole body hitbox used first to make sure you hit a target)
    // We shouldn't increase this on the same scale as the head as the main collision hitbox will be way too large
    HitPoints[0].PointRadius = 60.0 * HeadScale;
    HitPoints[0].PointHeight = 75.0 * HeadScale;

    // Adjust scale of head hitbox
    HitPoints[1].PointRadius = 6.5 * HeadScale;
    HitPoints[1].PointHeight = 8.0 * HeadScale;
}

// Modified so if player is on fire we cause fire damage every second, & force him to drop any weapon he in carrying in his hands
// We also enable burning effects when he first catches fire, or stop them if he's no longer on fire
simulated function Tick(float DeltaTime)
{
    local int i;

    super.Tick(DeltaTime);

    // If player is on fire, cause fire damage every second & force him to drop any weapon in his hands
    // Would prefer to do this in a Timer but too many states hijack timer and reset it on us
    // I don't want to have to override over a dozen functions just to do damage every second
    if (bOnFire && Role == ROLE_Authority && (Level.TimeSeconds - LastBurnTime) > 1.0 && Health > 0)
    {
        TakeDamage(FireDamage, FireStarter, Location, vect(0.0, 0.0, 0.0), FireDamageClass);

        if (Weapon != none)
        {
            BurningPlayerDropWeapon();
        }
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        // Start burning player effects if player is on fire, & make him drop any weapon in his hands
        if (bOnFire)
        {
            if (!bBurnFXOn)
            {
                StartBurnFX();
            }
        }
        // Stop burning player effects if place is no longer on fire
        else if (bBurnFXOn)
        {
            EndBurnFX();
        }
    }

    if (Role == ROLE_Authority)
    {
        // Recalculate the total supply count for our pawn, or -1 if there are
        // no supplies around.
        if (TouchingSupplyAttachments.Length == 0)
        {
            TouchingSupplyCount = -1;
        }
        else
        {
            TouchingSupplyCount = 0;

            for (i = 0; i < TouchingSupplyAttachments.Length; ++i)
            {
                if (TouchingSupplyAttachments[i] != none)
                {
                    TouchingSupplyCount += TouchingSupplyAttachments[i].GetSupplyCount();
                }
            }
        }
    }
}

// Modified to give a mortar operator his default carried mortar ammunition
// Also to fix bugs caused because PossessedBy gets called every time a player gets out of a vehicle & re-possesses his player pawn
// Each time a server was making new random selection of HeadgearClass for roles that have multiple possibilities
// Net clients then saw changing headgear on other players whose pawns got re-replicated & re-spawned(i.e. dropped out of network relevance & back in)
// And standalones & listen servers were spawning a new Headgear attachment each time
function PossessedBy(Controller C)
{
    local DHRoleInfo                 RI;
    local ROPlayer                   PC;
    local ROBot                      Bot;
    local array<class<ROAmmoPouch> > AmmoClasses;
    local class<DHMortarWeapon>      MortarClass;
    local int                        PrimaryWeapon, SecondaryWeapon, GrenadeWeapon, i;

    super(Pawn).PossessedBy(C);

    if (Controller != none)
    {
        OldController = Controller; // OldController records our controller so it can be used even after this pawn gets unpossessed, e.g. when dead

        if (Controller.IsA('DHPlayer'))
        {
            bMantleDebug = DHPlayer(Controller).bMantleDebug;
        }
    }

    // Pass current stamina to net client
    ClientForceStaminaUpdate(Stamina);

    // Stuff we should only do when this pawn is first possessed (fixes bugs & avoids wasting processing)
    if (!bHasBeenPossessed)
    {
        bHasBeenPossessed = true;
        RI = GetRoleInfo();

        if (RI != none)
        {
            // Apply role modifiers (implemented for Halloween 2021 event)
            bCanPickupWeapons = RI.bCanPickupWeapons;
            Health *= RI.HealthMultiplier;

            // Set classes for any ammo pouches based on player's role & weapon selections
            PC = ROPlayer(Controller);

            if (PC != none)
            {
                PrimaryWeapon = PC.PrimaryWeapon;
                SecondaryWeapon = PC.SecondaryWeapon;
                GrenadeWeapon = PC.GrenadeWeapon;
            }
            else
            {
                Bot = ROBot(Controller);

                if (Bot != none)
                {
                    PrimaryWeapon = Bot.PrimaryWeapon;
                    SecondaryWeapon = Bot.SecondaryWeapon;
                    GrenadeWeapon = Bot.GrenadeWeapon;
                }
            }

            RI.GetAmmoPouches(AmmoClasses, PrimaryWeapon, SecondaryWeapon, GrenadeWeapon);

            if (AmmoClasses.Length > 0)
            {
                for (i = 0; i < AmmoClasses.Length; ++i)
                {
                    AmmoPouchClasses[i] = AmmoClasses[i];
                }
            }
            else
            {
                AmmoPouchClasses[0] = none; // if no ammo pouch attachments, set 1st replicated array member to none (from default dummy class) so client detects the change
            }

            // Set classes for headgear & severed limbs, based on player's role
            // Any random headgear selection for role gets made here, when pawn first possessed
            HeadgearClass = RI.GetHeadgear();
            BackpackClass = RI.GetBackpack();
            DetachedArmClass = RI.static.GetArmClass();
            DetachedLegClass = RI.static.GetLegClass();

            // Spawn decorative attachments for any headgear & ammo pouches
            // This is for standalones or listen server hosts; a net client does this is PostNetReceive() when the classes get replicated to it
            if (Level.NetMode != NM_DedicatedServer)
            {
                if (HeadgearClass != none && HeadgearClass != default.HeadgearClass && Headgear == none)
                {
                    Headgear = Spawn(HeadgearClass, self);
                }

                if (BackpackClass != none && BackpackClass != default.BackpackClass && Backpack == none)
                {
                    Backpack = Spawn(BackpackClass, self);
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

            // Give a mortar operator his default carried mortar ammunition
            // Don't have weapons yet, so have to get mortar class from role's GivenItems array
            if (RI.bCanUseMortars)
            {
                for (i = 0; i < RI.GivenItems.Length; ++i)
                {
                    if (RI.GivenItems[i] != "")
                    {
                        MortarClass = class<DHMortarWeapon>(Level.Game.BaseMutator.GetInventoryClass(RI.GivenItems[i]));

                        if (MortarClass != none)
                        {
                            MortarHEAmmo = MortarClass.default.HighExplosiveMaximum;
                            MortarSmokeAmmo = MortarClass.default.SmokeMaximum;
                            break;
                        }
                    }
                }
            }
        }
    }

    NetUpdateTime = Level.TimeSeconds - 1.0;
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

            if (VSizeSquared(Velocity) < 25.0) // if player isn't moving significantly
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
                    else if (WeaponAttachment.WA_Idle != '')
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

// Modified to match dropped helmet mesh skin to original helmet skin, including a burned overlay if player is on fire
// Slight re-factor for clarity
simulated function HelmetShotOff(rotator RotDir)
{
    local DroppedHeadgear DroppedHelmet;

    if (Headgear == none)
    {
        return;
    }

    DroppedHelmet = Spawn(class'DroppedHeadGear',,, Headgear.Location, Headgear.Rotation);

    if (DroppedHelmet != none)
    {
        DroppedHelmet.LinkMesh(Headgear.Mesh);

        if (Headgear.Skins.Length > 0 && Headgear.Skins[0] != none)
        {
            DroppedHelmet.Skins[0] = Headgear.Skins[0];
        }

        if (bOnFire)
        {
            DroppedHelmet.SetOverlayMaterial(BurnedHeadgearOverlayMaterial, 999.0, true);
        }

        DroppedHelmet.Velocity = Velocity + vector(RotDir) * (DroppedHelmet.MaxSpeed * (1.0 + FRand() * 0.5));
        DroppedHelmet.LifeSpan -= FRand() * 2.0;

        Headgear.Destroy();
        HeadgearClass = none; // server should replicate this but let's make sure by setting it immediately
    }
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

// Returns true if this pawn spawned on a combat spawnpoint (MDV, Squad Rally, HQ)
function bool IsCombatSpawned()
{
    return bCombatSpawned;
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
    if (WhizType != 0 && Role < ROLE_Authority)
    {
        PawnWhizzed(WhizLocation, int(WhizType));
    }
}

// Emptied out to prevent playing old whiz sounds over the top of the new
// This event is called by native code when net client receives a changed replicated value of SpawnWhizCount,
// but should no longer be called as I've stopped PawnWhizzed from replicating whiz variables
simulated event HandleWhizSound()
{
}

// Modified so player pawn's AuxCollisionCylinder (the bullet whip attachment) only retains its collision if player is entering a VehicleWeaponPawn in an exposed position
// Part of new vehicle occupant hit detection system, which basically keeps normal hit detection as for an infantry player pawn, if the player is exposed
// Also so player's CullDistance isn't set to 5000 (83m) when in vehicle, as caused exposed players to disappear at quite close ranges when often should be highly visible
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

        // Set driver visibility - slight change so now we always set whether or not the driver is hidden, based on vehicle's bDrawDriverinTP setting
        // When switching vehicle positions, we no longer briefly repossess the player pawn & receive StopDriving(), so bHidden won't have been reset to default false
        // Also we no longer set a visible player's CullDistance to 5000 (83m), as caused exposed players to disappear at quite close ranges
        bHidden = !V.bDrawDriverinTP;
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

// Modified to avoid re-enabling collision to a player killed in vehicle as it can cause some vehicles to jump wildly when player is killed in vehicle with other occupants
// Seems to be some sort of collision clash when player's collision is re-enabled & he's inside the vehicle's collision - leaving collision disabled is harmless
// Also so exiting into a shallow water volume doesn't send player into swimming state
// Note that on a net client it appears that this function is triggered natively when the value of DrivenVehicle gets reset to none
// A function comment in class 'Pawn' says StartDriving/StopDriving are triggered by transitions of bIsDriving, but it appears that does nothing & bIsDriving isn't used
simulated function StopDriving(Vehicle V)
{
    if (Role == ROLE_Authority && IsHumanControlled() && V != none)
    {
        V.PlayerStartTime = Level.TimeSeconds + 12.0; // tells bots not to enter this vehicle position for a little while
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
    bCollideWorld = true;
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

// New function used by vehicle pawns to record their Controller (as SwitchingController) before a player switches vehicle position
// SwitchingController is now needed by KDriverEnter() when switched positions, as the player no longer briefly re-possesses his DHPawn before entering the new position
function SetSwitchingController(Controller C)
{
    SwitchingController = C;
}

// New function to set a player's reference to a locked vehicle that this player is allowed to enter, or to clear it passing 'none'
function SetCrewedLockedVehicle(DHArmoredVehicle NewLockedVehicleRef)
{
    local DHArmoredVehicle OldLockedVehicle;

    // Update player's locked vehicle reference, but first save the old vehicle
    OldLockedVehicle = CrewedLockedVehicle;
    CrewedLockedVehicle = NewLockedVehicleRef;

    // Player has stopped being registered as an allowed crewman in a vehicle that hasn't been destroyed
    if (OldLockedVehicle != none && CrewedLockedVehicle != OldLockedVehicle && OldLockedVehicle.Health > 0)
    {
        // Player is no longer relevant to the old vehicle, so get it to check whether it should now be unlocked or set an unlock timer
        // Means player has either died, or has now become an allowed crewman in a different locked vehicle (can only be registered in one locked vehicle)
        if (OldLockedVehicle.bVehicleLocked)
        {
            OldLockedVehicle.CheckUnlockVehicle();
        }
        // Player's locked vehicle just became unlocked as it was left without tank crew for too long, so notify the player
        else if (OldLockedVehicle.UnlockVehicleTime != 0.0 && Level.TimeSeconds > OldLockedVehicle.UnlockVehicleTime)
        {
            if (DrivenVehicle != none)
            {
                DrivenVehicle.ReceiveLocalizedMessage(class'DHVehicleMessage', 23); // "You left your locked vehicle for too long and it's now unlocked"
            }
            else
            {
                ReceiveLocalizedMessage(class'DHVehicleMessage', 23); // "You left your locked vehicle for too long and it's now unlocked"
            }
        }
    }
}

// New function to set player's bInLockedVehicle flag, which replicates to net clients so their vehicle HUD knows whether to display a locked vehicle icon
// Note we don't waste replication updating this to false if player isn't in a vehicle as it's only used by a vehicle HUD & when on foot it's irrelevant
// So all we need to do is make sure it's updated if the player enters a vehicle (any vehicle), & also if the vehicle's lock is toggled
function SetInLockedVehicle(bool bNewStatus)
{
    bInLockedVehicle = bNewStatus;
}

// Modified to deprecate SavedAuxCollision & simply enable or disable collision based on passed bool
simulated function ToggleAuxCollision(bool bEnabled)
{
    if (AuxCollisionCylinder != none)
    {
        AuxCollisionCylinder.SetCollision(bEnabled, false);
    }
}

// Modified so server sets HeadgearClass to none if player takes a hit to the head & survives, which in DH knocks any headgear off (happens in ProcessHitFX)
// Clearing HeadgearClass stops client from re-spawning player's original headgear if he gets re-replicated & re-spawned on another net client, after dropping out of network relevancy
// Also re-factored to optimise & make clearer
function DoDamageFX(name BoneName, int Damage, class<DamageType> DamageType, rotator RotDir)
{
    local float       DismemberProbability;
    local int         RandomBone, i;
    local bool        bSever;
    local array<name> SeveredLimbs;

    if (DamageType != none && (Damage > 30 || Health <= 0 || FRand() > 0.3))
    {
        // If hit player is dead
        if (Health <= 0)
        {
            // Get bone name for hit effects
            if (Damage > DamageType.default.HumanObliterationThreshhold && Damage != 1000)
            {
                BoneName = 'obliterate';
            }
            else
            {
                switch (BoneName)
                {
                    case 'lfoot':
                    case 'lthigh':
                    case 'lupperthigh':
                        BoneName = 'lthigh';
                        break;

                    case 'rfoot':
                    case 'rthigh':
                    case 'rupperthigh':
                        BoneName = 'rthigh';
                        break;

                    case 'lhand':
                    case 'lfarm':
                    case 'lupperarm':
                    case 'lshoulder':
                        BoneName = 'lfarm';
                        break;

                    case 'rhand':
                    case 'rfarm':
                    case 'rupperarm':
                    case 'rshoulder':
                        BoneName = 'rfarm';
                        break;

                    case 'None':
                        BoneName = 'spine';
                        break;
                }
            }

            // Check whether a body part should be severed
            if (!class'GameInfo'.static.UseLowGore())
            {
                if (DamageType.default.bAlwaysSevers || Damage == 1000)
                {
                    bSever = true;
                }
                else if (DamageType.default.GibModifier > 0.0)
                {
                    DismemberProbability = Abs((Health - (Damage * DamageType.default.GibModifier)) / 130.0);
                    bSever = DismemberProbability >= 1.0 || FRand() < DismemberProbability;
                }

                // If severing a limb & the hit is to the head or spine, switch our bone to a random limb
                // Added head to this list as in ROPawn sending 'head' with bSever caused helmet to be shot off, but in DH any head hit knocks headgear off
                // So in DH sending 'head' is pointless & does nothing, as the action has been removed from the severed bone list in ProcessHitFX
                if (bSever && !DamageType.default.bLocationalHit && (BoneName == 'head' || BoneName == 'Spine' || BoneName == 'Upperspine'))
                {
                    RandomBone = Rand(4);

                    switch (RandomBone)
                    {
                        case 0:
                            BoneName = 'lthigh';
                            break;
                        case 1:
                            BoneName = 'rthigh';
                            break;
                        case 2:
                            BoneName = 'lfarm';
                            break;
                        case 3:
                            BoneName = 'rfarm';
                            break;
                        default:
                            BoneName = 'lthigh';
                    }
                }
            }
        }
        // If player is still alive, a hit to the head will knock off any headgear, so set replicated HeadgearClass to none
        else if (BoneName == 'head' && HeadgearClass != none)
        {
            HeadgearClass = none;
        }

        // Now set the replicated HitFX properties & increment the replicated HitFxTicker counter to trigger ProcessHitFX() on all modes
        HitFX[HitFxTicker].DamType = DamageType;
        HitFX[HitFxTicker].Bone = BoneName;
        HitFX[HitFxTicker].bSever = bSever;
        HitFX[HitFxTicker].RotDir = RotDir;

        HitFxTicker = ++HitFxTicker % arraycount(HitFX); // increment counter, looping back to 0 if reached end

        // If this was really hardcore damage from an explosion, also add some random extra 'hits' that may generate extra severed limbs
        if (bSever && !DamageType.default.bLocationalHit && Damage > 200 && Damage != 1000)
        {
            if ((Damage > 400 && FRand() < 0.3) || FRand() < 0.1 )
            {
                SeveredLimbs[SeveredLimbs.Length] = 'head';
                SeveredLimbs[SeveredLimbs.Length] = 'lthigh';
                SeveredLimbs[SeveredLimbs.Length] = 'rthigh';
                SeveredLimbs[SeveredLimbs.Length] = 'lfarm';
                SeveredLimbs[SeveredLimbs.Length] = 'rfarm';
            }
            else if (FRand() < 0.25)
            {
                SeveredLimbs[SeveredLimbs.Length] = 'lthigh';
                SeveredLimbs[SeveredLimbs.Length] = 'rthigh';

                if (FRand() < 0.5)
                {
                    SeveredLimbs[SeveredLimbs.Length] = 'lfarm';
                }
                else
                {
                    SeveredLimbs[SeveredLimbs.Length] = 'rfarm';
                }
            }
            else if (FRand() < 0.35)
            {
                SeveredLimbs[SeveredLimbs.Length] = 'lthigh';
            }
            else if (FRand() < 0.5)
            {
                SeveredLimbs[SeveredLimbs.Length] = 'rthigh';
            }
            else if (FRand() < 0.75)
            {
                if (FRand() < 0.5)
                {
                    SeveredLimbs[SeveredLimbs.Length] = 'lfarm';
                }
                else
                {
                    SeveredLimbs[SeveredLimbs.Length] = 'rfarm';
                }
            }

            for (i = 0; i < SeveredLimbs.Length; ++i)
            {
                if (SeveredLimbs[i] != BoneName) // if same as our BoneName then skip, as we've already caused this limb to be severed
                {
                    DoDamageFX(SeveredLimbs[i], 1000, DamageType, RotDir);
                }
            }
        }
    }
}

// Modified so any hit to the head will knock off any headgear (in RO it only happened if the player was killed), & to play bullet impact sound for a helmet hit
// Also re-factored to optimise & make clearer
simulated function ProcessHitFX()
{
    local class<SeveredAppendage> SeveredLimbClass;
    local name                    BoneName;
    local vector                  BoneLocation;
    local rotator                 RotDir;
    local float                   GibPerterbation;
    local int                     LoopCount;

    if (Level.NetMode == NM_DedicatedServer)
    {
        SimHitFxTicker = HitFxTicker;

        return;
    }

    // Loop from last recorded SimHitFxTicker to latest HitFxTicker & play each hit effect
    for (SimHitFxTicker = SimHitFxTicker; SimHitFxTicker != HitFxTicker; SimHitFxTicker = ++SimHitFxTicker % arraycount(HitFX))
    {
        if (++LoopCount > 30) // runaway loop safeguard
        {
            SimHitFxTicker = HitFxTicker;

            return;
        }

        if (HitFX[SimHitFxTicker].DamType == none || (Level.bDropDetail && !IsHumanControlled() && (Level.TimeSeconds - LastRenderTime) > 3.0))
        {
            continue;
        }

        BoneName = HitFX[SimHitFxTicker].Bone;
        RotDir = HitFX[SimHitFxTicker].RotDir;

        // If no gore is enabled we skip any effects for player being gibbed, blood spurting or severed limbs
        // Blood was previously subject to a separate NoBlood() check, but in RO/DH it serves no different purpose as gore setting gets forced to either full or no gore
        if (!class'GameInfo'.static.UseLowGore())
        {
            // A passed BoneName 'obliterate' causes player to be completely gibbed (& we go no further here)
            if (BoneName == 'obliterate')
            {
                SpawnGibs(RotDir, 0.0);
                bGibbed = true;
                Destroy();

                return;
            }

            BoneLocation = GetBoneCoords(BoneName).Origin;

            // Show blood spurting from body's hit location
            if (!Level.bDropDetail && BoneName != '')
            {
                AttachEffect(BleedingEmitterClass, BoneName, BoneLocation, RotDir);
            }

            // Spawn a severed limb if that's indicated (& allowed)
            if (HitFX[SimHitFxTicker].bSever)
            {
                switch (BoneName)
                {
                    case 'lthigh':
                    case 'lupperthigh':
                        if (!bLeftLegGibbed)
                        {
                            SeveredLimbClass = DetachedLegClass;
                            bLeftLegGibbed = true;
                        }
                        break;

                    case 'rthigh':
                    case 'rupperthigh':
                        if (!bRightLegGibbed)
                        {
                            SeveredLimbClass = DetachedLegClass;
                            bRightLegGibbed = true;
                        }
                        break;

                    case 'lfarm':
                    case 'lupperarm':
                        if (!bLeftArmGibbed)
                        {
                            SeveredLimbClass = DetachedArmClass;
                            bLeftArmGibbed = true;
                        }
                        break;

                    case 'rfarm':
                    case 'rupperarm':
                        if (!bRightArmGibbed)
                        {
                            SeveredLimbClass = DetachedArmClass;
                            bRightArmGibbed = true;
                        }
                        break;

                    case 'head':
                        if (!bHeadSevered)
                        {
                            bHeadSevered = true;
                            HideBone('head'); //just literally blow it off
                        }
                        break;
                }

                if (SeveredLimbClass != none)
                {
                    GibPerterbation = HitFX[SimHitFxTicker].DamType.default.GibPerterbation;
                    SpawnGiblet(SeveredLimbClass, BoneLocation, RotDir, GibPerterbation);
                    HideBone(BoneName);
                }
            }
        }

        // Hit to the head knocks off any headgear, with an impact sound
        if (BoneName == 'head' && Headgear != none)
        {
            if (Headgear.IsA('DHHeadgear') && DHHeadgear(Headgear).bIsHelmet) // TODO: check this is a projectile weapon DamType before playing bullet impact sounds?
            {
                if (HitDamageType != none && HitDamageType.default.HumanObliterationThreshhold == 1000001)
                {
                    Headgear.PlaySound(HelmetHitSounds[Rand(HelmetHitSounds.Length)], SLOT_None, 2.0,, 8,, true);
                }
                else
                {
                    Headgear.PlaySound(HelmetHitSounds[Rand(HelmetHitSounds.Length)], SLOT_None, RandRange(100.0, 150.0),, 80,, true);
                }
            }

            HelmetShotOff(RotDir);
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
            PlaySound(PlayerHitSounds[Rand(PlayerHitSounds.Length)], SLOT_None, 3.0, false, 100.0);
        }

        HitDamageType = DamageType;
        TakeDamage(CumulativeDamage, InstigatedBy, hitlocation, Momentum, DamageType, HighestDamagePoint);
    }
}

function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    local int        ActualDamage;
    local Controller Killer;
    local DarkestHourGame G;
    local DHGameReplicationInfo GRI;
    local int RoundTime;
    local Controller C;

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
    else if (DamageType.Name == 'DHBurningDamageType' || DamageType.Name == 'DamTypeVehicleExplosion' || DamageType.Name == 'DHShellSmokeWPDamageType')
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

            C = Controller;

            // Controller might be possessing a vehicle pawn.
            if (Controller == none && DrivenVehicle != none && DrivenVehicle.Controller != none)
            {
                C = DrivenVehicle.Controller;
            }

            G.Metrics.OnPlayerFragged(PlayerController(Killer), PlayerController(C), DamageType, HitLocation, HitIndex, RoundTime);
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

    PlayOwnedSound(Sound'Inf_Weapons_Foley.ammogive', SLOT_Interact, 1.75,, 10.0);
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

    PlayOwnedSound(Sound'Inf_Weapons_Foley.ammogive', SLOT_Interact, 1.75,, 10.0);
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

    PlayOwnedSound(Sound'Inf_Weapons_Foley.ammogive', SLOT_Interact, 1.75,, 10.0);
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

        PlayOwnedSound(Sound'Inf_Weapons_Foley.ammogive', SLOT_Interact, 1.75,, 10.0);
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

// Modified to avoid errors if trying to play animations that don't exist
simulated function PlayBoltAction()
{
    local name Anim;

    if (WeaponAttachment != none)
    {
        if (bIsCrawling)
        {
            Anim = WeaponAttachment.PA_ProneBoltActionAnim;
        }
        else if (bIsCrouched)
        {
            if (bIronSights || VSizeSquared(Velocity) > 25.0) // if ironsighted or player is moving
            {
                Anim = WeaponAttachment.PA_CrouchIronBoltActionAnim;
            }
            else
            {
                Anim = WeaponAttachment.PA_CrouchBoltActionAnim;
            }
        }
        else
        {
            if (bIronSights)
            {
                Anim = WeaponAttachment.PA_StandIronBoltActionAnim;
            }
            else
            {
                Anim = WeaponAttachment.PA_StandBoltActionAnim;
            }
        }

        // Play any 3rd person player animation
        if (HasAnim(Anim))
        {
            AnimBlendParams(1, 1.0, 0.0, 0.2, SpineBone1);
            AnimBlendParams(1, 1.0, 0.0, 0.2, SpineBone2);

            PlayAnim(Anim,, 0.1, 1);

            AnimBlendTime = GetAnimDuration(Anim, 1.0) + 0.1;
        }

        if (WeaponAttachment.bBayonetAttached)
        {
            Anim = WeaponAttachment.WA_BayonetWorkBolt;
        }
        else
        {
            Anim = WeaponAttachment.WA_WorkBolt;
        }

        // Play any 3rd person weapon animation
        if (WeaponAttachment.HasAnim(Anim))
        {
            WeaponAttachment.PlayAnim(Anim,, 0.1);
        }
    }
}

// Modified to avoid errors if trying to play animations that don't exist
simulated function PlayStopReloading()
{
    local name Anim;

    if ((WeaponState == GS_ReloadLooped || WeaponState == GS_PreReload) && WeaponAttachment != none)
    {
        AnimBlendParams(1, 1.0, 0.0, 0.2, FireRootBone);

        if (bIsCrawling)
        {
            Anim = WeaponAttachment.PA_PronePostReloadAnim;
        }
        else
        {
            Anim = WeaponAttachment.PA_PostReloadAnim;
        }

        // Play any 3rd person player animation
        if (HasAnim(Anim))
        {
            PlayAnim(Anim,, 0.1, 1);
        }

        if (WeaponAttachment.bBayonetAttached && WeaponAttachment.WA_BayonetPostReload != '')
        {
            Anim = WeaponAttachment.WA_BayonetPostReload;
        }
        else if (WeaponAttachment.WA_PostReload != '')
        {
            Anim = WeaponAttachment.WA_PostReload;
        }

        // Play any 3rd person weapon animation
        if (WeaponAttachment.HasAnim(Anim))
        {
            WeaponAttachment.PlayAnim(Anim,, 0.1);
        }

        WeaponState = GS_ReloadSingle;
    }

    IdleTime = Level.TimeSeconds;
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
ignores Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer; // added (from Pawn) as don't believe 'ignores' specifier is inherited & it wasn't re-stated in ROPawn

    // Modified to destroy player's bullet whip attachment actor so that happens as soon as player dies, without waiting for pawn actor to be destroyed when ragdoll disappears
    // Also to avoid re-enabling bCollideActors as it can cause some vehicles to jump wildly when player is killed in vehicle with other occupants
    // Seems to be some sort of collision clash when player's collision is re-enabled & he's inside the vehicle's collision
    // Infantry pawns have full collision enabled anyway so this actually does nothing for them, while leaving it disabled for players killed in vehicles is harmless
    // Even then, something else (native code I believe) re-enables bCollideActors on net client - happens after BeginState() but before state's 'Begin:' label state code
    // But by then it appears the collision change is late enough that it avoids causing an exited vehicle to jump wildly, so we achieve our primary aim with this fix
    function BeginState()
    {
        local int i;

//      SetCollision(true, false, false); // removed

        // Destroy player's bullet whip attachment
        if (AuxCollisionCylinder != none)
        {
            AuxCollisionCylinder.Destroy();
        }

        if (bTearOff && Level.NetMode == NM_DedicatedServer)
        {
            LifeSpan = 1.0;
        }
        else
        {
            SetTimer(2.0, false);
        }

        SetPhysics(PHYS_Falling);
        bInvulnerableBody = true;

        if (Controller != none)
        {
            if (Controller.bIsPlayer)
            {
                Controller.PawnDied(self);
            }
            else
            {
                Controller.Destroy();
            }
        }

        for (i = 0; i < Attached.Length; ++i)
        {
            if (Attached[i] != none)
            {
                Attached[i].PawnBaseDied();
            }
        }

        AmbientSound = none;
    }

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

        // Effects on ragdoll bodies
        if (Physics == PHYS_KarmaRagdoll)
        {
            if (bDeRes)
            {
                return; // can't shoot corpses during de-res
            }

            // Move the body if it's a grenade or mine explosion // TODO: add others explosive types & try to remove projectile-specific literals as far as possible
            if (DamageType.Name == 'DH_StielGranateDamType' || DamageType.Name == 'DH_M1GrenadeDamType' || DamageType.Name == 'DH_F1GrenadeDamType'
                || DamageType.Name == 'ROMineDamType' || DamageType.Name == 'ROSMineDamType' || DamageType.Name == 'DHATMineDamage')
            {
                ShotDir = Normal(Momentum);
                PushLinVel = (RagDeathVel * ShotDir) +  vect(0.0, 0.0, 250.0);
                PushAngVel = Normal(ShotDir cross vect(0.0, 0.0, 1.0)) * -18000.0;
                KSetSkelVel(PushLinVel, PushAngVel);
            }
            // Move the body if it's a bullet
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

                PushLinVel = RagShootStrength * Normal(Momentum);
                KAddImpulse(PushLinVel, HitLocation);

                if (LifeSpan > 0.0 && LifeSpan < (DeResTime + 2.0))
                {
                    LifeSpan += 0.2;
                }
            }
            // Set the body on fire if it's burning damage
            else if (DamageType.Name == 'DHBurningDamageType')
            {
                if (!bOnFire)
                {
                    bOnFire = true;
                }

                BurnTimeLeft = 10;

                SetTimer(1.0, false);
            }
            // Otherwise move the body for other damage types
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

            if (VSizeSquared(Momentum) < 100.0) // was VSize(Momentum) < 10 but it's more efficient to use VSizeSquared < 100
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

        // No longer call the super, just rerun the timer
        SetTimer(1.0, false);
    }

Begin:
    Sleep(0.2);
    bInvulnerableBody = false;

    if (Level.Game != none && !Level.Game.bGameEnded) // needs != none check to avoid "accessed none" error on client (actor has been torn off so usual role authority check doesn't work)
    {
        PlayDyingSound();
    }
}

// Modified to remove native functionality which limited ragdolls to 4
function PlayDyingAnimation(class<DamageType> DamageType, vector HitLoc)
{
    local vector            ShotDir, HitLocRel, DeathAngVel, ShotStrength;
    local float             MaxDim;
    local string            RagSkelName;
    local KarmaParamsSkel   SkelParams;
    local bool              bPlayersRagdoll;
    local PlayerController  PC;

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (OldController != none)
        {
            PC = PlayerController(OldController);
        }

        // Is this the local player's ragdoll?
        if (PC != none && PC.ViewTarget == self)
        {
            bPlayersRagdoll = true;
        }

        if (FRand() < 0.3)
        {
            HelmetShotOff(rotator(Normal(GetTearOffMomemtum())));
        }

        // In low physics detail, if we were not just controlling this pawn,
        // and it has not been rendered in 3 seconds, just destroy it.
        if ((Level.PhysicsDetailLevel != PDL_High) && !bPlayersRagdoll && (Level.TimeSeconds - LastRenderTime > 3))
        {
            Destroy();
            return;
        }

        // Get the ragdoll name
        if (RagdollOverride != "")
        {
            RagSkelName = RagdollOverride;
        }
        else if (Species != none)
        {
            RagSkelName = Species.static.GetRagSkelName(GetMeshName());
        }
        else
        {
            Log("xPawn.PlayDying: No Species");
        }

        // Handle the pawn to ragdoll switch
        if (RagSkelName != "")
        {
            SkelParams = KarmaParamsSkel(KParams);
            SkelParams.KSkeleton = RagSkelName;

            StopAnimating(true);

            if (DamageType != none)
            {
                if (DamageType.default.bLeaveBodyEffect)
                {
                    TearOffMomentum = vect(0,0,0);
                }

                if (DamageType.default.bKUseOwnDeathVel)
                {
                    RagDeathVel = DamageType.default.KDeathVel;
                    RagDeathUpKick = DamageType.default.KDeathUpKick;
                    RagShootStrength = DamageType.default.KDamageImpulse;
                }
            }

            // Set the dude moving in direction he was shot in general
            ShotDir = Normal(GetTearOffMomemtum());
            ShotStrength = RagDeathVel * ShotDir;

            // Calculate angular velocity to impart, based on shot location.
            HitLocRel = TakeHitLocation - Location;

            if (DamageType.default.bLocationalHit)
            {
                HitLocRel.X *= RagSpinScale;
                HitLocRel.Y *= RagSpinScale;

                if (Abs(HitLocRel.X) > RagMaxSpinAmount)
                {
                    if (HitLocRel.X < 0)
                    {
                        HitLocRel.X = FMax((HitLocRel.X * RagSpinScale), (RagMaxSpinAmount * -1));
                    }
                    else
                    {
                        HitLocRel.X = FMin((HitLocRel.X * RagSpinScale), RagMaxSpinAmount);
                    }
                }

                if (Abs(hitLocRel.Y) > RagMaxSpinAmount)
                {
                    if (HitLocRel.Y < 0)
                    {
                        HitLocRel.Y = FMax((HitLocRel.Y * RagSpinScale), (RagMaxSpinAmount * -1));
                    }
                    else
                    {
                        HitLocRel.Y = FMin((HitLocRel.Y * RagSpinScale), RagMaxSpinAmount);
                    }
                }
            }
            else
            {
                // We scale the hit location out sideways a bit, to get more spin around Z.
                HitLocRel.X *= RagSpinScale;
                HitLocRel.Y *= RagSpinScale;
            }

            // If the tear off momentum was very small for some reason, make up some angular velocity for the pawn
            if (VSize(GetTearOffMomemtum()) < 0.01)
            {
                DeathAngVel = VRand() * 18000.0;
            }
            else
            {
                DeathAngVel = RagInvInertia * (HitLocRel cross ShotStrength);
            }

            // Set initial angular and linear velocity for ragdoll.
            // Scale horizontal velocity for characters - they run really fast!
            if (DamageType.Default.bRubbery)
            {
                SkelParams.KStartLinVel = vect(0,0,0);
            }

            if (Damagetype.default.bKUseTearOffMomentum)
            {
                SkelParams.KStartLinVel = GetTearOffMomemtum() + Velocity;
            }
            else
            {
                SkelParams.KStartLinVel.X = 0.6 * Velocity.X;
                SkelParams.KStartLinVel.Y = 0.6 * Velocity.Y;
                SkelParams.KStartLinVel.Z = 1.0 * Velocity.Z;
                SkelParams.KStartLinVel += ShotStrength;
            }

            // If not moving downwards - give extra upward kick
            if (!DamageType.default.bLeaveBodyEffect && !DamageType.Default.bRubbery && (Velocity.Z > -10))
            {
                SkelParams.KStartLinVel.Z += RagDeathUpKick;
            }

            if (DamageType.Default.bRubbery)
            {
                Velocity = vect(0,0,0);
                SkelParams.KStartAngVel = vect(0,0,0);
            }
            else
            {
                SkelParams.KStartAngVel = DeathAngVel;

                // Set up deferred shot-bone impulse
                MaxDim = Max(CollisionRadius, CollisionHeight);

                SkelParams.KShotStart = TakeHitLocation - (1 * ShotDir);
                SkelParams.KShotEnd = TakeHitLocation + (2 * MaxDim * ShotDir);
                SkelParams.KShotStrength = RagShootStrength;
            }

            // If this damage type causes convulsions, turn them on here.
            if (DamageType != none && DamageType.default.bCauseConvulsions)
            {
                RagConvulseMaterial = DamageType.default.DamageOverlayMaterial;
                SkelParams.bKDoConvulsions = true;
            }

            // Turn on Karma collision for ragdoll.
            KSetBlockKarma(true);

            // Set physics mode to ragdoll.
            // This doesn't actaully start it straight away, it's deferred to the first tick.
            SetPhysics(PHYS_KarmaRagdoll);

            // If viewing this ragdoll, set the flag to indicate that it is 'important'
            if (bPlayersRagdoll)
            {
                SkelParams.bKImportantRagdoll = true;
            }

            SkelParams.KActorGravScale = RagGravScale;

            return;
        }
    }

    // Non-Ragdoll death fallback
    Velocity += GetTearOffMomemtum();
    BaseEyeHeight = default.BaseEyeHeight;
    SetTwistLook(0,0);
    SetPhysics(PHYS_Falling);
}

// Modified to prevent damage overlay from overriding burning overlay
function PlayHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> DamageType, vector Momentum, optional int HitIndex)
{
    local PlayerController     PC;
    local ProjectileBloodSplat BloodHit;
    local name                 HitBone;
    local vector               HitNormal;
    local rotator              SplatRot;
    local bool                 bShowEffects, bRecentHit;

    bRecentHit = Level.TimeSeconds - LastPainTime < 0.2;

    // Call the modified version of the original Pawn PlayHit()
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
    }
    else
    {
        HitLocation = Location;
        HitBone = 'none';
    }

    if (DamageType.default.bAlwaysSevers && DamageType.default.bSpecial)
    {
        HitBone = 'head';
    }

    if (InstigatedBy != none)
    {
        HitNormal = Normal(Normal(InstigatedBy.Location - HitLocation) + VRand() * 0.2 + vect(0.0, 0.0, 2.8));
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

// Modified to specify radius for hit/damage sounds, including a little randomization
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
            PlaySound(GetSound(EST_Drown), SLOT_Pain, 1.5 * TransientSoundVolume,, 10.0); // added radius 10
        }
        else
        {
            PlaySound(GetSound(EST_HitUnderwater), SLOT_Pain, 1.5 * TransientSoundVolume,, 10.0); // added radius 10
        }

        return;
    }

    if (Level.NetMode != NM_DedicatedServer && class<ROWeaponDamageType>(DamageType) != none
        && class<ROWeaponDamageType>(DamageType).default.bCauseViewJarring && ROPlayer(Controller) != none)
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

    PlayOwnedSound(SoundGroupClass.static.GetHitSound(DamageType), SLOT_Pain, 3.0 * TransientSoundVolume,, RandRange(30, 90),, true); // added randomized radius
}

// Modified to add removal of radioman arty triggers on death
// And so if player was registered as an allowed crewman in a locked vehicle, we notify that vehicle this player is no longer valid
// We no longer disable collision on player's bullet whip attachment as we may as well simply destroy that actor
// But we now do that in state 'Dying' as that happens on both server & client, while this function is server only
// Also omit possible call to ClientDying() at end of this function as ClientDying() is redundant & emptied out in ROPawn, so it's pointless replication
function Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
    local Trigger         T;
    local NavigationPoint N;
    local vector          HitDirection;
    local float           DamageBeyondZero;
    local bool            bShouldGib;


    // Exit if pawn being destroyed or level is being cleaned up
    if (bDeleteMe || Level.bLevelChange || Level.Game == none)
    {
        return;
    }

    if (GunToRotate != none)
    {
        GunToRotate.ServerExitRotation();
    }

    // Re-assign killer if death was caused indirectly by them
    if (DamageType != none && DamageType.default.bCausedByWorld && (Killer == none || Killer == Controller) && LastHitBy != none)
    {
        Killer = LastHitBy;
    }
    else if (bOnFire)
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

    // Make sure health is no more than zero (record original health before adjusting, for use later)
    DamageBeyondZero = Health;
    Health = Min(0, Health);

    if (DamageType == class'Suicided')
    {
        DamageType = class'ROSuicided'; // fix for suicide death messages
    }

    bShouldGib = DamageType != none && (DamageType.default.bAlwaysGibs || ((Abs(DamageBeyondZero) + default.Health) > DamageType.default.HumanObliterationThreshhold));

    // If the pawn has not been gibbed, is not in a vehicle & has not been spawn killed, then drop weapons
    // If they don't get dropped here, they get destroyed in the GameInfo's DiscardInventory(), called from its Killed() function
    if (!bShouldGib && (DrivenVehicle == none || DrivenVehicle.bAllowWeaponToss) && !IsSpawnKillProtected())
    {
        DropWeaponInventory(vect(0.0, 0.0, 0.0)); // the TossVel argument isn't used so just pass in a null vector
    }

    // Destroy some possible DH special carried/owned actors
    DestroyRadio();

    if (OwnedMortar != none)
    {
        OwnedMortar.GotoState('PendingDestroy');
    }

    // Notify other actors that player has died
    if (DrivenVehicle != none)
    {
        Velocity = DrivenVehicle.Velocity; // give dead driver the vehicle's velocity
        DrivenVehicle.DriverDied();
    }

    if (CrewedLockedVehicle != none)
    {
        SetCrewedLockedVehicle(none); // if player was registered as an allowed crewman in a locked vehicle, this will notify vehicle this player is no longer valid
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

    // Trigger any event that needs to happen on player's death
    if (Killer != none)
    {
        TriggerEvent(Event, self, Killer.Pawn);
    }
    else
    {
        TriggerEvent(Event, self, none);
    }

    // Notify some touching actors that player has died
    if (IsPlayerPawn() || WasPlayerPawn())
    {
        PhysicsVolume.PlayerPawnDiedInVolume(self);

        foreach TouchingActors(class'Trigger', T)
        {
            T.PlayerToucherDied(self); // un-trigger any triggers requiring player touch
        }

        foreach TouchingActors(class'NavigationPoint', N)
        {
            if (N.bReceivePlayerToucherDiedNotify)
            {
                N.PlayerToucherDied(self);
            }
        }
    }

    // Give player's velocity a little up-kick, force a quick net update, & jarr player's vision if DamageType causes that effect
    Velocity.Z *= 1.3;

    if (IsHumanControlled())
    {
        PlayerController(Controller).ForceDeathUpdate();
    }

    if (DHPlayer(Controller) != none && class<ROWeaponDamageType>(DamageType) != none && class<ROWeaponDamageType>(DamageType).default.bCauseViewJarring)
    {
        HitDirection = Location - HitLocation;
        HitDirection.Z = 0.0;
        HitDirection = normal(HitDirection);

        DHPlayer(Controller).PlayerJarred(HitDirection, 3.0);
    }

    // Damage/dying effects
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
    }


}

// Stop damage overlay from overriding burning overlay if necessary
simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
    local DHPlayer PC;

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

    // Set LifeSpan
    if (Level.NetMode != NM_DedicatedServer)
    {
        // Set PC
        PC = DHPlayer(Level.GetLocalPlayerController());

        if (PC != none)
        {
            LifeSpan = Clamp(PC.CorpseStayTime, class'DHPlayer'.default.CorpseStayTimeMin, class'DHPlayer'.default.CorpseStayTimeMax);
        }
        else
        {
            LifeSpan = RagdollLifeSpan; // default (30 seconds)
        }
    }
    else
    {
        LifeSpan = 10.0; // TODO: figure out if this matters and what value best to set to (before the server would have set it to 30)
    }

    GotoState('Dying');

    PlayDyingAnimation(DamageType, HitLoc);
}

simulated function SetOverlayMaterial(Material Mat, float Time, bool bOverride)
{
    local int i;
    local FinalBlend FB;

    if (Level.bDropDetail || Level.DetailMode == DM_Low)
    {
        Time *= 0.75;
    }

    // Combiners do not play nice with the overlay system! We have to pre-prime
    // our skins to use FinalBlend, otherwise the skins will be invisible when
    // an the overlay material is applied..
    for (i = 0; i < Skins.Length; ++i)
    {
        if (Skins[i].IsA('Combiner'))
        {
            FB = new class'FinalBlend';
            FB.Material = Skins[i];
            Skins[i] = FB;
        }
    }

    super.SetOverlayMaterial(Mat, Time, bOverride);
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
        PushLinVel = RagDeathVel * ShotDir;
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

// Modified to destroy burning player effects
// Also so if player was registered as an allowed crewman in a locked vehicle, we notify that vehicle this player is no longer valid
simulated event Destroyed()
{
    if (FlameFX != none)
    {
        FlameFX.Emitters[0].SkeletalMeshActor = none;
        FlameFX.Emitters[1].SkeletalMeshActor = none;
        FlameFX.Emitters[2].SkeletalMeshActor = none;
        FlameFX.Kill();
    }

    if (CrewedLockedVehicle != none)
    {
        SetCrewedLockedVehicle(none); // if player was registered as an allowed crewman in a locked vehicle, this will notify vehicle this player is no longer valid
    }

    DestroyRadio();

    super.Destroyed();
}

// Called by DH_GiveChuteTrigger, adds parachute items to player's inventory
singular function GiveChute()
{
    local DHRoleInfo RI;
    local int        i;
    local string     ItemString;
    local bool       bHasPSL, bHasPI;

    RI = GetRoleInfo();

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
function DestroyRadio()
{
    if (Radio != none)
    {
        Radio.Destroy();
    }
}

// Modified to allow player to carry more than 1 type of grenade
// And to automatically give all players a shovel if constructions are enabled in the map
// Also to add != "none" (string) checks before calling CreateInventory to avoid calling GetInventoryClass("none") on base mutator & the log errors created each time a player spawns
function AddDefaultInventory()
{
    local DHPlayerReplicationInfo PRI;
    local DHPlayer   P;
    local DHBot      B;
    local DHRoleInfo RI;
    local string     S;
    local int        i;

    if (Controller == none)
    {
        return;
    }

    P = DHPlayer(Controller);
    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

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

            CheckGiveShovel();
            CheckGiveBinocs();
            CheckGiveSmoke();

            RI = GetRoleInfo();

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

                // Set whether this pawn can carry extra ammo
                bCarriesExtraAmmo = RI.default.bCanCarryExtraAmmo;

                // If we do not carry extra ammo or we aren't supposed to spawn with it, then we shouldn't have it
                if (!bCarriesExtraAmmo || !RI.default.bSpawnWithExtraAmmo)
                {
                    bUsedCarriedMGAmmo = true; // This means it is "used" aka the player won't have extra ammo
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

                RI = DHRoleInfo(B.GetRoleInfo());

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
            RI = GetRoleInfo();

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

            // Set whether this pawn can carry extra ammo
            bCarriesExtraAmmo = RI.default.bCanCarryExtraAmmo;

            // If we do not carry extra ammo or we aren't supposed to spawn with it, then we shouldn't have it
            if (!bCarriesExtraAmmo || !RI.default.bSpawnWithExtraAmmo)
            {
                bUsedCarriedMGAmmo = true; // This means it is "used" aka the player won't have extra ammo
            }

            CheckGiveShovel();
            CheckGiveBinocs();
            CheckGiveSmoke();
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

// New function used to give all non-squad leaders a shovel (the appropriate shovel for their nationality)
function CheckGiveShovel()
{
    local DHGameReplicationInfo GRI;
    local DHPlayerReplicationInfo PRI;
    
    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    if (ShovelClassName != "" && Level.Game != none)
    {
        GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

        if (GRI != none && GRI.bAreConstructionsEnabled && PRI != none && !PRI.IsSquadLeader())
        {
            CreateInventory(ShovelClassName);
        }
    }
}

// Function used to give binoculars to Squad Leaders
function CheckGiveBinocs()
{
    local DHGameReplicationInfo GRI;
    local DHPlayerReplicationInfo PRI;

    if (BinocsClassName != "" && Level.Game != none)
    {
        GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);
        PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

        if (GRI != none && PRI != none && (PRI.IsSquadLeader() || PRI.IsASL()))
        {
            CreateInventory(BinocsClassName);
        }
    }
}

// Function used to give smoke grenades to squad leaders (if squad is large enough)
function CheckGiveSmoke()
{
    local DHRoleInfo RI;
    local DHGameReplicationInfo GRI;
    local DHPlayerReplicationInfo PRI;
    local DHPlayer PC;
    local DarkestHourGame DHG;
    local byte TeamIndex;
    local int SquadMemberCount;
    local string ColoredSmokeGrenadeToGive;
    local string SmokeGrenadeToGive;

    if (Level.Game != none)
    {
        RI = GetRoleInfo();

        // Exclude tank crewmen and mortar operators
        if (RI == none || RI.bCanBeTankCrew || RI.bCanUseMortars)
        {
            return;
        }

        GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);
        PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);
        PC = DHPlayer(Controller);

        if (GRI == none ||
            PC == none ||
            PC.SquadReplicationInfo == none ||
            PRI == none ||
            !PRI.IsSquadLeader())
        {
            return;
        }

        TeamIndex = GetTeamNum();
        SquadMemberCount = PC.SquadReplicationInfo.GetMemberCount(TeamIndex, PRI.SquadIndex);

        // Not enough people in the squad to receive any smoke
        if (SquadMemberCount < Min(RequiredSquadMembersToReceiveSmoke, RequiredSquadMembersToReceiveColoredSmoke))
        {
            return;
        }

        switch (TeamIndex)
        {
            case AXIS_TEAM_INDEX:
                SmokeGrenadeToGive = SmokeGrenadeClassName.Germany;
                ColoredSmokeGrenadeToGive = ColoredSmokeGrenadeClassName.Germany;

                break;

            case ALLIES_TEAM_INDEX:
                DHG = DarkestHourGame(Level.Game);

                if (DHG == none || DHG.LevelInfo == none)
                {
                    return;
                }

                switch (DHG.DHLevelInfo.AlliedNation)
                {
                    case NATION_Canada:
                        // Falls back to Britain
                        if (SmokeGrenadeClassName.Canada != "")
                        {
                            SmokeGrenadeToGive = SmokeGrenadeClassName.Canada;
                        }
                        else
                        {
                            SmokeGrenadeToGive = SmokeGrenadeClassName.Britain;
                        }

                        if (ColoredSmokeGrenadeClassName.Canada != "")
                        {
                            ColoredSmokeGrenadeToGive = SmokeGrenadeClassName.Canada;
                        }
                        else
                        {
                            ColoredSmokeGrenadeToGive = ColoredSmokeGrenadeClassName.Britain;
                        }

                        break;

                    case NATION_Britain:
                        SmokeGrenadeToGive = SmokeGrenadeClassName.Britain;
                        ColoredSmokeGrenadeToGive = ColoredSmokeGrenadeClassName.Britain;
                        break;

                    case NATION_USSR:
                        SmokeGrenadeToGive = SmokeGrenadeClassName.USSR;
                        ColoredSmokeGrenadeToGive = ColoredSmokeGrenadeClassName.USSR;
                        break;

                    case NATION_Poland:
                        SmokeGrenadeToGive = SmokeGrenadeClassName.Poland;
                        ColoredSmokeGrenadeToGive = ColoredSmokeGrenadeClassName.Poland;
                        break;

                    default:
                        SmokeGrenadeToGive = SmokeGrenadeClassName.USA;
                        ColoredSmokeGrenadeToGive = ColoredSmokeGrenadeClassName.USA;
                        break;
                }
        }

        if (SquadMemberCount >= RequiredSquadMembersToReceiveSmoke && SmokeGrenadeToGive != "")
        {
            CreateInventory(SmokeGrenadeToGive);
        }

        if (SquadMemberCount >= RequiredSquadMembersToReceiveColoredSmoke && ColoredSmokeGrenadeToGive != "")
        {
            CreateInventory(ColoredSmokeGrenadeToGive);
        }
    }
}

// Modified to optimise network load by avoiding needlessly destroying & re-spawning replicated BackAttachment actors just because we need to change its mesh
// Also slightly re-factored to optimise
function ServerChangedWeapon(Weapon OldWeapon, Weapon NewWeapon)
{
    // If single player mode or a hosting listen server player, & in 1st person view, then just switch the attachment
    // Don't worry about playing all the third person player stuff (that was borking up the first person weapon switches)
    if (IsFirstPerson()) // replacing following checks as does same thing quicker: if (IsLocallyControlled() && IsHumanControlled() && !PlayerController(Controller).bBehindView)
    {
        Weapon = NewWeapon;

        if (Controller != none)
        {
            Controller.ChangedWeapon();
        }

        PendingWeapon = none;

        // Put away any currently held weapon
        if (OldWeapon != none)
        {
            if (OldWeapon.bCanAttachOnBack)
            {
                // Originally the replicated BackAttachment actor was needlessly destroyed & re-spawned just to switch to a different weapon mesh
                // That caused unnecessary network load by requiring server to destroy existing actor, instruct all clients to do same, then close the net channels
                // Only to immediately spawn the same BackAttachment actor, initialise it to have the new weapon mesh, then replicate it to all relevant clients
                // BackAttachment actor is completely generic & is only made to take on the appearance of new weapon by calling InitFor() to swap its mesh
                // So we can keep the existing BackAttachment actor, which is already attached, & simply call InitFor() on it
                if (AttachedBackItem == none)
                {
                    AttachedBackItem = Spawn(class'BackAttachment', self);

                    if (AttachedBackItem != none)
                    {
                        AttachToBone(AttachedBackItem, AttachedBackItem.AttachmentBone);
                    }
                }

                AttachedBackItem.InitFor(OldWeapon);
            }

            OldWeapon.SetDefaultDisplayProperties();
            OldWeapon.DetachFromPawn(self);
            OldWeapon.GotoState('Hidden');
            OldWeapon.NetUpdateFrequency = 2.0;
        }

        // Switch to the new weapon
        if (Weapon != none)
        {
            // Destroy an AttachedBackItem actor if it represents the weapon we are switching to
            if (AttachedBackItem != none && AttachedBackItem.InventoryClass == Weapon.Class)
            {
                AttachedBackItem.Destroy();
                AttachedBackItem = none;
            }

            Weapon.NetUpdateFrequency = 100.0;
            Weapon.AttachToPawn(self);
            Weapon.BringUp(OldWeapon);
            PlayWeaponSwitch(NewWeapon);
        }

        if (Inventory != none)
        {
            Inventory.OwnerEvent('ChangedWeapon');
        }
    }
    // If a dedicated server or other mode in 3rd person view
    else
    {
        // If we're holding a weapon, put that away & set our PendingWeapon to be the new weapon so we will switch to that
        if (OldWeapon != none)
        {
            if (IsInState('PutWeaponAway'))
            {
                GotoState('');
            }

            PendingWeapon = NewWeapon;
            GotoState('PutWeaponAway');
        }
        // Or if we're not currently holding a weapon, switch to the new weapon immediately
        // (Removed pointless OldWeapon stuff from this as we can't have an OldWeapon if we got here)
        else
        {
            Weapon = NewWeapon;

            if (Controller != none)
            {
                Controller.ChangedWeapon();
            }

            PendingWeapon = none;

            if (Weapon != none)
            {
                // Destroy an AttachedBackItem actor if it represents the weapon we are switching to
                if (AttachedBackItem != none && AttachedBackItem.InventoryClass == Weapon.Class)
                {
                    AttachedBackItem.Destroy();
                    AttachedBackItem = none;
                }

                Weapon.NetUpdateFrequency = 100.0;
                Weapon.AttachToPawn(self);
                Weapon.BringUp();
                PlayWeaponSwitch(NewWeapon);
            }

            if (Inventory != none)
            {
                Inventory.OwnerEvent('ChangedWeapon');
            }
        }
    }
}

// Modified to use DH weapon classes to determine the correct put away & draw animations (also to prevent "accessed none" errors on parachute landing)
// Also to optimise network load by avoiding needlessly destroying & re-spawning replicated BackAttachment actors just because we need to change its mesh
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
            // Putting away a pistol, or a shovel that hangs on the player's left hip
            else if (Weapon.IsA('DHPistolWeapon') ||
                     Weapon.IsA('DHRevolverWeapon') ||
                     (Weapon.IsA('DHShovelItem') && bShovelHangsOnLeftHip))
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
                // Originally the replicated BackAttachment actor was needlessly destroyed & re-spawned just to switch to a different weapon mesh
                // That caused unnecessary network load by requiring server to destroy existing actor, instruct all clients to do same, then close the net channels
                // Only to immediately spawn the same BackAttachment actor, initialise it to have the new weapon mesh, then replicate it to all relevant clients
                // BackAttachment actor is completely generic & is only made to take on the appearance of new weapon by calling InitFor() to swap its mesh
                // So we can keep the existing BackAttachment actor, which is already attached, & simply call InitFor() on it
                if (AttachedBackItem == none)
                {
                    AttachedBackItem = Spawn(class'BackAttachment', self);

                    if (AttachedBackItem != none)
                    {
                        AttachToBone(AttachedBackItem, AttachedBackItem.AttachmentBone);
                    }
                }

                AttachedBackItem.InitFor(SwapWeapon);
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
                // From grenade or binocs, to pistol or shovel from left hip
                if (Weapon.IsA('DHPistolWeapon') ||
                    Weapon.IsA('DHRevolverWeapon') ||
                    (Weapon.IsA('DHShovelItem') && bShovelHangsOnLeftHip))
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
                // From grenade or binocs, to any other weapon (generic anim to draw new weapon from player's back)
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
            else if (SwapWeapon.IsA('DHPistolWeapon') ||
                     SwapWeapon.IsA('DHRevolverWeapon') ||
                     (SwapWeapon.IsA('DHShovelItem') && bShovelHangsOnLeftHip))
            {
                // From pistol or shovel that goes on left hip, to grenade or binocs
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
                // From pistol or shovel that goes on left hip, to pistol or shovel from left hip
                else if (Weapon.IsA('DHPistolWeapon') ||
                         Weapon.IsA('DHRevolverWeapon') ||
                         (Weapon.IsA('DHShovelItem') && bShovelHangsOnLeftHip))
                {
                    if (bIsCrawling)
                    {
                        Anim = 'prone_draw_pistol';
                    }
                    else
                    {
                        Anim = 'stand_draw_pistol';
                    }
                }
                // From pistol or shovel that goes on left hip, to any other weapon (generic anim to draw new weapon from player's back)
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
                // From any other weapon, to pistol or shovel from left hip
                else if (Weapon.IsA('DHPistolWeapon') ||
                         Weapon.IsA('DHRevolverWeapon') ||
                         (Weapon.IsA('DHShovelItem') && bShovelHangsOnLeftHip))
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
            // Destroy an AttachedBackItem actor if it represents the weapon we are switching to
            if (AttachedBackItem != none && AttachedBackItem.InventoryClass == Weapon.Class)
            {
                AttachedBackItem.Destroy();
                AttachedBackItem = none;
            }

            // Unhide the weapon now
            if (Weapon.ThirdPersonActor != none)
            {
                if (DrivenVehicle == none) // added 'if' so we don't make the 3rd person weapon attachment visible again if player just got into a vehicle
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
    local name Anim;

    if (DHWeaponAttachment(WeaponAttachment) != none)
    {
        Anim = DHWeaponAttachment(WeaponAttachment).PA_AssistedReloadAnim;

        if (HasAnim(Anim))
        {
            AnimBlendParams(1, 1.0, 0.0, 0.2, SpineBone1);
            AnimBlendParams(1, 1.0, 0.0, 0.2, SpineBone2);

            PlayAnim(Anim,, 0.1, 1);

            AnimBlendTime = GetAnimDuration(Anim, 1.0) + 0.1;
        }

        Anim = WeaponAttachment.WA_ReloadEmpty;

        if (WeaponAttachment.HasAnim(Anim))
        {
            WeaponAttachment.PlayAnim(Anim,, 0.1);
        }

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

    if (bLocallyControlled)
    {
        PlaySound(MantleSound, SLOT_Interact, 1.0,, 10.0); // was PlayOwnedSound but that's only relevant to server & this plays on client - same below & in PlayEndMantle
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
            ClientMessage("SERVER playing mantling anim:" @ Anim);
            Log("SERVER playing mantling anim:" @ Anim);
        }
        else
        {
            ClientMessage("CLIENT playing mantling anim:" @ Anim);
            Log("CLIENT playing mantling anim:" @ Anim);
        }
    }
}

simulated function PlayEndMantle() // TODO: perhaps ought to play these anims on a dedicated server to put player's hit boxes in correct position? (server hit boxes must match client)
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

simulated function HUDCheckDig()
{
    if (IsLocallyControlled())
    {
        bCanDig = CanDig();
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

// Check whether there's anything in front of the player that can be built with the shovel
simulated function bool CanDig()
{
    return Weapon != none && Weapon.IsA('DHShovelItem') && Weapon.GetFireMode(0) != none && Weapon.GetFireMode(0).AllowFire();
}

simulated function bool CanMantleActor(Actor A)
{
    local DHObstacleInstance O;
    local DHConstruction C;

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

        C = DHConstruction(A);

        if (C != none && C.bCanBeMantled)
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
    local DHPlayer PC;

    PC = DHPlayer(Controller);
    DHW = DHWeapon(Weapon);

    // Do a check if the game is in a setup phase
    // Because mantling can bypass destroyable static mesh collision, lets just prevent mantling all together while in the setup phase
    // This is a simulated function which both the server and the client need to check, so the client can't use Level.Game (reason for accessing controller)
    // If mantling is ever fixed to where it cannot bypass DSM collision, then this check is not needed
    if (PC != none && PC.GameReplicationInfo != none && DHGameReplicationInfo(PC.GameReplicationInfo).bIsInSetupPhase)
    {
        return false;
    }

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
        //Spawn(class'RODebugTracer', self,, HitLoc, rotator(HitNorm));
        //ClientMessage("Object is too high to mantle");
        return false;
    }

    EndLoc += 7.0 * Direction; // brings us to a total of 60uu out from our starting location, which is how far our animations go
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

    if (PC != none)
    {
        PC.QueueHint(1, true);
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
            ClientMessage("SERVER running PostMantle");
            Log("SERVER running PostMantle");
        }
        else
        {
            ClientMessage("CLIENT running PostMantle");
            Log("CLIENT running PostMantle");
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
                ClientMessage("SERVER running mantling timer");
                Log("SERVER running mantling timer");
            }
            else
            {
                ClientMessage("CLIENT running mantling timer");
                Log("CLIENT running mantling timer");
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
    local float  Smooth, OldEyeHeight, MaxEyeHeight;
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
            LandBob *= 1 - Smooth;

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

    if (Trace(HitLocation, HitNormal, Location + (CollisionHeight + MAXSTEPHEIGHT + 14.0) * vect(0.0, 0.0, 1.0), Location + CollisionHeight * vect(0.0, 0.0, 1.0), true) != none)
    {
        MaxEyeHeight = HitLocation.Z - Location.Z - 14.0;
    }
    else
    {
        MaxEyeHeight = CollisionHeight + MAXSTEPHEIGHT;
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
        LandBob *= 1.0 - Smooth;

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
        LandBob *= 1.0 - Smooth;

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
    if ((DHWeapon(Weapon) != none && DHWeapon(Weapon).WeaponLeanRight()) || TraceWall(16384, 64.0) || bLeaningLeft || bIsSprinting || bIsMantling || bIsDeployingMortar || bIsCuttingWire)
    {
        bLeanRight = false;
    }
    else if (!bLeanLeft)
    {
        bLeanRight = true;
    }
}

simulated function LeanRightReleased()
{
    if (DHWeapon(Weapon) != none)
    {
        DHWeapon(Weapon).WeaponLeanRightReleased();
    }

    super.LeanRightReleased();
}

simulated function LeanLeft()
{
    if ((DHWeapon(Weapon) != none && DHWeapon(Weapon).WeaponLeanLeft()) || TraceWall(-16384, 64.0) || bLeaningRight || bIsSprinting || bIsMantling || bIsDeployingMortar || bIsCuttingWire)
    {
        bLeanLeft = false;
    }
    else if (!bLeanRight)
    {
        bLeanLeft = true;
    }
}

simulated function LeanLeftReleased()
{
    if (DHWeapon(Weapon) != none)
    {
        DHWeapon(Weapon).WeaponLeanLeftReleased();
    }

    super.LeanLeftReleased();
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

    if (Headgear != none)
    {
        Headgear.SetOverlayMaterial(BurnedHeadgearOverlayMaterial, 999.0, true);
    }

    if (Backpack != none)
    {
        Backpack.SetOverlayMaterial(BurningOverlayMaterial, 999.0, true);
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

// Modified so a burning player can't switch weapons (he's forced to drop the one he's carrying in his hands & this stops him bringing up another weapon)
simulated function bool CanSwitchWeapon()
{
    return !bOnFire && super.CanSwitchWeapon();
}

// Modified so a burning player can't switch weapons
simulated function bool CanBusySwitchWeapon()
{
    return bOnFire && super.CanBusySwitchWeapon();
}

// New function to make a burning player drop the weapon he is holding
// If he can't drop it, applying the check whether weapon should be dropped when player dies), we just destroy it so it disappears
function BurningPlayerDropWeapon()
{
    local DHWeapon DHW;
    local vector   TossVel;

    if (Controller != none)
    {
        Controller.LastPawnWeapon = Weapon.Class;
    }

    if ((DrivenVehicle == none || DrivenVehicle.bAllowWeaponToss) && !IsSpawnKillProtected())
    {
        DHW = DHWeapon(Weapon);

        if ((DHW != none && DHW.CanDeadThrow()) || (DHW == none && Weapon.bCanThrow))
        {
            TossVel = vector(GetViewRotation());
            TossVel = TossVel * ((Velocity dot TossVel) + 50.0) + vect(0.0, 0.0, 200.0);
            TossWeapon(TossVel);

            return;
        }
    }

    Weapon.Destroy();
}

// Modified to use new CanDeadThrow() before dropping a weapon (makes function specific to dropping player's inventory when dead, buts that's all it's used for)
// Also to incorporate tossing player's current weapon, which was previously in Died() & always called before this function, so no need for it to be separate
// Completely re-factored the inventory check loop to be far simpler & more efficient
// Note the passed in TossVel argument wasn't used, but here it gets used like a local variable by the toss current weapon functionality
function DropWeaponInventory(vector TossVel)
{
    local Inventory Inv, NextInv;
    local Weapon    W;
    local DHWeapon  DHW;
    local vector    X, Y, Z;

    GetAxes(Rotation, X, Y, Z);

    // Loop through player's inventory chain & drop anything that can be dropped
    for (Inv = Inventory; Inv != none; Inv = NextInv)
    {
        NextInv = Inv.Inventory; // have to record this here & use it in for loop, as if we drop current Inv it will be destroyed & we'll lose our Inv.Inventory reference
        W = Weapon(Inv);

        if (W != none)
        {
            DHW = DHWeapon(W);

            if ((DHW != none && DHW.CanDeadThrow()) || (DHW == none && W.bCanThrow))
            {
                // Special handling if inventory item is pawn's currently held weapon
                // This was previously part of separate functionality in Died() but we can apply standardised 'can drop?' checks here
                if (W == Weapon)
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
                // Other inventory items
                else
                {
                    W.DropFrom(Location + (0.8 * CollisionRadius * X) - (0.5 * CollisionRadius * Y));
                }
            }
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
    local DHPlayerReplicationInfo PRI;

    PRI = DHPlayerReplicationInfo(PlayerReplicationInfo);

    if (PRI != none)
    {
        return DHRoleInfo(PRI.RoleInfo);
    }

    return none;
}

simulated function bool AllowSprint()
{
    if (bIsWalking && (Weapon != none && !Weapon.bUsingSights))
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
    return Amplitude * (Sin(Frequency * T) / (Frequency ** ((Decay / Frequency) * T)));
}

exec simulated function BobAmplitude(optional float F)
{
    if (IsDebugModeAllowed())
    {
        if (F == 0)
        {
            Level.Game.Broadcast(self, "IronsightBobAmplitude" @ IronsightBobAmplitude);

            return;
        }

        IronsightBobAmplitude = F;
    }
}

exec simulated function BobFrequencyY(optional float F)
{
    if (IsDebugModeAllowed())
    {
        if (F == 0)
        {
            Level.Game.Broadcast(self, "IronsightBobFrequencyY" @ IronsightBobFrequencyY);

            return;
        }

        IronsightBobFrequencyY = F;
    }
}

exec simulated function BobFrequencyZ(optional float F)
{
    if (IsDebugModeAllowed())
    {
        if (F == 0)
        {
            Level.Game.Broadcast(self, "IronsightBobFrequencyZ" @ IronsightBobFrequencyZ);

            return;
        }

        IronsightBobFrequencyZ = F;
    }
}

exec simulated function BobDecay(optional float F)
{
    if (IsDebugModeAllowed())
    {
        if (F == 0)
        {
            Level.Game.Broadcast(self, "IronsightBobDecay" @ IronsightBobDecay);

            return;
        }

        IronsightBobDecay = F;
    }

}

// Modified to add some initial weapon bobbing when first iron sighting, & to enforce the default Bob setting
// General re-factor to optimise, only doing local variable calcs in code blocks that are actually going to use them
function CheckBob(float DeltaTime, vector Y)
{
    local float BobModifier, Speed2D, OldBobTime, IronsightBobAmplitudeModifier, IronsightBobDecayModifier;
    local int   M, N;

    OldBobTime = BobTime;

    Bob = 0.01; // added to enforce the default Bob value (instead of clamping it between certain values)

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

    // Player is in the normal 'walking' state
    if (Physics == PHYS_Walking)
    {
        Speed2D = VSize(Velocity);

        OldBobTime = BobTime;

        // Set a bob scaling factor based on the movement state
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
        else if (bIronSights) // added
        {
            BobModifier = 0.5;
        }
        else
        {
            BobModifier = 1.0;
        }

        // Apply weapon bob modifier factor if bIronSights
        if (bIronSights && Weapon != none && DHWeapon(Weapon) != none)
        {
            BobModifier *= DHWeapon(Weapon).BobModifyFactor;
        }

        // If ironsighted, update ironsight bob properties based on the movement state (added this if/else block)
        if (bIronSights)
        {
            if (bIsCrawling)
            {
                IronsightBobAmplitudeModifier = 0.75;
                IronsightBobDecayModifier = 1.25;
            }
            else if (bIsCrouched)
            {
                IronsightBobAmplitudeModifier = 0.9;
                IronsightBobDecayModifier = 1.1;
            }
            else
            {
                IronsightBobAmplitudeModifier = 1.1;
                IronsightBobDecayModifier = 1.0;
            }

            IronsightBobTime += DeltaTime;

            IronsightBob.Y = BobFunction(IronsightBobTime, IronsightBobAmplitude * IronsightBobAmplitudeModifier, IronsightBobFrequencyY, IronsightBobDecay * IronsightBobDecayModifier);
            IronsightBob.Z = BobFunction(IronsightBobTime, IronsightBobAmplitude * IronsightBobAmplitudeModifier, IronsightBobFrequencyZ, IronsightBobDecay * IronsightBobDecayModifier);
        }
        else
        {
            IronsightBobTime = 0.0;
            IronsightBob = vect(0.0, 0.0, 0.0);
        }

        // Update bob properties based on movement state & speed
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
            WalkBob.Z += 0.75 * (Bob * BobModifier) * Speed2D * Sin(16.0 * BobTime);
        }

        if (LandBob > 0.01)
        {
            AppliedBob += FMin(1.0, 16.0 * DeltaTime) * LandBob;
            LandBob *= 1.0 - 8.0 * DeltaTime;
        }

        // Play footstep effects (if moving fast enough & not crawling)
        if (!bIsCrawling && Speed2D >= 10.0 && !(IsHumanControlled() && PlayerController(Controller).bBehindView))
        {
            M = int(0.5 * Pi + 9.0 * OldBobTime / Pi);
            N = int(0.5 * Pi + 9.0 * BobTime / Pi);

            if (M != N)
            {
                FootStepping(0);
            }
        }
    }
    // Player is in deep water
    else if (Physics == PHYS_Swimming)
    {
        Speed2D = Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
        WalkBob = Y * Bob * 0.5 * Speed2D * Sin(4.0 * Level.TimeSeconds);
        WalkBob.Z = Bob * 1.5 * Speed2D * Sin(8.0 * Level.TimeSeconds);
    }
    // Player is in any other state (not walking or swimming)
    else
    {
        BobTime = 0.0;
        WalkBob = WalkBob * (1.0 - FMin(1.0, 8.0 * DeltaTime));
    }
}

// Modified to cause some stamina loss for prone diving
// Also to play the selected animation (the Super always played the pawn's DiveToProneEndAnim, even if the weapon-specific anim had been selected)
simulated state DivingToProne
{
    simulated function EndState()
    {
        local float NewHeight;
        local name  Anim;

        NewHeight = default.CollisionHeight - ProneHeight;

        if (WeaponAttachment != none)
        {
            Anim = WeaponAttachment.PA_DiveToProneEndAnim;
        }
        else
        {
            Anim = DiveToProneEndAnim;
        }

        if (HasAnim(Anim))
        {
            PlayAnim(Anim, 0.0, 0.0, 0); // the Super wasn't playing the selected anim & always played the pawn's DiveToProneEndAnim
        }

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
            PlaySound(Sound'Inf_Player.FootStepWaterDeep', SLOT_Interact, FootstepVolume * 2.0,, FootStepSoundRadius);

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
    PlaySound(DHSoundFootsteps[SurfaceTypeID], SLOT_Interact, FootstepVolume * SoundVolumeModifier,, FootStepSoundRadius * SoundRadiusModifier);
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
    local xUtil.PlayerRecord      Rec;

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
            Rec = class'xUtil'.static.FindPlayerRecord(PRI.CharacterName);
            Setup(Rec);
            bInitializedPlayer = true;

            // Added call to LoadResources() if we don't have a PlayerRecord (we won't now in DH)
            // Without a PlayerRecord it no longer gets called from the PlayerController's PostNetReceive() or the PRI's UpdatePrecacheMaterials()
            // But there is a small amount of LoadResources() that is still relevant, even without a PlayerRecord
            if (Rec.Species == none)
            {
                if (PRI.Team != none)
                {
                    Species.static.LoadResources(Rec, Level, PRI, PRI.Team.TeamIndex);
                }
                else
                {
                    Species.static.LoadResources(Rec, Level, PRI, 255);
                }
            }
        }
    }
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

// New function to handle Modified to set up any random selection of body & face skins for the player mesh
// In multiplayer the server selects & replicates to all net clients
simulated function SetBodyAndFaceSkins(optional byte BodySkinsIndex, optional byte FaceSkinsIndex)
{
    local int  BodySlot, FaceSlot;
    local bool bIsDebugPawn;

    // Identify if this is a debug pawn, i.e. a fake pawn (not a real player) spawned by another DHPawn using a debug function
    // Then have to reset owner to none so we can see our own debug pawn (as pawns have bOwnerNoSee=true, so otherwise it would be hidden from us!)
    // But don't change owner on a server as we need a net client to receive that when it runs this function as it initialises
    if (DHPawn(Owner) != none)
    {
        bIsDebugPawn = true;

        if (Level.NetMode != NM_DedicatedServer)
        {
            SetOwner(none);
        }
    }

    // Authority role makes random selection of skin for body & face, if any choices are specified in the BodySkins or FaceSkins arrays
    if (Role == ROLE_Authority)
    {
        if (!bIsDebugPawn) // skip random selection & any warnings if this is just a debug pawn
        {
            // Select index for body skin
            if (BodySkins.Length > 0)
            {
                // First trim the array if more than 16 members
                // Server can only pack a maximum of 16 into a byte to replicate to net clients & more than 16 probably just means a typo in the numbering
                // Don't need to do this on client as the excess members will simply be ignored & have no effect
                if (BodySkins.Length > 16)
                {
                    Log("WARNING: class '" $ Name $ "' with excessive BodySkins array in defaultproperties - please reduce to no higher than BodySkins(15)");
                    BodySkins.Length = 16;
                }

                // Now make random selection
                BodySkinsIndex = Rand(BodySkins.Length);

                if (BodySkins[BodySkinsIndex] == none)
                {
                    Log("WARNING: class '" $ Name $ "' with empty BodySkins[" $ BodySkinsIndex $ "] in defaultproperties - please specify a skin or remove the entry");
                }
            }

            // Select index for face skin
            if (FaceSkins.Length > 0)
            {
                if (FaceSkins.Length > 16)
                {
                    Log("WARNING: class '" $ Name $ "' with excessive FaceSkins array in defaultproperties - please reduce to no higher than FaceSkins(15)");
                    FaceSkins.Length = 16;
                }

                FaceSkinsIndex = Rand(FaceSkins.Length);

                if (FaceSkins[FaceSkinsIndex] == none)
                {
                    Log("WARNING: class '" $ Name $ "' with empty FaceSkins[" $ FaceSkinsIndex $ "] in defaultproperties - please specify a skin or remove the entry");
                }
            }
        }

        // Server packs the selected skin indexes into a single byte for most efficient replication to net clients
        if (Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer)
        {
            PackedSkinIndexes = (BodySkinsIndex * 16) + FaceSkinsIndex;
        }
    }
    // Net client unpacks replicated byte received from server to get selected index numbers for body & face skins
    else
    {
        BodySkinsIndex = PackedSkinIndexes / 16;
        FaceSkinsIndex = PackedSkinIndexes - (BodySkinsIndex * 16);
    }

    // Finally we set any new body or skin from the selected index position in our BodySkins or FaceSkins arrays
    // Ignore any empty skins slot unless this is just a debug pawn, in which case we'll set the null texture on the pawn as it highlights the problem
    if (Level.NetMode != NM_DedicatedServer)
    {
        // Body & face skin slots are normally 0 & 1 respectively, but some DH meshes have this reversed, so this option handles that
        if (bReversedSkinsSlots)
        {
            BodySlot = 1;
        }
        else
        {
            FaceSlot = 1;
        }

        if (BodySkinsIndex < BodySkins.Length && Skins[BodySlot] != BodySkins[BodySkinsIndex] && (BodySkins[BodySkinsIndex] != none || bIsDebugPawn))
        {
            Skins[BodySlot] = BodySkins[BodySkinsIndex];
        }

        if (FaceSkinsIndex < FaceSkins.Length && Skins[FaceSlot] != FaceSkins[FaceSkinsIndex] && (FaceSkins[FaceSkinsIndex] != none || bIsDebugPawn))
        {
            Skins[FaceSlot] = FaceSkins[FaceSkinsIndex];
        }
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

// Modified to use DHShadowProjector class (unlike vehicle shadows, this has no functional change, but the projector's tick functionality is optimised)
simulated function UpdateShadow()
{
    if (PlayerShadow != none) // shouldn't already have a shadow, so destroy any that somehow exists
    {
        PlayerShadow.Destroy();
        PlayerShadow = none;
    }

    if (Level.NetMode != NM_DedicatedServer && bPlayerShadows && bActorShadows)
    {
        PlayerShadow = Spawn(class'DHShadowProjector', self, '', Location);

        if (PlayerShadow != none)
        {
            PlayerShadow.ShadowActor = self;
            PlayerShadow.bBlobShadow = bBlobShadow;
            PlayerShadow.LightDirection = Normal(vect(1.0, 1.0, 3.0));
            PlayerShadow.LightDistance = 320.0;
            PlayerShadow.MaxTraceDistance = 350;

            PlayerShadow.InitShadow();
        }
    }
}

simulated function NotifySelected(Pawn User)
{
    local DHPawn P;

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

    if (!P.bUsedCarriedMGAmmo && P.bCarriesExtraAmmo && bWeaponNeedsResupply)
    {
        P.ReceiveLocalizedMessage(TouchMessageClass, 0, self.PlayerReplicationInfo,, User.Controller);
        LastNotifyTime = Level.TimeSeconds;
    }
    else if (bWeaponNeedsReload)
    {
        P.ReceiveLocalizedMessage(TouchMessageClass, 1, self.PlayerReplicationInfo,, User.Controller);
        LastNotifyTime = Level.TimeSeconds;
    }
}

// Modified to add a safeguard against a mapper specifying an invalid item name in a GivenItems slot
// Can happen as he's entering text, unlike the weapon slots where he simply picks a class from a drop down list
// Also optimised by avoiding a pointless inventory checking loop & if there are no GivenItems to check for (true for most roles)
simulated function bool VerifyGivenItems()
{
    local array<class<Inventory> > GivenItemClasses;
    local class<Inventory>         InventoryClass;
    local Inventory                Inv;
    local RORoleInfo               RI;
    local int                      FoundItemsCount, LoopCount, i;

    RI = GetRoleInfo();

    if (RI != none)
    {
        // First loop through GivenItems array & build an array of inventory classes to check against
        // Ignores any invalid entries that don't load as it's not a valid class & so the item is not going to spawn/exist
        for (i = 0; i < RI.GivenItems.Length; ++i)
        {
            InventoryClass = class<Inventory>(DynamicLoadObject(RI.GivenItems[i], class'Class'));

            if (InventoryClass != none)
            {
                GivenItemClasses[GivenItemClasses.Length] = InventoryClass;
            }
        }

        // If the GivenItems array is empty or contains no valid items, just return true so that GivenItems are verified
        // No point checking for something that isn't going to exist
        if (GivenItemClasses.Length == 0)
        {
            return true;
        }

        // Loop through the pawn's inventory & find if it has all the valid items we've saved in our GivenItemClasses array
        for (Inv = Inventory; Inv != none; Inv = Inv.Inventory)
        {
            if (Weapon(Inv) != none && Inv.Instigator != none)
            {
                for (i = 0; i < GivenItemClasses.Length; ++i)
                {
                    // This inventory item is in the role's GivenItems, so increment the found count & return true if we've now found all the GivenItems
                    if (GivenItemClasses[i] == Inv.Class)
                    {
                        FoundItemsCount++;

                        if (FoundItemsCount == GivenItemClasses.Length)
                        {
                            return true;
                        }

                        break;
                    }
                }
            }

            if (++LoopCount > 500) // runaway loop safeguard
            {
                break;
            }
        }
    }

    return false;
}

// New helper function to check whether debug execs can be run
simulated function bool IsDebugModeAllowed()
{
    return Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode();
}

// Bogeyman mode to become invisible and invincible, useful for filming!
exec function BogeyMan()
{
    local DarkestHourGame G;
    local DHPlayer PC;

    G = DarkestHourGame(Level.Game);
    PC = DHPlayer(Controller);

    if (G == none || PC == none)
    {
        return;
    }

    if (G.IsAdmin(PC) || class'DHAccessControl'.static.IsDeveloper(PC.ROIDHash))
    {
        PC.bGodMode = true;
        bHidden = true;
        SetCollision(false, false, false);

        PC.ClientMessage("Bogeyman, goin' black...", 'Say');
    }
}

// New debug exec to make bots spawn
// Team is 0 for axis, 1 for allies, 2 for both
// Num is optional & limits the number of bots that will be spawned (if not entered, zero is passed & gets used to signify no limit on numbers)
exec function DebugSpawnBots(int Team, optional int Num, optional int Distance)
{
    local DarkestHourGame DHG;
    local Controller      C;
    local ROBot           B;
    local vector          TargetLocation, RandomOffset;
    local rotator         Direction;
    local int             i;

    DHG = DarkestHourGame(Level.Game);

    if (DHG != none && (IsDebugModeAllowed() || DHG.IsAdmin(PlayerController(Controller))))
    {
        TargetLocation = Location;

        // If a Distance has been specified, move the target spawn location that many metres away from the player's location, in the yaw direction he is facing
        if (Distance > 0)
        {
            Direction.Yaw = Rotation.Yaw;
            TargetLocation += vector(Direction) * class'DHUnits'.static.MetersToUnreal(Distance);
        }

        for (C = Level.ControllerList; C != none; C = C.NextController)
        {
            B = ROBot(C);

            // Look for bots that aren't in game & are on the the specified team (Team 2 signifies to spawn bots of both teams)
            if (B != none && B.Pawn == none && (Team == 2 || B.GetTeamNum() == Team))
            {
                // Spawn bot
                DHG.DeployRestartPlayer(B, false, true);

                if (B != none && B.Pawn != none)
                {
                    // Randomise location a little, so bots don't all spawn on top of each other
                    RandomOffset = VRand() * 120.0;
                    RandomOffset.Z = 0.0;

                    // Move bot to target location
                    if (B.Pawn.SetLocation(TargetLocation + RandomOffset))
                    {
                        // If spawn & move successful, check if we've reached any specified number of bots to spawn (NumBots zero signifies no limit, so skip this check)
                        if (Num > 0 && ++i >= Num)
                        {
                            break;
                        }
                    }
                    // But if we couldn't move the bot to the target, kill the pawn
                    else
                    {
                        B.Pawn.Suicide();
                    }
                }
            }
        }
    }
}

// New debug exec to spawn player pawns with all possible permutations of body & face skins that can be randomly selected
// Works with either a DHRoleInfo class (includes all of its specified RolePawns classes) or a single DHPawn class
// Use "DebugPlayerModels kill" to just remove all existing debug pawns that have been spawned
// Use "DebugPlayerModels <ClassName> true" or "DebugPlayerModels true" to show every possible body & face skin permutation (or FaceSkins combinations won't be spawned)
exec function DebugPlayerModels(string ClassName, optional bool bShowAllFaceCombinations)
{
    local class<DHRoleInfo> RoleClass;
    local class<DHPawn>     PawnClass;
    local DHPawn            P;
    local vector            SpawnLocation;
    local rotator           Direction;
    local int               i;

    // Don't run this on client as resulting pawns only exist clientside & work badly, e.g. can't be shot (use 'admin' console command if you need to use in multiplayer)
    if (Role < ROLE_Authority || !IsDebugModeAllowed())
    {
        return;
    }

    // If "kill" option was specified then just find & destroy any existing debug pawns that have been spawned, so we don't end up with lots of them
    if (ClassName ~= "kill")
    {
        foreach DynamicActors(class'DHPawn', P, 'DebugPawn')
        {
            P.Destroy();
        }

        return;
    }

    // Load the debug role or pawn class from the passed in string value, or use our own role or pawn class if no ClassName has been specified
    if (ClassName == "" || ClassName ~= "true")
    {
        if (GetRoleInfo() != none)
        {
            RoleClass = GetRoleInfo().Class;
        }
        else
        {
            PawnClass = Class;
        }

        if (ClassName ~= "true") // "DebugPlayerModels true" uses our own role class & enables the bShowAllFaceCombinations option
        {
            bShowAllFaceCombinations = true;
        }
    }
    else
    {
        RoleClass = class<DHRoleInfo>(DynamicLoadObject(ClassName, class'Class'));

        if (RoleClass == none)
        {
            PawnClass = class<DHPawn>(DynamicLoadObject(ClassName, class'Class'));
        }

        if (RoleClass == none && PawnClass == none)
        {
            ClientMessage("DebugPlayerModels: don't recognise '" $ ClassName $ "' as a valid DHRoleInfo or DHPawn class");

            return;
        }
    }

    // Set SpawnLocation for 1st debug pawn - approx 3m in front of us
    Direction.Yaw = Rotation.Yaw;
    SpawnLocation = Location + (180.0 * vector(Direction));

    // If a role class has been specified, spawn debug pawns for each of its RolePawns
    // Updated SpawnLocation is passed back to us by SpawnDebugPawns() so positioning works for subsequent pawn classes
    if (RoleClass != none)
    {
        for (i = 0; i < RoleClass.default.RolePawns.Length; ++i)
        {
            PawnClass = class<DHPawn>(RoleClass.default.RolePawns[i].PawnClass);

            if (PawnClass != none)
            {
                SpawnDebugPawns(PawnClass, SpawnLocation, bShowAllFaceCombinations);
            }
            else
            {
                ClientMessage("WARNING: '" $ RoleClass $ "' with empty RolePawns[" $ i $ "] - specify a pawn class or remove it");
                Log("WARNING: '" $ RoleClass $ "' with empty RolePawns[" $ i $ "] - specify a pawn class or remove it");
            }
        }
    }
    // Or if a pawn class has been specified, spawn debug pawns for that pawn class
    else if (PawnClass != none)
    {
        SpawnDebugPawns(PawnClass, SpawnLocation, bShowAllFaceCombinations);
    }
}

// New helper function to DebugPlayerModels() exec, to spawn player pawns with all possible permutations of body & face skins that can be randomly selected
// Passes back updated SpawnLocation so pawn positioning works for a series of pawn classes
function SpawnDebugPawns(class<DHPawn> PawnClass, out vector SpawnLocation, optional bool bShowAllFaceCombinations)
{
    local DHPawn  P;
    local vector  NextSpawnOffset;
    local rotator SpawnRotation, NextSpawnOffsetDirection;
    local byte    BodySkinsIndex, FaceSkinsIndex;

    if (PawnClass == none || Role < ROLE_Authority)
    {
        return;
    }

    // Skins arrays can only have a maximum size of 16, so check size & trim if too big & issue a warning
    if (PawnClass.default.BodySkins.Length > 16)
    {
        ClientMessage("WARNING: '" $ PawnClass $ "' - reduce BodySkins array to no more than index no.15!");
        Log("WARNING: '" $ PawnClass $ "' - reduce BodySkins array to no more than BodySkins(15)!");
        PawnClass.default.BodySkins.Length = 16;
    }

    if (PawnClass.default.FaceSkins.Length > 16)
    {
        ClientMessage("WARNING: '" $ PawnClass $ "' - reduce FaceSkins array to no more than index no.15!");
        Log("WARNING: '" $ PawnClass $ "' - reduce FaceSkins array to no more than FaceSkins(15)!");
        PawnClass.default.FaceSkins.Length = 16;
    }

    // Set spawn rotation for debug pawns (facing us) & a spacing offset between pawns (approx 1m to the right) - so they form a line in front of us
    SpawnRotation.Yaw = Rotation.Yaw + 32768;
    NextSpawnOffsetDirection.Yaw = Rotation.Yaw + 16384;
    NextSpawnOffset = 60.0 * vector(NextSpawnOffsetDirection);

    // Loop through all BodySkins & spawn a debug pawn for each one
    // We use a 'do until' loop so we can handle pawn classes that don't have a BodySkins array, in which case we'll keep the mesh's default skin
    do
    {
        // If this BodySkins slot is empty then give a warning (done here so only happens once for this BodySkins slot)
        if (PawnClass.default.BodySkins.Length > 0 && PawnClass.default.BodySkins[BodySkinsIndex] == none)
        {
            ClientMessage("WARNING: '" $ PawnClass $ "' with empty BodySkins[" $ BodySkinsIndex $ "] - specify a skin or remove it");
            Log("WARNING: '" $ PawnClass $ "' with empty BodySkins[" $ BodySkinsIndex $ "] - specify a skin or remove it");
        }

        FaceSkinsIndex = 0; // reset for each BodySkins slot

        // This is the FaceSkins loop
        // But note that unless bShowAllFaceCombinations option has been specified, we won't actually spawn a pawn for every body/face skins permutation
        // It's not that useful to see every combination of face skin for every body skin & for some pawn classes we'd end up with masses of debug pawns
        // So by default we exit FaceSkins loop after 1 pawn has been spawned for this body skin - use bShowAllFaceCombinations option to override this
        do
        {
            // Spawn a debug pawn - the assigned tag allows us to find & destroy them later to clear things up
            // And assigning ourselves as its owner allows us to determine it's a debug pawn in its initialisation & avoid doing random skin set up
            // Note we can't use the 'DebugPawn' tag to do that because it isn't assigned until after the new pawn's initialisation
            P = Spawn(PawnClass, self, 'DebugPawn', SpawnLocation, SpawnRotation);

            if (P != none)
            {
                // Now set the current combination of body & face skins
                // Changing NetUpdateTime is attempt to delay server's replication of new pawn until it's set skin indexes, then do a quick net update
                // But generally this debug will be used in single player
                P.NetUpdateTime = Level.TimeSeconds + 100.0;
                P.SetBodyAndFaceSkins(BodySkinsIndex, FaceSkinsIndex);
                P.NetUpdateTime = Level.TimeSeconds - 1.0;
                P.PlayAnim(IdleRestAnim); // put the pawn in a neutral pose (doesn't get played here on client, but client's pose is fine anyway)

                // On the 1st loop through FaceSkins, if this slot is empty then give a warning
                if (BodySkinsIndex == 0 && P.FaceSkins.Length > 0 && P.FaceSkins[FaceSkinsIndex] == none)
                {
                    ClientMessage("WARNING: '" $ PawnClass $ "' with empty FaceSkins[" $ FaceSkinsIndex $ "] - specify a skin or remove it");
                    Log("WARNING: '" $ PawnClass $ "' with empty FaceSkins[" $ FaceSkinsIndex $ "] - specify a skin or remove it");
                }

                // Adjust the next spawn location about 1m to the right, so pawns form a line in front of us
                SpawnLocation += NextSpawnOffset;
            }

            FaceSkinsIndex++;
        }
        until (!bShowAllFaceCombinations || FaceSkinsIndex >= PawnClass.default.FaceSkins.Length) // by default we exit after 1st pass, unless using bShowAllFaceCombinations option

        BodySkinsIndex++;
    }
    until (BodySkinsIndex >= PawnClass.default.BodySkins.Length)
}

// Debug exec to set own player on fire
exec function BurnPlayer()
{
    if (IsDebugModeAllowed())
    {
        bOnFire = true;
        FireDamage = 1;
    }
}

// Debug exec to increase fly speed
exec function SetFlySpeed(float NewSpeed)
{
    if (IsDebugModeAllowed())
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

exec function GimmeSupplies()
{
    switch (GetTeamNum())
    {
        case AXIS_TEAM_INDEX:
            DebugSpawnVehicle("DH_OpelBlitzSupport", 5.0);
            break;
        case ALLIES_TEAM_INDEX:
            DebugSpawnVehicle("DH_GMCTruckSupport", 5.0);
            break;
    }
}

// New debug exec to spawn any vehicle, in front of you
exec function DebugSpawnVehicle(string VehicleString, int Distance, optional int Degrees)
{
    local class<Vehicle> VehicleClass;
    local Vehicle        V;
    local vector         SpawnLocation;
    local rotator        SpawnDirection;

    // TODO: there really is no reason why a game admin should be able to spawn vehicles in the live game & the admin 'pass through' should be removed here - Matt
    if (VehicleString != "" && (IsDebugModeAllowed() || (PlayerReplicationInfo != none && (PlayerReplicationInfo.bAdmin || PlayerReplicationInfo.bSilentAdmin))))
    {
        if (InStr(VehicleString, ".") == -1) // saves typing in "DH_Vehicles." in front of almost all vehicles spawned (but still allows a package name to be specified)
        {
            VehicleString = "DH_Vehicles." $ VehicleString;
        }

        VehicleClass = class<Vehicle>(DynamicLoadObject(VehicleString, class'class'));

        if (VehicleClass != none)
        {
            SpawnDirection.Yaw = Rotation.Yaw;
            SpawnLocation = Location + (vector(SpawnDirection) * class'DHUnits'.static.MetersToUnreal(Max(Distance, 5.0))); // distance is raised to 5 if <5

            // Add the vehicle's desired rotation (90 will be perpendicular)
            SpawnDirection.Yaw += class'UUnits'.static.DegreesToUnreal(Degrees);

            V = Spawn(VehicleClass,,, SpawnLocation, SpawnDirection);
            Level.Game.Broadcast(self, "Admin" @ GetHumanReadableName() @ "spawned a" @ V.GetHumanReadableName());
        }
    }
}

// New debug exec to make player's current weapon fire dummy AP shells, which is very useful for checking vehicle armour is set up correctly
// It also enables penetration debug, which shows on screen text & lines
// Entering this console command again will toggle your weapon back to using its normal ammo & disable penetration debug
// The dummy AP shells do no damage & have no spread & a minimum ballistic drop (for accurate aiming to check certain armour locations)
// By default, dummy shells will be 75mm calibre & never penetrate - you just use the debug info on screen to check the armour is set up ok
// But you can specify a specific shell class (from DH_Vehicles package) & then dummy shells will use its calibre & penetration properties
exec function DebugShootAP(optional string APProjectileClassName)
{
    local class<DHAntiVehicleProjectile> DebugProjectileClass, APProjectileClass;
    local DHProjectileFire               FireMode;
    local bool                           bDebugAPEnabled;
    local int                            i;

    if (IsDebugModeAllowed() && Weapon != none)
    {
        FireMode = DHProjectileFire(Weapon.GetFireMode(0));

        if (FireMode != none)
        {
            DebugProjectileClass = class'DH_Engine.DHDummyDebugAPShell'; // just avoids lots of literals

            if (APProjectileClassName != "") // get projectile class from any specified class name
            {
                APProjectileClass = class<DHAntiVehicleProjectile>(DynamicLoadObject("DH_Vehicles." $ APProjectileClassName, class'Class'));
            }

            // Switch current weapon to fire dummy (non-damaging) debug AP rounds
            // If a valid projectile class has been specified, we'll keep the debug enabled, as player may have just switched projectile class
            if (FireMode.ProjectileClass != DebugProjectileClass || APProjectileClass != none)
            {
                bDebugAPEnabled = true;
                FireMode.ProjectileClass = DebugProjectileClass;
                FireMode.bUsePreLaunchTrace = false; // have to disable PLT otherwise it stops projectiles even being spawned for close range shots
                FireMode.SpreadStyle = SS_None;

                // If specific AP projectile class name has been specified, we'll use that to set properties for the debug shell class
                if (APProjectileClass != none)
                {
                    DebugProjectileClass.default.RoundType = APProjectileClass.default.RoundType;
                    DebugProjectileClass.default.ShellDiameter = APProjectileClass.default.ShellDiameter;
                    DebugProjectileClass.default.bShatterProne = APProjectileClass.default.bShatterProne;

                    for (i = 0; i < arraycount(DebugProjectileClass.default.DHPenetrationTable); ++i)
                    {
                        DebugProjectileClass.default.DHPenetrationTable[i] = APProjectileClass.default.DHPenetrationTable[i];
                    }
                }
                // Otherwise use a default 75mm shell calibre with zero penetration for debug shell class
                // Have to hard code literals here, as debug shell class defaults may have been changed by earlier debugging
                else
                {
                    DebugProjectileClass.default.RoundType = RT_APC;
                    DebugProjectileClass.default.ShellDiameter = 7.5;
                    DebugProjectileClass.default.bShatterProne = false;

                    for (i = 0; i < arraycount(DebugProjectileClass.default.DHPenetrationTable); ++i)
                    {
                        DebugProjectileClass.default.DHPenetrationTable[i] = 0;
                    }
                }
            }
            // Or toggle back to using normal weapon ammo (if debug AP is already enabled & a projectile class hasn't been specified)
            else
            {
                FireMode.ProjectileClass = FireMode.default.ProjectileClass;
                FireMode.bUsePreLaunchTrace = FireMode.default.bUsePreLaunchTrace;
                FireMode.SpreadStyle = FireMode.default.SpreadStyle;
            }

            // Enable penetration debugging (or toggle back to off)
            if (DHPlayer(Controller) != none)
            {
                DHPlayer(Controller).DebugPenetration(bDebugAPEnabled);
            }
        }
    }
}

function ServerGiveWeapon(string WeaponClass)
{
    local Weapon NewWeapon;

    GiveWeapon(WeaponClass);
    NewWeapon = Weapon(FindInventoryType(class<Weapon>(DynamicLoadObject(WeaponClass, class'class'))));

    if (NewWeapon != none)
    {
        NewWeapon.ClientWeaponSet(true);
    }
}

// Modified to fix an accessed none that could happen if Weapon was none
simulated function NextWeapon()
{
    if (Level.Pauser != none || !bRecievedInitialLoadout)
    {
        return;
    }

    if (Weapon == none && Controller != none)
    {
        Controller.SwitchToBestWeapon();

        return;
    }

    if (PendingWeapon != none)
    {
        if (PendingWeapon.bForceSwitch)
        {
            return;
        }

        if (Inventory != none)
        {
            PendingWeapon = Inventory.NextWeapon(none, PendingWeapon);
        }
    }
    else if (Inventory != none)
    {
        PendingWeapon = Inventory.NextWeapon(none, Weapon);
    }

    if (PendingWeapon != none && PendingWeapon != Weapon && Weapon != none)
    {
        Weapon.PutDown();
    }
}

// Emptied out as irrelevant to RO/DH (concerns UT2004 PowerUps) & can just cause "accessed none" log errors if keybound & used (if player has no inventory)
exec function NextItem()
{
}

// Overridden from ROPawn to fix "sequence not found" bugs when a weapon simply
// does not have a WA_Idle or WA_IdleEmpty.
simulated function StartFiring(bool bAltFire, bool bRapid)
{
    local name FireAnim;
    local bool bIsMoving;

    if (Physics == PHYS_Swimming || WeaponAttachment == none)
    {
        return;
    }

    bIsMoving = VSizeSquared(Velocity) > 25;

    if (bAltFire)
    {
        if (WeaponAttachment.bBayonetAttached)
        {
            if (bIsCrawling)
            {
                FireAnim = WeaponAttachment.PA_ProneBayonetAltFire;
            }
            else if (bIsCrouched)
            {
                FireAnim = WeaponAttachment.PA_CrouchBayonetAltFire;
            }
            else
            {
                FireAnim = WeaponAttachment.PA_BayonetAltFire;
            }
        }
        else
        {
            if (bIsCrawling)
            {
                FireAnim = WeaponAttachment.PA_ProneAltFire;
            }
            else if (bIsCrouched)
            {
                FireAnim = WeaponAttachment.PA_CrouchAltFire;
            }
            else if (bBipodDeployed)
            {
                FireAnim = WeaponAttachment.PA_DeployedAltFire;
            }
            else
            {
                FireAnim = WeaponAttachment.PA_AltFire;
            }
        }
    }
    // Regular fire
    else
    {
        if (bBipodDeployed)
        {
            if (bIsCrouched)
            {
                FireAnim = WeaponAttachment.PA_CrouchDeployedFire;
            }
            else if (bIsCrawling)
            {
                FireAnim = WeaponAttachment.PA_ProneDeployedFire;
            }
            else
            {
                FireAnim = WeaponAttachment.PA_DeployedFire;
            }
        }
        else if (bIsCrawling)
        {
            FireAnim = WeaponAttachment.PA_ProneFire;
        }
        else if (bIsCrouched)
        {
            if (bIsMoving)
            {
                FireAnim = WeaponAttachment.PA_MoveCrouchFire[Get8WayDirection()];
            }
            else
            {
                if (bIronSights)
                {
                    FireAnim = WeaponAttachment.PA_CrouchIronFire;
                }
                else
                {
                    FireAnim = WeaponAttachment.PA_CrouchFire;
                }
            }
        }
        else if (bIronSights)
        {
            if (bIsMoving)
            {
                FireAnim = WeaponAttachment.PA_MoveStandIronFire[Get8WayDirection()];
            }
            else
            {
                FireAnim = WeaponAttachment.PA_IronFire;
            }
        }
        else
        {
            if (bIsMoving)
            {
                if (bIsWalking)
                {
                    FireAnim = WeaponAttachment.PA_MoveWalkFire[Get8WayDirection()];
                }
                else
                {
                    FireAnim = WeaponAttachment.PA_MoveStandFire[Get8WayDirection()];

                }
            }
            else
            {
                FireAnim = WeaponAttachment.PA_Fire;
            }
        }
    }

    // Blend the fire animation a bit so the standard player movement animations still play
    AnimBlendParams(1, 0.25, 0.0, 0.2, FireRootBone);

    if (bRapid)
    {
        if (WeaponState != GS_FireLooped)
        {
            LoopAnim(FireAnim,, 0.0, 1);
            WeaponState = GS_FireLooped;

            if (!bAltFire)
            {
                if (WeaponAttachment.bBayonetAttached && WeaponAttachment.WA_BayonetFire != '')
                {
                    WeaponAttachment.LoopAnim(WeaponAttachment.WA_BayonetFire);
                }
                else if (WeaponAttachment.WA_Fire != '')
                {
                    WeaponAttachment.LoopAnim(WeaponAttachment.WA_Fire);
                }
            }
        }
    }
    else
    {
        PlayAnim(FireAnim,, 0.0, 1);
        WeaponState = GS_FireSingle;

        if (!bAltFire)
        {
            if (WeaponAttachment.bBayonetAttached)
            {
                if (WeaponAttachment.WA_BayonetFire != '')
                {
                    WeaponAttachment.PlayAnim(WeaponAttachment.WA_BayonetFire);
                }
            }
            else
            {
                if (WeaponAttachment.WA_Fire != '')
                {
                    WeaponAttachment.PlayAnim(WeaponAttachment.WA_Fire);
                }
            }
        }
    }

    IdleTime = Level.TimeSeconds;
}

// Modified to remove the HasAmmo check since we really don't care if it has
// ammo or not.
exec function SwitchToLastWeapon()
{
    if (Weapon != none && Weapon.OldWeapon != none)
    {
        PendingWeapon = Weapon.OldWeapon;
        Weapon.PutDown();
    }
}

// Uses up the total supplies specified using the touching supply attachments.
// Returns true if the supplies were used, or false if there were not enough
// supplies nearby to perform the operation.
function bool UseSupplies(int SupplyCost, optional out array<DHConstructionSupplyAttachment.Withdrawal> Withdrawals)
{
    local int i, SuppliesToUse, TotalSupplyCount;
    local UComparator AttachmentComparator;
    local array<DHConstructionSupplyAttachment> Attachments;

    for (i = 0; i < TouchingSupplyAttachments.Length; ++i)
    {
        if (TouchingSupplyAttachments[i] != none)
        {
            TotalSupplyCount += TouchingSupplyAttachments[i].GetSupplyCount();
        }
    }

    if (TotalSupplyCount < SupplyCost)
    {
        return false;
    }

    // Sort the supply attachments by priority.
    Attachments = TouchingSupplyAttachments;
    AttachmentComparator = new class'UComparator';
    AttachmentComparator.CompareFunction = class'DHConstructionSupplyAttachment'.static.CompareFunction;
    class'USort'.static.Sort(Attachments, AttachmentComparator);

    // Use supplies from the sorted supply attachments, in order, until costs are met.
    for (i = 0; i < Attachments.Length; ++i)
    {
        if (SupplyCost == 0)
        {
            break;
        }

        SuppliesToUse = Min(SupplyCost, Attachments[i].GetSupplyCount());

        Attachments[i].SetSupplyCount(Attachments[i].GetSupplyCount() - SuppliesToUse);

        Withdrawals.Insert(0, 1);
        Withdrawals[0].Attachment = Attachments[i];
        Withdrawals[0].Amount = SuppliesToUse;

        SupplyCost -= SuppliesToUse;
    }

    return true;
}

// Attempts to refund supplies to nearby supply attachments. Returns the total
// amount of supplies that were actually refunded.
function int RefundSupplies(int SupplyCount)
{
    local int i, SuppliesToRefund, SuppliesRefunded;
    local array<DHConstructionSupplyAttachment> Attachments;
    local UComparator AttachmentComparator;

    // Sort the supply attachments by priority.
    Attachments = TouchingSupplyAttachments;
    AttachmentComparator = new class'UComparator';
    AttachmentComparator.CompareFunction = class'DHConstructionSupplyAttachment'.static.CompareFunction;
    class'USort'.static.Sort(Attachments, AttachmentComparator);

    for (i = 0; i < Attachments.Length; ++i)
    {
        if (SupplyCount == 0)
        {
            break;
        }

        SuppliesToRefund = Min(SupplyCount, Attachments[i].SupplyCountMax - Attachments[i].GetSupplyCount());
        Attachments[i].SetSupplyCount(Attachments[i].GetSupplyCount() + SuppliesToRefund);
        SuppliesRefunded += SuppliesToRefund;
        SupplyCount -= SuppliesToRefund;
    }

    return SuppliesRefunded;
}

simulated function class<DHVoicePack> GetVoicePack()
{
    return class<DHVoicePack>(VoiceClass);
}

function EnterATRotation(DHATGun Gun)
{
    GunToRotate = Gun;

    ServerGiveWeapon("DH_Weapons.DH_ATGunRotateWeapon");
}

function ServerExitATRotation()
{
    GunToRotate = none;

    ClientExitATRotation();
}

simulated function ClientExitATRotation()
{
    GunToRotate = none;

    if (Weapon != none && Weapon.OldWeapon != none)
    {
        // HACK: This stops a standalone client from immediately firing
        // their previous weapon.
        if (Level.NetMode == NM_Standalone)
        {
            Instigator.Weapon.OldWeapon.ClientState = WS_Hidden;
        }

        SwitchToLastWeapon();
        ChangedWeapon();
    }
    else
    {
        // We've no weapon to go back to so just put this down, subsequently
        // destroying it.
        if (Weapon != none)
        {
            Weapon.PutDown();
        }

        Controller.SwitchToBestWeapon();
    }
}

exec function RotateAT()
{
    local DHATGun Gun;

    foreach RadiusActors(class'DHATGun', Gun, 256.0)
    {
        if (Gun != none)
        {
            break;
        }
    }

    if (Gun == none || Gun.GetRotationError(self) != ERROR_None)
    {
        return;
    }

    GunToRotate = Gun;

    ServerGiveWeapon("DH_Weapons.DH_ATGunRotateWeapon");
}

exec simulated function IronSightDisplayFOV(float FOV)
{
    local DHProjectileWeapon W;

    if (IsDebugModeAllowed())
    {
        W = DHProjectileWeapon(Weapon);

        if (W != none)
        {
            W.default.IronSightDisplayFOV = FOV;
            W.default.IronSightDisplayFOVHigh = FOV;
            W.SetIronSightFOV();
        }
    }
}

exec simulated function ShellRotOffsetIron(int Pitch, int Yaw, int Roll)
{
    local ROWeaponFire WF;

    if (IsDebugModeAllowed())
    {
        WF = ROWeaponFire(Weapon.GetFireMode(0));

        if (WF != none)
        {
            WF.ShellRotOffsetIron.Pitch = Pitch;
            WF.ShellRotOffsetIron.Yaw = Yaw;
            WF.ShellRotOffsetIron.Roll = Roll;
        }
    }
}

exec simulated function ShellRotOffsetHip(int Pitch, int Yaw, int Roll)
{
    local ROWeaponFire WF;

    if (IsDebugModeAllowed())
    {
        WF = ROWeaponFire(Weapon.GetFireMode(0));

        if (WF != none)
        {
            WF.ShellRotOffsetHip.Pitch = Pitch;
            WF.ShellRotOffsetHip.Yaw = Yaw;
            WF.ShellRotOffsetHip.Roll = Roll;
        }
    }
}

exec simulated function ShellHipOffset(int X, int Y, int Z)
{
    local ROWeaponFire WF;

    if (IsDebugModeAllowed())
    {
        WF = ROWeaponFire(Weapon.GetFireMode(0));

        if (WF != none)
        {
            WF.ShellHipOffset.X = X;
            WF.ShellHipOffset.Y = Y;
            WF.ShellHipOffset.Z = Z;
        }
    }
}

exec simulated function ShellIronSightOffset(int X, int Y, int Z)
{
    local ROWeaponFire WF;

    if (IsDebugModeAllowed())
    {
        WF = ROWeaponFire(Weapon.GetFireMode(0));

        if (WF != none)
        {
            WF.ShellIronSightOffset.X = X;
            WF.ShellIronSightOffset.Y = Y;
            WF.ShellIronSightOffset.Z = Z;
        }
    }
}

exec simulated function Give(string WeaponName)
{
    local string ClassName;
    local int i;

    if (!PlayerReplicationInfo.bAdmin && !IsDebugModeAllowed())
    {
        return;
    }

    if (WeaponName ~= "ALL")
    {
        for (i = 0; i < class'DHWeaponRegistry'.default.Records.Length; ++i)
        {
            if (class'DHWeaponRegistry'.default.Records[i].bShouldExcludeFromGiveAll)
            {
                continue;
            }

            GiveWeapon(class'DHWeaponRegistry'.default.Records[i].ClassName);
        }

        return;
    }

    ClassName = class'DHWeaponRegistry'.static.GetClassNameFromWeaponName(WeaponName);

    if (ClassName == "")
    {
        ClassName = WeaponName;
    }

    GiveWeapon(ClassName);
}

exec function BigHead(float V)
{
    SetHeadScale(V);
}

defaultproperties
{
    // General class & interaction stuff
    Mesh=none // must be set by a specific pawn subclass
    Species=class'DH_Engine.DHSPECIES_Human'
    ControllerClass=class'DH_Engine.DHBot'
    TouchMessageClass=class'DHPawnTouchMessage'
    bAutoTraceNotify=true
    bCanAutoTraceSelect=true
    HeadgearClass=class'ROEngine.ROHeadgear' // start with dummy abstract classes so server changes to either a spawnable class or to none; then net client can detect when its been set
    BackpackClass=class'DH_Engine.DHBackpack'
    AmmoPouchClasses(0)=class'ROEngine.ROAmmoPouch'
    bCanPickupWeapons=true

    // Movement & impacts
    WalkingPct=0.45
    MinHurtSpeed=475.0
    MaxFallSpeed=700.0

    // Stamina
    Stamina=40.0                        // How many second of stamina the player has
    StanceChangeStaminaDrain=1.5        // How much stamina is lost by changing stance
    StaminaRecoveryRate=1.8             // How much stamina to recover normally per second
    CrouchStaminaRecoveryRate=1.5       // How much stamina to recover per second while crouching
    ProneStaminaRecoveryRate=2.5        // How much stamina to recover per second while proning
    SlowStaminaRecoveryRate=0.75        // How much stamina to recover per second when moving
    JumpStaminaDrain=2.5                // How much stamina is lost by jumping

    // Weapon aim
    IronsightBobAmplitude=1.0
    IronsightBobFrequencyY=3.75
    IronsightBobFrequencyZ=5.25
    IronsightBobDecay=5.0
    DeployedPitchUpLimit=7300 // bipod
    DeployedPitchDownLimit=-7300

    // Sound
    FootStepSoundRadius=64
    FootstepVolume=0.5
    QuietFootStepVolume=0.66
    SoundGroupClass=class'DH_Engine.DHPawnSoundGroup'
    MantleSound=SoundGroup'DH_Inf_Player.Mantling.Mantle'
    HelmetHitSounds(0)=SoundGroup'DH_ProjectileSounds.Bullets.Helmet_Hit'
    PlayerHitSounds(0)=SoundGroup'ProjectileSounds.Bullets.Impact_Player'

    //Footstepping - add additional slots in the array for our new material surface types
    DHSoundFootsteps(0)=Sound'Inf_Player.FootStepDirt'
    DHSoundFootsteps(1)=Sound'Inf_Player.FootstepGravel' // Rock
    DHSoundFootsteps(2)=Sound'Inf_Player.FootStepDirt'
    DHSoundFootsteps(3)=Sound'Inf_Player.FootstepMetal' // Metal
    DHSoundFootsteps(4)=Sound'Inf_Player.FootstepWoodenfloor' // Wood
    DHSoundFootsteps(5)=Sound'Inf_Player.FootstepGrass' // Plant
    DHSoundFootsteps(6)=Sound'Inf_Player.FootStepDirt' // Flesh
    DHSoundFootsteps(7)=Sound'Inf_Player.FootstepSnowRough' // Ice
    DHSoundFootsteps(8)=Sound'Inf_Player.FootstepSnowHard'
    DHSoundFootsteps(9)=Sound'Inf_Player.FootstepWaterShallow'
    DHSoundFootsteps(10)=Sound'Inf_Player.FootstepGravel' // Glass- Replaceme
    DHSoundFootsteps(11)=Sound'Inf_Player.FootstepGravel' // Gravel
    DHSoundFootsteps(12)=Sound'Inf_Player.FootstepAsphalt' // Concrete
    DHSoundFootsteps(13)=Sound'Inf_Player.FootstepWoodenfloor' // HollowWood
    DHSoundFootsteps(14)=Sound'Inf_Player.FootstepMud' // Mud
    DHSoundFootsteps(15)=Sound'Inf_Player.FootstepMetal' // MetalArmor
    DHSoundFootsteps(16)=Sound'Inf_Player.FootstepAsphalt_P' // Paper
    DHSoundFootsteps(17)=Sound'Inf_Player.FootStepDirt' // Cloth
    DHSoundFootsteps(18)=Sound'Inf_Player.FootStepDirt' // Rubber
    DHSoundFootsteps(19)=Sound'Inf_Player.FootStepDirt' // Crap

    DHSoundFootsteps(20)=none // this is a test material
    DHSoundFootsteps(21)=Sound'Inf_Player.FootstepSnowRough' // Sand
    DHSoundFootsteps(22)=Sound'Inf_Player.FootStepDirt' //Sand Bags
    DHSoundFootsteps(23)=Sound'Inf_Player.FootstepAsphalt' // Brick
    DHSoundFootsteps(24)=Sound'Inf_Player.FootstepGrass' // Hedgerow

    // Burning player
    FireDamage=10
    FireDamageClass=class'DH_Engine.DHBurningDamageType'
    FlameEffect=class'DH_Effects.DHBurningPlayerFlame'
    BurningOverlayMaterial=Combiner'DH_FX_Tex.Fire.PlayerBurningOverlay_ALT'
    DeadBurningOverlayMaterial=Combiner'DH_FX_Tex.Fire.PlayerBurningOverlay'
    CharredOverlayMaterial=Combiner'DH_FX_Tex.Fire.PlayerCharredOverlay'
    BurnedHeadgearOverlayMaterial=Combiner'DH_FX_Tex.Fire.HeadgearBurnedOverlay'

    // Smoke grenades for squad leaders
    SmokeGrenadeClassName=(Germany="DH_Equipment.DH_NebelGranate39Weapon",USA="DH_Equipment.DH_USSmokeGrenadeWeapon",Britain="DH_Equipment.DH_USSmokeGrenadeWeapon",USSR="DH_Equipment.DH_RDG1SmokeGrenadeWeapon",Poland="DH_Equipment.DH_RDG1SmokeGrenadeWeapon")
    ColoredSmokeGrenadeClassName=(Germany="DH_Equipment.DH_OrangeSmokeWeapon",USA="DH_Equipment.DH_RedSmokeWeapon",Britain="DH_Equipment.DH_RedSmokeWeapon")
    RequiredSquadMembersToReceiveSmoke=4
    RequiredSquadMembersToReceiveColoredSmoke=6

    // Third person player animations
    bShovelHangsOnLeftHip=true

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

    IdleSwimAnim="stand_idlehip_nade" // not specified in ROPawn, resulting in log spam when in water (goes with ROPawn's 'stand_jogX_nade' directional SwimAnims)

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
    // When the player walks without a weapon the missing anims caused the player to 'slide' walk without animation, with spammed log errors
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
