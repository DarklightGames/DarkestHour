//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHAdminMenuMutator extends Mutator;

#exec AUDIO IMPORT FILE="..\DH_AdminMenuMutator\Sounds\Submarine-Klaxon.wav" NAME="Klaxon"

const   BOTH_TEAMS_INDEX = 99;             // an index no. representing that an action is to be performed on both teams (adding to RO's ALLIES_TEAM_INDEX & AXIS_TEAM_INDEX)
const   ERROR_INDEX = -1;                  // an index number representing an error return, e.g. could not find a match
const   NULL_VECTOR = vect(0.0, 0.0, 0.0); // just saves having lots of NullVector local variables

struct  Minefield
{
var     float   MVKillTime;
var     float   MVWarnInterval;
};

var DHAdminMenu_Replicator  Replicator;             // a 'helper' actor that gets replicated to all clients to add menu interactions & replicate variables for client use
var     ROTeamGame          ROTG;                   // reference to the ROTeamGame actor (which is RO's GameInfo class) - used by several functions
var     AccessControl       AccessControl;          // reference to the AccessControl class actor, which handles kicks & bans - used by the kick with warning function
var     PlayerController    Admin;                  // temporarily saves the admin performing the current action, which avoids passing it through lots & lots of functions
var     array<Minefield>    SavedMinefields;        // an array of minefields that records their original properties, so they can be re-enabled later
var     int                 ParaDropHeight;         // the Z co-ordinate used for the starting height in all paradrop options
var     float               MapScale;               // size/scale of current map, used to calculate grid locations for paradrops
var     vector              MapCenter;              // centre location of map, also used to calculate grid locations for paradrops

// Settings that are replicated to clients via the Replicator
var     bool                bRealismMutPresent;     // flags whether the realism match mutator is present on the server
var     bool                bMinesDisabled;         // flags that all minefields have been disabled
var     bool                bHideCapProgress;       // flags that capture progress bars have been disabled
var     bool                bHidePlayerIcon;        // flags that the player icon on the map has been disabled

// Config variables that can be set in the server's DarkestHour.ini file
// (some default values are set here but can be overridden in the config file)
var     config bool         bParaDropPlayerAllowed; // unless set to true, paradropping a single player will be disabled (replicated to clients via the Replicator)
var     config bool         bShowRealismMenu;       // unless set to true, the realism/testing menu & its options will be disabled (replicated to clients via the Replicator)
var     config bool         bBypassAdminLogin;      // allows the option of disabling admin checks, e.g. if used on a test server
var     config bool         bDebug;                 // if true, various events will be logged
var     config sound        WarningSound;           // the sound to play when sending an admin warning message to a player (default is a klaxon)

////////////////////////////  INITIALIZATION FUNCTIONS  ////////////////////////////////////////////////////////////////////////////////

// Waits until the GameInfo has completed its BeginPlay events & then sets the initial variables we need here
// Note that we use this instead of a BeginPlay event as it allows time to make sure other mutators have been spawned & for the ROTG.MineVolumes array to be populated
function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    if (Level.Game.bScriptInitialized) // this means that the GameInfo actor has completed its BeginPlay events
    {
        SetInitialVariables();
        Disable('Tick');
    }
}

// Sets some key variables that are used by various functions & also by the Replicator (which is spawned here)
function SetInitialVariables()
{
    local Mutator Mut;

    // Get a reference to the ROTeamGame actor, which is used by many functions
    ROTG = ROTeamGame(Level.Game);

    if (ROTG == none)
    {
        Log("DHAdminMenu ERROR: an ROTeamGame actor wasn't found on the server - this is a serious problem & many functions will not work");
    }

    // Get a reference to the AccessControl actor, which is used by the 'kick player with reason' option
    AccessControl = Level.Game.AccessControl;

    if (AccessControl == none && Level.NetMode != NM_Standalone)
    {
        Log("DHAdminMenu ERROR: an AccessControl actor wasn't found on the server - it won't be possible to kick a player with a message");
    }

    // If we're in single player or DH debug mode (i.e. the development branch), always enable the extra menu options for convenience
    if (Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode())
    {
        bParaDropPlayerAllowed = true;
        bShowRealismMenu = true;
    }

    // If the paradrop or realism/testing menu options are enabled, we set the necessary paradrop variables for this map
    if (bParaDropPlayerAllowed || bShowRealismMenu)
    {
        SetParaDropVariables();
    }

    if (bShowRealismMenu)
    {
        // Create an array saving the starting properties of all minefield, so if they are disabled & re-enabled we can re-set them
        SaveMinefields();

        // Look for the realism match mutator - if it's there we just set a flag
        // Check GroupName as there are different realism mutator versions & may have different class names, but GroupName should be constant
        for (Mut = Level.Game.BaseMutator; Mut != none; Mut = Mut.NextMutator)
        {
            if (Mut.GroupName ~= "RealismMatch")
            {
                bRealismMutPresent = true;
                break;
            }
        }
    }

    // Spawns the 'helper' actor (Replicator) that will get replicated to all clients
    Replicator = Spawn(class'DH_AdminMenuMutator.DHAdminMenu_Replicator', self);
}

// Builds a SavedMinefields array so we can restore minefield properties if they are disabled then re-enabled
function SaveMinefields()
{
    local int i;

    if (ROTG != none && ROTG.MineVolumes.Length > 0)
    {
        SavedMinefields.Length = ROTG.MineVolumes.Length;

        for (i = 0; i < ROTG.MineVolumes.Length; ++i)
        {
            SavedMinefields[i].MVKillTime = ROTG.MineVolumes[i].KillTime;
            SavedMinefields[i].MVWarnInterval = ROTG.MineVolumes[i].WarnInterval;

            if (bDebug)
            {
                Log("DHAdminMenu: building array SavedMinefields[" $ i $ "]: kill time =" @ SavedMinefields[i].MVKillTime $ ", warning interval =" @ SavedMinefields[i].MVWarnInterval);
            }
        }
    }
}

////////////////////////////  THE MIGHTY MUTATE FUNCTION !  ///////////////////////////////////////////////////////////

