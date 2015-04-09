//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Teleporter extends Teleporter
    placeable;

var()   int     SpawnProtectionTime;
var()   bool    bResetStamina;

// Set timer for spawn protection
simulated function bool Accept(actor Incoming, Actor Source)
{
    local rotator newRot, oldRot;
    local float mag;
    local vector oldDir;
    local Controller P;

    if (Incoming == none)
    {
        return false;
    }

    // Move the actor here.
    Disable('Touch');

    newRot = Incoming.Rotation;

    if (bChangesYaw)
    {
        oldRot = Incoming.Rotation;
        newRot.Yaw = Rotation.Yaw;
    }

    if (Pawn(Incoming) != none)
    {
        //tell enemies about teleport
        if (Role == ROLE_Authority)
        {
            for (P = Level.ControllerList; P != none; P = P.NextController)
            {
                if (P.Enemy == Incoming)
                {
                    P.LineOfSightTo(Incoming);
                }
            }
        }

        if (!Pawn(Incoming).SetLocation(Location))
        {
            Log(self @ "Teleport failed for" @ Incoming);

            return false;
        }

        if (Role == ROLE_Authority || (Level.TimeSeconds - LastFired) > 0.5)
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
        {
            Incoming.SetRotation(newRot);
        }
    }

    Enable('Touch');

    if (bChangesVelocity)
    {
        Incoming.Velocity = TargetVelocity;
    }
    else
    {
        if (bChangesYaw)
        {
            if (Incoming.Physics == PHYS_Walking)
            {
                OldRot.Pitch = 0;
            }

            oldDir = vector(OldRot);
            mag = Incoming.Velocity dot oldDir;
            Incoming.Velocity = Incoming.Velocity - mag * oldDir + mag * vector(Incoming.Rotation);
        }
        if (bReversesX)
        {
            Incoming.Velocity.X *= -1.0;
        }

        if (bReversesY)
        {
            Incoming.Velocity.Y *= -1.0;
        }

        if (bReversesZ)
        {
            Incoming.Velocity.Z *= -1.0;
        }
    }

    DHPawn(Incoming).TeleSpawnProtEnds = Level.TimeSeconds + SpawnProtectionTime;

    if (Role == ROLE_Authority && bResetStamina && DHPawn(Incoming) != none)
    {
        DHPawn(Incoming).Stamina = DHPawn(Incoming).default.Stamina;
        DHPawn(Incoming).ClientForceStaminaUpdate(DHPawn(Incoming).default.Stamina);
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

