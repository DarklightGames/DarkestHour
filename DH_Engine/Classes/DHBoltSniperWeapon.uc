//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBoltSniperWeapon extends DHSniperWeapon
    abstract;

enum EReloadState
{
    RS_None,
    RS_PreReload,
    RS_ReloadStripper,
    RS_ReloadLooped,
    RS_PostReload,
};

var     EReloadState    ReloadState;        // weapon's current reloading state (none means not reloading)
var     bool            bInterruptReload;   // set when one-by-one reload is stopped by player part way through, by pressing fire button
var     name            PreReloadAnim;      // one-off anim when starting to reload
var     name            SingleReloadAnim;   // looping anim for inserting a single round
var     name            StripperReloadAnim; // stripper clip reload animation
var     name            PostReloadAnim;     // one-off anim when reloading ends
var     byte            NumRoundsToLoad;    // how many rounds to be loaded to fill the weapon
var     byte            NumSingles;         // how many singles we have in reserve to be reloaded.

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
    return ReloadState == RS_None && !AmmoMaxed(0) && !IsFiring() && !IsBusy() && CurrentMagCount > 0;
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

    // Modified to progress through reload stages, playing appropriate anims
    simulated function AnimEnd(int Channel)
    {
        local name  Anim;
        local float Frame, Rate;

        if (InstigatorIsLocallyControlled())
        {
            GetAnimParams(0, Anim, Frame, Rate);

            // Just finished playing pre-reload anim so now load 1st round
            if (Anim == PreReloadAnim)
            {
                SetTimer(0.0, false);

                if (CanLoadStripperClip())
                {
                    ReloadState = RS_ReloadStripper;
                }
                else
                {
                    ReloadState = RS_ReloadLooped;
                }

                PlayReload();

                return;
            }
            // Just finished playing a single round reload anim
            else if (Anim == SingleReloadAnim || Anim == StripperReloadAnim)
            {
                // Either loaded last round or player stopped the reload (by pressing fire), so now play post-reload anim
                if (NumRoundsToLoad == 0 || bInterruptReload)
                {
                    SetTimer(0.0, false);
                    bInterruptReload = false;
                    ReloadState = RS_PostReload;
                    PlayPostReload();

                    if (Role == ROLE_Authority)
                    {
                        if (ROPawn(Instigator) != none)
                        {
                            ROPawn(Instigator).StopReload();
                        }

                        PerformReload();
                    }
                }
                // Otherwise start loading the next round
                else
                {
                    PlayReload();

                    if (Role == ROLE_Authority)
                    {
                        PerformReload();
                    }
                }

                return;
            }
        }
    }

    // Modified to progress through reload stages
    simulated function Timer()
    {
        // Just finished pre-reload anim so now load 1st round
        if (ReloadState == RS_PreReload)
        {
            ReloadState = RS_ReloadLooped;
            PlayReload();

            if (Role == ROLE_Authority)
            {
                NumRoundsToLoad--;
            }
        }
        // Just finished loading a single round
        else if (ReloadState == RS_ReloadLooped)
        {
            // Either loaded last round or player stopped the reload (by pressing fire), so now play post-reload anim
            if (NumRoundsToLoad == 0 || bInterruptReload)
            {
                if (Role == ROLE_Authority)
                {
                    if (ROPawn(Instigator) != none)
                    {
                        ROPawn(Instigator).StopReload();
                    }

                    PerformReload();
                }

                bInterruptReload = false;
                ReloadState = RS_PostReload;
                PlayPostReload();
            }
            // Otherwise start loading the next round
            else
            {
                PlayReload();

                if (Role == ROLE_Authority)
                {
                    PerformReload();
                    NumRoundsToLoad--;
                }
            }
        }
        // Just finished post-reload anim so we're finished
        else if (ReloadState == RS_PostReload)
        {
            GotoState('Idle');
        }
    }

    simulated function BeginState()
    {
        if (Role == ROLE_Authority && ROPawn(Instigator) != none)
        {
            ROPawn(Instigator).StartReload();
        }

        if (ReloadState == RS_None)
        {
            ReloadState = RS_PreReload;
            PlayPreReload();
        }
    }

    simulated function EndState()
    {
        if (ReloadState == RS_PostReload)
        {
            NumRoundsToLoad = 0;
            bWaitingToBolt = false;
            ReloadState = RS_None;
        }
    }
}

// New function to play the pre-reload animation
simulated function PlayPreReload()
{
    PlayAnimAndSetTimer(PreReloadAnim, 1.0);
}

