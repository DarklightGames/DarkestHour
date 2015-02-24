//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Pawn extends ROPawn
    config(User);

#exec OBJ LOAD FILE=ProjectileSounds.uax

// Resupply
var bool bHasMGAmmo;
var bool bHasATAmmo;
var bool bHasMortarAmmo;
var bool bWeaponCanBeReloaded;          // Whether a weapon can be reloaded by an assistant
var bool bWeaponNeedsReload;            // Whether an AT weapon is loaded or not
var bool bCanMGResupply;
var bool bCanATResupply;
var bool bCanATReload;
var bool bCanMortarResupply;
var bool bWeaponIsMG, bWeaponIsAT;
var int  MortarHEAmmo, MortarSmokeAmmo;

var bool bChuteDeleted;
var bool bHatShotOff;
var float MinHurtSpeed;                 // When a moving player lands, if they're moving faster than this speed they'll take damage

var(Sounds) class<DH_PawnSoundGroup> DHSoundGroupClass;

// Radioman
var ROArtilleryTrigger  CarriedRadioTrigger; // For storing the trigger on a radioman each spawn, for the purpose of deleting it on death
var int                 GRIRadioPos;         // For storing radioman's specific radio arty trigger position in ROGRI.AlliedRadios array

var float           TeleSpawnProtEnds;       // Is set when a player teleports for "spawn" protection in selectable spawn maps

var() array<sound>  HelmetHitSounds;
var() array<sound>  PlayerHitSounds;

// Mantling
var vector      MantleEndPoint;        // Player's final location after mantle
var bool        bCanMantle;            // Used for HUD icon display
var bool        bSetMantleEyeHeight;   // For lowering eye height during mantle
var bool        bIsMantling;           // Fairly straightforward
var bool        bMantleSetPitch;       // To prevent climbing/bob until view pitch is level
var bool        bCrouchMantle;         // Whether a climb ends in a crouch or not, for tight spaces
var bool        bMantleAnimRun;        // Has the anim been started on the server/remote clients yet?
var bool        bCancelledMantle;      // Whether a mantle has ended naturally or been aborted
var bool        bMantleDebug;          // Show debug output while mantling
var float       MantleHeight;          // How high we're climbing
var float       StartMantleTime;       // Used for smoothing out pitch at mantle start
var int         MantleYaw;             // for locking rotation during climb
var vector      RootLocation;
var vector      RootDelta;
var vector      NewAcceleration;       // Acceleration which is checked by PlayerMove in the Mantling state within DHPlayer
var bool        bEndMantleBob;         // Initiates the pre mantle head bob up motion

var(ROAnimations)   name        MantleAnim_40C, MantleAnim_44C, MantleAnim_48C, MantleAnim_52C, MantleAnim_56C, MantleAnim_60C, MantleAnim_64C,
                                MantleAnim_68C, MantleAnim_72C, MantleAnim_76C, MantleAnim_80C, MantleAnim_84C, MantleAnim_88C;

var(ROAnimations)   name        MantleAnim_40S, MantleAnim_44S, MantleAnim_48S, MantleAnim_52S, MantleAnim_56S, MantleAnim_60S, MantleAnim_64S,
                                MantleAnim_68S, MantleAnim_72S, MantleAnim_76S, MantleAnim_80S, MantleAnim_84S, MantleAnim_88S;

var             sound           MantleSound;

// Burning
var bool                bOnFire;                         // Whether Pawn is on fire or not
var bool                bBurnFXOn;                       // Whether Fire FX are enabled or not
var bool                bCharred;                        // For switching in a charred overlay after the fire goes out
var class<Emitter>      FlameEffect;                     // The fire sprite emitter class
var Emitter             FlameFX;                         // Spawned instance of the above
var Material            BurningOverlayMaterial;          // Overlay for when player is on fire
var Material            DeadBurningOverlayMaterial;      // Overlay for when player is on fire and dead
var Material            CharredOverlayMaterial;          // Overlay for dead, burned players after flame extinguished
var Material            BurnedHeadgearOverlayMaterial;   // Overlay for burned hat
var int                 FireDamage;
var class<DamageType>   FireDamageClass;    // The damage type that started the fire
var int                 BurnTimeLeft;       // Number of seconds remaining for a corpse to burn
var float               LastBurnTime;       // Last time we did fire damage to the Pawn
var Pawn                FireStarter;        // Who set a player on fire

var bool                bHasBeenPossessed;  // Fixes players getting new ammunition when they get out of vehicles.

// Mortars
var     Actor   OwnedMortar;                // Mortar vehicle associated with this actor, used to destroy upon death.
var     bool    bIsDeployingMortar;         // Whether or not the pawn is deploying his mortar.  Used for disabling movement.
var     bool    bMortarCanBeResupplied;

// Obstacle clearing
var bool                bCanCutWire;
var bool                bIsCuttingWire;

var bool                bLockViewRotation;
var rotator             LockViewRotation;

