//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Teleporter extends Teleporter
    placeable;

var()   int     SpawnProtectionTime;   // How long in seconds to protect a player who's just teleported
var()   bool    bResetStamina;

// Set timer for spawn protection
simulated function bool Accept(actor Incoming, Actor Source)
{
    local rotator newRot, oldRot;
    local float mag;
    local vector oldDir;
    local Controller P;

    if (Incoming == none)
        return false;

    // Move the actor here.
    Disable('Touch');
    newRot = Incoming.Rotation;
    if (bChangesYaw)
    {
        oldRot = Incoming.Rotation;
        newRot.Yaw = Rotation.Yaw;
        /*if (Source != none)
            newRot.Yaw += (32768 + Incoming.Rotation.Yaw - Source.Rotation.Yaw);*/
    }

    if (Pawn(Incoming) != none)
    {
        //tell enemies about teleport
        if (Role == ROLE_Authority)
            For (P=Level.ControllerList; P!=none; P=P.NextController)
                if (P.Enemy == Incoming)
                    P.LineOfSightTo(Incoming);

        if (!Pawn(Incoming).SetLocation(Location))
        {
            log(self$" Teleport failed for "$Incoming);
            return false;
        }
        if ((Role == ROLE_Authority)
            || (Level.TimeSeconds - LastFired > 0.5))
        {
            newRot.Roll = 0;
            Pawn(Incoming).SetRotation(newRot);
            Pawn(Incoming).SetViewRotation(newRot);
            Pawn(Incoming).ClientSetRotation(newRot);
            LastFired = Level.TimeSeconds;
        }
        if (Pawn(Incoming).Controller != none)
        {
            Pawn(Incoming).Controller.MoveTimer = -1.0;
            Pawn(Incoming).Anchor = self;
            Pawn(Incoming).SetMoveTarget(self);
        }
        Incoming.PlayTeleportEffect(false, true);
    }
    else
    {
        if (!Incoming.SetLocation(Location))
        {
            Enable('Touch');
            return false;
        }
        if (bChangesYaw)
            Incoming.SetRotation(newRot);
    }
    Enable('Touch');

    if (bChangesVelocity)
        Incoming.Velocity = TargetVelocity;
    else
    {
        if (bChangesYaw)
        {
            if (Incoming.Physics == PHYS_Walking)
                OldRot.Pitch = 0;
            oldDir = vector(OldRot);
            mag = Incoming.Velocity Dot oldDir;
            Incoming.Velocity = Incoming.Velocity - mag * oldDir + mag * vector(Incoming.Rotation);
        }
        if (bReversesX)
            Incoming.Velocity.X *= -1.0;
        if (bReversesY)
            Incoming.Velocity.Y *= -1.0;
        if (bReversesZ)
            Incoming.Velocity.Z *= -1.0;
    }

    DH_Pawn(Incoming).TeleSpawnProtEnds = Level.TimeSeconds + SpawnProtectionTime;

    // I'm tired of having no stamina...get it? :D -Basnett
    if (Role == ROLE_Authority&& bResetStamina && DH_Pawn(Incoming) != none)
    {
        DH_Pawn(Incoming).Stamina = DH_Pawn(Incoming).default.Stamina;
        DH_Pawn(Incoming).ClientForceStaminaUpdate(DH_Pawn(Incoming).default.Stamina);
    }

    return true;
}

function Reset()
{
    bEnabled = default.bEnabled;
}

defaultproperties
{
     bResetStamina=true
}
