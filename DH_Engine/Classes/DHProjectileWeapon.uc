//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHProjectileWeapon extends DHWeapon
    abstract;

// Animations
var         name        MagEmptyReloadAnim;         // anim for reloads when a weapon has an empty magazine/box, this anim will be used by bolt actions when inserting a full stripper clip
var         name        MagPartialReloadAnim;       // anim for reloads when a weapon still has ammo in magazine/box

var         name        IronIdleAnim;               // anim for weapon idling while in iron sight view
var         name        IronBringUp;                // anim for weapon being brought up to iron sight view
var         name        IronBringUpRest;            // anim for weapon being brought up to iron sight view when needing to bolt
var         name        IronPutDown;                // anim for weapon being lowered out of iron sight view

var         name        BayoAttachAnim;             // anim for attaching the bayonet
var         name        BayoDetachAnim;             // anim for detaching the bayonet
var         name        BayonetBoneName;            // name for the bayonet bone, used in scaling the bayonet bone based on its attachment status
var         bool        bHasBayonet;                // whether or not this weapon has a bayonet

var         float       IronSwitchAnimRate;         // the rate to play the ironsight animation at

// Empty animations used for weapons that have visible empty states (pistols, PTRD, etc)
var         name        IdleEmptyAnim;              // anim for weapon idling empty
var         name        IronIdleEmptyAnim;          // anim for weapon idling while in iron sight view empty

var         name        IronBringUpEmpty;           // anim for weapon being brought up to iron sight view
var         name        IronPutDownEmpty;           // anim for weapon being lowered out of iron sight view

var         name        SprintStartEmptyAnim;       // anim that shows the beginning of the sprint with empty weapon
var         name        SprintLoopEmptyAnim;        // anim that is looped for when player is sprinting with empty weapon
var         name        SprintEndEmptyAnim;         // anim that shows the weapon returning to normal after sprinting with empty weapon

var()       name        CrawlForwardEmptyAnim;      // animation for crawling forward empty
var()       name        CrawlBackwardEmptyAnim;     // animation for crawling backward empty
var()       name        CrawlStartEmptyAnim;        // animation for starting to crawl empty
var()       name        CrawlEndEmptyAnim;          // animation for ending crawling empty

var()       name        SelectEmptyAnim;            // animation for drawing an empty weapon
var()       name        PutDownEmptyAnim;           // animation for putting away an empty weapon

// Manual bolting anims
var()       name        BoltHipAnim;                // animation for crawling forward
var()       name        BoltIronAnim;               // animation for crawling backward
var()       name        PostFireIronIdleAnim;       // animation for crawling forward
var()       name        PostFireIdleAnim;           // animation for crawling backward

// Ammo/Magazines
var         array<int>  PrimaryAmmoArray;           // the array of magazines and thier ammo amounts this weapon has
var         byte        CurrentMagCount;            // current number of magazines, this should be replicated to the client // Matt: changed from int to byte for more efficient replication
var         int         MaxNumPrimaryMags;          // the maximum number of mags a solder can carry for this weapon, should move to the role info
var         int         InitialNumPrimaryMags;      // the number of mags the soldier starts with, should move to the role info
var         int         CurrentMagIndex;            // the index of the magazine currently in use
var         bool        bUsesMagazines;             // this weapon uses magazines, not single bullets, etc
var         bool        bPlusOneLoading;            // can have an extra round in the chamber when you reload before empty
var         int         FillAmmoMagCount;

// Barrels
var     bool                bTrackBarrelHeat;       // we should track barrel heat for this MG
var     bool                bBarrelSteaming;        // barrel is steaming
var     bool                bBarrelDamaged;         // barrel is close to failure, accuracy is VERY BAD
var     bool                bBarrelFailed;          // barrel overheated and can't be used
var     bool                bCanFireFromHip;        // if true this weapon has a hip firing mode

var     byte                BarrelIndex;            // barrel being used
var     byte                RemainingBarrels;       // number of barrels still left, INCLUDES the active barrel
var     byte                InitialBarrels;         // barrels initially given

var     class<DHWeaponBarrel>  BarrelClass;            // barrel type we use now
var     array<DHWeaponBarrel>  Barrels;                // The array of carried MG barrels for this weapon

// Barrel steam info
var     class<Emitter>      ROBarrelSteamEmitterClass;
var     Emitter             ROBarrelSteamEmitter;
var     name                BarrelSteamBone;        // bone we attach the barrel steam emitter too

// MG specific animations
var     name                BarrelChangeAnim;       // anim for bipod barrel changing while deployed
var     float               PlayerDeployFOV;

replication
{
    // Variables the server will replicate to the client that owns this actor
    reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
        CurrentMagCount, RemainingBarrels, bBarrelSteaming, bBarrelDamaged, bBarrelFailed;

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerRequestReload, ServerZoomIn, ServerZoomOut, ServerChangeBayoStatus, ServerWorkBolt, ServerSwitchBarrels;

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        ClientDoReload, ClientCancelReload, ToggleBarrelSteam;
}

// Implemented in subclasses
function ServerWorkBolt()
{
}

// Play an idle animation on the server so that weapon will be in the right position for free-aim calculations (not the ref pose)
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority && !Instigator.IsLocallyControlled())
    {
        PlayAnim(IdleAnim, IdleAnimRate, 0.0);
    }
}

// Debug logging to show how much ammo we have in our mags
exec function LogAmmo()
{
    local int i;

    if (!class'ROEngine.ROLevelInfo'.static.RODebugMode())
    {
        return;
    }

    for (i = 0; i < PrimaryAmmoArray.Length; ++i)
    {
        if (i == CurrentMagIndex)
        {
            Log("Current mag has" @ PrimaryAmmoArray[i] @ "ammo");
        }
        else
        {
            Log("Stowed mag has " @ PrimaryAmmoArray[i] @ "ammo");
        }
    }

    Log("Primary Ammo Count is" @ AmmoAmount(0));
    Log("There are" @ PrimaryAmmoArray.Length @ "mags");
}

simulated event RenderOverlays(Canvas Canvas)
{
    local int      i;
    local rotator  RollMod;
    local ROPlayer Playa;
    local ROPawn   RPawn;
    local int      LeanAngle;
    local rotator  RotOffset;

    if (Instigator == none)
    {
        return;
    }

    // Lets avoid having to do multiple casts every tick - Ramm
    Playa = ROPlayer(Instigator.Controller);

    // Don't draw the weapon if we're not viewing our own pawn
    if (Playa != none && Playa.ViewTarget != Instigator)
    {
        return;
    }

    // Draw muzzleflashes/smoke for all fire modes so idle state won't cause emitters to just disappear
    Canvas.DrawActor(none, false, true);

    for (i = 0; i < NUM_FIRE_MODES; ++i)
    {
        if (FireMode[i] != none)
        {
            FireMode[i].DrawMuzzleFlash(Canvas);
        }
    }

    // Adjust weapon position for lean
    RPawn = ROPawn(Instigator);

    if (RPawn != none && RPawn.LeanAmount != 0)
    {
        LeanAngle += RPawn.LeanAmount;
    }

    SetLocation(Instigator.Location + Instigator.CalcDrawOffset(self));

    if (bUsesFreeAim && !bUsingSights)
    {
        // Remove the roll component so the weapon doesn't tilt with the terrain
        RollMod = Instigator.GetViewRotation();

        if (Playa != none)
        {
            RollMod.Pitch += Playa.WeaponBufferRotation.Pitch;
            RollMod.Yaw += Playa.WeaponBufferRotation.Yaw;

            RotOffset.Pitch -= Playa.WeaponBufferRotation.Pitch;
            RotOffset.Yaw -= Playa.WeaponBufferRotation.Yaw;
        }

        RollMod.Roll += LeanAngle;

        if (IsCrawling())
        {
            RollMod.Pitch = CrawlWeaponPitch;
            RotOffset.Pitch = CrawlWeaponPitch;
        }
    }
    else
    {
        RollMod = Instigator.GetViewRotation();
        RollMod.Roll += LeanAngle;

        if (IsCrawling())
        {
            RollMod.Pitch = CrawlWeaponPitch;
            RotOffset.Pitch = CrawlWeaponPitch;
        }
    }

    // Use the special actor drawing when in ironsights to avoid the ironsight "jitter"
    // TODO: This messes up the lighting, and texture environment map shader when using ironsights
    // Maybe use a texrotator to simulate the texture environment map, or just find a way to fix the problems
    if (bUsingSights && Playa != none)
    {
        bDrawingFirstPerson = true;

        Canvas.DrawBoundActor(self, false, false, DisplayFOV, Playa.Rotation, Playa.WeaponBufferRotation, Instigator.CalcZoomedDrawOffset(self));

        bDrawingFirstPerson = false;
    }
    else
    {
        SetRotation(RollMod);

        bDrawingFirstPerson = true;

        Canvas.DrawActor(self, false, false, DisplayFOV);

        bDrawingFirstPerson = false;
    }
}

