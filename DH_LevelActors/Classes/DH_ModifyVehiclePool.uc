//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ModifyVehiclePool extends DH_ModifyActors;

var()   name                                VehiclePoolTag;
var()   DHObjective.EVehiclePoolOperation   Operation;
var()   int                                 Value;

event Trigger(Actor Other, Pawn EventInstigator)
{
    local DHSpawnManager    SM;
    local int               i;
    local DarkestHourGame   G;

    G = DarkestHourGame(Level.Game);

    if (G == none || G.SpawnManager == none)
    {
        return;
    }

    SM = G.SpawnManager;

    // This is duplicated from the objective actions. This sucks, but for backwards
    // compatibility, we cannot move the types to the spawn manager.
    switch (Operation)
    {
        case EVPO_Enable:
            SM.SetVehiclePoolIsActiveByTag(VehiclePoolTag, true);
            break;
        case EVPO_Disable:
            SM.SetVehiclePoolIsActiveByTag(VehiclePoolTag, false);
            break;
        case EVPO_Toggle:
            SM.ToggleVehiclePoolIsActiveByTag(VehiclePoolTag);
            break;
        case EVPO_MaxSpawnsAdd:
            SM.AddVehiclePoolMaxSpawnsByTag(VehiclePoolTag, Value);
            break;
        case EVPO_MaxSpawnsSet:
            SM.SetVehiclePoolMaxSpawnsByTag(VehiclePoolTag, Value);
            break;
        case EVPO_MaxActiveAdd:
            SM.AddVehiclePoolMaxActiveByTag(VehiclePoolTag, Value);
            break;
        case EVPO_MaxActiveSet:
            SM.SetVehiclePoolMaxActiveByTag(VehiclePoolTag, Value);
            break;
    }
}
