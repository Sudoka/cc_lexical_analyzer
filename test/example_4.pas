program simpleTest (input, output);
var i : integer;
begin
  i := 1
end.



program expressionTest (input, output);   {Sample tvi code here}
 var a, b : integer;
        c : real;
 begin
   a := 3;
   b := a * 4;
   c := (b + a)/ 2
 end.


program arrayTest(input, output);    {Sample tvi code here}
var
   m : array[1..5] of integer;
begin
        m[1] := 1;
        m[2] := 2;
        m[3] := 3;
        m[4] := 4;
        m[5] := 5;

        write(m[1]);
        write(m[2]);
        write(m[3]);
        write(m[4]);
        write(m[5])
end.


program arrayRefTest (input, output);
 var a, b : integer;
     x : array [1..5] of real;
begin
  read(a);
  read(b);
  x[a] := 6.783;
  write(a,b,x[a])
end.



program ifTest(input, output);       {Sample tvi code here}
var
    i,j:integer;
begin
        i := 0;
        if i = 0 then
                write(0)
        else if i = 1 then
                write(1)
        else if i = 2 then
                write(2)
        else write (99);

        i := 1;
        if i = 0 then
                write(0)
        else if i = 1 then
                write(1)
        else if i = 2 then
                write(2)
        else write (99);

        i := 2;
        if i = 0 then
                   write(0)
        else if i = 1 then
                   write(1)
        else if i = 2 then
                   write(2)
        else write (99)
end.


program procTest (input, output);
 var a, b : integer;
     x : array [1..5] of real;
  procedure one (i, j : integer; k : array [1..5] of real);
    var n : integer;
    begin
      n := i + j;
      k[n] := 2.345
    end
  begin
    a := 1;
    b := 2;
    one(a,b,x);
    write(x[a+b])
  end.



program funcTest(input, output);        
var
        i, j, k:integer;

function Sum(a,b:integer): result integer;
begin
        Sum := a + b
end

begin
        i := 10;
        j := 20;
        k := Sum(i,j) * 2;
        write(k)
end.


program fibTest(input, output);   {Sample tvi code here}
var
        i, done: integer;
function fib(n:integer) : result integer;
var
        j, k : integer;
begin
        if n = 1 then
                fib := 1
        else if n = 2 then
                fib := 1
        else
                fib := fib(n-1) + fib(n-2)
end
begin
        done := 0;
        while done = 0 do begin
                read(i);
                if i = 0 then
                        done := 1
                else begin
                        write(i);
                        i := fib(i);
                        write(i)
                end    { else part }
        end    { while }
end.




program uminusTest (input, output);
 var a, b : integer;
        c : real;
  function two (i, j : integer): result integer;
    var n : integer;
    begin
      n := i + j;
      two := -n
    end
  begin
    a := 1;
    b := 2;
    c := a+b+two(a,b);
    write(c)
  end.



program noparmTest (input, output);
 var a, b : integer;
        c : real;
  function two: result integer;
    var n : integer;
    begin
      c := a + b;
      two := -c
    end
  begin
    a := 1;
    b := 2;
    c := a+b+two;
    write(c)
  end.

Program recursionTest (input,output);
Var
   x,y : integer;

function gcd (a, b: integer) : result real;
   var x : integer;
begin
   if b= 0 then gcd := a
   else begin
     x := a;
     while (x >= b) do
      begin
        x := x - b
      end;
      gcd := gcd(b,x)
     end
end
begin
   read (x,y);
   if x>y then write (gcd(x, y))
end.



Program theUltimateTest (input,output);
Var
   h,z,i,x,y : integer;
   w : array [1..5] of real;

function gcd (a, b: integer) : result real;
   var x : integer;
begin
   if (b = 0) then gcd := a
   else begin
     x := a;
     while (x >= b) do 
      begin
        x := x - b
      end
      gcd := gcd(b,x)
     end
end

procedure this (why, note : real);
begin
   if ((why = note - 1608) or (not (note = why)))
   then if (x - y = 0)
      then begin
         x := why / note
         end
end

procedure that;
var h,z : real;
begin
   x := y;
   this (h,z)
end

begin
   i := 1;
   x := 5;
   While (I <= 5) and (x <= 75) do
   begin
      w [i] := x;
      x := w[i] * 20.5;
      i := 1 + 1 
   end;
   read (x,y);
   if x>y then write (gcd(x, y)) else write (gcd (h,z));
   w[gcd(x,y)] := 23e10;
   this (w,z);
   this (w[w[i]],gcd(x,y));
   that;
   i := 1;
   while (i <= 5) do
     begin
       write(w[i]);
       i := 1 + 1
     end;
   write(h,i,x,y,z)
end