function SetServerOrientation(rotator NewRotation)
{
    local rotator WeaponRotation;

    if (bUsesFreeAim && !bUsingSights)
    {
        // Remove the roll component so the weapon doesn't tilt with the terrain
        WeaponRotation = Instigator.GetViewRotation();

        WeaponRotation.Pitch += NewRotation.Pitch;
        WeaponRotation.Yaw += NewRotation.Yaw;
        WeaponRotation.Roll += ROPawn(Instigator).LeanAmount;

        SetRotation(WeaponRotation);
        SetLocation(Instigator.Location + Instigator.CalcDrawOffset(self));
    }
}

// Get the coords for the muzzle bone. Used for free-aim projectile spawning
function coords GetMuzzleCoords()
{
    // have to update the location of the weapon before getting the coords
    SetLocation(Instigator.Location + Instigator.CalcDrawOffset(self));

    return GetBoneCoords('Muzzle');
}

// Returns true if this weapon should use free-aim in this particular state
simulated function bool ShouldUseFreeAim()
{
    if (FireMode[1].bMeleeMode && FireMode[1].IsFiring())
    {
        return false;
    }

    if (bUsesFreeAim && !bUsingSights)
    {
        return true;
    }

    return false;
}

// Choose between regular or alt-fire
function byte BestMode()
{
    local AIController C;

    C = AIController(Instigator.Controller);

    if (C == none || C.Enemy == none)
    {
        return 0;
    }

    if (!FireMode[1].bMeleeMode)
    {
        return super.BestMode();
    }

    if (VSize(C.Enemy.Location - Instigator.Location) < 125 && FRand() < 0.3)
    {
        return 1;
    }

    return 0;
}

state Hidden
{
    // Don't allow a reload if we're putting the weapon away
    simulated function bool AllowReload() {return false;}
}

// Overridden to support projectile weapon specific functionality
simulated state RaisingWeapon
{
    simulated function BeginState()
    {
        local int i;
        local name Anim;

        // If we have quickly raised our sights right after putting the weapon away, take us out of ironsight mode
        if (bUsingSights)
        {
            ZoomOut(false);
        }

        // Reset any zoom values
        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            if (DisplayFOV != default.DisplayFOV)
            {
                DisplayFOV = default.DisplayFOV;
            }

            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }
        }

        if (AmmoAmount(0) < 1 && HasAnim(SelectEmptyAnim))
        {
            Anim = SelectEmptyAnim;
        }
        else
        {
            Anim = SelectAnim;
        }

        if (ClientState == WS_Hidden)
        {
            PlayOwnedSound(SelectSound, SLOT_Interact,,,,, false);

            if (Instigator.IsLocallyControlled())
            {
                // Determines if bayonet capable weapon should come up with bayonet on or off
                if (bHasBayonet)
                {
                    if (bBayonetMounted)
                    {
                        ShowBayonet();
                    }
                    else
                    {
                        HideBayonet();
                    }
                }

                if (Mesh != none && HasAnim(Anim))
                {
                    PlayAnim(Anim, SelectAnimRate, 0.0);
                }
            }

            ClientState = WS_BringUp;
        }

        SetTimer(GetAnimDuration(Anim, SelectAnimRate), false);

        for (i = 0; i < NUM_FIRE_MODES; ++i)
        {
            FireMode[i].bIsFiring = false;
            FireMode[i].HoldTime = 0.0;
            FireMode[i].bServerDelayStartFire = false;
            FireMode[i].bServerDelayStopFire = false;
            FireMode[i].bInstantStop = false;
        }
    }
}

// Overridden to support empty put away anims
simulated state LoweringWeapon
{
    // Don't zoom in when we're lowering the weapon
    simulated function PerformZoom(bool bZoomStatus)
    {
    }

    // Don't allow a reload if we're putting the weapon away
    simulated function bool AllowReload()
    {
        return false;
    }

    // Don't allow the bayo to be attached while lowering the weapon
    simulated exec function Deploy()
    {
    }

    simulated function BeginState()
    {
        local name Anim;
        local int  i;

        if (AmmoAmount(0) < 1 && HasAnim(PutDownEmptyAnim))
        {
            Anim = PutDownEmptyAnim;
        }
        else
        {
            Anim = PutDownAnim;
        }

        if (ClientState == WS_BringUp || ClientState == WS_ReadyToFire)
        {
            if (Instigator.IsLocallyControlled())
            {
                for (i = 0; i < NUM_FIRE_MODES; ++i)
                {
                    if (FireMode[i].bIsFiring)
                    {
                        ClientStopFire(i);
                    }
                }

                if (ClientState == WS_BringUp)
                {
                    TweenAnim(SelectAnim, PutDownTime);
                }
                else if (HasAnim(Anim))
                {
                    PlayAnim(Anim, PutDownAnimRate, 0.0);
                }
            }

            ClientState = WS_PutDown;
        }

        SetTimer(GetAnimDuration(Anim, PutDownAnimRate), false);

        for (i = 0; i < NUM_FIRE_MODES; ++i)
        {
            FireMode[i].bServerDelayStartFire = false;
            FireMode[i].bServerDelayStopFire = false;
        }

        ResetPlayerFOV();
    }

    simulated function EndState()
    {
        super.EndState();

        if (bUsingSights && Role == ROLE_Authority)
        {
            ServerZoomOut(false);
        }

        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            // destroy the barrel steam emitter
            if (ROBarrelSteamEmitter != none)
            {
                ROBarrelSteamEmitter.Destroy();
            }
        }
    }
// Take the player out of iron sights if they are in ironsights
Begin:
    if (bUsingSights)
    {
        if (Role == ROLE_Authority)
        {
            ServerZoomOut(false);
        }

        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }

            SmoothZoom(false);
        }
    }
}

// Overridden to support taking you out of iron sights when using melee attacks (client & server)
simulated function bool StartFire(int Mode)
{
    local int Alt;

    if (!FireMode[Mode].bMeleeMode && AmmoAmount(0) <= 0 || bBarrelFailed)
    {
        return false;
    }

    if (!ReadyToFire(Mode))
    {
        return false;
    }

    if (Mode == 0)
    {
        Alt = 1;
    }
    else
    {
        Alt = 0;
    }

    FireMode[Mode].bIsFiring = true;
    FireMode[Mode].NextFireTime = Level.TimeSeconds + FireMode[Mode].PreFireTime;

    if (FireMode[Alt].bModeExclusive)
    {
        // prevents rapidly alternating fire modes
        FireMode[Mode].NextFireTime = FMax(FireMode[Mode].NextFireTime, FireMode[Alt].NextFireTime);
    }

    if (Instigator.IsLocallyControlled())
    {
        if (FireMode[Mode].PreFireTime > 0.0 || FireMode[Mode].bFireOnRelease)
        {
            FireMode[Mode].PlayPreFire();
        }

        FireMode[Mode].FireCount = 0;
    }

    // Take the weapon out of ironsights if we're trying to do a melee attack in ironsights
    if (FireMode[Mode].bMeleeMode)
    {
        ROPawn(Instigator).SetMeleeHoldAnims(true);
        GotoState('UnZoomImmediately');
    }

    return true;
}

