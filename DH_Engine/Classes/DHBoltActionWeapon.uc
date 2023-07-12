//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBoltActionWeapon extends DHProjectileWeapon
    abstract;

enum EReloadState
{
    RS_None,
    RS_PreReload,
    RS_ReloadLooped,
    RS_ReloadLoopedStripper,
    RS_PostReload,
    RS_FullReload
};

var     EReloadState    ReloadState;        // weapon's current reloading state (none means not reloading)
var     bool            bInterruptReload;   // set when one-by-one reload is stopped by player part way through, by pressing fire button

var     name            PreReloadAnim;      // one-off anim when starting to reload
var     name            PreReloadHalfAnim;  // same as above, but when there are one or more rounds in the chamber
var     name            PreReloadEmptyAnim; // same as above, but when the weapon is empty

var     name            SingleReloadAnim;       // looping anim for inserting a single round
var     name            SingleReloadHalfAnim;   // same as above, but when there are one or more rounds in the chamber

var     name            StripperReloadAnim; // stripper clip reload animation

var     name            PostReloadAnim;     // one-off anim when reloading ends

var     name            FullReloadAnim;     // full reload animation (takes precedence!)

var     int             NumRoundsToLoad;    // how many rounds to be loaded to fill the weapon

var     bool            bShouldSkipBolt;

var     bool            bCanUseUnfiredRounds;

// TODO: for refactoring this, when we try to do a reload,
// check if the magazine is empty enough for a full stripper clip to be
// reloaded. if so, do the full stripper clip (N times if need be, unless cancelled!)
// if we can't fit a whole new stripper clip in, we go to *single* reload mode.
// when we do that, we essentially consume a whole clip to break down into singles
// and keep track of the number of singles. if at the end of a reload, we have
// enough singles to make a new clip, consolidate the singles into a clip.
replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerSetInterruptReload;
}

// Modified to work the bolt when fire is pressed, if weapon is waiting to bolt
simulated function Fire(float F)
{
    if (!bShouldSkipBolt && bWaitingToBolt && !IsBusy())
    {
        WorkBolt();
    }
    else
    {
        super.Fire(F);
    }
}

// New function to work the bolt
simulated function WorkBolt()
{
    if (bWaitingToBolt && AmmoAmount(0) > 0 && !FireMode[1].bIsFiring && !FireMode[1].IsInState('MeleeAttacking'))
    {
        GotoState('WorkingBolt');

        if (Role < ROLE_Authority)
        {
            ServerWorkBolt();
        }
    }
}

// Client-to-server function to work the bolt
function ServerWorkBolt()
{
    WorkBolt();
}

// State where the bolt is being worked
simulated state WorkingBolt extends WeaponBusy
{
    simulated function bool ShouldUseFreeAim()
    {
        return global.ShouldUseFreeAim();
    }

    simulated function bool WeaponAllowSprint()
    {
        return false;
    }

    simulated function bool CanStartCrawlMoving()
    {
        return false;
    }

    simulated function AnimEnd(int Channel)
    {
        local name  Anim;
        local float Frame, Rate;

        if (InstigatorIsLocallyControlled())
        {
            GetAnimParams(0, Anim, Frame, Rate);

            if (Anim == BoltIronAnim || Anim == BoltHipAnim)
            {
                bWaitingToBolt = false;
            }
        }

        super.AnimEnd(Channel);

        GotoState('Idle');
    }

    simulated function BeginState()
    {
        if (bUsingSights)
        {
            if (bPlayerFOVZooms && InstigatorIsLocallyControlled())
            {
                PlayerViewZoom(false);
            }

            PlayAnimAndSetTimer(BoltIronAnim, 1.0, 0.1);
        }
        else
        {
            PlayAnimAndSetTimer(BoltHipAnim, 1.0, 0.1);
        }

        if (Role == ROLE_Authority && ROPawn(Instigator) != none)
        {
            ROPawn(Instigator).HandleBoltAction(); // play the animation on the pawn
        }
    }

    simulated function EndState()
    {
        if (bUsingSights && bPlayerFOVZooms && InstigatorIsLocallyControlled())
        {
            PlayerViewZoom(true);
        }

        bWaitingToBolt = false;
        FireMode[0].NextFireTime = Level.TimeSeconds - 0.1; // ready to fire fire now
    }
}

