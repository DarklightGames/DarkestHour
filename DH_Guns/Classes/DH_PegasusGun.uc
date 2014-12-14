//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PegasusGun extends DH_Flak88Gun;

function bool TryToDrive(Pawn P)
{
    local int x;

//  Deny entry to bots - cos on Benouville Bridge map - the Brit bots all go for gun & ignore bridge
    if (!p.IsHumanControlled())
            {
        bTeamLocked=true;
                    DenyEntry(P, 3);
        return false;
    }
    if (p.IsHumanControlled())
            {
        bTeamLocked = false;
    }

    //don't allow vehicle to be stolen when somebody is in a turret
    if (!bTeamLocked && P.GetTeamNum() != VehicleTeam)
    {
        for (x = 0; x < WeaponPawns.length; x++)
            if (WeaponPawns[x].Driver != none)
            {
                DenyEntry(P, 2);
                return false;
            }
    }

    //Removed "P.bIsCrouched" to allow players to connect while crouched.
    if (bNonHumanControl || (P.Controller == none) || (Driver != none) || (P.DrivenVehicle != none) || !P.Controller.bIsPlayer
         || P.IsA('Vehicle') || Health <= 0)
        return false;

    if (!Level.Game.CanEnterVehicle(self, P))
        return false;

    // Check vehicle Locking....
    if (bTeamLocked && (P.GetTeamNum() != VehicleTeam))
    {
        DenyEntry(P, 1);
        return false;
    }
//    // Tank Crew is not allowed to use the gun.   - DH- oh yes they are!
//  else if (!bMustBeTankCommander && ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew)
//  {
//      DenyEntry(P, 0);
//     return false;
//  }
    else
    {
        //At this point we know the pawn is not a tanker, so let's see if they can use the gun
        if (bEnterringUnlocks && bTeamLocked)
            bTeamLocked = false;

        //The gun is manned and it is a human - deny entry
        if (WeaponPawns[0].Driver != none && WeaponPawns[0].IsHumanControlled())
        {
            DenyEntry(P, 3);
            return false;
        }
        //The gun is manned by a bot and the requesting pawn is human controlled - kick the bot off the gun
        else if (WeaponPawns[0].Driver != none && !WeaponPawns[0].IsHumanControlled() && p.IsHumanControlled())
        {
            WeaponPawns[0].KDriverLeave(true);

            KDriverEnter(P);
            return true;
        }
        //The gun is manned by a bot and a bot is trying to use it, deny entry.
        else if (WeaponPawns[0].Driver != none && !WeaponPawns[0].IsHumanControlled() && !p.IsHumanControlled())
        {
            DenyEntry(P, 3);
            return false;
        }
        //The gun is unmanned, so let who ever is there first can use it.
        else
        {
            KDriverEnter(P);
            return true;
        }
    }
}

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_PegasusGunPawn')
    HealthMax=101.000000
    Health=101
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.000000
        KInertiaTensor(3)=3.000000
        KInertiaTensor(5)=3.000000
        KLinearDamping=0.050000
        KAngularDamping=0.050000
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.000000
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=50.000000
        KImpactThreshold=700.000000
    End Object
    KParams=KarmaParamsRBFull'DH_Guns.DH_PegasusGun.KParams0'
}