//=============================================================================
// Crawling
//=============================================================================

simulated event NotifyCrawlMoving()
{
    if (!bUsingSights)
    {
        super.NotifyCrawlMoving();
    }
}

simulated state StartCrawling
{
    simulated function bool IsCrawling()
    {
        return true;
    }

    simulated function bool ReadyToFire(int Mode)
    {
        return false;
    }

    simulated function bool ShouldUseFreeAim()
    {
        return false;
    }

    simulated function Timer()
    {
        GotoState('Crawling');
    }

    simulated event WeaponTick(float dt)
    {
        local int WeaponPitch;

        // This is only for the visual rotation of the first person weapon client side
        if (Level.NetMode == NM_DedicatedServer)
        {
            return;
        }

        // Looking straight forward
        CrawlWeaponPitch = 0;

        if (Level.TimeSeconds - LastStartCrawlingTime < 0.15)
        {
            WeaponPitch =  Rotation.Pitch & 65535;

            if (WeaponPitch != CrawlWeaponPitch)
            {

                if (WeaponPitch > 32768)
                {
                    WeaponPitch += CrawlPitchTweenRate * dt;

                    if (WeaponPitch > 65535)
                    {
                        WeaponPitch = CrawlWeaponPitch;
                    }
                }
                else
                {
                    WeaponPitch -= CrawlPitchTweenRate * dt;

                    if (WeaponPitch <  0)
                    {
                        WeaponPitch = CrawlWeaponPitch;
                    }
                }
            }

            CrawlWeaponPitch = WeaponPitch;
        }
    }

    simulated function PlayIdle()
    {
        local int Direction;

        if (Instigator.IsLocallyControlled())
        {
            Direction = ROPawn(Instigator).Get8WayDirection();

            switch (Direction)
            {
                case 0:
                case 2:
                case 3:
                case 4:
                case 5:

                    if (AmmoAmount(0) < 1 && HasAnim(CrawlForwardEmptyAnim))
                    {
                        LoopAnim(CrawlForwardEmptyAnim, 1.0, 0.2);
                    }
                    else if (HasAnim(CrawlForwardAnim))
                    {
                        LoopAnim(CrawlForwardAnim, 1.0, 0.2);
                    }

                    break;

                default:

                    if (AmmoAmount(0) < 1 && HasAnim(CrawlBackwardEmptyAnim))
                    {
                        LoopAnim(CrawlBackwardEmptyAnim, 1.0, 0.2);
                    }
                    else if (HasAnim(CrawlBackwardAnim))
                    {
                        LoopAnim(CrawlBackwardAnim, 1.0, 0.2);
                    }

                    break;
            }
        }
    }

// Take the player out of iron sights if they are in ironsights
Begin:
    if (bUsingSights)
    {
        if (Role == ROLE_Authority)
        {
            ServerZoomOut(false);
        }
        else
        {
            ZoomOut(false);
        }

        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }

            SmoothZoom(false);
        }
    }
    // Finish unzooming the player if they are zoomed
    else if (DisplayFOV != default.DisplayFOV)
    {
        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            SmoothZoom(false);
        }
    }
}

simulated function PlayStartCrawl()
{
    local name  Anim;
    local float AnimTimer;

    if (AmmoAmount(0) < 1 && HasAnim(CrawlStartEmptyAnim))
    {
        Anim = CrawlStartEmptyAnim;
    }
    else
    {
        Anim = CrawlStartAnim;
    }

    if (Instigator.IsLocallyControlled())
    {
        PlayAnim(Anim, 1.0, FastTweenTime);
    }

    AnimTimer = GetAnimDuration(Anim, 1.0) + FastTweenTime;

    if (Level.NetMode == NM_DedicatedServer || (Level.NetMode == NM_ListenServer && !Instigator.IsLocallyControlled()))
    {
        SetTimer(AnimTimer - (AnimTimer * 0.1), false);
    }
    else
    {
        SetTimer(AnimTimer, false);
    }
}

// Overridden to support empty crawling anims
simulated state Crawling
{
    simulated function PlayIdle()
    {
        local int Direction;

        if (Instigator.IsLocallyControlled())
        {
            Direction = ROPawn(Instigator).Get8WayDirection();

            if (Direction == 0 ||  Direction == 2 ||  Direction == 3 || Direction == 4 ||
                Direction == 5)
            {
                if (AmmoAmount(0) < 1 && HasAnim(CrawlForwardEmptyAnim))
                {
                    LoopAnim(CrawlForwardEmptyAnim, 1.0, 0.2);
                }
                else if (HasAnim(CrawlForwardAnim))
                {
                    LoopAnim(CrawlForwardAnim, 1.0, 0.2);
                }
            }
            else
            {
                if (AmmoAmount(0) < 1 && HasAnim(CrawlBackwardEmptyAnim))
                {
                    LoopAnim(CrawlBackwardEmptyAnim, 1.0, 0.2);
                }
                else if (HasAnim(CrawlBackwardAnim))
                {
                    LoopAnim(CrawlBackwardAnim, 1.0, 0.2);
                }
            }
        }
    }

// Finish unzooming the player if they are zoomed
Begin:
    if (DisplayFOV != default.DisplayFOV)
    {
        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            SmoothZoom(false);
        }
    }
}

simulated function PlayEndCrawl()
{
    local name Anim;

    if (AmmoAmount(0) < 1 && HasAnim(CrawlEndEmptyAnim))
    {
        Anim = CrawlEndEmptyAnim;
    }
    else
    {
        Anim = CrawlEndAnim;
    }

    if (Instigator.IsLocallyControlled())
    {
        PlayAnim(Anim, 1.0, FastTweenTime);
    }

    SetTimer(GetAnimDuration(Anim, 1.0) + FastTweenTime, false);
}

//==============================================================================
// Bayonet attach/detach functionality
//==============================================================================

// Hide the bayonet (also called by anim notifies to hide bayonet during the attach/detach transition)
simulated function HideBayonet()
{
    SetBoneScale(0, 0.001, BayonetBoneName); // scale down bayonet bone
}

// Hide the bayonet (also called by anim notifies to hide bayonet during the attach/detach transition)
simulated function ShowBayonet()
{
    SetBoneScale(0, 1.0, BayonetBoneName);
}

simulated exec function Deploy()
{
    if (IsBusy() || !bHasBayonet || (FireMode[1] != none && FireMode[1].bMeleeMode && (FireMode[1].bIsFiring || FireMode[1].IsInState('MeleeAttacking'))))
    {
        return;
    }

    ChangeBayoStatus(!bBayonetMounted);
}

simulated function ChangeBayoStatus(bool bBayoStatus)
{
    if (bBayoStatus)
    {
        GotoState('AttachingBayonet');
    }
    else
    {
        GotoState('DetachingBayonet');
    }

    if (Role < ROLE_Authority)
    {
        ServerChangeBayoStatus(bBayoStatus);
    }
}

function ServerChangeBayoStatus(bool bBayoStatus)
{
    if (bBayoStatus)
    {
        GotoState('AttachingBayonet');
    }
    else
    {
        GotoState('DetachingBayonet');
    }
}