// Called by the weapon fire code to send the weapon to the post firing state
simulated function PostFire()
{
    GotoState('PostFiring');
}

// State where the weapon has just been fired
simulated state PostFiring
{
    simulated function bool ReadyToFire(int Mode)
    {
        return false;
    }

    simulated function Timer()
    {
        if (!InstigatorIsHumanControlled())
        {
            if (AmmoAmount(0) > 0)
            {
                GotoState('WorkingBolt');
            }
            else
            {
               GotoState('Reloading');
            }
        }
        else
        {
            GotoState('Idle');
        }
    }

    simulated function BeginState()
    {
        bWaitingToBolt = true;

        if (bUsingSights && DHProjectileFire(FireMode[0]) != none)
        {
            SetTimer(GetAnimDuration(DHProjectileFire(FireMode[0]).FireIronAnim, 1.0), false);
        }
        else
        {
            SetTimer(GetAnimDuration(FireMode[0].FireAnim, 1.0), false);
        }
    }
}

// Modified so bots don't go straight to the reloading state on bolt actions
simulated function OutOfAmmo()
{
    super(ROWeapon).OutOfAmmo();
}

simulated function int GetStripperClipSize()
{
    return 5;   // TODO: get this from the ammo class??
}

// Modified to update number of individual spare rounds
// As weapon doesn't used mags, the existing replicated CurrentMagCount is used to represent the total no. of individual spare rounds
// This is calculated by adding up the rounds in each dummy 'mag' (just a data grouping of individual spare rounds)
// This is primarily used by net clients to display the no. of spare rounds carried, as clients don't have PrimaryAmmoArray data
function UpdateResupplyStatus(bool bCurrentWeapon)
{
    local DHPawn P;
    local int    NumSpareRounds, DummyMagCount, i;

    if (bCurrentWeapon)
    {
        for (i = 1; i < PrimaryAmmoArray.Length; ++i)
        {
            NumSpareRounds += PrimaryAmmoArray[i];
        }

        CurrentMagCount = byte(NumSpareRounds);
    }

    P = DHPawn(Instigator);

    if (P != none)
    {
        DummyMagCount = Max(0, PrimaryAmmoArray.Length - 1); // what CurrentMagCount would normally be, used below to set bWeaponNeedsResupply

        P.bWeaponNeedsResupply = bCanBeResupplied && bCurrentWeapon && DummyMagCount < (MaxNumPrimaryMags - 1) && (TeamIndex == 2 || TeamIndex == P.GetTeamNum());
        P.bWeaponNeedsReload = false;
    }
}

// Modified to prevent reloading if weapon is already reloading or has maximum ammo
simulated function bool AllowReload()
{
    return ReloadState == RS_None && !AmmoMaxed(0) && !IsFiring() && !IsBusy() && CurrentMagCount > 0 && GetRoundsToLoad() > 0;
}

// Modified to allow reloading of individual rounds
function ServerRequestReload()
{
    local byte ReloadAmount;

    if (AllowReload())
    {
        ReloadAmount = GetRoundsToLoad();

        if (Level.NetMode == NM_DedicatedServer)
        {
            NumRoundsToLoad = ReloadAmount;
            GotoState('Reloading');
        }

        ClientDoReload(ReloadAmount);
    }
    else
    {
        ClientCancelReload();
    }
}

// Modified to update (on the client) the number of rounds to be reloaded
simulated function ClientDoReload(optional byte NumRounds)
{
    NumRoundsToLoad = NumRounds;

    super.ClientDoReload(NumRounds);
}

// Out of state this does nothing & should never be called anyway - it is only effective in state Reloading
function ServerSetInterruptReload()
{
}

simulated function PostPreReload() {}
simulated function PostFullReloadEnd() {}
simulated function PostLoop() {}

