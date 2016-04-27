//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHCommandInteraction extends DHInteraction;

const FADE_DURATION = 0.25;
const INNER_RADIUS = 96.0;
const OUTER_RADIUS = 128.0;
const Tau = 6.28318530718;

var Stack_Object        Menus;

var float               MenuAlpha;
var vector              Cursor;
var int                 SelectedIndex;

event Initialized()
{
    super.Initialized();

    Menus = new class'Stack_Object';

    GotoState('FadeIn');
}

function Hide()
{
    GotoState('FadeOut');
}

function PushMenu(string ClassName)
{
    local DHCommandMenu Menu;
    local class<DHCommandMenu> MenuClass;

    MenuClass = class<DHCommandMenu>(DynamicLoadObject(ClassName, class'class'));

    Menu = new MenuClass;

    if (Menu == none)
    {
        Warn("Failed to load menu class" @ ClassName);
        return;
    }

    Menus.Push(Menu);
}

function PopMenu()
{
    Menus.Pop();
}

auto state FadeIn
{
    function Tick(float DeltaTime)
    {
        global.Tick(DeltaTime);

        MenuAlpha = FMin(1.0, MenuAlpha + (DeltaTime / FADE_DURATION));

        if (MenuAlpha == 1.0)
        {
            GotoState('Active');
        }
    }

    event BeginState()
    {
        MenuAlpha = 0.0;
    }
}

state Active
{
    event BeginState()
    {
        MenuAlpha = 1.0;
    }
}

state FadeOut
{
    function Tick(float DeltaTime)
    {
        super.Tick(DeltaTime);

        MenuAlpha = FMax(0.0, MenuAlpha - (DeltaTime / FADE_DURATION));

        if (MenuAlpha == 0.0)
        {
            ViewportOwner.InteractionMaster.RemoveInteraction(self);
        }
    }

    function bool KeyEvent(out EInputKey Key, out EInputAction Action, float Delta)
    {
        return false;
    }
}

function Tick(float DeltaTime)
{
    local float ArcLength, Theta;
    local DHCommandMenu Menu;

    Menu = DHCommandMenu(Menus.Peek());

    // Clamp cursor
    Cursor = class'UCore'.static.VClampSize(Cursor, 0.0, OUTER_RADIUS);

    if (Menu != none &&
        Menu.Options.Length > 0 &&
        Cursor != vect(0, 0, 0))
    {
        // TODO: extract this to a function to be reused, may be useful in
        // other areas.

        // Calculated the selected index
        ArcLength = Tau / Menu.Options.Length;
        Theta = Atan(Cursor.Y, Cursor.X) + (ArcLength / 2);
        Theta += class'UUnits'.static.DegreesToRadians(90);

        if (Theta < 0)
        {
            Theta = Tau + Theta;
        }

        if (VSize(Cursor) < INNER_RADIUS)
        {
            // No selection
            SelectedIndex = -1;
        }
        else
        {
            SelectedIndex = (Menu.Options.Length * (Theta / Tau));
        }
    }
    else
    {
        SelectedIndex = -1;
    }
}

function PostRender(Canvas C)
{
    local int i;
    local float Theta, ArcLength;
    local float CenterX, CenterY, X, Y, Xl, YL;
    local DHCommandMenu Menu;

    if (C == none)
    {
        return;
    }

    CenterX = (C.ClipX / 2);
    CenterY = (C.ClipY / 2);

    if (SelectedIndex == -1)
    {
        C.DrawColor = class'UColor'.default.Green;
    }

    C.DrawColor.A = MenuAlpha * 255;

    // TODO: get rid of magic numbers
    C.SetPos(CenterX - 64, CenterY - 64);
    C.DrawTile(material'DH_InterfaceArt_tex.Communication.command_menu_ring', 128, 128, 0, 0, 128, 128);

    Menu = DHCommandMenu(Menus.Peek());

    Theta -= class'UUnits'.static.DegreesToRadians(90);

    if (Menu != none)
    {
        ArcLength = Tau / Menu.Options.Length;

        // Draw all the options.
        for (i = 0; i < Menu.Options.Length; ++i)
        {
            X = Cos(Theta) * 128;
            Y = Sin(Theta) * 128;   //MAGIC

            if (SelectedIndex == i)
            {
                C.DrawColor = class'UColor'.default.Green;
            }
            else
            {
                C.DrawColor = class'UColor'.default.White;
            }

            C.DrawColor.A = MenuAlpha * 255;
            C.SetPos(CenterX + X - 64, CenterY + Y - 64);
            C.DrawTile(material'DH_InterfaceArt_tex.Communication.command_menu_ring', 128, 128, 0, 0, 128, 128);

            Theta += ArcLength;
        }
    }

    if (SelectedIndex >= 0)
    {
        C.TextSize(Menu.Options[SelectedIndex].Text, XL, YL);
        C.SetPos(CenterX - (XL / 2), CenterY);
        C.DrawText(Menu.Options[SelectedIndex].Text);
    }

    // debug rendering for cursor
    C.SetPos(CenterX + Cursor.X, CenterY + Cursor.Y);
    C.DrawColor = class'UColor'.default.Red;
    C.DrawBox(C, 4, 4);
}

function bool KeyEvent(out EInputKey Key, out EInputAction Action, float Delta)
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo PRI;
    local vector TraceStart, TraceEnd, HitLocation, HitNormal;
    local Actor A, HitActor;

    PC = DHPlayer(ViewportOwner.Actor);

    if (PC == none || PC.Pawn == none && PC.Pawn.Region.Zone != none)
    {
        return false;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    if (PRI == none)
    {
        return false;
    }

    switch (Action)
    {
        case IST_Axis:
            switch (Key)
            {
                case IK_MouseX:
                    Cursor.X += Delta;
                    return true;
                case IK_MouseY:
                    Cursor.Y -= Delta;
                    return true;
                default:
                    break;
            }
            break;
        case IST_Press:
            switch (Key)
            {
                // TODO: Left mouse might not be bound to fire, and exec functions
                // do not register in interactions. This isn't ideal, but I'm
                // guessing that %99.9 of players use left mouse as the fire
                // key, so this will do for now.
                case IK_LeftMouse:
                    TraceStart = PC.CalcViewLocation;
                    TraceEnd = TraceStart + (vector(PC.CalcViewRotation) * PC.Pawn.Region.Zone.DistanceFogEnd);

                    foreach PC.TraceActors(class'Actor', A, HitLocation, HitNormal, TraceEnd, TraceStart)
                    {
                        if (A == PC.Pawn ||
                            A.IsA('ROBulletWhipAttachment') ||
                            A.IsA('Volume'))
                        {
                            continue;
                        }

                        HitActor = A;

                        break;
                    }

                    Log(HitActor);

                    if (HitActor == none)
                    {
                        HitLocation = TraceEnd;
                    }

                    OnSelect(SelectedIndex, HitLocation);
                    return true;
                case IK_RightMouse:
                    if (Menus.Size() > 1)
                    {
                        PopMenu();
                    }
                    return true;
                default:
                    break;
            }
            return false;
        default:
            break;
    }

    return false;
}

function bool OnSelect(int Index, optional vector Location)
{
    local DHCommandMenu Menu;

    Menu = DHCommandMenu(Menus.Peek());

    if (Menu == none || Index < 0 || Index >= Menu.Options.Length)
    {
        return false;
    }

    Menu.OnSelect(self, Index, Location);
}

defaultproperties
{
    bActive=true
    bVisible=true
    bRequiresTick=true
}