simulated state AttachingBayonet extends Busy
{
    simulated function bool ReadyToFire(int Mode)
    {
        return false;
    }

    simulated function bool ShouldUseFreeAim()
    {
        return false;
    }

    simulated function bool WeaponAllowSprint()
    {
        return false;
    }

    simulated function bool CanStartCrawlMoving()
    {
        return false;
    }

    simulated function Timer()
    {
        if (Instigator.bIsCrawling && VSizeSquared(Instigator.Velocity) > 1.0)
        {
            GotoState('StartCrawling');
        }
        else
        {
            GotoState('Idle');
        }
    }

    simulated function BeginState()
    {
        local float AnimTimer;

        bBayonetMounted = true;

        if (DHWeaponAttachment(ThirdPersonActor) != none)
        {
            DHWeaponAttachment(ThirdPersonActor).bBayonetAttached = true;
        }

        if (Instigator.IsLocallyControlled())
        {
            PlayAnim(BayoAttachAnim, 1.0, FastTweenTime);
        }

        if (Role == ROLE_Authority)
        {
            ROPawn(Instigator).HandleBayoAttach();
        }

        AnimTimer = GetAnimDuration(BayoAttachAnim, 1.0) + FastTweenTime;

        if (Level.NetMode == NM_DedicatedServer || (Level.NetMode == NM_ListenServer && !Instigator.IsLocallyControlled()))
        {
            SetTimer(AnimTimer - (AnimTimer * 0.1), false);
        }
        else
        {
            SetTimer(AnimTimer, false);
        }
    }

// Take the player out of iron sights if they are in ironsights
Begin:
    if (bUsingSights)
    {
        if (Role == ROLE_Authority)
        {
            ServerZoomOut(false);
        }
        else
        {
            ZoomOut(false);
        }

        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }

            SmoothZoom(false);
            ResetPlayerFOV();
        }
    }
}

simulated state DetachingBayonet extends Busy
{
    simulated function bool ReadyToFire(int Mode)
    {
        return false;
    }

    simulated function bool ShouldUseFreeAim()
    {
        return false;
    }

    simulated function bool CanStartCrawlMoving()
    {
        return false;
    }

    simulated function Timer()
    {
        if (Instigator.bIsCrawling && VSizeSquared(Instigator.Velocity) > 1.0)
        {
            GotoState('StartCrawling');
        }
        else
        {
            GotoState('Idle');
        }
    }

    simulated function BeginState()
    {
        local float AnimTimer;

        bBayonetMounted = false;

        if (DHWeaponAttachment(ThirdPersonActor) != none)
        {
            DHWeaponAttachment(ThirdPersonActor).bBayonetAttached = false;
        }

        if (Instigator.IsLocallyControlled())
        {
            PlayAnim(BayoDetachAnim, 1.0, FastTweenTime);
        }

        if (Role == ROLE_Authority)
        {
            ROPawn(Instigator).HandleBayoDetach();
        }

        AnimTimer = GetAnimDuration(BayoDetachAnim, 1.0) + FastTweenTime;

        if (Level.NetMode == NM_DedicatedServer || (Level.NetMode == NM_ListenServer && !Instigator.IsLocallyControlled()))
        {
            SetTimer(AnimTimer - (AnimTimer * 0.1), false);
        }
        else
        {
            SetTimer(AnimTimer, false);
        }
    }

// Take the player out of iron sights if they are in ironsights
Begin:
    if (bUsingSights)
    {
        if (Role == ROLE_Authority)
        {
            ServerZoomOut(false);
        }
        else
        {
            ZoomOut(false);
        }

        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }

            SmoothZoom(false);
            ResetPlayerFOV();
        }
    }
}

//=============================================================================
// Ironsight transition functionality
//=============================================================================

simulated function ROIronSights()
{
    PerformZoom(!bUsingSights);
}

simulated function PerformZoom(bool bZoomStatus)
{
    if (IsBusy() && !IsCrawling())
    {
        return;
    }

    if (bZoomStatus)
    {
        if (Instigator.Physics == PHYS_Falling)
        {
            return;
        }

        // Don't allow them to go to iron sights during a melee attack
        if (FireMode[1] != none && (FireMode[1].bIsFiring || FireMode[1].IsInState('MeleeAttacking')))
        {
            return;
        }

        ZoomIn(true);

        if (Role < ROLE_Authority)
        {
            ServerZoomIn(true);
        }
    }
    else
    {
        ZoomOut(true);

        if (Role < ROLE_Authority)
        {
            ServerZoomOut(true);
        }
    }
}

simulated function ZoomIn(bool bAnimateTransition)
{
    // Make the player stop firing when they go to iron sights
    if (FireMode[0] != none && FireMode[0].bIsFiring)
    {
        FireMode[0].StopFiring();
    }

    // Don't allow player to go to iron sights while in melee mode
    if (FireMode[1] != none && (FireMode[1].bIsFiring || FireMode[1].IsInState('MeleeAttacking')))
    {
        return;
    }

    if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
    {
        SetPlayerFOV(PlayerIronsightFOV);
    }

    if (bAnimateTransition)
    {
        GotoState('IronSightZoomIn');
    }

    bUsingSights = true;
    ROPawn(Instigator).SetIronSightAnims(true);
}

function ServerZoomIn(bool bAnimateTransition)
{
    ZoomIn(bAnimateTransition);
}

simulated function ZoomOut(bool bAnimateTransition)
{
    if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
    {
        ResetPlayerFOV();
    }

    if (bAnimateTransition)
    {
        GotoState('IronSightZoomOut');
    }

    bUsingSights = false;
    ROPawn(Instigator).SetIronSightAnims(false);
}

function ServerZoomOut(bool bAnimateTransition)
{
    ZoomOut(bAnimateTransition);
}

simulated function PlayerViewZoom(bool ZoomDirection)
{
    if (ZoomDirection)
    {
        bPlayerViewIsZoomed = true;

        if (Instigator != none && PlayerController(Instigator.Controller) != none)
        {
            PlayerController(Instigator.Controller).SetFOV(PlayerFOVZoom);
        }
    }
    else
    {
        bPlayerViewIsZoomed = false;

        if (Instigator != none && PlayerController(Instigator.Controller) != none)
        {
            PlayerController(Instigator.Controller).ResetFOV();
        }
    }
}

simulated state IronSightZoomIn extends Busy
{
    simulated function bool ReadyToFire(int Mode)
    {
        return false;
    }

    simulated function bool ShouldUseFreeAim()
    {
        return false;
    }

    simulated function bool CanStartCrawlMoving()
    {
        return false;
    }

    simulated function Timer()
    {
        GotoState('Idle');
    }

    simulated function BeginState()
    {
        local name  Anim;
        local float AnimTimer;

        if (AmmoAmount(0) < 1 && HasAnim(IronBringUpEmpty))
        {
            Anim = IronBringUpEmpty;
        }
        else if (bWaitingToBolt && HasAnim(IronBringUpRest))
        {
            Anim = IronBringUpRest;
        }
        else
        {
            Anim = IronBringUp;
        }

        if (Instigator.IsLocallyControlled())
        {
            PlayAnim(Anim, IronSwitchAnimRate, FastTweenTime);
        }

        AnimTimer = GetAnimDuration(Anim, IronSwitchAnimRate) + FastTweenTime;

        if (Level.NetMode == NM_DedicatedServer || (Level.NetMode == NM_ListenServer && !Instigator.IsLocallyControlled()))
        {
            SetTimer(AnimTimer - (AnimTimer * 0.15), false);
        }
        else
        {
            SetTimer(AnimTimer, false);
        }

        SetPlayerFOV(PlayerIronsightFOV);
    }

    simulated function EndState()
    {
        local float  TargetDisplayFOV;
        local vector TargetPVO;

        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            if (ScopeDetail == RO_ModelScopeHigh)
            {
                TargetDisplayFOV = default.IronSightDisplayFOVHigh;
                TargetPVO = default.XoffsetHighDetail;
            }
            else if (ScopeDetail == RO_ModelScope)
            {
                TargetDisplayFOV = default.IronSightDisplayFOV;
                TargetPVO = default.XoffsetScoped;
            }
            else
            {
                TargetDisplayFOV = default.IronSightDisplayFOV;
                TargetPVO = default.PlayerViewOffset;
            }

            DisplayFOV = TargetDisplayFOV;
            PlayerViewOffset = TargetPVO;
        }
    }

Begin:
    if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
    {
        SmoothZoom(true);
    }
}