// Modified to handle substantially different one round at a time reload system
simulated state Reloading
{
    // Modified to allow interruption of reload by pressing fire
    simulated function Fire(float F)
    {
        if (ReloadState != RS_PostReload)
        {
            bInterruptReload = true;
            ServerSetInterruptReload();
        }
    }

    // New replicated client-to-server function to set bInterruptReload on server
    function ServerSetInterruptReload()
    {
        bInterruptReload = true;
    }

    simulated function PostPreReload()
    {
        // Give back the unfired round that was in the chamber.
        if (Role == ROLE_Authority)
        {
            if (!bWaitingToBolt && bCanUseUnfiredRounds)
            {
                GiveBackAmmo(1);
            }
        }

        if (NumRoundsToLoad >= GetStripperClipSize() && HasAnim(StripperReloadAnim))
        {
            ReloadState = RS_ReloadLoopedStripper;

            if (Role == ROLE_Authority)
            {
                SetStripperReloadTimer();
            }

            PlayStripperReload();
        }
        else
        {
            ReloadState = RS_ReloadLooped;

            if (Role == ROLE_Authority)
            {
                SetSingleReloadTimer();
            }

            PlaySingleReload();
        }
    }

    simulated function PostFullReloadEnd()
    {
        if (Role == ROLE_Authority)
        {
            PerformReload(GetMaxLoadedRounds());

            if (ROPawn(Instigator) != none)
            {
                ROPawn(Instigator).StopReload();
            }
        }

        NumRoundsToLoad = 0;
    }

    simulated function PostLoop()
    {
        if (Role == ROLE_Authority)
        {
            // Based on state we just finished animating, give appropriate ammo.
            if (ReloadState == RS_ReloadLoopedStripper)
            {
                PerformReload(GetStripperClipSize());
            }
            else if (ReloadState == RS_ReloadLooped)
            {
                PerformReload();
            }
        }

        // Process reload that has just taken place.
        if (ReloadState == RS_ReloadLoopedStripper)
        {
            NumRoundsToLoad -= GetStripperClipSize();
        }
        else if (ReloadState == RS_ReloadLooped)
        {
            NumRoundsToLoad--;
        }

        // Check if end of reloading has been reached.
        if (NumRoundsToLoad <= 0 || bInterruptReload)
        {
            if (ROPawn(Instigator) != none)
            {
                ROPawn(Instigator).StopReload();
            }

            ReloadState = RS_PostReload;
            PlayPostReload();

            return;
        }

        // Decide next reload.
        if (NumRoundsToLoad >= GetStripperClipSize() && HasAnim(StripperReloadAnim))
        {
            ReloadState = RS_ReloadLoopedStripper;

            if (Role == ROLE_Authority)
            {
                SetStripperReloadTimer();
            }

            PlayStripperReload();
        }
        else
        {
            ReloadState = RS_ReloadLooped;

            if (Role == ROLE_Authority)
            {
                SetSingleReloadTimer();
            }

            PlaySingleReload();
        }
    }

    // Modified to progress through reload stages, playing appropriate anims
    simulated function AnimEnd(int Channel)
    {
        local name  Anim;
        local float Frame, Rate;

        if (InstigatorIsLocallyControlled())
        {
            GetAnimParams(0, Anim, Frame, Rate);

            // Just finished playing pre-reload anim so now load 1st round
            if (Anim == PreReloadAnim || Anim == PreReloadHalfAnim || Anim == PreReloadEmptyAnim)
            {
                PostPreReload();
                return;
            }
            else if (Anim == FullReloadAnim)
            {
                PostFullReloadEnd();

                GotoState('Idle');
            }
            // Just finished playing a single round reload anim
            else if (Anim == SingleReloadAnim || Anim == SingleReloadHalfAnim || Anim == StripperReloadAnim)
            {
                PostLoop();
                return;
            }
            else if (Anim == PostReloadAnim)
            {
                GotoState('Idle');
            }
        }
    }

    // Modified to progress through reload stages
    simulated function Timer()
    {
        if (Role != ROLE_Authority || InstigatorIsLocallyControlled())
        {
            return;
        }

        // Just finished pre-reload anim so now load 1st round
        if (ReloadState == RS_PreReload)
        {
            PostPreReload();
        }
        // Just finished loading some ammo
        else if (ReloadState == RS_ReloadLooped || ReloadState == RS_ReloadLoopedStripper)
        {
            PostLoop();
        }
        else if (ReloadState == RS_FullReload)
        {
            PostFullReloadEnd();
            GotoState('Idle');
        }
        // Just finished post-reload or full-reload anim so we're finished
        else if (ReloadState == RS_PostReload)
        {
            GotoState('Idle');
        }
    }

    simulated function BeginState()
    {
        if (ReloadState == RS_None)
        {
            if (NumRoundsToLoad >= GetStripperClipSize() && HasAnim(FullReloadAnim))
            {
                // Give back the unfired round in the chamber.
                if (!bWaitingToBolt && bCanUseUnfiredRounds)
                {
                    GiveBackAmmo(1);
                }

                if (Role == ROLE_Authority && ROPawn(Instigator) != none)
                {
                    ROPawn(Instigator).HandleStandardReload();
                }

                ReloadState = RS_FullReload;
                PlayFullReload();
            }
            else
            {
                if (Role == ROLE_Authority && ROPawn(Instigator) != none)
                {
                    ROPawn(Instigator).StartReload();
                }

                ReloadState = RS_PreReload;
                PlayPreReload();
            }
        }
    }

    simulated function EndState()
    {
        if (ReloadState == RS_PostReload || ReloadState == RS_FullReload)
        {
            NumRoundsToLoad = 0;
            bWaitingToBolt = false;
            ReloadState = RS_None;
            bInterruptReload = false;
        }
    }
}

