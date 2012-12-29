unit DayIO;
{* This unit provides a facility to input and output day of the week
 * names.  The names are Sun, Mon, Tue, Wed, Thu, Fri, and Sat.  Such
 * names may be read in using ReadDay, written using WriteDay.  ReadDay
 * reads in the name, and returns it as a value of the enumerated type
 * DayType.  The input value is case-sensitive, and must be entered
 * exactly as given in the list above.  WriteDay takes a DayType value
 * and prints it, using one of the string above.  There is also a
 * function MapToDay which accepts a string containing the name of a
 * day and maps it to a DayType value.
 *}

interface
    type
	{ Type to represent a day of the week, or an error. }
	DayType = (Sun, Mon, Tue, Wed, Thu, Fri, Sat, BadDay);

    { Convert a string to a day.  If it is not a legal day, the result is
      BadDay.
	Precondition: None:
	Postcondition: If S is one of the strings Sun Mon Tue Wed Thu Fri, or
	    Sat, MapToDay returns the corresponding day.  Otherwise, it
	    returns BadDay. }
    function MapToDay(S: string): DayType;

    { Read a day from the file.  The day must be the next item on the same
      line.  The procedure skips leading blanks, and reads the next
      non-blank item on the line, and returns the day read.  If there was
      no item on the line, or the item was not a legal day, it returns
      BadDay.
	Precondition: InFile is open for reading.
	Postcondition: The file has been read until the first non-blank
	    character is seen, then through the first blank character, but
	    not past the end of the current line.  If the sequence of
	    non-blank characters read matches one of the day strings
	    Sun Mon Tue Wed Thu Fri or Sat, the corresponding day of the
	    week is returned in Day.  If not, or if no non-blank characters
	    were read, the item BadDay is returned. }
    procedure ReadDay
	    (var InFile: TEXT;		{ Input file read from. }
	     var Day: DayType);	{ Returned day of the week value. }

    { Write a day to the file.
	Precondition: OutFile is open for writing.
	Postcondition: The string of characters Sun Mon Tue Wed Thu Fri or Sat
	corresponding the value is Day is written to OutFile. }
    procedure WriteDay
	    (var OutFile: TEXT;		{ Input file written to. }
	 	 Day: DayType);		{ Day to write. }

implementation
    const
	{ Size of day strings. }
	DaySize = 3;
    type
	{ Type of a day. }
	DayStrType = string[DaySize];
    var
	{ Map from enumerated day type to characters. }
	DayMap: array[DayType] of DayStrType;

    { Convert a string to a day.  If it is not a legal day, the result is
      BadDay. }
    function MapToDay(S: string): DayType;
	var
	    Day: DayType;		{ Scanner. }
	    Found: boolean;		{ Tell if a match was found. }
	begin
	    Found := FALSE;
	    Day := Sun;
	    while (Day < BadDay) and not Found do
		begin
		    if DayMap[Day] = S then
		        Found := TRUE
		    else
			Day := succ(Day)
		end;

	    MapToDay := Day
	end;

    { Read one character, but do not read past the end of line.  Just
      return a space.
  	Pre: InFile is open for reading.
 	Post: If InFile was at eoln, Ch is set to " ", and InFile is
  	    unchanged.  Otherwise, one character is read from InFile to Ch. }
    procedure ReadOnLine(var InFile: TEXT; var Ch: Char);
	begin
	    if eoln(InFile) then 
		Ch := " "
	    else 
		read(InFile, Ch)
	end;

    { Read a day from the file.  The day must be the next item on the same
      line.  The procedure skips leading blanks, and reads the next
      non-blank item on the line, and returns the day read.  If there was
      no item on the line, or the item was not a legal day, it returns
      BadDay. }
    procedure ReadDay
	    (var InFile: TEXT;		{ Input file read from. }
	     var Day: DayType);		{ Returned day of the week value. }
        var
            Ch: char;			{ Input character. }
	    DayStr: DayStrType;		{ Input string of chars. }
	begin
	    { Skip blanks. }
	    Ch := " ";
	    while (Ch = " ") and not eoln(InFile) do
		begin
		    read(InFile, Ch)
		end;

	    { See if we found a non-blank character. }
	    if Ch = " " then 
		{ The skip loop must have ended at eoln. }
		Day := BadDay
	    else 
		begin
		    { Read the characters. }
		    DayStr := "";
		    while (Ch <> " ") and (Length(DayStr) < DaySize) do
			begin
			    DayStr := DayStr + Ch;  
			    ReadOnLine(InFile, Ch)
			end;

                    { Match must be exact. }
                    if Ch <> " " then
                        { Something else out there.  Not good. }
                        Day := BadDay
                    else
                        begin
		             { Discard any remaining characters. }
		             while (Ch <> " ") and not eoln(InFile) do 
			         read(InFile, Ch);

		             { Map the string to the enum. }
		             Day := MapToDay(DayStr)
                        end
		end
        end;

    { Write a day to the file. }
    procedure WriteDay
	    (var OutFile: TEXT;		{ Input file written to. }
	 	 Day: DayType);		{ Day to write. }
	begin
	    write(OutFile, DayMap[Day])
	end;

    begin
        { Initialize the DayMap.  This is an easy way to convert
           DayType values to strings.  It is used internally by the
           unit. }
	DayMap[Sun] := "Sun";
	DayMap[Mon] := "Mon";
	DayMap[Tue] := "Tue";
	DayMap[Wed] := "Wed";
	DayMap[Thu] := "Thu";
	DayMap[Fri] := "Fri";
	DayMap[Sat] := "Sat";
	DayMap[BadDay] := "***"
    end.
