//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHDestroyableSM extends RODestroyableStaticMesh
    abstract placeable;

// This class exists because we need it in DH_Engine as classes in DH_Engine access these class variables
// It is abstract because we have DH_DestroyableSM (notice the _) which is in DH_LevelActors and already used by maps
// We can't just move DH_DestroyableSM to DH_Engine, as it would break levels that use it, hence why we have DHDestroyableSM

enum ETeamCanDamage
{
    TD_Both,
    TD_Axis,
    TD_Allies,
};

var()   ETeamCanDamage  TeamCanDamage;                     // option for leveller to specify that only one team can damage the mesh
var     Controller      DelayedDamageInstigatorController; // projectiles set this when they explode so we have reference to player responsible for damage, even if his pawn dies

var()   bool            bInitiallyActive; // leveller can set DSM to be inactive at start of round, so it can be activated later by an event
var     bool            bActive;          // option for DSM to only be treated as 'active' at certain map stages or conditions, so it can't be destroyed at other times

replication
{
    // Variables the server will replicate to all clients
    // bAcive is only replicated so it can be used by the HUD to avoid displaying an inactive DSM as a destroyable target on the map
    // So we only replicate it if this mesh has been set up with the bShowOnSituationMap option enabled
    reliable if (bNetDirty && bShowOnSituationMap && Role == ROLE_Authority)
        bActive;
}

// Modified to activate or deactivate the DSM based on the leveller's setting of bInitiallyActive
// Called whenever a new round starts, including the ResetGame option (so we don't need to do this in PostBeginPlay)
function Reset()
{
    SetActiveStatus(bInitiallyActive);

    super.Reset();

    DelayedDamageInstigatorController = none;
}

// New function to set whether or not this DSM is active & can be destroyed
function SetActiveStatus(bool bNewActiveStatus)
{
    bActive = bNewActiveStatus;
}

// Modified to allow allow toggling between destroyed & normal states
function Trigger(Actor Other, Pawn EventInstigator)
{
    if (EventInstigator != none)
    {
        MakeNoise(1.0);
    }

    if (bDamaged)
    {
        GotoState('Working');
    }
    else
    {
        DestroyDSM(EventInstigator);
    }
}

// New function used by DH_ModifyDSMStatus actor to
function DestroyDSM(Pawn EventInstigator)
{
    Health = 0;
    TriggerEvent(DestroyedEvent, self, EventInstigator);
    BroadcastCriticalMessage(EventInstigator);
    BreakApart(Location);
}

// Modified to prevent damage by a certain team if the mesh has been set up that way
// Specifically requires damage to be caused by the opposing team, to prevent exploits by player switching to spectator or exiting the server
auto state Working
{
    function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
    {
        if (!bActive)
        {
            return;
        }

        if (TeamCanDamage == TD_Axis && GetDamagingTeamIndex(InstigatedBy) != AXIS_TEAM_INDEX)
        {
            return;
        }

        if (TeamCanDamage == TD_Allies && GetDamagingTeamIndex(InstigatedBy) != ALLIES_TEAM_INDEX)
        {
            return;
        }

        if (!ShouldTakeDamage(DamageType))
        {
            return;
        }

        if (InstigatedBy != none)
        {
            MakeNoise(1.0);
        }

        Health -= Damage;

        if (Health <= 0)
        {
            TriggerEvent(DestroyedEvent, self, InstigatedBy);
            BroadcastCriticalMessage(InstigatedBy);
            BreakApart(HitLocation, Momentum);
        }
    }
}

// New helper function to get the team index of the player responsible for trying to damage the static mesh
// If we don't have an InstigatedBy pawn, e.g. pawn has been killed after throwing an explosive, we use our DelayedDamageInstigatorController to get a team index
// Note that thrown explosives (i.e. satchels & grenades) have built in protection to avoid damage caused by player who switches teams after throwing the explosive
function int GetDamagingTeamIndex(Pawn InstigatedBy)
{
    if (InstigatedBy != none)
    {
        return InstigatedBy.GetTeamNum();
    }

    if (DelayedDamageInstigatorController != none)
    {
        return DelayedDamageInstigatorController.GetTeamNum();
    }

    return 255;
}

// Implemented so projectiles set this when they explode so we have reference to player responsible for damage, even if his pawn dies
// Then TakeDamage() can prevent damage by a certain team if the mesh has been set up that way
function SetDelayedDamageInstigatorController(Controller C)
{
    DelayedDamageInstigatorController = C;
}

defaultproperties
{
    bInitiallyActive=true
    bActive=true
}