replication
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        bHasATAmmo, bHasMGAmmo, bHasMortarAmmo;

    // Variables the server will replicate to all clients except the one that owns this actor
    reliable if (bNetDirty && !bNetOwner && Role == ROLE_Authority)
        bWeaponCanBeReloaded, bWeaponNeedsReload, bWeaponIsMG, bWeaponIsAT;

    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bOnFire, bCrouchMantle, MantleHeight, bMortarCanBeResupplied;
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    // From UnrealPawn
    if (Level.bStartup && !bNoDefaultInventory)
    {
        AddDefaultInventory();
    }

    AssignInitialPose();

    UpdateShadow();

    // end from UnrealPawn

    SavedBreathSound = 0;

    if (AuxCollisionCylinder == none)
    {
        AuxCollisionCylinder = Spawn(class'DH_BulletWhipAttachment', self);
        AttachToBone(AuxCollisionCylinder, 'spine');
    }

    SavedAuxCollision = AuxCollisionCylinder.bCollideActors;
    LastResupplyTime = Level.TimeSeconds - 1.0;
    bTouchingResupply = false;
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
    }

    // Forces us to equip a mortar if we have one on us.
    if (Level.NetMode != NM_DedicatedServer && HasMortarInInventory() && Weapon.Name != 'DH_Kz8cmGrW42Weapon' && Weapon.Name != 'DH_M2MortarWeapon')
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
        if (I.Name == 'DH_Kz8cmGrW42Weapon' || I.Name == 'DH_M2MortarWeapon')
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
    local DH_RoleInfo DHRI;

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

        HeadgearClass = ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo.GetHeadgear();
        ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo.GetAmmoPouches(AmmoClasses, Prim, Sec, Gren);

        if (ROPlayerReplicationInfo(PlayerReplicationInfo) != none && ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo != none)
        {
            DetachedArmClass = ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo.static.GetArmClass();
            DetachedLegClass = ROPlayerReplicationInfo(PlayerReplicationInfo).RoleInfo.static.GetLegClass();
        }
        else
        {
            Log("Error!!! Possess with no RoleInfo!!!");
        }

        for (i = 0; i < AmmoClasses.Length; i++)
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

            for (i = 0; i < arraycount(AmmoPouchClasses); i++)
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

            // Give resupply ammunition.
            if (DHRI.bCarriesATAmmo)
            {
                bHasATAmmo = true;
            }
            if (DHRI.bCarriesMGAmmo)
            {
                bHasMGAmmo = true;
            }
            if (DHRI.bCarriesMortarAmmo)
            {
                bHasMortarAmmo = true;
            }

            // Give default mortar ammunition.
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

function bool TeleSpawnProtected()
{
    return TeleSpawnProtEnds > Level.TimeSeconds;
}

function DeactivateSpawnProtection()
{
    TeleSpawnProtEnds = -10000.0;

    super.DeactivateSpawnProtection();
}

// Set the vars so this bullet whiz is replicated to the owning client
// Overridden to call a customised function to spawn the sound
event PawnWhizzed(vector WhizLocation, int WhizType)
{
    if ((Level.TimeSeconds - LastWhippedTime) > (0.1 + FRand() * 0.15))
    {
        LastWhippedTime = Level.TimeSeconds;
        mWhizSoundLocation = WhizLocation;

        SpawnWhizCount++;

        // Spawn the whiz sound for local non network players
        HandleSnapSound(WhizType);

        NetUpdateTime = Level.TimeSeconds - 1.0;
    }
}

// Replaces HandleWhizSound, switches "whiz" sounds with "snaps" for supersonic rounds
// Only plays snaps for bullets that are supersonic (via WhizType set in bullet classes)
simulated event HandleSnapSound(int WhizType)
{
    // Don't play whiz sounds for bots, or from other players
    if (IsHumanControlled() && IsLocallyControlled())
    {
        if (WhizType == 1)
        {
            Spawn(class'DH_BulletSnap',,, mWhizSoundLocation); // supersonic rounds
        }
        else
        {
            Spawn(class'DH_BulletWhiz',,, mWhizSoundLocation); // subsonic rounds
        }

        // Anything above WhizType of 2 is a friendly bullet at very close range, so don't suppress
        if (WhizType == 1 || WhizType == 2)
        {
            DHPlayer(Controller).PlayerWhizzed(VSizeSquared(Location - mWhizSoundLocation));
        }
    }
}

// Overridden to prevent playing old whiz sounds over the top of the new
// Why this is still called by the engine I truly don't know
simulated event HandleWhizSound()
{
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
                        bLeftLegGibbed=true;
                    }
                    break;

                case 'rthigh':
                case 'rupperthigh':
                    if (!bRightLegGibbed)
                    {
                        SpawnGiblet(DetachedLegClass, BoneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation);
                        bRightLegGibbed=true;
                    }
                    break;

                case 'lfarm':
                case 'lupperarm':
                    if (!bLeftArmGibbed)
                    {
                        SpawnGiblet(DetachedArmClass, BoneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation);
                        bLeftArmGibbed=true;
                    }
                    break;

                case 'rfarm':
                case 'rupperarm':
                    if (!bRightArmGibbed)
                    {
                        SpawnGiblet(DetachedArmClass, BoneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation);
                        bRightArmGibbed=true;
                    }
                    break;

                case 'head':
                    HelmetShotOff(HitFX[SimHitFxTicker].rotDir);
                    break;
            }

            if (HitFX[SimHitFXTicker].Bone != 'Spine' && HitFX[SimHitFXTicker].Bone != 'UpperSpine')
            {
                HideBone(HitFX[SimHitFxTicker].Bone);
            }
        }

        if (HitFX[SimHitFXTicker].Bone == 'head' && Headgear != none)
        {
            if (DH_Headgear(HeadGear).bIsHelmet)
            {
                DH_Headgear(HeadGear).PlaySound(HelmetHitSounds[Rand(HelmetHitSounds.Length)], SLOT_None, 100.0);
            }

            HelmetShotOff(HitFX[SimHitFxTicker].rotDir);
        }
    }
}