// This processes a mutate string passed as a console command from the local menus - it is where everything in the mutator is initiated
function Mutate(string MutateString, PlayerController Sender)
{
    local array<string> Words;
    local string        MutateOption;

    // Splits the mutate arguments into an array of separate words (note the menus will have replaced spaces in names with non-breaking spaces, which stops those names being split up)
    Split(MutateString, " ", Words);

    if (Words.Length > 1) // mutators are chained & if a mutate call is made from another mutator it will probably only have 1 passed argument & so will skip everything here
    {
        Admin = Sender; // saves the sending player's PlayerController as class variable 'Admin', which avoids having to pass it through lots & lots of functions
        MutateOption = Words[1];

        if (Words.Length < 6) // makes sure Words array has at least 6 members, just to avoid errors in paradrop options trying to pass Words[4] & Words[5] that may not exist
        {
            Words.Length = 6;
        }

        // Private message to one player
        if (MutateOption ~= "PrivateMessageToPlayer")
        {
            PrivateMessageToPlayer(Words[2], PutMessageTogether(Words, 3), false); // Words[2] is PlayerName, Words[3+] is admin's message, false flags it's not an admin warning
        }
        // Admin warning message to one player
        else if (MutateOption ~= "WarningMessageToPlayer")
        {
            PrivateMessageToPlayer(Words[2], PutMessageTogether(Words, 3), true); // Words[2] is PlayerName, Words[3+] is admin's warning, true flags it is an admin warning
        }
        // Kick with message giving reason
        else if (MutateOption ~= "KickPlayerWithReason")
        {
            KickPlayerWithReason(Words[2], PutMessageTogether(Words, 3)); // Words[2] is PlayerName, Words[3+] may be admin's message
        }
        // Kill a player
        else if (MutateOption ~= "KillPlayer")
        {
            KillPlayer(Words[2]); // Words[2] is PlayerName
        }
        else if (MutateOption ~= "GagPlayer")
        {
            GagPlayer(Words[2]); // Words[2] is PlayerName
        }
        // Switch a player (including a spectator) to a different role or team
        else if (MutateOption ~= "SwitchPlayer")
        {
            SwitchPlayer(Words[2], Words[3], Words[4], Words[5]); // Words[2] is PlayerName, Words[3] is TeamName, Words[4] is RoleName, Words[5] is RoleIndex
        }
        // Rename a player
        else if (MutateOption ~= "RenamePlayer")
        {
            RenamePlayer(Words[2], Words[3]); // Words[2] is OldPlayerName, Words[3] is NewPlayerName
        }
        // Set game password
        else if (MutateOption ~= "SetGamePassword")
        {
            SetGamePassword(Words[2]);
        }
        // Toggle lock all weapons (for setup phase)
        else if (MutateOption ~= "ToggleLockWeapons")
        {
            ToggleIsInSetupPhase();
        }
        // Drop single player at an objective or at a grid location or at their current location
        else if (MutateOption ~= "ParaDropPlayer")
        {
            if (Words[3] ~= "AtGridRef")
            {
                Words[4] = ConcatenateGridRef(Words, 4);
            }

            ParaDropPlayer(Words[2], Words[3], Words[4], Words[5]); // Words[2] is PlayerName, Words[3] is TypeOfDropTarget, Words[4+] may be GridRef, Words[4] may be ObjName, Words[5] may be ObjNum
        }

        // REALISM MATCH / TEST MENU ONLY:
        else if (bShowRealismMenu)
        {
            // Enable realism match
            if (MutateOption ~= "EnableRealismMatch")
            {
                EnableRealismMatch(); // calls real enable match functionality from realism mutator, but adds auto admin login/out, plus 'must be admin' message if not logged in
            }
            // Disable realism match
            else if (MutateOption ~= "DisableRealismMatch")
            {
                DisableRealismMatch(); // calls real disable match functionality from realism mutator, but adds auto admin login/out, plus 'must be admin' message if not logged in
            }
            // Force realism match live
            else if (MutateOption ~= "ForceRealismMatchLive")
            {
                ForceRealismMatchLive(); // calls real match live functionality from realism mutator, but adds auto admin login/out, plus 'must be admin' message if not logged in
            }

            // Drop either all players or all of one team, either at an objective or at a grid location
            else if (MutateOption ~= "ParaDropAll")
            {
                if (Words[3] ~= "AtGridRef")
                {
                    Words[4] = ConcatenateGridRef(Words, 4);
                }

                ParaDropAll(Words[2], Words[3], Words[4], Words[5]); // Words[2] is TeamName, Words[3] is TypeOfDropTarget, Words[4+] may be GridRef, Words[4] may be ObjName, Words[5] may be ObjNum
            }
            // Disable or enable minefields
            else if (MutateOption ~= "DisableMinefields")
            {
                DisableMinefields();
            }
            else if (MutateOption ~= "EnableMinefields")
            {
                EnableMinefields();
            }
            // Toggle cap progress bars
            else if (MutateOption ~= "ToggleCapProgress")
            {
                ToggleCapProgress();
            }
            // Toggle player icon on map
            else if (MutateOption ~= "TogglePlayerIcon")
            {
                TogglePlayerIcon();
            }
            // Kill all players
            else if (MutateOption ~= "KillAllPlayers")
            {
                KillAllPlayers();
            }
            // Set new game speed
            else if (MutateOption ~= "SetGameSpeed")
            {
                SetGameSpeed(float(Words[2]));
            }
            // Set new round time remaining
            else if (MutateOption ~= "SetRoundMinutesRemaining")
            {
                SetRoundMinutesRemaining(float(Words[2]));
            }
            // Toggle server's setting for bAdminCanPause (the game)
            else if (MutateOption ~= "ToggleAdminCanPauseGame")
            {
                ToggleAdminCanPauseGame();
            }
            // Destroy actor that is currently in player's sights (e.g. destroy immobile tank blocking spawn exit)
            else if (MutateOption ~= "DestroyActorInSights")
            {
                DestroyActorInSights();
            }
            // Set new maximum squad size foe either team
            else if (MutateOption ~= "ChangeAlliesSquadSize")
            {
                ChangeAlliesSquadSize(int(Words[2]));
            }
            else if (MutateOption ~= "ChangeAxisSquadSize")
            {
                ChangeAxisSquadSize(int(Words[2]));
            }
            else if (MutateOption ~= "DisableRallyPoints")
            {
                SetRallyPoints(false);
            }
            else if (MutateOption ~= "EnableRallyPoints")
            {
                SetRallyPoints(true);
            }
        }

        // If a menu passed "logout" as the 1st Mutate string word it means the menu logged us in as an admin, so we now log out after the selected task is completed
        if (Words[0] ~= "logout")
        {
            Sender.AdminLogout();
        }

        Admin = none; // re-set for next time
    }

    super.Mutate(MutateString, Sender);
}

////////////////////////////  PLAYER MENU OPTIONS CALLED BY MUTATE FUNCTION  ///////////////////////////////////////////////////////////

function PrivateMessageToPlayer(string PlayerName, string Message, optional bool bIsAdminWarning)
{
    local PlayerController Receiver;

    if (!IsLoggedInAsAdmin())
    {
        return;
    }

    if (Message == "")
    {
        ErrorMessageToSelf(12); // no message specified

        return;
    }

    Receiver = PlayerController(FindControllerFromName(PlayerName));

    if (Receiver != none && Replicator != none)
    {
        // Crop a very long message to avoid trying to send huge strings that take up bandwidth & may not work if too long
        Message = Left(Message, 350);

        // Use the Replicator to display the message to the target player
        Replicator.ServerPrivateMessage(Receiver, Admin, Message, bIsAdminWarning);

        if (bIsAdminWarning)
        {
            Log("DHAdminMenu: admin warning from" @ GetAdminName() @ "to '" $ PlayerName $ "':" @ Message);
        }
        else
        {
            Log("DHAdminMenu: private message from" @ GetAdminName() @ "to '" $ PlayerName $ "':" @ Message);
        }
    }
}