simulated state IronSightZoomOut extends Busy
{
    simulated function bool ReadyToFire(int Mode)
    {
        return false;
    }

    simulated function bool ShouldUseFreeAim()
    {
        return false;
    }

    simulated function Timer()
    {
        GotoState('Idle');
    }

    simulated function BeginState()
    {
        local name  Anim;
        local float AnimTimer;

        if (AmmoAmount(0) < 1 && HasAnim(IronPutDownEmpty))
        {
            Anim = IronPutDownEmpty;
        }
        else
        {
            Anim = IronPutDown;
        }

        if (Instigator.IsLocallyControlled())
        {
            PlayAnim(Anim, IronSwitchAnimRate, FastTweenTime);
        }

        AnimTimer = GetAnimDuration(Anim, IronSwitchAnimRate) + FastTweenTime;

        if (Level.NetMode == NM_DedicatedServer || (Level.NetMode == NM_ListenServer && !Instigator.IsLocallyControlled()))
        {
            SetTimer(AnimTimer - (AnimTimer * 0.15), false);
        }
        else
        {
            SetTimer(AnimTimer, false);
        }
    }

    simulated function EndState()
    {
        if (Instigator.bIsCrawling && VSizeSquared(Instigator.Velocity) > 1.0)
        {
            NotifyCrawlMoving();
        }

        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            DisplayFOV = default.DisplayFOV;
            PlayerViewOffset = default.PlayerViewOffset;
        }
    }

Begin:
    if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
    {
        if (bPlayerFOVZooms)
        {
            PlayerViewZoom(false);
        }

        SmoothZoom(false);
        ResetPlayerFOV();
    }
}

// Take the weapon out of iron sights if you jump
simulated function NotifyOwnerJumped()
{
    if (!IsBusy() || IsInState('IronSightZoomIn'))
    {
        GotoState('TweenDown');
    }
}

// Just go back to the idle animation and take us out of zoom if we are zoomed
simulated state TweenDown extends Busy
{
    simulated function bool ReadyToFire(int Mode)
    {
        return false;
    }

    simulated function bool ShouldUseFreeAim()
    {
        return false;
    }

    simulated function Timer()
    {
        GotoState('Idle');
    }

    simulated function PlayIdle()
    {
        if (bUsingSights)
        {
            if (bWaitingToBolt && HasAnim(PostFireIronIdleAnim))
            {
                TweenAnim(PostFireIronIdleAnim, FastTweenTime);
            }
            else if (AmmoAmount(0) < 1 && HasAnim(IronIdleEmptyAnim))
            {
                TweenAnim(IronIdleEmptyAnim, FastTweenTime);
            }
            else
            {
                TweenAnim(IronIdleAnim, FastTweenTime);
            }
        }
        else
        {
            if (bWaitingToBolt && HasAnim(PostFireIdleAnim))
            {
                TweenAnim(PostFireIdleAnim, FastTweenTime);
            }
            else if (AmmoAmount(0) < 1 && HasAnim(IdleEmptyAnim))
            {
                TweenAnim(IdleEmptyAnim, FastTweenTime);
            }
            else
            {
                TweenAnim(IdleAnim, FastTweenTime);
            }
        }
    }

    simulated function BeginState()
    {
    }

    simulated function EndState()
    {
        // Reset any zoom values
        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            global.PlayIdle();
        }
    }

Begin:
    if (bUsingSights)
    {
        SetTimer(Default.ZoomOutTime + 0.1, false);

        if (Role == ROLE_Authority)
        {
            ServerZoomOut(false);
        }
        else
        {
            ZoomOut(false);
        }

        if (Instigator.IsLocallyControlled() || (Instigator.DrivenVehicle != none && Instigator.DrivenVehicle.IsLocallyControlled()))
        {
            PlayIdle();

            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }

            SmoothZoom(false);
            ResetPlayerFOV();
        }
    }
    else
    {
        GotoState('Idle');
    }
}

simulated function PlayIdle()
{
    if (bUsingSights)
    {
        if (bWaitingToBolt && HasAnim(PostFireIronIdleAnim))
        {
            LoopAnim(PostFireIronIdleAnim, IdleAnimRate, 0.2);
        }
        else if (AmmoAmount(0) < 1 && HasAnim(IronIdleEmptyAnim))
        {
            LoopAnim(IronIdleEmptyAnim, IdleAnimRate, 0.2);
        }
        else
        {
            LoopAnim(IronIdleAnim, IdleAnimRate, 0.2);
        }
    }
    else
    {
        if (bWaitingToBolt && HasAnim(PostFireIdleAnim))
        {
            LoopAnim(PostFireIdleAnim, IdleAnimRate, 0.2);
        }
        else if (AmmoAmount(0) < 1 && HasAnim(IdleEmptyAnim))
        {
            LoopAnim(IdleEmptyAnim, IdleAnimRate, 0.2);
        }
        else
        {
            LoopAnim(IdleAnim, IdleAnimRate, 0.2);
        }
    }
}

// Takes us out of zoom immediately - this is a non blocking state, and will not prevent firing, reloading, etc
// Use this when some non state changing action needs to bring us out of iron sights immediately, without playing the idle animation
simulated state UnZoomImmediately extends Idle
{
Begin:
    if (bUsingSights)
    {
        if (Role == ROLE_Authority)
        {
            ServerZoomOut(false);
        }
        else
        {
            ZoomOut(false);
        }

        // We'll want to sleep however long this zoom out takes
        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }

            SmoothZoom(false);
            ResetPlayerFOV();
        }
    }

    GotoState('Idle');
}

//=============================================================================
// Sprinting
//=============================================================================

simulated state StartSprinting
{
    simulated function PlayIdle()
    {
        local float LoopSpeed, Speed2d;
        local name  Anim;

        if (Instigator.IsLocallyControlled())
        {
            // Make the sprinting animation match the sprinting speed
            LoopSpeed = 1.5;

            Speed2d = VSize(Instigator.Velocity);
            LoopSpeed = (Speed2d / (Instigator.default.GroundSpeed * Instigator.SprintPct)) * 1.5;

            if ((AmmoAmount(0) <= 0) && HasAnim(SprintLoopEmptyAnim))
            {
                Anim = SprintLoopEmptyAnim;
            }
            else
            {
                Anim = SprintLoopAnim;
            }

            if (HasAnim(SprintLoopAnim))
            {
                LoopAnim(Anim, LoopSpeed, 0.2);
            }
        }
    }

    simulated function BeginState()
    {
        PlayStartSprint();
    }

// Take the player out of iron sights if they are in ironsights
Begin:
    if (bUsingSights)
    {
        if (Role == ROLE_Authority)
        {
            ServerZoomOut(false);
        }
        else
        {
            ZoomOut(false);
        }

        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }

            SmoothZoom(false);
            ResetPlayerFOV();
        }
    }
    // Finish unzooming the player if they are zoomed
    else if (DisplayFOV != default.DisplayFOV)
    {
        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            SmoothZoom(false);
        }
    }
}

simulated function PlayStartSprint()
{
    local name Anim;

    if (AmmoAmount(0) <= 0 && HasAnim(SprintStartEmptyAnim))
    {
        Anim = SprintStartEmptyAnim;
    }
    else
    {
        Anim = SprintStartAnim;
    }

    if (Instigator.IsLocallyControlled())
    {
        PlayAnim(Anim, 1.5, FastTweenTime);
    }

    SetTimer(GetAnimDuration(Anim, 1.5) + FastTweenTime, false);
}

simulated state WeaponSprinting
{
    simulated function PlayIdle()
    {
        local float LoopSpeed;
        local float Speed2d;
        local name  Anim;

        if (Instigator.IsLocallyControlled())
        {
            // Make the sprinting animation match the sprinting speed
            LoopSpeed = 1.5;

            Speed2d = VSize(Instigator.Velocity);
            LoopSpeed = (Speed2d / (Instigator.default.GroundSpeed * Instigator.SprintPct)) * 1.5;

            if (AmmoAmount(0) <= 0 && HasAnim(SprintLoopEmptyAnim))
            {
                Anim = SprintLoopEmptyAnim;
            }
            else
            {
                Anim = SprintLoopAnim;
            }

            if (HasAnim(SprintLoopAnim))
            {
                LoopAnim(Anim, LoopSpeed, FastTweenTime);
            }
        }
    }

// Finish unzooming the player if they are zoomed
Begin:
    if (DisplayFOV != default.DisplayFOV)
    {
        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            SmoothZoom(false);
        }
    }
}

