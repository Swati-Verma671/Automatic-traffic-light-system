org 0000h;
	mov p1,#0ffh;initializing the button
	mov p2,#00h;lcd initialization
	mov p3,#00h;led initialization
	main:mov P3,#00h;led1=0, led2=0, led3=0
	acall lcd;
	mov A,#01h;
	acall command;
	mov A,#80h;
	acall command;
	acall display;stop
	setb p3.0;red led
	acall delay;
	mov A,#01h;
	acall command;
	mov A,#80h;
	acall command;
	acall display1;standby
	setb p3.1;yellow led
	acall delay;
	mov A,#01h;
	acall command;
	mov A,#80h;
	acall command;
	acall display2;go
	setb p3.2;green led
	
	lcd:mov A,#38h;
	acall command;
	mov A,#0eh;
	acall command;
	mov A,#01h;
	acall command;
	mov A,#06h;
	acall command;
	
	command:acall busy;lcd command
	clr p0.0;rs=0
	setb p0.1;rw=1
	mov p2,a;
	setb p0.2;en=1
	nop;
	clr p0.2;en=0
	ret;
	
	busy:setb p2.7;busy flag
	clr p0.0;rs=0
	setb p0.1;rw=1
	wait1:clr p0.2;en=0
	nop;
	setb p0.2;en=1
	jb p2.7,wait1;
	ret;
	
	data1:acall busy;lcd data 
	setb p0.0;rs=1
	clr p0.1;rw=0
	mov p2,A;
	setb p0.2;en=1
	nop;
	clr p0.2;en=0
	ret;
	
	display:mov dptr,#table;Stop message
	again:clr A;
	movc A,@A+dptr;
	jz skip;
	mov p2,A;
	acall data1;
	inc dptr;
	sjmp again;
	skip:mov A,#0ch;
	acall command;
	
	display1:mov dptr,#table1;Standby message
	again1:clr A;
	movc A,@A+dptr;
	jz skip1;
	mov p2,A;
	acall data1;
	inc dptr;
	sjmp again1;
	skip1:mov A,#0ch;
	acall command;
	
	display2:mov dptr,#table2;Go message
	again2:clr A;
	movc A,@A+dptr;
	jz skip2;
	mov p2,A;
	acall data1;
	inc dptr;
	sjmp again2;
	skip2:mov A,#0ch;
	acall command;
	
	delay:mov r2,#0c8h;delay of 10 sec
	loop:mov tmod,#01h;
	mov th0,#2bh;
	mov tl0,#0f3h;
	setb tr0;
	wait2:jnb tf0,wait2;
	clr tr0;
	clr tf0;
	djnz r2,loop;
	
org 0100h;
	table: db 'Stop',0;
	table1: db 'Standby',0;
	table2: db 'Go',0;
		
end;