function ToggleIsInSetupPhase()
{
    local DHGameReplicationInfo DHGRI;

    if (!IsLoggedInAsAdmin())
    {
        return;
    }

    DHGRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    // Get role info
    if (DHGRI != none)
    {
        DHGRI.bIsInSetupPhase = !DHGRI.bIsInSetupPhase;
    }
}

function KickPlayerWithReason(string PlayerName, optional string KickMessage)
{
    local PlayerController PlayerToKick;
    local string           OriginalDefaultKickReason;

    if (!IsLoggedInAsAdmin())
    {
        return;
    }

    if (AccessControl != none)
    {
        PlayerToKick = PlayerController(FindControllerFromName(PlayerName));

        if (PlayerToKick != none)
        {
            // If no message specified we will use the default "none specified" message
            if (KickMessage == "")
            {
                KickMessage = AccessControl.DefaultKickReason;
            }

            // Set the custom message
            OriginalDefaultKickReason = AccessControl.DefaultKickReason; // moved this here from PostBeginPlay just in case another mutator changes AC.DefaultKickReason during play
            AccessControl.DefaultKickReason = KickMessage;

            // Kick the player
            if (AccessControl.KickPlayer(PlayerToKick)) // returns true if kick was successful so we use that to message & log accordingly
            {
                Log("DHAdminMenu: admin" @ GetAdminName() @ "kicked" @ PlayerName @ "with message:" @ KickMessage);
            }
            else
            {
                ErrorMessageToSelf(13, PlayerName); // kick failed (may be because target is a logged in admin)
                Log("DHAdminMenu: admin" @ GetAdminName() @ "tried to kick" @ PlayerName @ "but kick failed (message:" @ KickMessage $ ")");
            }

            // Restore original DefaultKickReason for next person who gets kicked (who may not have a message specified)
            AccessControl.DefaultKickReason = OriginalDefaultKickReason;
        }
    }
    else
    {
        ErrorMessageToSelf(14); // cannot kick, no AccessControl actor on server
        Log("DHAdminMenu ERROR: AccessControl actor not found when admin" @ GetAdminName() @ "tried to kick" @ PlayerName @ "(message:" @ KickMessage $ ")");
    }
}

function KillPlayer(string PlayerName)
{
    local Controller PlayerToKill;

    if (!IsLoggedInAsAdmin())
    {
        return;
    }

    PlayerToKill = FindControllerFromName(PlayerName, true);

    if (PlayerToKill != none)
    {
        KillThisPlayer(PlayerToKill, PlayerName);
    }
}

function GagPlayer(string PlayerName)
{
    local Controller PlayerToGag;

    if (!IsLoggedInAsAdmin())
    {
        return;
    }

    PlayerToGag = FindControllerFromName(PlayerName, false);

    if (PlayerToGag != none)
    {
        GagThisPlayer(PlayerToGag, PlayerName);
    }
}


function SwitchPlayer(string PlayerName, string TeamName, string RoleName, string RoleIndexString)
{
    local DHGameReplicationInfo DHGRI;
    local DHPlayer              PlayerToSwitch;
    local DHRoleInfo            RoleInfo;
    local int                   TeamIndex, RoleIndex, i;
    local bool                  bOriginalPlayersBalanceTeams;

    if (!IsLoggedInAsAdmin())
    {
        return;
    }

    // Get player (Controller) & new team & role index
    PlayerToSwitch = DHPlayer(FindControllerFromName(PlayerName));
    TeamIndex = GetTeamIndexFromName(TeamName);
    RoleIndex = RemoveBracketsFromIndex(RoleIndexString);

    if (PlayerToSwitch == none || (TeamIndex != ALLIES_TEAM_INDEX && TeamIndex != AXIS_TEAM_INDEX) || RoleIndex < 0)
    {
        return; // invalid player, team or role selection
    }

    DHGRI = DHGameReplicationInfo(PlayerToSwitch.GameReplicationInfo);

    // Get role info
    if (DHGRI != none)
    {
        if (TeamIndex == ALLIES_TEAM_INDEX)
        {
            if (RoleIndex < arraycount(DHGRI.DHAlliesRoles) && DHGRI.DHAlliesRoles[RoleIndex] != none)
            {
                RoleInfo = DHGRI.DHAlliesRoles[RoleIndex];
            }
        }
        else if (RoleIndex < arraycount(DHGRI.DHAxisRoles) && DHGRI.DHAxisRoles[RoleIndex] != none)
        {
            RoleInfo = DHGRI.DHAxisRoles[RoleIndex];
        }
    }

    if (RoleInfo == none)
    {
        ErrorMessageToSelf(19, RoleName @ "(" $ TeamName @ "role index no." $ RoleIndex $ ")"); // can't find that role

        return;
    }

    // If we aren't switching teams, set team index to 'passive' 255 & make sure player is actually being switched to a different role
    if (PlayerToSwitch.GetTeamNum() == TeamIndex)
    {
        TeamIndex = 255; // if we leave this as a real team index, it makes ServerSetPlayerInfo() reset the spawn position index & stops player spawning

        if (PlayerToSwitch.CurrentRole == RoleIndex)
        {
            ErrorMessageToSelf(10, PlayerName); // player is already in that role

            return;
        }
    }

    // Passed all checks, so kill the player & then handle the switch
    KillThisPlayer(PlayerToSwitch);

    // If switching teams, save current team balance setting & then disable team balance so it can't block us from switching the player
    if (TeamIndex != 255 && ROTG != none)
    {
        bOriginalPlayersBalanceTeams = ROTG.bPlayersBalanceTeams;
        ROTG.bPlayersBalanceTeams = false;
    }

    // Now change team and/or role
    PlayerToSwitch.ServerSetPlayerInfo(TeamIndex, RoleIndex, 0, 0, PlayerToSwitch.SpawnPointIndex, -1);

    // If switched teams, now restore restore original team balance setting & find an active spawn point for the new team (just find 1st active spawn for team)
    if (TeamIndex != 255 && ROTG != none)
    {
        ROTG.bPlayersBalanceTeams = bOriginalPlayersBalanceTeams;

        for (i = 0; i < arraycount(DHGRI.SpawnPoints); ++i)
        {
            if (DHGRI.GetSpawnPoint(i) != none && DHGRI.GetSpawnPoint(i).CanSpawnWithParameters(DHGRI, TeamIndex, RoleIndex, -1, -1))
            {
                PlayerToSwitch.ServerSetPlayerInfo(255, 255, 0, 0, i , -1);
                break;
            }
        }
    }

    if (Admin != none)
    {
        NotifyPlayer(3, PlayerToSwitch); // admin switched your role/team
        Log("DHAdminMenu: admin" @ GetAdminName() @ "switched player '" $ PlayerName $ "' to" @ Locs(TeamName) @ Locs(RoleName));
    }
}