function ProcessLocationalDamage(int Damage, Pawn InstigatedBy, vector hitlocation, vector Momentum, class<DamageType> DamageType, array<int> PointsHit)
{
    local int    ActualDamage, OriginalDamage, CumulativeDamage, TotalDamage, i;
    local int    HighestDamagePoint, HighestDamageAmount;
    local vector HitDirection;

    OriginalDamage = damage;

    // If someone else has killed this player , return
    if (bDeleteMe || PointsHit.Length < 1 || Health <= 0)
    {
        return;
    }

    for (i = 0; i < PointsHit.Length; i++)
    {
        // If someone else has killed this player , return
        if (bDeleteMe || Health <= 0)
        {
            return;
        }

        ActualDamage = OriginalDamage;
        ActualDamage *= Hitpoints[PointsHit[i]].DamageMultiplier;
        TotalDamage += ActualDamage;
        ActualDamage = Level.Game.ReduceDamage(Damage, self, InstigatedBy, HitLocation, Momentum, DamageType);
        CumulativeDamage += ActualDamage;

        if (ActualDamage > HighestDamageAmount)
        {
            HighestDamageAmount = ActualDamage;
            HighestDamagePoint = PointsHit[i];
        }

        if (Hitpoints[PointsHit[i]].HitPointType == PHP_Leg || Hitpoints[PointsHit[i]].HitPointType == PHP_Foot)
        {
            // If we've been shot in the foot or the leg, we have a chance to 'fall' and drop our weapon.
            if (ActualDamage > 0 && DHPlayer(Controller) != none && !bIsCrawling && bIsSprinting)
            {
                // Zero stamina and fall to the ground if shot in the leg or foot
                Stamina = 0.0;
                ClientForceStaminaUpdate(Stamina);
                DHPlayer(Controller).ClientProne();
            }
        }
        else if (Hitpoints[PointsHit[i]].HitPointType == PHP_Hand && FRand() > 0.5)
        {
            if (DHPlayer(Controller) != none && DarkestHourGame(Level.Game).FriendlyFireScale > 0.0 && !InGodMode())
            {
                DHPlayer(Controller).ThrowWeapon();
                DHPlayer(Controller).ReceiveLocalizedMessage(class'ROWeaponLostMessage');
            }
        }
        else if (Hitpoints[PointsHit[i]].HitPointType == PHP_Head)
        {
            if (DHPlayer(Controller) != none && DarkestHourGame(Level.Game).FriendlyFireScale > 0.0 && !InGodMode())
            {
                HitDirection = Location - HitLocation;
                HitDirection.Z = 0.0;
                HitDirection = normal(HitDirection);

                DHPlayer(Controller).PlayerJarred(HitDirection, 15.0);
            }
        }
        else if (Hitpoints[PointsHit[i]].HitPointType == PHP_Torso)
        {
            if (DHPlayer(Controller) != none && DarkestHourGame(Level.Game).FriendlyFireScale > 0.0 && !InGodMode())
            {
                // Lose half your stamina if you're shot in the chest - Basnett
                Stamina = 0.0;
                StaminaRecoveryRate /= 2;
                ClientForceStaminaUpdate(Stamina);
            }
        }

        // Update the locational damage list
        UpdateDamageList(PointsHit[i] - 1);

        // Lets exit out if one of the shots killed the player
        if (CumulativeDamage >=  Health)
        {
            if (DamageType.default.HumanObliterationThreshhold != 1000001) // Shitty way of identifying Melee damage classes using existing DamageType parent
            {
                PlaySound(PlayerHitSounds[Rand(PlayerHitSounds.Length)], SLOT_None, 1.0);
            }

            TakeDamage(TotalDamage, InstigatedBy, hitlocation, Momentum, DamageType, HighestDamagePoint);
        }
    }

    if (TotalDamage > 0)
    {
        // If someone else has killed this player , return
        if (bDeleteMe || Health <= 0)
        {
            return;
        }

        if (DamageType.default.HumanObliterationThreshhold != 1000001) // Shitty way of identifying Melee damage classes using existing DamageType parent
        {
            PlaySound(PlayerHitSounds[Rand(PlayerHitSounds.Length)], SLOT_None, 1.0);
        }

        TakeDamage(TotalDamage, InstigatedBy, hitlocation, Momentum, DamageType, HighestDamagePoint);
    }
}