function SetSingleReloadTimer()
{
    SetTimer(GetAnimDuration(GetSingleReloadAnim(), 1.0), false);
}

function SetStripperReloadTimer()
{
    if (HasAnim(StripperReloadAnim))
    {
        SetTimer(GetAnimDuration(StripperReloadAnim, 1.0), false);
    }
}

simulated function PlaySingleReload()
{
    if (InstigatorIsLocallyControlled())
    {
        PlayAnim(GetSingleReloadAnim(), 1.0);
    }
}

simulated function PlayStripperReload()
{
    if (InstigatorIsLocallyControlled() && HasAnim(StripperReloadAnim))
    {
       PlayAnim(StripperReloadAnim, 1.0);
    }
}

simulated function PlayPreReload()
{
    if (InstigatorIsLocallyControlled())
    {
        PlayAnim(GetPreReloadAnim(), 1.0, FastTweenTime);
    }

    if (Role == ROLE_Authority)
    {
        SetTimer(GetAnimDuration(GetPreReloadAnim(), 1.0), false);
    }
}

simulated function name GetPreReloadAnim()
{
    if (AmmoAmount(0) == 0 && HasAnim(PreReloadEmptyAnim))
    {
        return PreReloadEmptyAnim;
    }
    else if (AmmoAmount(0) > 0 && HasAnim(PreReloadHalfAnim))
    {
        return PreReloadHalfAnim;
    }
    else
    {
        return PreReloadAnim;
    }
}

simulated function name GetSingleReloadAnim()
{
    if (GetMaxLoadedRounds() != NumRoundsToLoad && HasAnim(SingleReloadHalfAnim))
    {
        return SingleReloadHalfAnim;
    }

    return SingleReloadAnim;
}

simulated function PlayFullReload()
{
    local float Duration;

    Duration = GetAnimDuration(FullReloadAnim, 1.0);

    SetTimer(GetAnimDuration(FullReloadAnim, 1.0), false);

    if (InstigatorIsLocallyControlled() && HasAnim(FullReloadAnim))
    {
        PlayAnim(FullReloadAnim, 1.0);
    }
}

// New function to play PostReloadAnim & set a timer for when it ends (without adding FastTweenTime to timer)
simulated function PlayPostReload()
{
    if (Role == ROLE_Authority)
    {
        SetTimer(GetAnimDuration(PostReloadAnim, 1.0), false);
    }

    if (InstigatorIsLocallyControlled() && HasAnim(PostReloadAnim))
    {
        PlayAnim(PostReloadAnim, 1.0);
    }
}

simulated function int GetMaxLoadedRounds()
{
    return AmmoClass[0].default.InitialAmount;
}