function RenamePlayer(string OldPlayerName, string NewPlayerName)
{
    local Controller PlayerToRename;

    if (!IsLoggedInAsAdmin())
    {
        return;
    }

    PlayerToRename = FindControllerFromName(OldPlayerName, true);

    if (PlayerToRename != none)
    {
        ROTG.ChangeName(PlayerToRename, NewPlayerName, true);

        // Use the Replicator to change the player name on his client
        if (PlayerToRename.IsA('PlayerController') && Replicator != none)
        {
            Replicator.ServerRenamePlayer(PlayerToRename, NewPlayerName);
        }

        if (Admin != none)
        {
            NotifyPlayer(1, PlayerToRename); // admin changed your game name
            Log("DHAdminMenu: admin" @ GetAdminName() @ "renamed player '" $ OldPlayerName $ "' to '" @ NewPlayerName $ "'");
        }
    }
}

function SetGamePassword(string NewPassword)
{
    if (!IsLoggedInAsAdmin())
    {
        return;
    }

    if (AccessControl != none)
    {
        AccessControl.SetGamePassword(NewPassword);
        AccessControl.SaveConfig();
    }
}

function ParaDropPlayer(string PlayerName, string TypeOfDropTarget, optional string DropTarget, optional string ObjectiveIndex)
{
    local Controller PlayerToDrop;
    local vector     ParaDropVector;

    if (!IsLoggedInAsAdmin())
    {
        return;
    }

    if (!bParaDropPlayerAllowed)
    {
        ErrorMessageToSelf(2); // paradropping a player not allowed on server

        return;
    }

    PlayerToDrop = FindControllerFromName(PlayerName, true);

    if (PlayerToDrop != none)
    {
        if (TypeOfDropTarget ~= "AtObjective")
        {
            ParaDropVector = GetObjectiveDropLocation(DropTarget, ObjectiveIndex);
        }
        else if (TypeOfDropTarget ~= "AtGridRef")
        {
            ParaDropVector = GetGridDropLocation(DropTarget);
        }
        else if (TypeOfDropTarget ~= "AtCurrentLocation")
        {
            ParaDropVector = GetCurrentDropLocation(PlayerToDrop);
        }
        else
        {
            ErrorMessageToSelf(21); // no valid type of drop target specified

            return;
        }

        if (ParaDropVector != NULL_VECTOR)
        {
            ParaDropThisPlayer(PlayerToDrop, ParaDropVector, PlayerName);
        }
    }
}

// Generic function that performs a player kill - called as required from other functions that are called directly from Mutate (e.g. KillPlayer, SwitchPlayer & KillAllPLayers)
function KillThisPlayer(Controller PlayerToKill, optional string PlayerName)
{
    local Pawn  PlayerPawn;
    local float OriginalFriendlyFireScale;

    if (PlayerToKill == none)
    {
        return;
    }

    PlayerPawn = PlayerToKill.Pawn;

    if (PlayerPawn != none && (PlayerPawn.IsA('ROPawn') || PlayerPawn.IsA('Vehicle')))
    {
        OriginalFriendlyFireScale = ROTG.FriendlyFireScale; // save the current friendly fire setting
        ROTG.FriendlyFireScale = 1.0; // turn on friendly fire

        // Kill the player (includes custom damage type that shows "was re-spawned by admin" message in the console)
        if (PlayerPawn.IsA('ROPawn'))
        {
            PlayerPawn.TakeDamage(9999, none, NULL_VECTOR, NULL_VECTOR, class'DH_AdminMenuMutator.DHAdminMenu_DamageType');
        }
        else
        {
            Vehicle(PlayerPawn).Driver.TakeDamage(9999, none, NULL_VECTOR, NULL_VECTOR, class'DH_AdminMenuMutator.DHAdminMenu_DamageType');
        }

        ROTG.FriendlyFireScale = OriginalFriendlyFireScale; // now restore the original friendly fire setting
        PlayerToKill.PlayerReplicationInfo.Score += 1; // compensate for the -1 score reduction they will get for having 'suicided', so their score remains the same

        // If a specific player name was passed (only used in KillPlayer) then give notification message to killed player & log the event
        if (PlayerName != "" && Admin != none)
        {
            NotifyPlayer(2, PlayerToKill); // admin killed you
            Log("DHAdminMenu: admin" @ GetAdminName() @ "killed player '" $ PlayerName $ "'");
        }
    }
    else if (PlayerName != "")
    {
        ErrorMessageToSelf(9, PlayerName); // player is not active
    }
}

function GagThisPlayer(Controller PlayerToGag, optional string PlayerName)
{
    if (DHPlayer(PlayerToGag) == none)
    {
        return;
    }

    if (!DHPlayer(PlayerToGag).bIsGagged)
    {
        DHPlayer(PlayerToGag).bIsGagged = true;

        if (PlayerName != "" && Admin != none)
        {
            NotifyPlayer(17, PlayerToGag); // admin gagged you
            Log("DHAdminMenu: admin" @ GetAdminName() @ "gagged player '" $ PlayerName $ "'");
        }
    }
    else if (PlayerName != "")
    {
        ErrorMessageToSelf(9, PlayerName); // player is not active
    }
}

////////////////////////////  REALISM/TESTING MENU OPTIONS CALLED BY MUTATE FUNCTION  ///////////////////////////////////////////////////////////

function EnableRealismMatch()
{
    if (!bRealismMutPresent || !IsLoggedInAsAdmin(true)) // the 'true' is bEnforceAdminLogin, so does not allow bBypassAdminLogin (won't work on realism mutator)
    {
        return;
    }

    Log("DHAdminMenu: admin" @ GetAdminName() @ "enabled a realism match");
    Level.Game.BaseMutator.Mutate("EnableMatch", Admin); // calls the real enable match functionality from the realism match mutator
}

function DisableRealismMatch()
{
    if (!bRealismMutPresent || !IsLoggedInAsAdmin(true)) // the 'true' is bEnforceAdminLogin
    {
        return;
    }

    Log("DHAdminMenu: admin" @ GetAdminName() @ "disabled a realism match");
    Level.Game.BaseMutator.Mutate("DisableMatch", Admin); // calls the real disable match functionality from the realism match mutator
}

function ForceRealismMatchLive()
{
    if (!bRealismMutPresent || !IsLoggedInAsAdmin(true)) // the 'true' is bEnforceAdminLogin
    {
        return;
    }

    Log("DHAdminMenu: admin" @ GetAdminName() @ "forced realism match live");
    Level.Game.BaseMutator.Mutate("MatchLive", Admin); // calls the real match live functionality from the realism match mutator
}