simulated function bool CanLoadStripperClip()
{
    return HasAnim(StripperReloadAnim) && NumRoundsToLoad >= GetStripperClipSize();
}

// Modified to use single reload animation (without adding FastTweenTime to timer), & to decrement the number of rounds to load
simulated function PlayReload()
{
    SetTimer(GetAnimDuration(SingleReloadAnim, 1.0), false);

    if (InstigatorIsLocallyControlled())
    {
        if (CanLoadStripperClip())
        {
            NumRoundsToLoad -= GetStripperClipSize();
            PlayAnim(StripperReloadAnim, 1.0);
        }
        else
        {
            NumRoundsToLoad -= 1;
            PlayAnim(SingleReloadAnim, 1.0);
        }
    }
}

// New function to play PostReloadAnim & set a timer for when it ends (without adding FastTweenTime to timer)
simulated function PlayPostReload()
{
    SetTimer(GetAnimDuration(PostReloadAnim, 1.0), false);

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
function byte GetRoundsToLoad()
{
    local int  CurrentLoadedRounds, MaxLoadedRounds;
    local byte AmountNeeded;

    if (PrimaryAmmoArray.Length == 0)
    {
        return 0;
    }

    CurrentLoadedRounds = AmmoAmount(0);
    MaxLoadedRounds = GetMaxLoadedRounds();
    AmountNeeded = MaxLoadedRounds - CurrentLoadedRounds;

    return Min(AmountNeeded, CurrentMagCount);
}

/* HOLY SHIT THIS IS AWFUL, FIX IT! */

// Modified to load one round each time
// 'Mags' for this weapon aren't really mags, they are just dummy mags that act as data groupings of individual spare rounds
// Each dummy mag contains the max no. of rounds that can be loaded into the weapon
// Mag zero represents the weapon's currently loaded rounds (so CurrentMagIndex is not cycled as usual & always remains zero)
// When reloading, individual rounds are stripped one at a time from mag 1 & loaded into the weapon
// When mag 1 is empty it is deleted (removed from PrimaryAmmoArray) so the next mag becomes mag 1 & that is used for any further loading
// It's done this way to work with existing mag-based functionality, while allowing one at a time loading up to a max no. limited by the dummy mag size
function PerformReload(optional int Count)
{
    local int i;

    if (CurrentMagCount < 1)
    {
        return;
    }

    // Loop through the spare mags
    for (i = 1; i < PrimaryAmmoArray.Length; ++i)
    {
        // If mag is empty, discard it & check the next one (shouldn't happen, but a fail-safe)
        if (PrimaryAmmoArray[i] <= 0)
        {
            PrimaryAmmoArray.Remove(i, 1);
            --i; // need to adjust for array member being removed, otherwise we'll skip the next mag
            continue;
        }

        // If mag has 1 round, discard the mag as it will be empty after loading
        if (PrimaryAmmoArray[i] == 1)
        {
            PrimaryAmmoArray.Remove(i, 1);
        }
        // Otherwise reduce the next mag by 1 round
        else
        {
            --PrimaryAmmoArray[1];
        }

        // Load 1 round & stop checking
        AddAmmo(1, 0);
        break;
    }

    // Update the weapon attachment ammo status
    if (AmmoAmount(0) > 0 && ROWeaponAttachment(ThirdPersonActor) != none)
    {
        ROWeaponAttachment(ThirdPersonActor).bOutOfAmmo = false;
    }

    UpdateResupplyStatus(true);
}

// Modified to skip over the Super in DHSniperWeapon that is only relevant to semi-auto & auto weapons
simulated function AnimEnd(int channel)
{
    super(DHProjectileWeapon).AnimEnd(Channel);
}

// Modified to skip over the Super in DHSniperWeapon that is only relevant to semi-auto & auto weapons
simulated event StopFire(int Mode)
{
    super(DHProjectileWeapon).StopFire(Mode);
}

defaultproperties
{
    bPlusOneLoading=false
    BobModifyFactor=0.8
    ZoomOutTime=0.4

    PostFireIdleAnim="Idle"
    PostFireIronIdleAnim="Scope_Idle"
    BoltHipAnim="bolt_scope"
    BoltIronAnim="scope_bolt"
    PreReloadAnim="Single_Open"
    SingleReloadAnim="Single_insert"
    PostReloadAnim="Single_Close"
    MagEmptyReloadAnims(0)=none
    MagPartialReloadAnims(0)=none
}
