  { EXAMPLES.PAS }
  { A set of examples to demonstrate features of Extended Pascal }

  { Prospero Software, January 1993 }

  {  ------------------------------------------  }

program strings1 (output);

  { Extended Pascal examples }
  { Variable length strings and substrings }

var a,b: string(20);  { a,b have capacity 20 }
    n: 1..10;

begin
  a := "1234567890";
  for n := 1 to 10 do
      writeln(a[1..n],".",substr(a,n+1));
    { The indexed string yields characters 1 to n of string a; }
    { function substr takes the remaining characters }
  a := "The quick brown fox";
  b := "the lazy dog.";
  writeln(a+" jumps over "+b);
    { + operator concatenates strings }
  a[5..6] := "sl";
  b[5..6] := "do";
  writeln(a," laughs at ",b);
end.

  { Generated output is:
    1.234567890
    12.34567890
    123.4567890
    1234.567890
    12345.67890
    123456.7890
    1234567.890
    12345678.90
    123456789.0
    1234567890.
    The quick brown fox jumps over the lazy dog.
    The slick brown fox laughs at the dozy dog.
  }

  {  ------------------------------------------  }

program strings2 (output);

  { Extended Pascal examples }
  { Variable strings and fixed strings }

type  pac10 = packed array [1..10] of char;

var   a,b: string(20);
      x,y: pac10;

begin
  x := "One,two,";    { two trailing spaces supplied }
  y := "three,four";  { fits exactly }
  a := trim(x);       { function trim removes trailing spaces }
  b := a + y;
  if x = a then writeln(b);
  writeln(index(b,"ee"));  { function index locates 'ee' in b }
end.

  { Generated output is:
    One,two,three,four
	12
  }

  {  ------------------------------------------  }

program strings3 (output);

  { Extended Pascal examples }
  { Schematic string parameters and 'domains' }

type  stringp =  string;

var   p1,p2: stringp;

function ps (s: string) = p: stringp;
    { Function ps takes a general string parameter,
      obtains space in the heap to fit a string of the
      length of the parameter, copies the parameter
      into the heap and returns the pointer }
    { The named function result avoids the need for
      a work variable }
  begin
    new(p,length(s));
    p  := s;
  end {ps};

begin {program}
  p1 := ps("A model jet-ski");
  p2 := ps("the ideal bath companion");
  writeln(p1 ," is (some say) ",p2 );
  dispose(p1);  { removes model from heap }
end.

  { Generated output is:
    A model jet-ski is (some say) the ideal bath companion
  }

  {  ------------------------------------------  }

program instate1 (output);

  { Extended Pascal examples }
  { Initial states of simple types }

type  col = (red,yellow,blue) VALUE yellow;

var   j: integer VALUE 999;
      cy: col;            { initialized to yellow }
      cr: col VALUE red;  { initialized to red }

procedure p;
    { As the type of the selector in the record below
      has an initial state, it determines the choice
      of variant (yellow) when the procedure is entered
      and the record variable is created }
  var rec: record
	     a: integer VALUE 100;
	     case c: col of
	       red:    (x: integer);
	       yellow: (y: real VALUE 2.5);
	       blue:   (z: complex);
	   end {rec};
  begin
    writeln(rec.a,rec.y);
  end {p};

begin {program}
  writeln(j+1);
  if (succ(cr) = cy) and (succ(cy) = blue) then
    writeln("cr and cy initialized");
  p;
end.

  { Generated output is:
      1000
    cr and cy initialized
       100 2.50000000000000E+000
  }

  {  ------------------------------------------  }

program instate2 (output);

  { Extended Pascal examples }
  { Record constructor as initial state }

type  col = (red,yellow,blue);
      rec = record
	      a: integer;
	      case c: col of
		red:    (x: integer);
		yellow: (y: real);
		blue:   (z: complex);
	    end
	    VALUE [ a: 100;
		    case c: yellow of [y: 2.5] ];

var   gc: col;
      pr:  rec;

procedure p (fc: col);
    { As the type of the record r below has a specified
      initial state, the record is initialized each time
      the procedure is entered and the variable created }
  var r: rec;
  begin
    writeln(r.a*ord(fc));
    if (fc = yellow) and (r.c = fc) then writeln(r.y);
  end {p};

begin {program}
  for gc := red to blue do p(gc);
  new(pr);    { pr  gets initial state too }
  writeln(pr .a,pr .y);
end.

  { Generated output is:
	 0
       100
     2.50000000000000E+000
       200
       100 2.50000000000000E+000
  }

  {  ------------------------------------------  }

