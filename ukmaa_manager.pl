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
 view_menu();
 exit;
}




sub view_menu {
my $numb_members=count_members();
system("clear");
print "==========================================================================\n";
print "|                                                                        |\n";
print "|                          UKMAA Manager                                 |\n";
print "|                                                                        |\n";
print "=========================================================================\n\n";
print "                      Total Number of members: $numb_members\n\n";

print "                <N>.. Enter New Association Member \n";
print "                <E>.. Edit Existing Member         \n";
print "                <L>.. List All Members             \n";
print "\n\n";
print "                <D>.. Database Manager             \n";
print "                <Q>.. Quit Program                 \n";
get_selection();
}

sub get_selection {
my $selection = "";
print "\n\n";
print "Please enter your selection: ";
$selection = <STDIN>;
chomp($selection);
$selection = uc($selection);

switch($selection) {
	case "Q"  {exit;}
	case "D" {system("./ukmaa_db_manager.pl");}
	case "N" {new_member();}
	case "E" {edit_member();}
  case "L" {list_all_members()}
  else {view_menu();}
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
#Declare Variables
print "Adding new member to the UKMAA Member Database...\n";
print "Please enter all information, or put N/A if it does not apply...\n";
print "\n\n";
print "FIRST name: "; my $first_name = <STDIN>;
print "LAST name: "; my $last_name = <STDIN>;
print "Association Number: "; my $assoc_number=<STDIN>;
print "Address: "; my $address = <STDIN>;
print "City: "; my $city = <STDIN>;
print "State (e.g TX): "; my $state=<STDIN>;
print "Zip Code: "; my $zip=<STDIN>;
print "Birth Date (mm/dd/yy): "; my $dob=<STDIN>;
print "E-Mail Address: "; my $email=<STDIN>;
print "Contact Phone: "; my $phone=<STDIN>;
print "Current Rank: "; my $current_rank=<STDIN>;
print "Last Test Date (mm/dd/yy): "; my $last_test=<STDIN>;
print "Current Instructor: "; my $current_instructor=<STDIN>;
print "Date Joined: "; my $date_joined=<STDIN>;
print "Studio ID: "; my $studio_id=<STDIN>;
print "Style(s) Preformed: "; my $styles=<STDIN>;
print "Other Associations/Federations belonged to: "; my $other_assoc=<STDIN>;
print "General Notes: "; my $notes=<STDIN>;

chomp($first_name); chomp($last_name); chomp($assoc_number); chomp($address); chomp($city); chomp($state); chomp($zip); chomp($dob); chomp($email); chomp($phone); chomp($current_rank);
chomp($last_test); chomp($current_instructor); chomp($date_joined); chomp($studio_id); chomp($styles); chomp($other_assoc); chomp($notes);

#Veiew and verify entry
print "\n\n\n";
print("==================================================================================\n");
printf("%-251s","Association ID: $assoc_number\n");
print("===================================================================================\n\n");
printf("%25s", "First Name: $first_name"); printf("%25s", "Last Name: $last_name\n");
printf("%25s","Address: $address"); printf("%25s", "City: $city\n");
printf("%25s","State: $state"); printf("%25s","Zip: $zip\n");
printf("%-25s","Birth Date: $dob"); printf("%-25s","E-Mail Address:$email\n");

print "Contact Phone: $phone                              Current Rank: $currenk_rank\n";
print "Last Test Date: $last_test                         Current Instructor: $current_instructor\n";
print "Date Joined: $date_joined                          Studio ID: $studio_id\n";
print "Style(s) Preformed: $styles                        Other Associations/Federations: $other_assoc\n";
print "Notes: $notes\n";
print "\n\n";
print "Is all the above information correct? (y/n) "; my $answer = <STDIN>;
chomp($answer);
$answer=uc($answer);
switch ($answer) {
    case "N"  {new_member();}
    case "Y"  {

      #Insert Into SQLite
       my $sth = $dbh->prepare("INSERT INTO members VALUES ('$assoc_number', '$first_name', '$last_name', '$address', '$city', '$state', '$zip', '$birth_date', '$email', '$phone', '$current_rank', '$last_test', '$current_instructor', '$date_joined', '$studio_id', '$styles', '$other_assoc', '$notes')");
       $sth->execute() or die "Association Member Addition Failed to add to database - error: $dbh->errstr()";
       print "\n\n";
       print "Added $first_name $last_name to the UKMAA database. Press any key to return to menu...";  <STDIN>;
       view_menu();
    }
    else {print "Invalid entry, try again. <STDIN>;"}

    }

}




sub count_members {
  #Count the total number of members in the member database
  my $numb_members = 0;
  my $sth = $dbh->prepare("SELECT * FROM members");
  $sth->execute();
  while (my $ref = $sth->fetchrow_hashref()) {
    $numb_members = $numb_members + 1;
  }

  return $numb_members;

}