// Handle locational damage
// MergeTODO: this function needs some work
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    local int        ActualDamage;
    local Controller Killer;

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

    if (ActualDamage > 0 && DamageType.Name == 'Fell' || DamageType.Name == 'DH_ExitMovingVehicleDamType')
    {
        if (!bIsCrawling && !bIsCrouched && DHPlayer(Controller) != none)
        {
            Stamina = 0.0;
            ClientForceStaminaUpdate(Stamina);
            DHPlayer(Controller).ClientProne();
        }

        SetLimping(FMin(ActualDamage / 5.0, 10.0));
    }
    else if (DamageType.Name == 'DH_BurningDamType') // || (DamageType.Name == 'DH_Whatever') // This is for later - Ch!cken
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

    PlayHit(ActualDamage,InstigatedBy, hitLocation, DamageType, Momentum, HitIndex);

    if (Health <= 0)
    {
        if (bOnFire)
        {
            BurnTimeLeft = 10;
            SetTimer(1.0, false);

            if (DH_PlayerFlame(FlameFX) != none)
            {
                DH_PlayerFlame(FlameFX).PlayerDied();
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
        DHPlayer(Controller).GoToState('PlayerWalking');
        DHPlayer(Controller).SetTimer(0.0, false);
    }
}

// Handle ammo resupply
function TossAmmo(Pawn Gunner, optional bool bIsATWeapon)
{
    local bool bResupplySuccessful;

    bResupplySuccessful = false;

    if ((!bHasATAmmo && bIsATWeapon) || (!bHasMGAmmo && !bIsATWeapon))
    {
        return;
    }

    if (DHWeapon(Gunner.Weapon) != none && DHWeapon(Gunner.Weapon).ResupplyAmmo())
    {
        if (bHasATAmmo && bIsATWeapon)
        {
            bResupplySuccessful=true;
            bHasATAmmo = false;
        }
        else if (bHasMGAmmo && !bIsATWeapon)
        {
            bResupplySuccessful=true;
            bHasMGAmmo = false;
        }
    }

    if (bResupplySuccessful)
    {
        if (DarkestHourGame(Level.Game) != none && Controller != none && Gunner.Controller != none)
        {
            // Send notification message to gunner & remove resupply request
            if (DHPlayer(Gunner.Controller) != none)
            {
                DHPlayer(Gunner.Controller).ReceiveLocalizedMessage(class'DHResupplyMessage', 2, Controller.PlayerReplicationInfo);

                if (Gunner.Controller != none && Gunner.Controller.PlayerReplicationInfo != none && DarkestHourGame(Level.Game).GameReplicationInfo != none)
                {
                    ROGameReplicationInfo(DarkestHourGame(Level.Game).GameReplicationInfo).RemoveMGResupplyRequestFor(Gunner.Controller.PlayerReplicationInfo);
                }
            }

            // Send notification message to supplier
            if (PlayerController(Controller) != none)
            {
                if (Gunner.Controller == none)
                {
                    PlayerController(Controller).ReceiveLocalizedMessage(class'DHResupplyMessage', 0);
                }
                else
                {
                    PlayerController(Controller).ReceiveLocalizedMessage(class'DHResupplyMessage', 1, Gunner.Controller.PlayerReplicationInfo);
                }
            }

            // Score point
            if (bIsATWeapon)
            {
                DarkestHourGame(Level.Game).ScoreATResupply(Controller, Gunner.Controller);
            }
            else
            {
                DarkestHourGame(Level.Game).ScoreMGResupply(Controller, Gunner.Controller);
            }
        }

        PlayOwnedSound(sound'Inf_Weapons_Foley.ammogive', SLOT_Interact, 1.75,, 10.0);
    }
}

function TossMortarAmmo(DH_Pawn P)
{
    if (bHasMortarAmmo && P != none && P.ResupplyMortarAmmunition())
    {
        bHasMortarAmmo = false;

        if (DarkestHourGame(Level.Game) != none && Controller != none && P.Controller != none)
        {
            // Send notification message to gunner & remove resupply request
            if (DHPlayer(P.Controller) != none)
            {
                DHPlayer(P.Controller).ReceiveLocalizedMessage(class'ROResupplyMessage', 1, Controller.PlayerReplicationInfo);

                if (ROGameReplicationInfo(DarkestHourGame(Level.Game).GameReplicationInfo) != none)
                    ROGameReplicationInfo(DarkestHourGame(Level.Game).GameReplicationInfo).RemoveMGResupplyRequestFor(P.Controller.PlayerReplicationInfo);
            }

            // Send notification message to supplier
            if (PlayerController(Controller) != none)
            {
                PlayerController(Controller).ReceiveLocalizedMessage(class'ROResupplyMessage', 0, P.Controller.PlayerReplicationInfo);
            }

            DarkestHourGame(Level.Game).ScoreMortarResupply(Controller, P.Controller);
        }

        PlayOwnedSound(sound'Inf_Weapons_Foley.ammogive', SLOT_Interact, 1.75,, 10.0);
    }
}

function TossMortarVehicleAmmo(DH_MortarVehicle V)
{
    if (bHasMortarAmmo && V != none && ResupplyMortarVehicleWeapon(V))
    {
        bHasMortarAmmo = false;

        if (DarkestHourGame(Level.Game) != none && Controller != none)
        {
            // Send notification message to gunner & remove resupply request
            if (V.WeaponPawns[0].Controller != none && DHPlayer(V.WeaponPawns[0].Controller) != none)
            {
                DHPlayer(V.WeaponPawns[0].Controller).ReceiveLocalizedMessage(class'ROResupplyMessage', 1, Controller.PlayerReplicationInfo);

                if (ROGameReplicationInfo(DarkestHourGame(Level.Game).GameReplicationInfo) != none)
                {
                    ROGameReplicationInfo(DarkestHourGame(Level.Game).GameReplicationInfo).RemoveMGResupplyRequestFor(V.PlayerReplicationInfo);
                }
            }

            // Send notification message to supplier
            if (PlayerController(Controller) != none)
            {
                PlayerController(Controller).ReceiveLocalizedMessage(class'ROResupplyMessage', 0, V.Controller.PlayerReplicationInfo);
            }

            DarkestHourGame(Level.Game).ScoreMortarResupply(Controller, V.WeaponPawns[0].Controller);
        }

        PlayOwnedSound(sound'Inf_Weapons_Foley.ammogive', SLOT_Interact, 1.75,, 10.0);
    }
}

function bool ResupplyMortarVehicleWeapon(DH_MortarVehicle V)
{
    local VehicleWeapon VW;

    if (V == none || V.WeaponPawns[0] == none || V.WeaponPawns[0].Gun == none)
    {
        return false;
    }

    VW = V.WeaponPawns[0].Gun;

    if (VW.MainAmmoCharge[0] == VW.default.InitialPrimaryAmmo && VW.MainAmmoCharge[1] == VW.default.InitialSecondaryAmmo)
    {
        return false;
    }

    V.PlayerResupply();

    return true;
}

// Handle assisted reload
function LoadWeapon(Pawn Gunner)
{
    // Can reload the other player (AssistedReload returns true if was successful)
    if (ROWeapon(Gunner.Weapon) != none && DHWeapon(Gunner.Weapon).AssistedReload())
    {
        if (DarkestHourGame(Level.Game) != none && Controller != none && Gunner.Controller != none)
        {
            // Send notification message to gunner
            if (DHPlayer(Gunner.Controller) != none)
            {
                DHPlayer(Gunner.Controller).ReceiveLocalizedMessage(class'DHATLoadMessage', 1, Controller.PlayerReplicationInfo);
            }

            // Send notification message to loader
            if (PlayerController(Controller) != none)
            {
                PlayerController(Controller).ReceiveLocalizedMessage(class'DHATLoadMessage', 0, Gunner.Controller.PlayerReplicationInfo);
            }

            // Score point
            DarkestHourGame(Level.Game).ScoreATReload(Controller, Gunner.Controller);
        }

        PlayOwnedSound(sound'Inf_Weapons_Foley.ammogive', SLOT_Interact, 1.75,, 10.0);
    }
    else
    {
        // Notify loader of failed attempt
        if (PlayerController(Controller) != none)
        {
            PlayerController(Controller).ReceiveLocalizedMessage(class'DHATLoadFailMessage', 0, Gunner.Controller.PlayerReplicationInfo);
        }
    }
}

// Update anims to match attachment
simulated function SetWeaponAttachment(ROWeaponAttachment NewAtt)
{
    WeaponAttachment = NewAtt;

    if (!bInitializedWeaponAttachment && NewAtt != none)
    {
        bInitializedWeaponAttachment = true;
    }

    if (WeaponAttachment == none)
    {
        return;
    }

    if (DH_ProjectileWeapon(Weapon) != none)
    {
        WeaponAttachment.bBayonetAttached = DH_ProjectileWeapon(Weapon).bBayonetMounted;
    }

    WeaponAttachment.AnimEnd(0);
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
        // Walking
        if (bIsSprinting)
        {
            // Use more stamina when crouch sprinting
            if (bIsCrouched)
            {
                Stamina = FMax(0.0, Stamina - (DeltaTime * 1.25));
            }
            else
            {
                Stamina = FMax(0.0, Stamina - DeltaTime);
            }
        }
        else
        {
            if (bIsMantling)
            {
                if ((Physics == PHYS_RootMotion || Physics == PHYS_Flying) && Stamina > 0.0)
                {
                    Stamina = FMax(0.0, Stamina - DeltaTime * 1.5);
                }
                else if (Stamina < 0.0)
                {
                    Stamina = 0.0;
                }
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
            else if (DamageType.Name == 'DH_BurningDamType')
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

                for (i = 0; i < AmmoPouches.Length; i++)
                {
                    AmmoPouches[i].SetOverlayMaterial(DeadBurningOverlayMaterial, 999.0, true);
                }
            }

            if (DH_PlayerFlame(FlameFX) != none)
            {
                DH_PlayerFlame(FlameFX).DouseFlames();
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

    if (Level.Game != none && !Level.Game.bGameEnded) // Matt: needs != none check to avoid "accessed none" error on a client (actor has been torn off so usual Role=authority check doesn't work)
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

            BloodHit = Spawn(ProjectileBloodSplatClass,InstigatedBy,, HitLocation, SplatRot);
        }
    }

    DoDamageFX(HitBone, Damage, DamageType, rotator(HitNormal));

    if (DamageType.default.DamageOverlayMaterial != none && Damage > 0 && !bOnFire)
    {
        SetOverlayMaterial(DamageType.default.DamageOverlayMaterial, DamageType.default.DamageOverlayTime, false);
    }
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
            PlaySound(GetSound(EST_Drown), SLOT_Pain, 1.5 * TransientSoundVolume);
        }
        else
        {
            PlaySound(GetSound(EST_HitUnderwater), SLOT_Pain, 1.5 * TransientSoundVolume);
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

    PlayOwnedSound(DHSoundGroupClass.static.GetHitSound(DamageType), SLOT_Pain, 3.0 * TransientSoundVolume,, 200.0);
}

// A few minor additions
// DH added removal of radioman arty triggers on death - PsYcH0_Ch!cKeN
function Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
    local vector          TossVel, HitDirection;
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
        Killer = FireStarter.Controller;
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
        AuxCollisionCylinder.SetCollision(false, false, false);
    }

    DamageBeyondZero = Health;

    Health = Min(0, Health);

    // Fix for suicide death messages
    if (DamageType == class'Suicided')
    {
        DamageType = class'ROSuicided';
    }

    bShouldGib = DamageType != none && (DamageType.default.bAlwaysGibs || ((Abs(DamageBeyondZero) + default.Health) > DamageType.default.HumanObliterationThreshhold));

    if (!bShouldGib && DrivenVehicle == none)
    {
        // Drop inventory if player is not in a vehicle and is not about to be completely obliterated
        DropWeaponInventory(TossVel);
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
    WeaponState = GS_none;

    if (PlayerController(Controller) != none)
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
simulated function SpawnGibs(Rotator HitRotation, float ChunkPerterbation)
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
        for (i = RI.GivenItems.Length - 1; i >= 0; i--)
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
    local DHGameReplicationInfo TmpGRI;

    if (CarriedRadioTrigger == none)
    {
        return;
    }

    TmpGRI = DHGameReplicationInfo(DarkestHourGame(Level.Game).GameReplicationInfo);

    if (TmpGRI != none)
    {
        if (CarriedRadioTrigger.TeamCanUse == AT_Allies)
        {
            TmpGRI.CarriedAlliedRadios[GRIRadioPos] = none;
        }

        if (CarriedRadioTrigger.TeamCanUse == AT_Axis)
        {
            TmpGRI.CarriedAxisRadios[GRIRadioPos] = none;
        }
    }

    CarriedRadioTrigger.Destroy();
}