simulated function PlayEndSprint()
{
    local name Anim;

    if (AmmoAmount(0) <= 0 && HasAnim(SprintEndEmptyAnim))
    {
        Anim = SprintEndEmptyAnim;
    }
    else
    {
        Anim = SprintEndAnim;
    }

    if (Instigator.IsLocallyControlled())
    {
        PlayAnim(Anim, 1.5, FastTweenTime);
    }

    SetTimer(GetAnimDuration(Anim, 1.5) + FastTweenTime, false);
}

//=============================================================================
// Reloading/Ammunition
//=============================================================================

simulated function OutOfAmmo()
{
    if (!HasAmmo() && DHWeaponAttachment(ThirdPersonActor) != none)
    {
        DHWeaponAttachment(ThirdPersonActor).bOutOfAmmo = true;
    }

    if (Instigator == none || !Instigator.IsLocallyControlled() || HasAmmo())
    {
        return;
    }

    if (AIController(Instigator.Controller) != none)
    {
        GotoState('Reloading');
    }
}

simulated exec function ROManualReload()
{
    if (!AllowReload())
    {
        return;
    }

    if (Level.NetMode == NM_Client && !IsBusy())
    {
        GotoState('PendingAction');
    }

    ServerRequestReload();
}

simulated function bool AllowReload()
{
    return !IsFiring() && !IsBusy() && CurrentMagCount >= 1;
}

simulated function int GetHudAmmoCount()
{
    return CurrentMagCount;
}

function ServerRequestReload()
{
    if (AllowReload())
    {
        GotoState('Reloading');
        ClientDoReload();
    }
    else
    {
        ClientCancelReload(); // if we can't reload
    }
}

simulated function ClientDoReload(optional int NumRounds)
{
    GotoState('Reloading');
}

simulated function ClientCancelReload()
{
    GotoState('Idle');
}

simulated state Reloading extends Busy
{
    simulated function bool ReadyToFire(int Mode)
    {
        return false;
    }

    simulated function bool ShouldUseFreeAim()
    {
        return false;
    }

    simulated function bool WeaponAllowSprint()
    {
        return false;
    }

    simulated function bool CanStartCrawlMoving()
    {
        return false;
    }

    simulated function Timer()
    {
        if (Instigator.bIsCrawling && VSizeSquared(Instigator.Velocity) > 1.0)
        {
            GotoState('StartCrawling');
        }
        else
        {
            GotoState('Idle');
        }
    }

    simulated function BeginState()
    {
        if (Role == ROLE_Authority)
        {
            ROPawn(Instigator).HandleStandardReload();
        }

        PlayReload();
        ResetPlayerFOV();
    }

    simulated function EndState()
    {
        if (Role == ROLE_Authority)
        {
            PerformReload();
        }

        bWaitingToBolt = false;
    }

// Take the player out of iron sights if they are in ironsights
Begin:
    if (bUsingSights)
    {
        if (Role == ROLE_Authority)
        {
            ServerZoomOut(false);
        }
        else
        {
            ZoomOut(false);
        }

        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }

            SmoothZoom(false);
        }
    }

    // Sometimes the client will get switched out of ironsight mode before getting to the reload function - this should catch that
    if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
    {
        if (DisplayFOV != default.DisplayFOV)
        {
            SmoothZoom(false);
        }

        if (bPlayerFOVZooms)
        {
            PlayerViewZoom(false);
        }
    }
}

// Client gets sent to this state when the client has requested an action that needs verified by the server
// Once the server verifies they can start the action, the server will take the client out of this state
simulated state PendingAction extends Busy
{
    simulated function bool ReadyToFire(int Mode)
    {
        return false;
    }

    simulated function bool WeaponAllowSprint()
    {
        return false;
    }

// Take the player out of iron sights if they are in ironsights
Begin:
    if (bUsingSights)
    {
        if (Role == ROLE_Authority)
        {
            ServerZoomOut(false);
        }
        else
        {
            ZoomOut(false);
        }

        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }

            SmoothZoom(false);
        }
    }
}

simulated function PlayReload()
{
    local name  Anim;
    local float AnimTimer;

    if (AmmoAmount(0) > 0)
    {
        Anim = MagPartialReloadAnim;
    }
    else
    {
        Anim = MagEmptyReloadAnim;
    }

    AnimTimer = GetAnimDuration(Anim, 1.0) + FastTweenTime;

    if (Level.NetMode == NM_DedicatedServer || (Level.NetMode == NM_ListenServer && !Instigator.IsLocallyControlled()))
    {
        SetTimer(AnimTimer - (AnimTimer * 0.1), false);
    }
    else
    {
        SetTimer(AnimTimer, false);
    }

    if (Instigator.IsLocallyControlled())
    {
        PlayAnim(Anim, 1.0, FastTweenTime);
    }
}

// Do the actual ammo swapping
function PerformReload()
{
    local int  CurrentMagLoad;
    local bool bDidPlusOneReload;

    CurrentMagLoad = AmmoAmount(0);

    if (PrimaryAmmoArray.Length == 0)
    {
        return;
    }

    if (CurrentMagLoad <= 0)
    {
        PrimaryAmmoArray.Remove(CurrentMagIndex, 1);
    }
    else
    {
        if (bPlusOneLoading)
        {
            // If there's only one bullet left(the one in the chamber), discard the clip
            if (CurrentMagLoad == 1)
            {
                PrimaryAmmoArray.Remove(CurrentMagIndex, 1);
            }
            else
            {
                PrimaryAmmoArray[CurrentMagIndex] = CurrentMagLoad - 1;
            }

            AmmoCharge[0] = 1;
            bDidPlusOneReload = true;
        }
        else
        {
            PrimaryAmmoArray[CurrentMagIndex] = CurrentMagLoad;
            AmmoCharge[0] = 0;
        }
    }

    if (PrimaryAmmoArray.Length == 0)
    {
        return;
    }

    CurrentMagIndex++;

    if (CurrentMagIndex > PrimaryAmmoArray.Length - 1)
    {
        CurrentMagIndex = 0;
    }

    if (bDidPlusOneReload)
    {
        AddAmmo(PrimaryAmmoArray[CurrentMagIndex] + 1, 0);
    }
    else
    {
        AddAmmo(PrimaryAmmoArray[CurrentMagIndex], 0);
    }

    if (Instigator.IsHumanControlled())
    {
        if (AmmoStatus(0) > 0.5)
        {
            PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'ROAmmoWeightMessage', 0);
        }
        else if (AmmoStatus(0) > 0.2)
        {
            PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'ROAmmoWeightMessage', 1);
        }
        else
        {
            PlayerController(Instigator.Controller).ReceiveLocalizedMessage(class'ROAmmoWeightMessage', 2);
        }
    }

    if (AmmoAmount(0) > 0)
    {
        if (DHWeaponAttachment(ThirdPersonActor) != none)
        {
            DHWeaponAttachment(ThirdPersonActor).bOutOfAmmo = false;
        }
    }

    ClientForceAmmoUpdate(0, AmmoAmount(0));

    CurrentMagCount = PrimaryAmmoArray.Length - 1;
}

function bool FillAmmo()
{
    local int  i;
    local bool bDidFillAmmo;

    if (PrimaryAmmoArray.Length < MaxNumPrimaryMags)
    {
        for (i = 0; i < default.FillAmmoMagCount; ++i)
        {
            PrimaryAmmoArray.Length = PrimaryAmmoArray.Length + 1;

            PrimaryAmmoArray[PrimaryAmmoArray.Length - 1] = FireMode[0].AmmoClass.default.InitialAmount;

            bDidFillAmmo = true;

            if (PrimaryAmmoArray.Length >= MaxNumPrimaryMags)
            {
                break;
            }
        }

        CurrentMagCount = PrimaryAmmoArray.Length - 1;
    }
    else if (FillAmmoMagCount > 0)
    {
        for (i = 0; i < PrimaryAmmoArray.Length; ++i)
        {
            if (PrimaryAmmoArray[i] < FireMode[0].AmmoClass.default.InitialAmount)
            {
                PrimaryAmmoArray[i] = FireMode[0].AmmoClass.default.InitialAmount;

                bDidFillAmmo = true;

                break;
            }
        }
    }

    return bDidFillAmmo;
}