program arrayc (output);

  { Extended Pascal examples }
  { Array constant and 'constant access' }

type  days = (sun,mon,tues,weds,thurs,fri,sat);
      dname = string(8);

var   d: days;

function DayName (fd: days): dname;
    { Elements of the array constant DayNames can be
      selected with a variable index }
  type  abbrevs = array [days] of
		  packed array [1..5] of char;
  const DayNames = abbrevs
	[ sun: "Sun"; mon: "Mon"; tues: "Tues";
	  weds: "Weds"; thurs: "Thurs"; fri: "Fri";
	  sat: "Satur" ];
  begin
    DayName := trim(DayNames[fd]) + "day";
  end {DayName};

begin {program}
  for d := fri downto mon do writeln(DayName(d));
end.

  { Generated output is:
    Friday
    Thursday
    Wedsday
    Tuesday
    Monday
  }

  {  ------------------------------------------  }

  {  The next example consists of three modules and a main
     program.  Module 'one' exports an interface named i1,
     containing two constants named lower and upper.  }

MODULE one;

EXPORT i1 = (lower,upper);

const  lower = 0;
       upper = 11;

end {of heading};
end {of module one}.


  {  Module 'two' imports the constants lower and upper,
     uses them to define a type, and also re-exports them.
     Export interface i2 contains the type subr, j2 contains
     the constants lower and upper.   (Interface j2 is not
     used in this sequence of modules, but illustrates that
     re-export is allowed.)  }

MODULE two;

EXPORT i2 = (subr);             { just the type subr }
       j2 = (lower,upper);      { the two constants }

IMPORT i1;

type   subr = lower..upper;

end { of heading };
end { of module two }.


  {  Module three employs qualified import and renaming.  It
     exports an interface named i3 containing a function, a type
     and two constants.  It imports i1 from module one and i2
     from module two, both qualified (that is, any references to
     the constituents must be qualified by the interface names).
     Also, the type subr is renamed on import to lim_range.
     The constants are renamed on export as lim_lower and
     lim_upper.  The heading of function 'limited' is given
     in the module heading, and the function definition in the
     module block.  }

MODULE three;

EXPORT i3 = (limited,i2.lim_range,
	     i1.lower => lim_lower, i1.upper => lim_upper);

IMPORT i1 QUALIFIED;
       i2 QUALIFIED ONLY (subr => lim_range);

function  limited (x: integer): i2.lim_range;

end { of heading};

function  limited;
  begin
    if x < i1.lower then limited := i1.lower
    else
    if x > i1.upper then limited := i1.upper
    else
      limited := x;
  end { limited };

end { of module three }.


  {  The main program imports interface i3 and calls the
     function 'limited' to restrict the range of values. }

program limit (output);

IMPORT i3;    { gets everything exported via i3 }

var    i: integer;
       limited_i: lim_range;

begin
  for i := lim_lower - 3 to lim_upper + 3 do
    begin
      limited_i := limited (i);
      if limited_i <> i then
	writeln (" i =",i:3,", limited_i =",limited_i:3);
    end;
end.

  { Generated output is:
     i = -3, limited_i =  0
     i = -2, limited_i =  0
     i = -1, limited_i =  0
     i = 12, limited_i = 11
     i = 13, limited_i = 11
     i = 14, limited_i = 11
  }

  {  ------------------------------------------  }

  { This example consists of a module and a main program.
    The module exports a protected variable, and also has
    initialization and finalization parts. }

MODULE  pvm (output);

EXPORT  pvi = (protected v, stepv);
    { The protected export allows an importing module or
      program to reference v but not to modify it; v can
      only be changed by code within this module, such as
      the procedure stepv. }

const lo = 0; hi = 3;

var   v: lo..hi;

procedure stepv;

end { of module heading };

procedure stepv;
  begin
    if v = hi then v := lo
    else v := succ(v);
  end {stepv};

to begin do v := 1;
    { module initialization is performed
      before the main program block is entered .. }

to end do writeln ("Final value of v is ",v:1);
    { .. finalization is performed after it has completed }

end { of module };


program pvp (output);

IMPORT  pvi;

var   j,k: integer;

begin
  writeln("Initial value of v is ",v:1);
  repeat
    j := v;  stepv;  k := v;
  until k < j;
  writeln("Range of v is ",k:1," to ",j:1);
  stepv;
end.

  { Generated output is:
    Initial value of v is 1
    Range of v is 0 to 3
    Final value of v is 1
  }

  {  ------------------------------------------  }

  {  ------------------------------------------  }