// Add inventory based on role and weapons choices
// MergeTODO: this doesn't seem too bad, except we need to turn nades back on for bots at some point
function AddDefaultInventory()
{
    local int i;
    local string S;
    local DHPlayer P;
    local DHBot B;
    local RORoleInfo RI;

    if (Controller == none)
    {
        return;
    }

    P = DHPlayer(Controller);
    B = DHBot(Controller);

    if (IsLocallyControlled())
    {
        if (P != none)
        {
            RI = P.GetRoleInfo();
            S = P.GetPrimaryWeapon();

            if (S != "")
            {
                CreateInventory(S);
            }

            S = P.GetSecondaryWeapon();

            if (S != "")
            {
                CreateInventory(S);
            }

            for (i = 0; i < 3; i++)
            {
                S = string(RI.Grenades[i].Item);

                if (S != "")
                {
                    CreateInventory(S);
                }
            }

            if (RI != none)
            {
                for (i = 0; i < RI.GivenItems.Length; i++)
                {
                    CreateInventory(RI.GivenItems[i]);
                }
            }
        }
        else if (B != none)
        {
            S = B.GetPrimaryWeapon();

            if (S != "")
            {
                CreateInventory(S);
            }

            S = B.GetSecondaryWeapon();

            if (S != "")
            {
                CreateInventory(S);
            }

            RI = B.GetRoleInfo();

            if (RI != none)
            {
                for (i = 0; i < RI.GivenItems.Length; i++)
                {
                    CreateInventory(RI.GivenItems[i]);
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
                for (i = RI.GivenItems.Length - 1; i >= 0; i--)
                {
                    CreateInventory(RI.GivenItems[i]);
                }
            }

            for (i = 0; i < 3; i++)
            {
                S = string(RI.Grenades[i].Item);

                if (S != "")
                {
                    CreateInventory(S);
                }
            }

            S = P.GetSecondaryWeapon();

            if (S != "")
            {
                CreateInventory(S);
            }

            S = P.GetPrimaryWeapon();

            if (S != "")
            {
                CreateInventory(S);
            }
        }
    }

    NetUpdateTime = Level.TimeSeconds - 1;

    // HACK FIXME
    if (Inventory != none)
    {
        Inventory.OwnerEvent('LoadOut');
    }

    if (Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer && IsLocallyControlled())
    {
        bRecievedInitialLoadout = true;
        Controller.ClientSwitchToBestWeapon();
    }
}

// Modified to prevent "accessed none" errors on parachute landing
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
            if (Weapon.IsA('ROExplosiveWeapon') || Weapon.IsA('BinocularsItem'))
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
            else if (Weapon.IsA('ROBoltActionWeapon') || Weapon.IsA('ROAutoWeapon') || Weapon.IsA('ROSemiAutoWeapon'))
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
            else if (Weapon.IsA('ROPistolWeapon'))
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
            else
            {
                // Default in case there is no anim
                if (bIsCrawling)
                {
                    Anim = 'prone_putaway_kar';
                }
                else
                {
                    Anim = 'stand_putaway_kar';
                }
            }
        }
        else
        {
            // TODO: Need a put away empty anim
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

            if (Weapon != none) // Matt: added this 'if' to prevent "accessed none" errors, as Weapon can become 'none' during GoToState above, e.g. when parachute landing
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

        if (ROExplosiveWeapon(Weapon) == none)
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
}