function SetNumMags(int M)
{
    PrimaryAmmoArray.Length = M;
    CurrentMagCount = PrimaryAmmoArray.Length - 1;
}

function GiveAmmo(int M, WeaponPickup WP, bool bJustSpawned)
{
    local bool bJustSpawnedAmmo;
    local int  AddAmount, InitialAmount, i;
    local DHWeaponPickup DHWP;

    if (FireMode[M] != none && FireMode[M].AmmoClass != none)
    {
        Ammo[M] = Ammunition(Instigator.FindInventoryType(FireMode[M].AmmoClass));

        bJustSpawnedAmmo = false;

        if (FireMode[M].AmmoClass == none || (M != 0 && FireMode[M].AmmoClass == FireMode[0].AmmoClass))
        {
            return;
        }

        InitialAmount = FireMode[M].AmmoClass.default.InitialAmount;

        if (bJustSpawned && WP == none)
        {
            PrimaryAmmoArray.Length = InitialNumPrimaryMags;

            for (i = 0; i < PrimaryAmmoArray.Length; ++i)
            {
                PrimaryAmmoArray[i] = InitialAmount;
            }

            CurrentMagIndex = 0;
        }

        if (WP != none)
        {
            InitialAmount = WP.AmmoAmount[M];

            DHWP = DHWeaponPickup(WP);

            if (DHWP != none)
            {
                for (i = 0; i < DHWP.AmmoMags.Length; ++i)
                {
                    PrimaryAmmoArray[i] = DHWP.AmmoMags[i];
                }

                CurrentMagIndex = DHWP.LoadedMagazineIndex;
            }
        }

        CurrentMagCount = PrimaryAmmoArray.Length - 1;

        if (Ammo[M] != none)
        {
            AddAmount = InitialAmount + Ammo[M].AmmoAmount;

            Ammo[M].Destroy();
        }
        else
        {
            AddAmount = InitialAmount;
        }

        AddAmmo(AddAmount, M);
    }
}

function bool AddAmmo(int AmmoToAdd, int Mode)
{
    if (AmmoClass[0] == AmmoClass[Mode])
    {
        Mode = 0;
    }

    if (Level.GRI.WeaponBerserk > 1.0)
    {
        AmmoCharge[Mode] = MaxAmmo(Mode);
    }
    else if (AmmoCharge[mode] < MaxAmmo(Mode))
    {
        AmmoCharge[Mode] = Min(MaxAmmo(Mode), AmmoCharge[Mode] + AmmoToAdd);
    }

    NetUpdateTime = Level.TimeSeconds - 1;

    return true;
}

function bool HandlePickupQuery(Pickup Item)
{
    local int            i;
    local WeaponPickup   WP;
    local DHWeaponPickup DHWP;
    local array<int>     LoadedMagazineIndices;

    if (Class == Item.InventoryType)
    {
        // Pickup is our weapon type
        WP = WeaponPickup(Item);

        if (WP != none)
        {
            DHWP = DHWeaponPickup(WP);

            if (DHWP != none)
            {
                // Gets loaded magazines from the pickup and adds them to our weapon
                LoadedMagazineIndices = DHWP.GetLoadedMagazineIndices();

                Log("LoadedMagazineIndices.Length" @ LoadedMagazineIndices.Length);

                for (i = 0; i < LoadedMagazineIndices.Length; ++i)
                {
                    Log("LoadedMagazineIndices[" $ i $ "] =" @ LoadedMagazineIndices[i] @ DHWP.AmmoMags[LoadedMagazineIndices[i]]);
                }

                for (i = 0; i < LoadedMagazineIndices.Length && PrimaryAmmoArray.Length < MaxNumPrimaryMags; ++i)
                {
                    PrimaryAmmoArray[PrimaryAmmoArray.Length] = DHWP.AmmoMags[LoadedMagazineIndices[i]];
                }

                CurrentMagCount = PrimaryAmmoArray.Length - 1;

                return false;
            }
            else
            {
                return !WP.AllowRepeatPickup();
            }
        }
        else
        {
            return false;
        }
    }

    // Drop current weapon and pickup the one on the ground
    if (Instigator.Weapon != none && Instigator.Weapon.InventoryGroup == InventoryGroup && Item.InventoryType.default.InventoryGroup == InventoryGroup && Instigator.CanThrowWeapon())
    {
        ROPlayer(Instigator.Controller).ThrowWeapon();

        return false;
    }

    // Avoid multiple weapons in the same slot
    if (Item.InventoryType.default.InventoryGroup == InventoryGroup)
    {
        return true;
    }

    if (Inventory == none)
    {
        return false;
    }

    return Inventory.HandlePickupQuery(Item);
}

function DropFrom(vector StartLocation)
{
    local int    i;
    local Pickup Pickup;

    if (!bCanThrow)
    {
        return;
    }

    if (Instigator != none && bUsingSights)
    {
        bUsingSights = false;

        ROPawn(Instigator).SetIronSightAnims(false);
    }

    ClientWeaponThrown();

    for (i = 0; i < NUM_FIRE_MODES; ++i)
    {
        if (FireMode[i].bIsFiring)
        {
            StopFire(i);
        }
    }

    if (Instigator != none)
    {
        DetachFromPawn(Instigator);
    }

    Pickup = Spawn(PickupClass,,, StartLocation, Rotation);

    if (Pickup != none)
    {
        Pickup.InitDroppedPickupFor(self);
        Pickup.Velocity = Velocity;
        Pickup.Velocity.X += RandRange(-100.0, 100.0);
        Pickup.Velocity.Y += RandRange(-100.0, 100.0);

        if (Instigator.Health > 0)
        {
            WeaponPickup(Pickup).bThrown = true;
        }
    }

    Destroy();
}

// The empty sound if your out of ammo
simulated function Fire(float F)
{
    if (AmmoAmount(0) < 1 && !IsBusy())
    {
        PlayOwnedSound(FireMode[0].NoAmmoSound, SLOT_None, 1.0,,,, false);
    }

    super.Fire(F);
}

// Called when we need to toggle barrel steam on or off, depending on the barrel temperature
simulated function ToggleBarrelSteam(bool NewState)
{
    bBarrelSteaming = NewState;

    if (DHWeaponAttachment(ThirdPersonActor) != none)
    {
        DHWeaponAttachment(ThirdPersonActor).bBarrelSteamActive = NewState;
    }

    if (Level.NetMode != NM_DedicatedServer && ROBarrelSteamEmitter != none)
    {
        ROBarrelSteamEmitter.Trigger(self, Instigator);
    }
}

function ServerSwitchBarrels()
{
    GotoState('ChangingBarrels');
}

simulated exec function ROMGOperation()
{
    if (!AllowBarrelChange())
    {
        return;
    }

    if (Level.NetMode == NM_Client)
    {
        GotoState('ChangingBarrels');
    }

    ServerSwitchBarrels();
}

simulated function bool AllowBarrelChange()
{
    return !IsFiring() && !IsBusy() && RemainingBarrels >= 2 && bTrackBarrelHeat && !IsInState('ChangingBarrels') && Instigator.bBipodDeployed;
}

// State where we are changing the barrel out for our MG
simulated state ChangingBarrels extends Busy
{
    simulated function bool ReadyToFire(int Mode)
    {
        return false;
    }

    simulated function bool ShouldUseFreeAim()
    {
        return false;
    }

    simulated function bool WeaponAllowSprint()
    {
        return false;
    }

    simulated function bool WeaponAllowProneChange()
    {
        return false;
    }

    simulated function bool WeaponAllowCrouchChange()
    {
        return false;
    }

    simulated function Timer()
    {
        GotoState('Idle');
    }

    simulated function BeginState()
    {
        PlayBarrelChange();
        PerformBarrelChange();

        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            ResetPlayerFOV();
        }
    }

    simulated function EndState()
    {
        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            SetPlayerFOV(PlayerDeployFOV);
        }
    }