// New function to calculate the number of rounds to be loaded to fill the weapon
simulated function byte GetRoundsToLoad()
{
    local int  CurrentLoadedRounds, MaxLoadedRounds;
    local byte AmountNeeded;

    if (CurrentMagCount == 0)
    {
        return 0;
    }

    CurrentLoadedRounds = AmmoAmount(0) - int(!bShouldSkipBolt && !bWaitingToBolt);

    //ensure we haven't dipped below 0
    CurrentLoadedRounds = Max(0,CurrentLoadedRounds);

    MaxLoadedRounds = GetMaxLoadedRounds();
    AmountNeeded = MaxLoadedRounds - CurrentLoadedRounds;

    return Min(AmountNeeded, CurrentMagCount);
}

// Modified to load one round each time
// 'Mags' for this weapon aren't really mags, they are just dummy mags that act as data groupings of individual spare rounds
// Each dummy mag contains the max no. of rounds that can be loaded into the weapon
// Mag zero represents the weapon's currently loaded rounds (so CurrentMagIndex is not cycled as usual & always remains zero)
// When reloading, individual rounds are stripped one at a time from mag 1 & loaded into the weapon
// When mag 1 is empty it is deleted (removed from PrimaryAmmoArray) so the next mag becomes mag 1 & that is used for any further loading
// It's done this way to work with existing mag-based functionality, while allowing one at a time loading up to a max no. limited by the dummy mag size
function PerformReload(optional int Count)
{
    local int Loaded, Withdraw; // How many rounds have been loaded in so far.

    if (CurrentMagCount < 1 || PrimaryAmmoArray.Length <= 1)
    {
        return;
    }

    // Ensure we attempt to reload at least one.
    Count = Max(1, Count);

    while (Loaded < Count)
    {
        // Check if there is a first mag to deduct from
        if (PrimaryAmmoArray.Length == 1)
        {
            break;
        }

        Withdraw = 0;

        // take all the rounds in the mag as possible.
        Withdraw = Min(Count - Loaded, PrimaryAmmoArray[1]);
        PrimaryAmmoArray[1] -= Withdraw;
        Loaded += Withdraw;

        // If mag is now empty, delete it.
        if (PrimaryAmmoArray[1] == 0)
        {
            PrimaryAmmoArray.Remove(0, 1);
        }
    }

    AddAmmo(Loaded, 0);

    // Update the weapon attachment ammo status
    if (AmmoAmount(0) > 0 && ROWeaponAttachment(ThirdPersonActor) != none)
    {
        ROWeaponAttachment(ThirdPersonActor).bOutOfAmmo = false;
    }

    UpdateResupplyStatus(true);
}

// Takes ammo out of gun and returns it to inventory. Used when reloading gun with round chambered.
function GiveBackAmmo(int Count)
{
    if (CurrentMagCount < 1 || PrimaryAmmoArray.Length <= 1)
    {
        return;
    }

    PrimaryAmmoArray[1] += Count;
    AmmoCharge[0] -= Count;

    // Update the weapon attachment ammo status
    if (AmmoAmount(0) <= 0 && ROWeaponAttachment(ThirdPersonActor) != none)
    {
        ROWeaponAttachment(ThirdPersonActor).bOutOfAmmo = true;
    }

    UpdateResupplyStatus(true);
}

simulated function bool ShouldDrawPortal()
{
    local name SeqName;
    local float AnimFrame, AnimRate;

    if (!super.ShouldDrawPortal())
    {
        return false;
    }

    GetAnimParams(0, SeqName, AnimFrame, AnimRate);

    return SeqName != PostFireIronIdleAnim;
}

defaultproperties
{
    SwayModifyFactor=0.6

    FreeAimRotationSpeed=6.0
    BobModifyFactor=0.6
    ZoomOutTime=0.4


    IronIdleAnim="Iron_idle"
    PostFireIdleAnim="Idle"
    PostFireIronIdleAnim="Iron_idlerest"
    BoltHipAnim="bolt"
    BoltIronAnim="iron_boltrest"
    MagEmptyReloadAnims(0)="Reload"

    AIRating=0.4
    CurrentRating=0.4
    bSniping=true

    bCanUseUnfiredRounds=true
}