// Increased damage once over safe fall threshold
// Hacked in code to hurt players who are moving too fast in any direction when they land
function TakeFallingDamage()
{
    local float Shake, EffectiveSpeed, TotalSpeed;

    TotalSpeed = Vsize(Velocity);

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
    else if (TotalSpeed > 0.75 * MinHurtSpeed)
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
                    TakeDamage((TotalSpeed - MinHurtSpeed) * 0.4, none, Location, vect(0.0, 0.0, 0.0), class'DH_ExitMovingVehicleDamType');
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

// Called on the server. Sends a message to the client to let them know to play a the reload
function HandleAssistedReload()
{
    local name PlayerAnim;

    // Set the anim blend time so the server will make this player relevant for third person reload sounds to be heard
    if (Level.NetMode != NM_StandAlone && WeaponAttachment != none)
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

    if (WeaponAttachment != none)
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

    bPhysicsAnimUpdate = false;
    LockRootMotion(1); // lock the rendering of the root bone to where it is (it will still translate for calculation purposes)
    bLocallyControlled = IsLocallyControlled();

    // Matt: was PlayOwnedSound but that's only relevant to server & this plays on client - same below & in PlayEndMantle
    if (bLocallyControlled)
    {
        PlaySound(MantleSound, SLOT_Interact, 1.0,, 10.0);
    }

    Anim = SetMantleAnim();
    AnimTimer = GetAnimDuration(Anim, 1.0) + 0.1;

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
            PlayAnim(Anim, 1.0, 0.15, 0);
        }
        else
        {
            SetTimer(AnimTimer, false);
            PlayAnim(Anim, 1.0, 0.1, 0);
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

            SetCollisionSize(CollisionRadius,CrouchHeight);
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

            SetCollisionSize(CollisionRadius,CrouchHeight);
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
            AnimBlendParams(1, 1.0 , 0.0, 0.2, SpineBone1);
            AnimBlendParams(1, 1.0, 0.0, 0.2, SpineBone2);
            PlayUpperBodyAnim(UsedAction, 1.0, 0.0);
        }
        else if (IsPutAwayAnim(UsedAction))
        {
            AnimBlendParams(1, 1.0 , 0.0, 0.2, SpineBone1);
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
            GoToState('');
        }
        else if (Physics == PHYS_None || (Level.Game != none && Level.Game.IsInState('MatchOver')))
        {
            PlayAnim(UsedAction,, 0.1);
            AnimBlendToAlpha(1, 0.0, 0.05);
        }
        else if (Physics == PHYS_Falling || (Physics == PHYS_Walking && Velocity.Z != 0))
        {
            if (CheckTauntValid(UsedAction))
            {
                if (WeaponState == GS_none || WeaponState == GS_Ready)
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
    local DHObstacle O;

    if (A != none)
    {
        if (A.bStatic)
        {
            return true;
        }

        O = DHObstacle(A);

        if (O != none && O.CanBeMantled())
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
    local vector   Extent, HitLoc, HitNorm, StartLoc, EndLoc, X, Y, Z;
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

    GetAxes(Rotation,X,Y,Z);

    StartLoc = Location;
    StartLoc.Z += 5.0; // necessary to make the bottom of the extent just clip the MINFLOORZ height and the top hit shoulder height
    EndLoc = StartLoc + X * 15.0;

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
    EndLoc = StartLoc + X * 30.0;

    if (CanMantleActor(Trace(HitLoc, HitNorm, EndLoc, StartLoc, true, Extent)))
    {
        //Spawn(class'DH_DebugTracer', self,, HitLoc, Rotator(HitNorm));
        //ClientMessage("Object is too high to mantle");
        return false;
    }

    EndLoc += X * 7; // brings us to a total of 60uu out from our starting location, which is how far our animations go
    StartLoc = EndLoc;
    EndLoc.Z = Location.Z - 22; // 36 uu above ground, which is just above MAXSTEPHEIGHT // NOTE: testing shows you can actually step higher than MAXSTEPHEIGHT - nevermind, this is staying as-is

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
            bCrouchMantle = true;
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
        EndLoc = StartLoc + X * 30.0;

        for (i = 0; i < 5; i++)
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
    WeaponAttachment.SetDrawType(DT_None);
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
        SetCollisionSize(CollisionRadius,CrouchHeight);
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
    WeaponAttachment.SetDrawType(DT_Mesh);

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
    if (!FastTrace((Location - (vect(0.0, 0.0, 1.0) * CollisionHeight)),Location))
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
        DHWeapon(Weapon).GoToState('StartMantle');
    }
    else if (DHExplosiveWeapon(Weapon) != none)
    {
        DHExplosiveWeapon(Weapon).bIsMantling = true;
        DHExplosiveWeapon(Weapon).GoToState('StartMantle');
    }
    else if (DH_BinocularsItem(Weapon) != none)
    {
        DH_BinocularsItem(Weapon).bIsMantling = true;
        DH_BinocularsItem(Weapon).GoToState('StartMantle');
    }
}

simulated function MantleRaiseWeapon()
{
    if (DHWeapon(Weapon) != none)
    {
        DHWeapon(Weapon).bIsMantling = false;
    }
    else if (DHExplosiveWeapon(Weapon) != none)
    {
        DHExplosiveWeapon(Weapon).bIsMantling = false;
    }
    else if (DH_BinocularsItem(Weapon) != none)
    {
        DH_BinocularsItem(Weapon).bIsMantling = false;
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
        EyeHeight = 0;
        return;
    }

    // START DH

    // Lower eye height here to hide crouch transition at end of mantle
    if (bSetMantleEyeHeight)
    {
        if (bCrouchMantle)
        {
            Smooth = FMin(0.65, 10.0 * DeltaTime);
            EyeHeight = EyeHeight * (1 - 0.1 * Smooth);

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

    for (i = 0; i < AmmoPouches.Length; i++)
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

    for (i = 0; i < AmmoPouches.Length; i++)
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
    local vector    X,Y,Z;
    local int       i;
    local array<Inventory> InventoryList;

    GetAxes(Rotation, X, Y, Z);

    Inv = Inventory;

    while (Inv != none)
    {
        InventoryList[InventoryList.Length] = Inv;

        Inv = Inv.Inventory;
    }

    if (Level.Game != none)
    {
        Level.Game.Broadcast(self, InventoryList.Length);
    }

    for (i = 0; i < InventoryList.Length; ++i)
    {
        W = Weapon(InventoryList[i]);

        if (W != none && W.bCanThrow)
        {
            if (W.IsA('BinocularsItem')) //TODO: this is shit, need a way to define something as being droppable but not on death
            {
                W.Destroy();
            }
            else
            {
                W.DropFrom(Location + (0.8 * CollisionRadius * X) - (0.5 * CollisionRadius * Y));
            }
        }
    }
}

function bool ResupplyMortarAmmunition()
{
    local DH_RoleInfo RI;

    RI = GetRoleInfo();

    if (!bMortarCanBeResupplied || RI == none || !RI.bCanUseMortars)
    {
        return false;
    }

    if (GetTeamNum() == 0) // axis
    {
        MortarHEAmmo = Clamp(MortarHEAmmo + 4, 0, 16);
        MortarSmokeAmmo = Clamp(MortarSmokeAmmo + 1, 0, 4);

        if (MortarHEAmmo == 16 && MortarSmokeAmmo == 4)
        {
            bMortarCanBeResupplied = false;
        }

        return true;
    }
    else if (GetTeamNum() == 1) // allies
    {
        MortarHEAmmo = Clamp(MortarHEAmmo + 6, 0, 24);
        MortarSmokeAmmo = Clamp(MortarSmokeAmmo + 1, 0, 4);

        if (MortarHEAmmo == 24 && MortarSmokeAmmo == 4)
        {
            bMortarCanBeResupplied = false;
        }

        return true;
    }
    else
    {
        return false;
    }
}

function FillMortarAmmunition()
{
    if (GetTeamNum() == 0) // axis
    {
        MortarHEAmmo = 16;
        MortarSmokeAmmo = 4;
    }
    else // allies
    {
        MortarHEAmmo = 24;
        MortarSmokeAmmo = 4;
    }

    bMortarCanBeResupplied = false;
}

function CheckIfMortarCanBeResupplied()
{
    bMortarCanBeResupplied = false;

    if (GetTeamNum() == 0 && MortarHEAmmo < 16 || MortarSmokeAmmo < 4) // axis
    {
        bMortarCanBeResupplied = true;
    }
    else if (GetTeamNum() == 1 && MortarHEAmmo < 24 || MortarSmokeAmmo < 4) // allies
    {
        bMortarCanBeResupplied = true;
    }
}

simulated function bool CanUseMortars()
{
    local DH_RoleInfo RI;

    RI = GetRoleInfo();

    return RI != none && RI.bCanUseMortars;
}

simulated function DH_RoleInfo GetRoleInfo()
{
    local DH_RoleInfo             RI;
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

    RI = DH_RoleInfo(PRI.RoleInfo);

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

//Simulated?
function SetAmmoPercent(byte AmmoAmount)
{
    local Inventory Inv;
    local DH_ProjectileWeapon Wep;
    local int i;

    //Cycle inventory and change ammo on needed items
    for (Inv=Inventory;Inv!=none;Inv=Inv.Inventory)
    {
        Wep = DH_ProjectileWeapon(Inv);

        //Theel: Only change primary weapon (for now)
        if(Wep != none && Wep.InventoryGroup == 1)
        {
            Wep.SetNumMags(AmmoAmount);
        }
        //Some odd prevention measure that exists in other things like this
        i++;
        if (i>500)
            break;
    }
}

defaultproperties
{
    MinHurtSpeed=475.0
    DHSoundGroupClass=class'DH_Engine.DH_PawnSoundGroup'
    HelmetHitSounds(0)=SoundGroup'DH_ProjectileSounds.Bullets.Helmet_Hit'
    PlayerHitSounds(0)=SoundGroup'ProjectileSounds.Bullets.Impact_Player'
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
    MantleSound=SoundGroup'DH_Inf_Player.Mantling.Mantle'
    FlameEffect=class'DH_Effects.DH_PlayerFlame'
    BurningOverlayMaterial=Combiner'DH_FX_Tex.Fire.PlayerBurningOverlay_ALT'
    DeadBurningOverlayMaterial=Combiner'DH_FX_Tex.Fire.PlayerBurningOverlay'
    CharredOverlayMaterial=Combiner'DH_FX_Tex.Fire.PlayerCharredOverlay'
    BurnedHeadgearOverlayMaterial=Combiner'DH_FX_Tex.Fire.HeadgearBurnedOverlay'
    FireDamage=10
    FireDamageClass=class'DH_Engine.DH_BurningDamType'
    Stamina=25.0
    DeployedPitchUpLimit=7300
    DeployedPitchDownLimit=-7300
    ControllerClass=class'DH_Engine.DHBot'
    AirAnims(0)="jumpF_mid_nade"
    AirAnims(1)="jumpB_mid_nade"
    AirAnims(2)="jumpL_mid_nade"
    AirAnims(3)="jumpR_mid_nade"
    TakeoffAnims(0)="jumpF_takeoff_nade"
    TakeoffAnims(1)="jumpB_takeoff_nade"
    TakeoffAnims(2)="jumpL_takeoff_nade"
    TakeoffAnims(3)="jumpR_takeoff_nade"
    LandAnims(0)="jumpF_land_nade"
    LandAnims(1)="jumpB_land_nade"
    LandAnims(2)="jumpL_land_nade"
    LandAnims(3)="jumpR_land_nade"
    DodgeAnims(0)="jumpF_mid_nade"
    DodgeAnims(1)="jumpB_mid_nade"
    DodgeAnims(2)="jumpL_mid_nade"
    DodgeAnims(3)="jumpR_mid_nade"
    AirStillAnim="jump_mid_nade"
    TakeoffStillAnim="jump_takeoff_nade"
    MaxFallSpeed=700.0
}
