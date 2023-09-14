//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHDataTable extends Object;

struct STableColumn
{
    var string Header;
    var color TextColor;
    var int Width;
    var int HeaderJustification;
    var int RowJustification;
};

struct STableRowColumn
{
    var string Value;
    var Color TextColor;
};

struct STableRow
{
    var array<STableRowColumn> Columns;
};

var Font Font;
var int PaddingHorizontal;
var int PaddingVertical;
var array<STableColumn> Columns;
var array<STableRow> Rows;

function int GetWidth()
{
    local int i;
    local int Width;

    for (i = 0; i < Columns.Length; ++i)
    {
        Width += Columns[i].Width;
    }

    return Width;
}

function int GetHeight(Canvas C)
{
    local float XL, YL;

    C.Font = Font;
    C.TextSize("A", XL, YL);

    return (YL + (PaddingVertical * 2)) * (Rows.Length + 1);
}

function DrawTable(Canvas C, float X, float Y)
{
    local int i, k;
    local float X1, Y1, XL, YL;
    local int TableWidth, TableHeight;

    C.Font = Font;  // TODO: have font not enter into this at all, just use whatever is set
    C.TextSize("W", XL, YL);
    YL += PaddingVertical * 2;

    TableWidth = GetWidth();
    TableHeight = GetHeight(C);

    X1 = X;
    Y1 = Y;

    // Header
    for (i = 0; i < Columns.Length; ++i)
    {
        C.DrawColor = Columns[i].TextColor;
        C.DrawTextJustified(
            Columns[i].Header,
            Columns[i].HeaderJustification,
            X1 + PaddingHorizontal,
            Y1 + PaddingVertical,
            X1 + Columns[i].Width - PaddingHorizontal,
            Y1 + YL - PaddingVertical
        );

        if (i > 0)
        {
            // Draw vertical column separator
            C.DrawColor = class'UColor'.default.DarkGray;
            C.SetPos(X1, Y);
            C.DrawVertical(X1, TableHeight);
        }

        X1 += Columns[i].Width;
    }

    Y1 += YL + PaddingVertical;

    // Draw horizontal header separator
    C.DrawColor = class'UColor'.default.DarkGray;
    C.SetPos(X, Y1);
    C.DrawHorizontal(Y1 - 2, TableWidth);

    // Draw Rows
    for (i = 0; i < Rows.Length; ++i)
    {
        X1 = X;

        for (k = 0; k < Rows[i].Columns.Length; ++k)
        {
            C.DrawColor = Rows[i].Columns[k].TextColor;

            C.DrawTextJustified(
                Rows[i].Columns[k].Value,
                Columns[k].RowJustification,
                X1 + PaddingHorizontal,
                Y1 + PaddingVertical,
                X1 + Columns[k].Width - PaddingHorizontal,
                Y1 + YL - PaddingVertical
            );

            X1 += Columns[k].Width;
        }

        Y1 += YL;
    }
}

defaultproperties
{
    PaddingHorizontal=8
    PaddingVertical=2
}
