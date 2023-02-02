//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class StringBuffer extends Object;

enum ESeekDirection
{
    SEEK_Begin,
    SEEK_End,
    SEEK_Current
};

var private string Buffer;
var private int ReadPosition;
var private int WritePosition;

function string ToString()
{
    return Buffer;
}

function Clear()
{
    Buffer = "";
    ReadPosition = 0;
    WritePosition = 0;
}

function int Tellg()
{
    return ReadPosition;
}

function int Tellp()
{
    return WritePosition;
}

function Seekg(ESeekDirection Direction, optional int Position)
{
    switch (Direction)
    {
        case SEEK_Begin:
            self.ReadPosition = Position;
            break;
        case SEEK_End:
            self.ReadPosition = Len(Buffer);
            break;
        case SEEK_Current:
            self.ReadPosition += Position;
            break;
    }
}

function Seekp(ESeekDirection Direction, optional int Position)
{
    switch (Direction)
    {
        case SEEK_Begin:
            self.WritePosition = Position;
            break;
        case SEEK_End:
            self.WritePosition = Len(Buffer);
            break;
        case SEEK_Current:
            self.WritePosition += Position;
            break;
    }
}

function Write(coerce string S)
{
    Buffer = Left(Buffer, WritePosition) $ S $ Right(Buffer, WritePosition);
    WritePosition += Len(S);
}

function string Read(int Count)
{
    local int Position;

    Position = ReadPosition;
    ReadPosition += Count;

    return Mid(Buffer, Position, Count);
}

function string Peek(int Count)
{
    return Mid(Buffer, ReadPosition, Count);
}
