#!/usr/bin/perl

#UKMAA Database Manager Program
#Written 11/21/2017 @ Chad Adams cadams@ukmaa.com


use DBI;
use Switch;

#Create DB Connection

 #Connect To Database
local $db_name = "ukmaa_data.dbl";
local $dbh = DBI->connect( "dbi:SQLite:$db_name" ) || die "Cannot connect: $DBI::errstr";
local $os = "";

#main program
run_program();



#Sub Delcations

sub run_program {

while (true) {
determine_os();
display_menu();
menu();

}


}

sub determine_os {

local $os_type_returned = $^O;
print $os_type;
switch ($os_type_returned) {
	case "linux"  {$os="linux"};
	case "win32"  {$os="win"};
	case "win64"  {$os="win"};
	case "darwin" {$os="mac"};

``}

}


sub create_member_table {
$dbh->do(" CREATE TABLE members ( assoc_number, firstname, lastname, address, city, state, zip, birth_date, email, phone, current_rank, last_test, current_instructor, date_joined, studio_id, styles, other_assoc, notes) ");
}

sub create_promotion_table {

}

sub drop_member_table {
$dbh->do(" DELETE TABLE members ");
}

sub drop_promotion_table {
print "Are you sure you want to delete the Rank Promotion Table? (y/n)";

$dbh->do(" DELETE TABLE promotions ");
}

sub delete_ukmaa_database {
my $answer = "";
print "Are you sure you want to delete the entire database? (y/n)";
$answer = <STDIN>;
$answer = uc($answer);
print "\n";

my $command = "";
switch ($os) {
case "linux" {$command = "rm -f $db_name";};
case "win"   {$command = "del $db_name";};
case "mac"   {$command = "rm -f $db_name";};
}

print "$answer"; <STDIN>;
switch ("Y") {
case "Y"   {system($command); print "Database $db_name has been deleted."; <STDIN>;};
case "N"   {return 0;};
}


}
sub display_menu {
system("clear");
print "========================================================\n";
print "|                                                      |\n";
print "|               UKMAA Database Utilites                |\n";
print "|                   (CAREFUL USE)                      |\n";
print "|                                                      |\n";
print "========================================================\n";
print "\n\n";
print "                  :Commands Available:                \n";
print "\n";
print "          <1>.. Create Assocation Member Table        \n";
print "          <2>.. Create Promotion Table                \n";
print "          <A>.. Delete Association Member Table       \n";
print "          <B>.. Delete Promotion Table                \n";
print "          <C>.. Delete UKMAA Entire Database          \n\n";

print "          <!>.. Backup Database Now                   \n";
print "          <Q>.. Quit Database Manager                 \n";
print "\n\n";
print "Note: Please be careful, you can destroy data.\n";
print "Running OS: $os \n\n";
return 0;
}

sub menu {
print "Please enter your choice: ";
my $choice = <STDIN>;
chomp $choice;
$choice = uc($choice);
switch ($choice) {
	case "Q"	{exit}
	case  1         {create_member_table(); return 0;}
	case  2         {create_promotion_table(); return 0;}
	case "A"        {drop_member_table(); return 0;}
	case "B"	      {drop_promotion_table(); return 0;}
	case "C"        {delete_ukmaa_database(); return 0;}
	else		{print "Invalid selection try again\n"; <STDIN>; return 0;}
}


print "You selected $choice \n\n";
print "Press any key";
<STDIN>;
return 0;
}