// Take the player out of zoom and then zoom them back in
Begin:
    if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
    {
        if (DisplayFOV != default.DisplayFOV)
        {
            SmoothZoom(false);
        }

        Sleep(GetAnimDuration(BarrelChangeAnim, 1.0) - (default.ZoomInTime + default.ZoomOutTime));

        SetPlayerFOV(PlayerDeployFOV);

        SmoothZoom(true);
    }
}

simulated function PlayBarrelChange()
{
    local float AnimTimer;

    AnimTimer = GetAnimDuration(BarrelChangeAnim, 1.0) + FastTweenTime;

    if (Level.NetMode == NM_DedicatedServer || (Level.NetMode == NM_ListenServer && !Instigator.IsLocallyControlled()))
    {
        SetTimer(AnimTimer - (AnimTimer * 0.1), false);
    }
    else
    {
        SetTimer(AnimTimer, false);
    }

    if (Instigator.IsLocallyControlled())
    {
        PlayAnim(BarrelChangeAnim, 1.0, FastTweenTime);
    }
}

function PerformBarrelChange()
{
    // We only have the 1 barrel in our weapon, don't do anything
    if (RemainingBarrels == 1)
    {
        return;
    }

    // If the barrel has failed, we're going to toss it, so remove it from the barrel array
    if (Barrels[BarrelIndex].bBarrelFailed && Barrels[BarrelIndex] != none)
    {
        Barrels[BarrelIndex].Destroy();

        Barrels.Remove(BarrelIndex, 1);

        RemainingBarrels = byte(Barrels.Length);
    }

    // We only have one barrel left now
    if (RemainingBarrels == 1)
    {
        if ((BarrelIndex >= (Barrels.Length - 1)) || (Barrels.Length == 1))
        {
            BarrelIndex = 0;
        }
        else
        {
            ++BarrelIndex;
        }

        // Put the new barrel in the use state for heat increments and steaming
        if (Barrels[BarrelIndex] != none)
        {
            Barrels[BarrelIndex].GotoState('BarrelInUse');
        }
    }
    else
    {
        // At this point, we have more than 1 barrel, & the one being replaced hasn't failed,
        // so we'll switch the BarrelIndex tracker & also place the barrels in new states for whether they're on or off
        // First place the current BarrelIndex in the BarrelOff state
        Barrels[BarrelIndex].GotoState('BarrelOff');

        if ((BarrelIndex >= (Barrels.Length - 1)) || (Barrels.Length == 1))
        {
            BarrelIndex = 0;
        }
        else
        {
            BarrelIndex++;
        }

        // Put the new barrel in the use state for heat increments and steaming
        if (Barrels[BarrelIndex] != none)
        {
            Barrels[BarrelIndex].GotoState('BarrelInUse');
        }
    }

    ResetBarrelProperties();
}

// Called when we change barrels, this updates the weapon's barrel properties for the new barrel that's being swapped in
function ResetBarrelProperties()
{
    bBarrelFailed = Barrels[BarrelIndex].bBarrelFailed;
    bBarrelSteaming = Barrels[BarrelIndex].bBarrelSteaming;
    bBarrelDamaged = Barrels[BarrelIndex].bBarrelDamaged;

    if (DHWeaponAttachment(ThirdPersonActor) != none && DHWeaponAttachment(ThirdPersonActor).SoundPitch != 64)
    {
        DHWeaponAttachment(ThirdPersonActor).SoundPitch = 64;
    }
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
    {
        SpawnBarrelSteamEmitter();

        if (bBarrelSteaming)
        {
            ToggleBarrelSteam(true);
        }
    }
}

// Spawns barrel steam emitter
simulated function SpawnBarrelSteamEmitter()
{
    if (Level.NetMode != NM_DedicatedServer && ROBarrelSteamEmitterClass != none)
    {
        ROBarrelSteamEmitter = Spawn(ROBarrelSteamEmitterClass, self);

        if (ROBarrelSteamEmitter != none)
        {
            AttachToBone(ROBarrelSteamEmitter, BarrelSteamBone);
        }
    }
}

// Spawns barrels for MG's on Authority
function GiveBarrels(optional Pickup Pickup)
{
    local int            i;
    local DHWeaponBarrel    TempBarrel, TempBarrel2;
    local DHWeaponPickup P;

    if (BarrelClass == none || Role != ROLE_Authority)
    {
        return;
    }

    if (Pickup == none)
    {
        // Give the barrels to the players
        for (i = 0; i < InitialBarrels; ++i)
        {
            TempBarrel = Spawn(BarrelClass, self);

            Barrels[i] = TempBarrel;

            if (i == 0)
            {
                Barrels[i].GotoState('BarrelInUse');
            }
            else
            {
                Barrels[i].GotoState('BarrelOff');
            }
        }
    }
    else if (DHWeaponPickup(Pickup) != none)
    {
        P = DHWeaponPickup(Pickup);

        TempBarrel = Spawn(BarrelClass, self);

        Barrels[0] = TempBarrel;

        Barrels[0].GotoState('BarrelInUse');
        Barrels[0].Temperature = P.Temperature;
        Barrels[0].bBarrelFailed = P.bBarrelFailed;
        Barrels[0].UpdateBarrelStatus(); // update the barrel for the weapon we just picked up

        if (P.bHasSpareBarrel)
        {
            TempBarrel2 = Spawn(BarrelClass, self);

            Barrels[1] = TempBarrel2;
            Barrels[1].GotoState('BarrelOff');

            Barrels[1].Temperature = P.Temperature2;
            Barrels[1].UpdateSpareBarrelStatus();
        }
    }

    BarrelIndex = 0;
    RemainingBarrels = byte(Barrels.Length);
}

// Overridden to set additional RO Variables when a weapon is given to the player
function GiveTo(Pawn Other, optional Pickup Pickup)
{
    super.GiveTo(Other,Pickup);

    GiveBarrels(Pickup);
}

simulated function Destroyed()
{
    local int i;

    super.Destroyed();

    // Remove and destroy the barrels in the Barrels array
    for (i = 0; i < Barrels.Length; ++i)
    {
        if (Barrels[i] != none)
        {
            Barrels[i].Destroy();
        }
    }

    // Destroy the barrel steam emitter
    if (ROBarrelSteamEmitter != none)
    {
        ROBarrelSteamEmitter.Destroy();
    }

    Barrels.Remove(0, Barrels.Length);
}

// Overridden to support notifying the barrels that we have fired
simulated function bool ConsumeAmmo(int Mode, float Load, optional bool bAmountNeededIsMax)
{
    local float       SoundModifier;
    local DHWeaponBarrel B;

    if (BarrelIndex >= 0 && BarrelIndex < Barrels.Length)
    {
        B = Barrels[BarrelIndex];

        if (Role == ROLE_Authority)
        {
            B.WeaponFired();
        }

        if (ROWeaponAttachment(ThirdPersonActor) != none)
        {
            if (bBarrelDamaged)
            {
                SoundModifier = FMax(52.0, 64.0 - ((B.Temperature - B.CriticalTemperature) / (B.FailureTemperature - B.CriticalTemperature) * 52.0));

                ROWeaponAttachment(ThirdPersonActor).SoundPitch = SoundModifier;
            }
            else if (ROWeaponAttachment(ThirdPersonActor).SoundPitch != 64)
            {
                ROWeaponAttachment(ThirdPersonActor).SoundPitch = 64;
            }
        }
    }

    return super.ConsumeAmmo(Mode, Load, bAmountNeededIsMax);
}

defaultproperties
{
    IronSwitchAnimRate=1.0
    FastTweenTime=0.2
    Priority=9
    bUsesFreeAim=true
    LightType=LT_Steady
    LightEffect=LE_NonIncidence
    LightHue=30
    LightSaturation=150
    LightBrightness=255.0
    LightRadius=4.0
    LightPeriod=3
    FillAmmoMagCount=1
    ROBarrelSteamEmitterClass=class'ROEffects.ROMGSteam'
}