function ParaDropAll(string TeamName, string TypeOfDropTarget, string DropTarget, optional string ObjectiveIndex)
{
    local int        SelectedTeamIndex;
    local vector     ParaDropVector;
    local Controller C;

    if (!bShowRealismMenu || !IsLoggedInAsAdmin())
    {
        return;
    }

    SelectedTeamIndex = GetTeamIndexFromName(TeamName);

    if (SelectedTeamIndex != ERROR_INDEX)
    {
        if (TypeOfDropTarget ~= "AtObjective")
        {
            ParaDropVector = GetObjectiveDropLocation(DropTarget, ObjectiveIndex);
        }
        else if (TypeOfDropTarget ~= "AtGridRef")
        {
            ParaDropVector = GetGridDropLocation(DropTarget);
        }
        else
        {
            ErrorMessageToSelf(21); // no valid type of drop target specified

            return;
        }

        if (ParaDropVector != NULL_VECTOR)
        {
            for (C = Level.ControllerList; C != none; C = C.NextController)
            {
                if (C.GetTeamNum() == SelectedTeamIndex || SelectedTeamIndex == BOTH_TEAMS_INDEX)
                {
                    ParaDropThisPlayer(C, ParaDropVector);
                }
            }

            Log("DHAdminMenu: admin" @ GetAdminName() @ "paradropped all" @ TeamName);
        }
    }
}

function DisableMinefields() // doesn't actually disable them, but it makes their warn & kill times so long that they appear disabled
{
    local int i;

    if (!bShowRealismMenu || !IsLoggedInAsAdmin())
    {
        return;
    }

    if (ROTG.MineVolumes.Length == 0)
    {
        ErrorMessageToSelf(15); // no minefields
    }
    else if (!bMinesDisabled)
    {
        bMinesDisabled = true;

        if (Replicator != none)
        {
            Replicator.bMinesDisabled = true; // also update the Replicator, which then replicates this to clients for use by the menu interactions
        }

        for (i = 0; i < ROTG.MineVolumes.Length; ++i)
        {
            ROTG.MineVolumes[i].KillTime = 9999.0;
            ROTG.MineVolumes[i].WarnInterval = 9999.0;

            if (bDebug)
            {
                Log("DHAdminMenu: MINES OFF: MineVolumes[" $ i $ "] =" @ ROTG.MineVolumes[i] $ ",kill time =" @ ROTG.MineVolumes[i].KillTime $ ", warning interval =" @ ROTG.MineVolumes[i].WarnInterval);
            }
        }

        BroadcastMessageToAll(5);
        Log("DHAdminMenu: admin" @ GetAdminName() @ "disabled all minefields");
    }
    else
    {
        ErrorMessageToSelf(16); // already disabled
    }
}

function EnableMinefields()
{
    local int i;

    if (!bShowRealismMenu || !IsLoggedInAsAdmin())
    {
        return;
    }

    if (ROTG.MineVolumes.Length == 0)
    {
        ErrorMessageToSelf(15); // no minefields
    }
    else if (bMinesDisabled)
    {
        bMinesDisabled = false;

        if (Replicator != none)
        {
            Replicator.bMinesDisabled = false; // also update the Replicator, which then replicates this to clients for use by the menu interactions
        }

        for (i = 0; i < ROTG.MineVolumes.Length; ++i)
        {
            ROTG.MineVolumes[i].KillTime = SavedMinefields[i].MVKillTime;
            ROTG.MineVolumes[i].WarnInterval = SavedMinefields[i].MVWarnInterval;

            if (bDebug)
            {
                Log("DHAdminMenu: MINES ON: MineVolumes[" $ i $ "] =" @ ROTG.MineVolumes[i] $ ",kill time =" @ ROTG.MineVolumes[i].KillTime $ ", warning interval =" @ ROTG.MineVolumes[i].WarnInterval);
            }
        }

        BroadcastMessageToAll(6);
        Log("DHAdminMenu: admin" @ GetAdminName() @ "re-enabled all minefields");
    }
    else
    {
        ErrorMessageToSelf(17); // already enabled
    }
}

function ToggleCapProgress()
{
    if (!bShowRealismMenu || !IsLoggedInAsAdmin() || Replicator == none)
    {
        return;
    }

    bHideCapProgress = !bHideCapProgress;

    if (bHideCapProgress)
    {
        BroadcastMessageToAll(7);
        Log("DHAdminMenu: admin" @ GetAdminName() @ "disabled capture progress indicators");
    }
    else
    {
        BroadcastMessageToAll(8);
        Log("DHAdminMenu: admin" @ GetAdminName() @ "re-enabled capture progress indicators");
    }

    Replicator.ServerToggleCapProgress(bHideCapProgress); // use the Replicator to toggle this for each player
}

function TogglePlayerIcon()
{
    if (!bShowRealismMenu || !IsLoggedInAsAdmin() || Replicator == none)
    {
        return;
    }

    bHidePlayerIcon = !bHidePlayerIcon;

    if (bHidePlayerIcon)
    {
        BroadcastMessageToAll(9);
        Log("DHAdminMenu: admin" @ GetAdminName() @ "disabled the player icon on the map");
    }
    else
    {
        BroadcastMessageToAll(10);
        Log("DHAdminMenu: admin" @ GetAdminName() @ "re-enabled the player icon on the map");
    }

    Replicator.ServerTogglePlayerIcon(bHidePlayerIcon); // use the Replicator to toggle this for each player
}

function KillAllPlayers()
{
    local Controller C;

    if (!bShowRealismMenu || !IsLoggedInAsAdmin())
    {
        return;
    }

    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        KillThisPlayer(C);
    }

    BroadcastMessageToAll(11);
    Log("DHAdminMenu: admin" @ GetAdminName() @ "killed all players");
}

function SetGameSpeed(float NewSpeed)
{
    if (!bShowRealismMenu || !IsLoggedInAsAdmin())
    {
        return;
    }

    if (NewSpeed >= 0.0)
    {
        NewSpeed = FClamp(NewSpeed, 0.1, 15.0);
        Level.Game.bAllowMPGameSpeed = true;
        Level.Game.SetGameSpeed(NewSpeed);
        Level.Game.bAllowMPGameSpeed = false;

        BroadcastMessageToAll(100 + (Level.Game.GameSpeed * 100)); // a trick of passing new game speed, as a % with 100 added so we know it isn't one of the normal numbered messages
        Log("DHAdminMenu: admin" @ GetAdminName() @ "changed game speed to" @ Level.Game.GameSpeed);
    }
}

function SetRoundMinutesRemaining(float NewMinutesRemaining)
{
    if (NewMinutesRemaining > 0.0 && DarkestHourGame(ROTG) != none)
    {
        DarkestHourGame(ROTG).ModifyRoundTime(int(NewMinutesRemaining * 60.0), 2);
        Log("DHAdminMenu: admin" @ GetAdminName() @ "set remaining round time to" @ class'ROEngine.ROHud'.static.GetTimeString(NewMinutesRemaining * 60.0));
    }
}

// bAdminCanPause setting gets reset (re-loaded from config file) when map changes, which is good, as there's no risk of leaving the server with an unwanted, changed config setting
function ToggleAdminCanPauseGame()
{
    ROTG.bAdminCanPause = !ROTG.bAdminCanPause;

    if (Admin != none)
    {
        if (ROTG.bAdminCanPause)
        {
            NotifyPlayer(13, Admin, true); // you toggled 'admin can pause' to true
        }
        else
        {
            NotifyPlayer(14, Admin, true); // you toggled 'admin can pause' to false
        }

        Log("DHAdminMenu: admin" @ GetAdminName() @ "toggled bAdminCanPause setting to" @ ROTG.bAdminCanPause);
    }
}

