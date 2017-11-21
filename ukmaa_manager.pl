#!/usr/bin/perl

#UKMAA Manager

use DBI;
use Switch;


#Connect to DB:
local $db_name = "ukmaa_data.dbl";
local $dbh = DBI->connect("dbi:SQLite:$db_name") || die "Cannot connect: $DBI::errstr";

#Main Program
main();



sub main {
while (true) {
 view_menu();
 get_selection();



}

}




sub view_menu {
system("clear");
print "==========================================================================\n";
print "|                                                                        |\n";
print "|                          UKMAA Manager                                 |\n";
print "|                                                                        |\n";
print "=========================================================================\n\n";

print "                <N>.. Enter New Association Member \n";
print "                <E>.. Edit Existing Member         \n";
print "                <L>.. List All Members             \n";
print "\n\n";
print "                <D>.. Database Manager             \n";
print "                <Q>.. Quit Program                 \n";
}

sub get_selection {
my $selection = "";
print "Please enter your selection: ";
$selection = <STDIN>;
chomp($selection);
$selection = uc($selection);

print "You selected: $selection\n"; <stdin>;

switch($selection) {
	case "Q"  {exit;};
	case "D" {exec("ukmaa_db_manager.pl");};
	case "N" {new_member();};
	case "E" {edit_member();};
}

return 0;
}

#Add New Member 
sub new_member {
system("clear");
print "==========================================================================\n";
print "|                  Add New Association Member to Database                |\n";
print "==========================================================================\n";
print "\n\n";

#Get Highest Association Number
my $sql_highest = "SELECT MAX(assoc_number) FROM members";

my $stmt = qq($sql_highest);
my $sth = $dbh->prepare( $stmt );
my $result1 = $sth->execute() or die $DBI::errstr;
print "value $sth"; <stdin>;


if ($result eq "") {
  $result = "NO RECORDS";
}

my $input_assoc_number = "";
print "Highest Association Number:" . $result . "\n";
print "Enter Association Number: "; 
$input_assoc_number = <STDIN>;
$sql_insert = "INSERT INTO members VALUE $input_assoc_number";
$dbh->do($sql_insert);

}
