//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHSquadInviteInteraction extends DHInteraction;

var localized string InvitationText;
var localized string PromptText;

var string SenderName;
var string SquadName;
var int TeamIndex;
var int SquadIndex;

function Initialized()
{
    super.Initialized();

    // TODO: make sure this gets called at the right time
    InvitationText = Repl(InvitationText, "{0}", class'GameInfo'.static.MakeColorCode(class'DHColor'.default.SquadColor) $ default.SenderName $ class'GameInfo'.static.MakeColorCode(class'UColor'.default.White));
    InvitationText = Repl(InvitationText, "{1}", class'GameInfo'.static.MakeColorCode(class'DHColor'.default.SquadColor) $ default.SquadName $ class'GameInfo'.static.MakeColorCode(class'UColor'.default.White));

    PromptText = Repl(PromptText, "[", class'GameInfo'.static.MakeColorCode(class'DHColor'.default.InputPromptColor) $ "[");
    PromptText = Repl(PromptText, "]", "]" $ class'GameInfo'.static.MakeColorCode(class'UColor'.default.White));
}

function bool KeyEvent(out EInputKey Key, out EInputAction Action, float Delta)
{
    local DHPlayer PC;

    PC = DHPlayer(ViewportOwner.Actor);

    if (PC == none)
    {
        return false;
    }

    if (Action == IST_Press)
    {
        if (Key == IK_F1)       // Accept
        {
            PC.ServerSquadJoin(default.TeamIndex, default.SquadIndex, true);

            Master.RemoveInteraction(self);

            return true;
        }
        else if (Key == IK_F2)  // Decline
        {
            Master.RemoveInteraction(self);

            return true;
        }
        else if (Key == IK_F3)  // Ignore All
        {
            PC.bIgnoreSquadInvitations = true;

            Master.RemoveInteraction(self);

            return true;
        }
    }

    return false;
}

simulated function PostRender(Canvas C)
{
    local float X, Y, XL, YL;

    X = 8;

    super.PostRender(C);

    C.DrawColor = class'UColor'.default.White;
    C.Font = class'DHHud'.static.GetConsoleFont(C);

    // "{0} has invited you to join {1} squad."
    C.TextSize(InvitationText, XL, YL);

    Y = (C.ClipY * (2.0 / 3.0)) - (YL / 2);

    C.SetPos(X, Y);
    C.DrawText(InvitationText, true);

    // "[F1] Accept [F2] Decline [F3] Ignore All"
    C.TextSize(PromptText, XL, YL);

    Y = (C.ClipY * (2.0 / 3.0)) - (YL / 2) + YL;

    C.SetPos(X, Y);
    C.DrawText(PromptText, true);
}

function NotifyLevelChange()
{
    super.NotifyLevelChange();

    Master.RemoveInteraction(self);
}

defaultproperties
{
    InvitationText="{0} has invited you to join {1} squad."
    PromptText="[F1] Accept [F2] Decline [F3] Ignore All"
    bActive=true
    bVisible=true
}