function DestroyActorInSights()
{
    local int    TraceDistance;
    local vector AimDirection, StartTrace, EndTrace, HitLocation, HitNormal;
    local Actor  HitActor;

    if (!bShowRealismMenu || !IsLoggedInAsAdmin())
    {
        return;
    }

    if (Admin.IsA('ROPlayer') && Admin.Pawn != none)
    {
        TraceDistance = ROPlayer(Admin).GetMaxViewDistance();
        AimDirection = vector(Admin.Pawn.GetViewRotation());
        StartTrace = Admin.Pawn.Location + Admin.Pawn.EyePosition();
        EndTrace = StartTrace + (AimDirection * TraceDistance);

        HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);

        if (!HitActor.IsA('ROPawn') && !HitActor.IsA('ROBulletWhipAttachment'))
        {
            if (HitActor.Destroy())
            {
                Log("DHAdminMenu: admin" @ GetAdminName() @ "used DestroyActorInSights to remove actor" @ HitActor);
            }
        }
    }
}

function ChangeAlliesSquadSize(int SquadSize)
{
    local DHPlayer PC;

    PC = DHPlayer(Admin);

    if (PC != none && PC.SquadReplicationInfo != none)
    {
        PC.SquadReplicationInfo.SetTeamSquadSize(ALLIES_TEAM_INDEX, SquadSize);
        BroadcastMessageToAll(15);
    }
}

function ChangeAxisSquadSize(int SquadSize)
{
    local DHPlayer PC;

    PC = DHPlayer(Admin);

    if (PC != none && PC.SquadReplicationInfo != none)
    {
        PC.SquadReplicationInfo.SetTeamSquadSize(AXIS_TEAM_INDEX, SquadSize);
        BroadcastMessageToAll(16);
    }
}

function SetRallyPoints(bool bEnabled)
{
    local DarkestHourGame DHG;
    local DHGameReplicationInfo DHGRI;
    local DHSquadReplicationInfo SRI;
    local bool bAlreadySet;

    if (!bShowRealismMenu || !IsLoggedInAsAdmin())
    {
        return;
    }

    DHG = DarkestHourGame(Level.Game);

    if (DHG == none)
    {
        return;
    }

    DHGRI = DHGameReplicationInfo(DHG.GameReplicationInfo);
    SRI = DHG.SquadReplicationInfo;

    if (DHGRI == none || SRI == none)
    {
        return;
    }

    if (DHGRI.GameType == none || !DHGRI.GameType.default.bAreRallyPointsEnabled)
    {
        ErrorMessageToSelf(25);
        return;
    }

    bAlreadySet = SRI.bAreRallyPointsEnabled == bEnabled;

    if (!bAlreadySet)
    {
        SRI.bAreRallyPointsEnabled = bEnabled;
    }

    if (bEnabled)
    {
        if (bAlreadySet)
        {
            ErrorMessageToSelf(27); // already enabled
            return;
        }

        BroadcastMessageToAll(19);
        Log("DHAdminMenu: admin" @ GetAdminName() @ "enabled rally point placement");
    }
    else
    {
        if (bAlreadySet)
        {
            ErrorMessageToSelf(26); // already disabled
            return;
        }

        BroadcastMessageToAll(18);
        Log("DHAdminMenu: admin" @ GetAdminName() @ "disabled rally point placement");
    }
}

////////////////////////////  GENERAL HELPER FUNCTIONS (messaging, true/false checks, find things, etc)  //////////////////////////////////////

function BroadcastMessageToAll(int MessageNumber)
{
    if (MessageNumber > 0 && Admin != none)
    {
        BroadcastLocalizedMessage(class'DH_AdminMenuMutator.DHAdminMenu_NotifyMessages', MessageNumber, Admin.PlayerReplicationInfo);
    }
}

function NotifyPlayer(byte MessageNumber, Controller Receiver, optional bool bNoAdminName)
{
    if (MessageNumber > 0 && Admin != none && Receiver.IsA('PlayerController'))
    {
        if (bNoAdminName)
        {
            PlayerController(Receiver).ReceiveLocalizedMessage(class'DH_AdminMenuMutator.DHAdminMenu_NotifyMessages', MessageNumber);
        }
        else
        {
            PlayerController(Receiver).ReceiveLocalizedMessage(class'DH_AdminMenuMutator.DHAdminMenu_NotifyMessages', MessageNumber, Admin.PlayerReplicationInfo);
        }
    }
}

function ErrorMessageToSelf(byte MessageNumber, optional string InsertedName)
{
    if (MessageNumber > 0 && Admin != none)
    {
        Admin.ClientMessage(class'DH_AdminMenuMutator.DHAdminMenu_ErrorMessages'.static.AssembleMessage(MessageNumber, InsertedName));
    }
}

// A check if the sending player is an admin - if not displays a message to say "you must be logged in as an admin ..."
function bool IsLoggedInAsAdmin(optional bool bEnforceAdminLogin)
{
    // Do an admin login check
    if (Admin != none && Admin.PlayerReplicationInfo != none && (Admin.PlayerReplicationInfo.bAdmin || Admin.PlayerReplicationInfo.bSilentAdmin))
    {
        return true;
    }

    // Otherwise, if bBypassAdminLogin has been set to true in the config file, we effectively bypass the usual admin check (e.g. for use on a test server)
    // (but this bypass will be overridden if this function call included the optional bEnforceAdminLogin = true)
    if (bBypassAdminLogin && !bEnforceAdminLogin)
    {
        return true;
    }

    // In single player an admin login is irrelevant, so just return true
    if (Level.NetMode == NM_Standalone)
    {
        return true;
    }

    ErrorMessageToSelf(1); // must be an admin

    return false;
}

// Returns admin's player name for use in logging
function string GetAdminName()
{
    if (Admin != none && Admin.PlayerReplicationInfo != none && Admin.PlayerReplicationInfo.PlayerName != "")
    {
        return "'" $ Admin.PlayerReplicationInfo.PlayerName $ "'";
    }

    return class'DH_AdminMenuMutator.DHAdminMenu_ErrorMessages'.static.AssembleMessage(10); // can't find admin's name (should never happen)
}

// Returns player's name (from their Controller) for use in messages & logging
function string GetPlayerName(Controller Player)
{
    if (Player != none && Player.PlayerReplicationInfo != none && Player.PlayerReplicationInfo.PlayerName != "")
    {
        return Player.PlayerReplicationInfo.PlayerName;
    }

    return class'DH_AdminMenuMutator.DHAdminMenu_ErrorMessages'.static.AssembleMessage(9); // can't find player's name (should never happen, but just in case)
}

// Takes an index number passed by a local menu as a string in brackets (just to add readability to an on-screen command), strips the brackets & converts to a integer
function int RemoveBracketsFromIndex(string IndexString)
{
    local int Index;

    // Special handling of a zero index because if invalid string is passed, cast to int will fail & return a misleading 0 - so menus pass a [0] index as [zero] to avoid this
    if (IndexString == "[zero]")
    {
        return 0;
    }

    IndexString = Repl(IndexString, "[", "");
    IndexString = Repl(IndexString, "]", "");

    Index = int(IndexString);

    if (Index == 0) // if Index is 0 it means the cast to int failed, so an invalid string must have been passed, i.e. string did not represent a number
    {
        return ERROR_INDEX;
    }

    return Index;
}

