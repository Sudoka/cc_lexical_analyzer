{*************************************************************************
 *
 * This program maintains a small work schedule covering the hours 8-6.
 * It processes the following commands:
 *
 * sched employee startday endday starthour endhour
 *        The  employee is added to the schedule in the range of days and
 *        hours  indicated.
 *
 * clear startday endday starthour endhour
 *        The  part  of the schedule indicated is cleared  any assignment
 *        of an employee during those hours is removed. 
 *
 * unsched employee
 *        Remove  the  employee  from all places in the schedule to which
 *        s/he has been assigned.
 *
 * print
 *        Print  the  schedule. Show a table with days along the top, and
 *        hours  down  the  side,  giving  the scheduled employee in each
 *        position.
 *
 * total employee
 *        Print  the  total hours for which the employee is scheduled. If
 *        the employee does not appear in the table, the total is 0.
 *
 * quit
 *        Terminate the program.
 *************************************************************************}

program a1 (input,output);
    uses dayio;

    const 
	{ Open positions in the schedule. }
	NotScheduled = "        ";

	{ Max length of an employee name. }
	EmployeeMaxLen = 8;

	{ Hours in a day. }
	FirstHour = 8;
	LastHour = 17;		{ 5:00 PM in 24-hour time }
	PastLastHour = 18;	{ One past, for while loops. }

	{ How much room to allow for each day in the table. }
	TableDayWidth = 9;
    type 
	{ The employee name type. }
	EmployeeType = string[EmployeeMaxLen];

	{ The type of the schedule array. }
	{ HourType = FirstHour..LastHour; }
	HourType = 8..17;
	ScheduleType = array [HourType, DayType] of EmployeeType;
	{ HourScanType = FirstHour..PastLastHour; }
	HourScanType = 8..18;

    {**********************************************************************
     * Procedure to read the next non-blank.  It skips leading blanks, then
     * reads the string up to the first blank or eoln.
     **********************************************************************}
    procedure ReadString(var Str: string);
	var
	    Ch: char;
	begin
	    Ch := " ";
	    while (Ch = " ") and not eoln do 
		read(Ch);

	    if Ch = " " then
		{ There is no command on this line. }
		Str := ""
	    else
		begin 
		    { Read the beast. }
		    Str := "";
		    while (Ch <> " ") and not eoln do
			begin
			    Str := Str + Ch;
			    read(Ch)
			end;

		    if Ch <> " " then
			{ Command ended at eoln. }
			Str := Str + Ch
		end
	end; { ReadString }

    {**********************************************************************
     * Procedure to read the arguments held in common by the sched 
     * clear commands.  Returns them through the arguments.  If there
     * is some error, that is reported through the argument error.
     *  Precondition: Following the read pointer, the input contains
     *	  two days of the week, then two integers.  If all days are present and
     *	  correct, the integers must be present and correct.
     *  Postcondition: If both strings are recognized day names,
     *	  they are read, and the integers are read as well, and their values
     *	  are loaded into StartDay, EndDay, StartHour, and EndHour, and Error
     *	  is set to false.  The hours are mapped to 24-hour clock time under
     *	  the rule that hours less than 6 are PM, and others are AM.  If a day
     *	  is missing or not recognized, the rest of the input line is
     *	  discarded, and Error is set to true.  If there is extra information
     *	  on the line, it is discared.  The read pointer is left at the start
     *	  of the following line.
     **********************************************************************}
    procedure ReadSchedClrArgs(
	    var StartDay, EndDay: DayType;	{ Input days. }
	    var StartHour, EndHour: HourType;	{ Input hour range. }
	    var Error: boolean);		{ Input error indicator.}
	var
	    InputHour: integer;			{ Input hour value. }

	{ Map time to 24-hours based on the AM/PM rules. }
	function MapTo24(Hour: integer): HourType;
	    const
		{ AM/PM time cut-off. }
		LastPM = 5;
	    begin
		if Hour <= LastPM then
		    MapTo24 := Hour + 12
		else
		    MapTo24 := Hour
	    end;

	begin { ReadSchedClrArgs }
	    { Read the days. }
	    ReadDay(input, StartDay);
	    ReadDay(input, EndDay);

	    { See if they both worked. }
	    if (StartDay <> BadDay) and (EndDay <> BadDay) then 
		begin
		    { It worked.  Read the hours. }
		    read(InputHour);
		    StartHour := MapTo24(InputHour);
		    read(InputHour);
		    EndHour := MapTo24(InputHour);

		    { Report success }
		    Error := FALSE 
		end
	    else
		{ Something went wrong, seriously wrong. }
		Error := TRUE;

	    { We"re done with this line. }
	    readln
	end; { ReadSchedClrArgs }

    {****************************************************************
     * procedure to print headers of each day.
     *  Precondition: None.
     *  Postcondition: A header line with the days of the week has
     *    been printed.  The 
     ****************************************************************}
    procedure WriteDaysHeader;
	const

	    { How many spaces to move over before printing days-of
	      the week header. }
	    DaysHeadMoveOver = 6;

	    { How much room to assume is needed by each day string. }
	    AllowForDay = 3;
	var
	    Day: DayType;
	begin
	    write(" ": DaysHeadMoveOver);

	    for Day := Sun to Sat do
		begin
		    write("[ ");
		    WriteDay(output, Day);
		    write(" ]", " ": TableDayWidth - AllowForDay - 4)
		end;
	    writeln
	end; { WriteDaysHeader }

    {****************************************************************
     * Function that tells if a pending schedule is legal.
     * Its arguments are those of sched, excluding the employee name.
     *  Precondition: FirstHour and LastHour are in range.
     *  Postcondition: If the indicated area of the schedule contains
     *    blanks in each entry, then return true, else false.
     *  Note: Schedule is sent by var for efficiency -- it is not
     *    changed.
     ****************************************************************}
    function SchedLegal(
	    var Schedule: ScheduleType;	    { Schedule to check. }
		StartDay, EndDay: DayType;  { Days in question. }
		FirstHour, LastHour: 	    { Hours in question. }
			HourType): boolean;
	var
	    ConflictFound: boolean;	    { Tell if one found. }
	    DayScan: DayType;		    { Go through the days. }
	    HourScan: HourScanType;	    { Go through the hours. }
	begin
	    { Scan the days. }
	    DayScan := StartDay;
	    ConflictFound := FALSE;
	    repeat
		{ For this day, scan the times. }
		HourScan := FirstHour;
		while not ConflictFound and
				(HourScan <= LastHour) do begin
		    { Conflict? }
		    ConflictFound :=
			    Schedule[HourScan, DayScan] <> NotScheduled;

		    { Next one. }
		    HourScan := HourScan + 1
		end;

		{ Next Day. }
		DayScan := succ(DayScan)
	    until ConflictFound or (DayScan > EndDay);

	    { And the answer is.. }
	    SchedLegal := not ConflictFound
	end; { SchedLegal }

    {****************************************************************
     * This takes care of most of the work of the clear and sched
     * commands.  Its arguments are those of sched, with blanks in
     * Employee for the clear.  It places this name in each indicated
     * postion.
     *  Precondition: FirstHour and LastHour are in range.
     *  Postcondition: The area of the schedule is changed to show
     *    the indicated employee.
     *  Note: This will replace any old entry, so the sched command
     *    should call SchedLegal above to make sure the operation
     *    is legal before calling this routine.
     ****************************************************************}
    procedure SetSchedPart(
	    var Schedule: ScheduleType;	    { Set me! Set me! }
		Employee: EmployeeType;	    { Who gets to work. }
		StartDay, EndDay: DayType;  { Days in question. }
		FirstHour, LastHour:	    { Hours in question. }
				HourType);
	var
	    DayScan: DayType;		    { Go through the days. }
	    HourScan: HourType;		    { Go through the hours. }
	begin
	    for DayScan := StartDay to EndDay do
		for HourScan := FirstHour to LastHour do
		    Schedule[HourScan, DayScan] := Employee
	end; { SetSchedPart }

    {****************************************************************
     * Perform the sched command.
     *  Precondition: The read pointer is followed by the arguments 
     *    for the sched command.
     *  Postcondition: The arguments have been read and echoed, and the
     *    read pointer is on the next line.  The sched command has been
     *    performed with appropriate messages.
     * Note: DayMap is passed by var for efficiency -- it is not
     *    changed.
     ****************************************************************}
    procedure DoSched(
	    var Schedule: ScheduleType);    { Change this. }
	var
	    Employee: EmployeeType;	    { Input employee name. }
	    StartDay, EndDay: DayType;	    { Input days. }
	    StartHour, EndHour: HourType;   { Input hour range. }
	    Error: boolean;		    { Input error indicator.}
	begin
	    { Read the employee name }
	    ReadString(Employee);

	    { Read all the other arguments, and recieve error 
	       indication. }
	    ReadSchedClrArgs(StartDay, EndDay, StartHour, EndHour, Error);

	    { For errors, let "em know.  Otherwise, do it. }
	    if Error then
		writeln("*** Un-recognized day code.  ",
		    "Command not performed. ***")
	    else 
		{ See if the scheduling is legal. }
		if SchedLegal(Schedule, StartDay, EndDay,
					StartHour, EndHour) then
		    begin
			{ Legal.  Do it and admit it. }
			SetSchedPart(Schedule, Employee,
				StartDay, EndDay, StartHour, EndHour);
			writeln(">>> ", Employee, " scheduled. <<<")
		    end
		else 
		    { Not legal. }
		    writeln("*** Conflicts with existing schedule.  ",
			"Command not performed. ***")
	end; { DoSched }

    {****************************************************************
     * Perform the clear command.
     *  Precondition: The read pointer is followed by the arguments 
     *    for the clear command.
     *  Postcondition: The arguments have been read and echoed, and the
     *    read pointer is on the next line.  The clear command has been
     *    performed with appropriate messages.
     * Note: DayMap is passed by var for efficiency -- it is not
     *    changed.
     ****************************************************************}
    procedure DoClear(
	    var Schedule: ScheduleType);    { Change this. }
	var
	    StartDay, EndDay: DayType;	    { Input days. }
	    StartHour, EndHour: HourType;   { Input hour range. }
	    Error: boolean;		    { Input error indicator.}
	begin
	    { Read the arguments, and recieve error indication. }
	    ReadSchedClrArgs(StartDay, EndDay, StartHour, EndHour, Error);

	    { For errors, let "em know.  Otherwise, do it. }
	    if Error then
		writeln("*** Un-recognized day code.  ",
		    "Command not performed. ***")
	    else 
		begin
		    SetSchedPart(Schedule, NotScheduled, StartDay, EndDay,
			StartHour, EndHour);
		    writeln(">>> Clear performed. <<<");
		end { DoClear }
	end;

    {****************************************************************
     * Peform the unsched command.
     *  Precondition: The read pointer is followed by an employee 
     *    name.
     *  Postcondition: The argument has been read and echoed, and the
     *    read pointer is on the next line.  The employee read has been
     *	  removed from Schedule.
     ****************************************************************}
    procedure DoUnsched(
	    var Schedule: ScheduleType);	{ Remove from. }
	var
	    Employee: EmployeeType;		{ To remove. }
	    Day: DayType;			{ Column scanner. }
	    Hour: integer;			{ Row scanner. }
	    Found: boolean;			{ Presence indicator }
	begin
	    { Read the employee. }
	    readln(Employee);

	    { Remove! Remove! }
	    Found := FALSE;
	    for Day := Sun to Sat do
		for Hour := FirstHour to LastHour do
		    if Schedule[Hour, Day] = Employee then 
			begin
			    { Remove. }
			    Schedule[Hour, Day] := NotScheduled;

			    { Note. }
			    Found := TRUE 
			end;

	    { Warn if not found. Else just state. }
	    if Found then 
		write(">>> ", Employee, " removed from schedule. <<<")
	    else
		write(">>> ", Employee, 
				    " was not on the schedule. <<<")
	end; { DoUnsched }

    {****************************************************************
     * Peform the print command.
     *  Precondition: None.
     *  Postcondition: Schedule has been printed to output.
     ****************************************************************}
    procedure DoPrint(
	    var Schedule: ScheduleType);	{ Print me. }
	var
	    Hour: HourType;			{ Hour scan. }
	    Day: DayType;			{ Day scan. }

	{ Map from 24-hour time to 12-hour time.  Arguments less than
	  13 are simply returned, arguments greater than 12 are 
	  reduced by 12 and returned. }
	function Map24to12(HourType: HourType): integer;
	    begin
		if Hour < 13 then
		    Map24to12 := Hour
		else
		    Map24to12 := Hour - 12
	    end;
	begin
	    readln;
	    WriteDaysHeader;

	    for Hour := FirstHour to LastHour do
		begin
		    write(Map24to12(Hour):2, ":00 ");
		    for Day := Sun to Sat do
			write(Schedule[Hour, Day], 
			    " ": TableDayWidth - length(Schedule[Hour, Day]));
		    writeln
		end
	end;

    {****************************************************************
     * Peform the total command.
     *  Precondition: The read pointer is followed by an employee 
     *    name.
     *  Postcondition: The argument has been read and echoed, and the
     *    read pointer is on the next line.  The total scheduled hours
     *	  for the employee read has been printed.
     ****************************************************************}
    procedure DoTotal(
	    var Schedule: ScheduleType);	{ The schedule. }
	var
	    Employee: EmployeeType;		{ To remove. }
	    Day: DayType;			{ Column scanner. }
	    Hour: integer;			{ Row scanner. }
	    Total: integer;			{ Total intgers. }
	begin
	    { Read the employee. }
	    readln(Employee);

	    { Do the sum. }
	    Total := 0;
	    for Day := Sun to Sat do
		for Hour := FirstHour to LastHour do
		    if Schedule[Hour, Day] = Employee then
			Total := Total + 1;

	    { Write the total. }
	    writeln(">>> ", Employee,
		" is scheduled for ", Total:1, " hours. <<<<")
	end; { DoTotal }

    {*****************************************************************
     * Main line.
     *****************************************************************}

    var
	{ The schedule. }
	Schedule: ScheduleType;

	{ Main loop continue flag. }
	KeepRunning: boolean;

        { Command input local to main. }
        Command: string;

    begin
        { Clear the schedule. }
        SetSchedPart(Schedule, NotScheduled, Sun, Sat, FirstHour, LastHour);
 
        { Do the commands. }
	write("==> ");
    	ReadString(Command);
	KeepRunning := TRUE;
        while KeepRunning do
	    begin
		if Command = "sched" then 
            	    DoSched(Schedule)
		else if Command = "clear" then
		    DoClear(Schedule)
		else if Command = "unsched" then
		    DoUnsched(Schedule)
		else if Command = "print" then
         	    DoPrint(Schedule)
		else if Command = "total" then
		    DoTotal(Schedule)
		else if Command = "quit" then 
		    begin
			writeln;
			writeln(">>> Program terminating. <<<");
			KeepRunning := FALSE
		    end
		else
		    { Command not recognized. }
		    begin
			readln;
			writeln;
			writeln("*** Command ", Command, 
						    " not recognized. ***");
		    end;

		{ Go to a new page for next"n. }
		write("==> ");
		ReadString(Command)
	    end
    end.