// Puts a message together from a passed array of words, starting from a specified point
function string PutMessageTogether(array<string> Words, byte StartIndex)
{
    local string Message;
    local int    i;

    if (Words.Length > StartIndex)
    {
        Message $= Words[StartIndex];

        if (Words.Length > (StartIndex + 1))
        {
            for (i = StartIndex + 1; i < Words.Length; ++i)
            {
                Message @= Words[i];
            }
        }
    }

    return Message;
}

// Finds the Controller for a given player name - includes a check for more than one player with the specified name & also an optional check for bots
function Controller FindControllerFromName(string PlayerName, optional bool bAllowActionOnBot)
{
    local Controller FoundPlayer, C;
    local string     CheckedPlayerName;

    if (PlayerName == "")
    {
        ErrorMessageToSelf(4); // no player name specified

        return none;
    }

    for (C = Level.ControllerList; C != none; C = C.NextController)
    {
        if (C.PlayerReplicationInfo != none)
        {
            // Replace any spaces in name with non-breaking spaces - needed to match against names passed from menu choices because those will have had the same treatment
            CheckedPlayerName = Repl(GetPlayerName(C)," "," ");

            if (CheckedPlayerName == PlayerName)
            {
                if (FoundPlayer != none) // if we have already saved a FoundPlayer we must have more than 1 player with that name, so we can't proceed
                {
                    ErrorMessageToSelf(6, PlayerName); // more than 1 player with that name, too risky to proceed

                    return none;
                }

                FoundPlayer = C;
                // we would typically break here as we've found our player, but we continue to search through all players in case we have more than one with this name
            }
        }
    }

    if (FoundPlayer == none)
    {
        ErrorMessageToSelf(5, PlayerName); // can't find player

        return none;
    }

    // if a bot has been selected & the function call hasn't allowed bots, we give an error message & return a blank
    if (FoundPlayer.IsA('ROBot') && !bAllowActionOnBot)
    {
        ErrorMessageToSelf(11); // can't do that to a bot

        return none;
    }

    return FoundPlayer;
}

// Convert a text team name to the relevant team index number
function int GetTeamIndexFromName(out string TeamName)
{
    switch (TeamName)
    {
        case "ToAllies":
            TeamName = "Allies"; // removes the "To" from TeamName & then 'falls through' to return same value as case "Allies"
        case "Allies":
            return ALLIES_TEAM_INDEX;

        case "ToAxis": // removes the "To" from TeamName & then 'falls through' to return same value as case "Axis"
            TeamName = "Axis";
        case "Axis":
            return AXIS_TEAM_INDEX;

        case "Players":
            return BOTH_TEAMS_INDEX;

        default:
            ErrorMessageToSelf(18); // no valid team specified
            return ERROR_INDEX;
    }
}

/////////////////////////////////////  PARADROP FUNCTIONS  /////////////////////////////////////////////////////////////////////////////////////////////

// Generic function that actually actions a player paradrop - called as required from other functions that are called directly from Mutate (e.g. ParaDropPlayer & ParaDropAll)
function ParaDropThisPlayer(Controller PlayerToDrop, vector ParaDropVector, optional string PlayerName)
{
    local Pawn PlayerPawn;

    if (PlayerToDrop == none || ParaDropVector == NULL_VECTOR)
    {
        return;
    }

    PlayerPawn = PlayerToDrop.Pawn;

    if (PlayerPawn != none && (PlayerPawn.IsA('DHPawn') || PlayerPawn.IsA('Vehicle')))
    {
        // If player is in a vehicle we switch PlayerPawn to the actual vehicle so we drop that
        if (PlayerPawn.IsA('Vehicle'))
        {
            if (PlayerPawn.IsA('VehicleWeaponPawn'))
            {
                PlayerPawn = PlayerPawn.GetVehicleBase();
            }

            PlayerPawn.SetPhysics(PHYS_None); // have to do this otherwise the vehicle doesn't move to the new location
        }
        else
        {
            DHPawn(PlayerPawn).GiveChute();
        }

        PlayerPawn.SetLocation(ParaDropVector + RandRange(10.0, 20.0) * 60.0 * vector(RotRand()));

        if (PlayerPawn.IsA('Vehicle')) // if we dropped a vehicle, we must now reset it's normal physics, otherwise it just hangs in the sky !
        {
            PlayerPawn.SetPhysics(PHYS_Karma);
        }

        // If a specific player name was passed (only used in ParaDropPlayer) then give notification message to dropped player & log the event
        if (PlayerName != "" && Admin != none)
        {
            NotifyPlayer(4, PlayerToDrop); // admin paradropped you
            Log("DHAdminMenu: admin" @ GetAdminName() @ "paradropped player '" $ PlayerName $ "'");
        }
    }
    else if (PlayerName != "")
    {
        ErrorMessageToSelf(9, PlayerName); // player is not active
    }
}

// Checks for a grid reference that may have been included from a certain point
function string ConcatenateGridRef(array<string> Characters, byte StartIndex)
{
    local string GridRef;
    local int    i;

    for (i = StartIndex; i < Characters.Length; ++i)
    {
        GridRef $= Characters[i];
    }

    return GridRef;
}

// Coverts a grid reference into paradrop location coordinates
// For quick typing it accepts the format "e25" for map grid E2 keypad 5, is not case sensitive & ignores any spaces between characters
// Also accepts "e2" format & assumes a central keypad 5 sub-grid position if a keypad number is not specified
function vector GetGridDropLocation(string GridRef)
{
    local string GridLetter;
    local byte   GridNumber, KeypadNumber;
    local float  GridX, GridY;
    local vector DropLocation;

    GridRef = Repl(GridRef, " ", "");  // remove any unwanted spaces
    GridRef = Repl(GridRef, "kp", ""); // remove "kp" if the admin has entered a grid ref in format of "E 4 kp 3" (the original Builder mutator format)

    GridLetter = Left(GridRef, 1);
    GridNumber = byte(Mid(GridRef, 1, 1));
    KeypadNumber = byte(Mid(GridRef, 2, 1));

    if (GridNumber < 1 || GridNumber > 9)
    {
        ErrorMessageToSelf(22); // invalid grid ref

        return NULL_VECTOR;
    }

    // Set GridX & GridY as relative offsets (in grid squares at this stage) from MapCentre, so we have values between -4 and +4 for calculating the drop position
    GridX = float(GridNumber - 5);

    switch (GridLetter)
    {
        case "A":
                GridY = -4.0;
                break;
        case "B":
                GridY = -3.0;
                break;
        case "C":
                GridY = -2.0;
                break;
        case "D":
                GridY = -1.0;
                break;
        case "E":
                GridY =  0.0;
                break;
        case "F":
                GridY = 1.0;
                break;
        case "G":
                GridY = 2.0;
                break;
        case "H":
                GridY = 3.0;
                break;
        case "I":
                GridY = 4.0;
                break;

        default:
                ErrorMessageToSelf(22); // invalid grid ref
                return NULL_VECTOR;
    }

    // Adjust GridX & GridY for keypad sub-grid position
    switch (KeypadNumber)
    {
        case 0: // if no keypad sub-grid is entered we assume a central keypad 5 position (no adjustment)
                break;
        case 1:
                GridX -= 0.333333;
                GridY += 0.333333;
                break;
        case 2:
                GridY += 0.333333;
                break;
        case 3:
                GridX += 0.333333;
                GridY += 0.333333;
                break;
        case 4:
                GridX -= 0.333333;
                break;
        case 5:
                break;
        case 6:
                GridX += 0.333333;
                break;
        case 7:
                GridX -= 0.333333;
                GridY -= 0.333333;
                break;
        case 8:
                GridY -= 0.333333;
                break;
        case 9:
                GridX += 0.333333;
                GridY -= 0.333333;
                break;

        default:
                ErrorMessageToSelf(22); // invalid grid ref
                return NULL_VECTOR;
    }

    // Convert DropLocation (currently just grid square offsets) to Unreal unit offsets from map centre, with Z as the established ParaDropHeight
    DropLocation.X = (GridX / 9.0) * MapScale;
    DropLocation.Y = (GridY / 9.0) * MapScale;
    DropLocation.Z = ParaDropHeight;

    // Now correct our offset for any rotational offset in the map
    DropLocation = GetAdjustedHudLocation(DropLocation, true);

    // Finally add to the map centre co-ords to give us real world co-ords for the paradrop
    DropLocation.X += MapCenter.X;
    DropLocation.Y += MapCenter.Y;

    return DropLocation;
}

// Finds a map objective & returns its location for paradrop coordinates
function vector GetObjectiveDropLocation(string ObjectiveName, string ObjectiveIndexString)
{
    local DarkestHourGame DHG;
    local vector          DropLocation;
    local int             ObjectiveIndex;
    local DHObjective     Objective;

    DHG = DarkestHourGame(ROTG);
    ObjectiveIndex = RemoveBracketsFromIndex(ObjectiveIndexString);

    if (DHG != none && ObjectiveIndex >= 0 && ObjectiveIndex < arraycount(DHG.DHObjectives))
    {
        Objective = DHG.DHObjectives[ObjectiveIndex];

        if (Objective != none && Objective.ObjNum == ObjectiveIndex)
        {
            DropLocation = Objective.Location;
            DropLocation.Z = ParaDropHeight;
        }
    }

    if (DropLocation == NULL_VECTOR)
    {
        ErrorMessageToSelf(20, ObjectiveName @ "(role index no." $ ObjectiveIndex $ ")"); // can't find objective
    }

    return DropLocation;
}

// Returns player's current location for paradrop coordinates
function vector GetCurrentDropLocation(Controller PlayerToDrop)
{
    local vector DropLocation;

    if (PlayerToDrop == none || PlayerToDrop.Pawn == none)
    {
        ErrorMessageToSelf(9, GetPlayerName(PlayerToDrop)); // player is not active

        return NULL_VECTOR;
    }

    DropLocation = PlayerToDrop.Pawn.Location;
    DropLocation.Z = ParaDropHeight;

    return DropLocation;
}

// This function will adjust a hud map location based on the rotation offset of the overhead map (used by GetGridDropLocation function)
// Note this is from ROHud but that is not accessible serverside, so we need the same function here
function vector GetAdjustedHudLocation(vector HudLoc, optional bool bInvert)
{
    local int   OverheadOffset;
    local float SwapX, SwapY;

    if (ROGameReplicationInfo(Level.Game.GameReplicationInfo) != none)
    {
        OverheadOffset = ROGameReplicationInfo(Level.Game.GameReplicationInfo).OverheadOffset;

        if (bInvert)
        {
            if (OverheadOffset == 90)
            {
                OverheadOffset = 270;
            }
            else if (OverheadOffset == 270)
            {
                OverheadOffset = 90;
            }
        }

        if (OverheadOffset == 90)
        {
            SwapX = HudLoc.Y * -1.0;
            SwapY = HudLoc.X;
            HudLoc.X = SwapX;
            HudLoc.Y = SwapY;
        }
        else if (OverheadOffset == 180)
        {
            SwapX = HudLoc.X * -1.0;
            SwapY = HudLoc.Y * -1.0;
            HudLoc.X = SwapX;
            HudLoc.Y = SwapY;
        }
        else if (OverheadOffset == 270)
        {
            SwapX = HudLoc.Y;
            SwapY = HudLoc.X * -1.0;
            HudLoc.X = SwapX;
            HudLoc.Y = SwapY;
        }
    }

    return HudLoc;
}

function SetParaDropVariables()
{
    local ROGameReplicationInfo GRI;
    local TerrainInfo           TI;
    local vector                TestLocation, MapDiagonal;
    local Actor                 TestActor;
    local int                   i;

    // Get the maximum safe height to paradrop a player, without him getting stuck in the skybox or whatever
    // For a starting location we get the location of the TerrainInfo actor
    foreach AllActors(class'TerrainInfo', TI)
    {
        TestLocation = TI.Location;
        break;
    }

    // We'll spawn a temporary static mesh test actor & use it to check up to 5 locations of increasing height
    for (i = 1; i < 6; ++i)
    {
        TestLocation.Z += 1920.0; // each pass we'll try moving the test location higher (approx 32m)

        // On the 1st pass we'll spawn the test actor (1920 UU above the TerrainInfo)
        if (TestActor == none)
        {
            TestActor = Spawn(class'DH_AdminMenuMutator.DHAdminMenu_TestSM',,, TestLocation); // spawns on 1st pass & then gets moved
        }
        // Only subsequent passes we try to move the test actor to the new higher location
        // If we fail (i.e. SetLocation returns false) then we're too high, so revert to the previous height & stop checking
        else if (!TestActor.SetLocation(TestLocation))
        {
            TestLocation.Z -= 1920.0;
            break;
        }
    }

    ParaDropHeight = TestLocation.Z;

    if (TestActor != none)
    {
        TestActor.Destroy();
    }

    // Now calculate the map centre & scale
    GRI = ROGameReplicationInfo(Level.Game.GameReplicationInfo);
    MapDiagonal = GRI.SouthWestBounds - GRI.NorthEastBounds;
    MapCenter = (MapDiagonal / 2.0) + GRI.NorthEastBounds;
    MapScale = Abs(MapDiagonal.X);
}

defaultproperties
{
    GroupName="AdminMenu"
    FriendlyName="Admin menu"
    Description="Screen menu options allowing an admin greater control over players, a realism match or during testing"
    bAddToServerPackages=true // this is necessary for the Replicator to be spawned on a client
    WarningSound=Sound'DH_AdminMenuMutator.Klaxon' // can be overridden in server DarkestHour.ini file
}
